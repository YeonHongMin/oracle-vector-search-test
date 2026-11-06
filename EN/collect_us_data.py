#!/usr/bin/env python3
"""collect_us_data.py — build data/EN/spots_us_en.csv (US festivals + tourist attractions).

Pipeline (stdlib only, serial, cached under CACHE_DIR):
  1. WDQS/qlever SPARQL: items P17=US, P31* Q132241(festival) or Q570116(tourist
     attraction), P625, en sitelink  -> candidates
  2. en.wikipedia extracts (prop=extracts|info|revisions, titles<=50, maxlag=5)
     -> lead text + pageid + revid; empty extract -> REST summary fallback
  3. Census coordinatesbatch -> state FIPS; official state.txt -> English name
  4. Quality filter + deterministic selection -> spots_us_en.csv + report

Re-runnable: every stage caches raw responses; no DB calls; no secrets.
"""
import csv, io, json, os, re, sys, time, urllib.parse, urllib.request

CACHE = os.environ.get("USEN_CACHE", ".venv/us_en_build")
OUT_CSV = "data/EN/spots_us_en.csv"
OUT_REP = "data/EN/collection_report.json"
UA = {"User-Agent": "OracleVecPOC-dataset-build/1.0 (vector-search POC test data; contact: repo owner)"}
WDQS = "https://query.wikidata.org/sparql"
QLEVER = "https://qlever.dev/api/wikidata"
WP_API = "https://en.wikipedia.org/w/api.php"
WP_REST = "https://en.wikipedia.org/api/rest_v1/page/summary/"
CENSUS = "https://geocoding.geo.census.gov/geocoder/geographies/coordinatesbatch"
BENCHMARK = "Public_AR_Current"
VINTAGE = "Current_Current"
STATE_TXT = "https://www2.census.gov/geo/docs/reference/state.txt"
TARGET = 477
MIN_DESC = 100

os.makedirs(CACHE, exist_ok=True)

def cget(name):
    p = os.path.join(CACHE, name)
    return json.load(open(p)) if os.path.exists(p) else None

def cput(name, obj):
    json.dump(obj, open(os.path.join(CACHE, name), "w"), ensure_ascii=False)

def get(url, data=None, headers=None, retry=3):
    for a in range(retry):
        try:
            req = urllib.request.Request(url, data=data, headers={**UA, **(headers or {})})
            with urllib.request.urlopen(req, timeout=120) as r:
                return r.read()
        except urllib.error.HTTPError as e:
            ra = e.headers.get("Retry-After")
            if ra and a < retry - 1:
                time.sleep(int(ra)); continue
            raise
        except Exception:
            if a < retry - 1: time.sleep(3 * (a + 1)); continue
            raise

# ---------- stage 1: candidates ----------
def sparql(endpoint, q):
    body = urllib.parse.urlencode({"query": q, "format": "json"}).encode()
    return json.loads(get(endpoint, data=body,
                          headers={"Accept": "application/sparql-results+json",
                                   "Content-Type": "application/x-www-form-urlencoded"}))

def stage_candidates():
    c = cget("candidates.json")
    if c: return c
    q = """PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX schema: <http://schema.org/>
SELECT ?item ?itemLabel ?type ?coord ?article WHERE {
  VALUES ?t { wd:Q132241 wd:Q570116 }
  ?item wdt:P31/wdt:P279* ?t .
  ?item wdt:P17 wd:Q30 .
  ?item wdt:P625 ?coord .
  ?article schema:about ?item ; schema:isPartOf <https://en.wikipedia.org/> .
  BIND(?t AS ?type)
  SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }
}"""
    last_err = None
    for ep in (QLEVER, WDQS):
        try:
            d = sparql(ep, q)
            rows = []
            for b in d["results"]["bindings"]:
                m = re.match(r"Point\(([-\d.]+) ([-\d.]+)\)", b["coord"]["value"])
                if not m: continue
                qid = b["item"]["value"].rsplit("/", 1)[1]
                typ = "FESTIVAL" if b["type"]["value"].endswith("Q132241") else "TOURIST_ATTRACTION"
                title = urllib.parse.unquote(b["article"]["value"].rsplit("/", 1)[1])
                rows.append({"qid": qid, "label": b["itemLabel"]["value"], "type": typ,
                             "lat": float(m.group(2)), "lon": float(m.group(1)),
                             "title": title, "article_url": b["article"]["value"]})
            seen, ded = set(), []
            for r in rows:
                if r["qid"] in seen: continue
                seen.add(r["qid"]); ded.append(r)
            out = {"endpoint": ep, "rows": ded}
            cput("candidates.json", out)
            return out
        except Exception as e:
            last_err = e
    raise RuntimeError(f"sparql failed: {last_err}")

# ---------- stage 2: wikipedia extracts ----------
def stage_extracts(cands):
    c = cget("extracts.json")
    if c: return c
    by_title = {}
    titles = [c["title"] for c in cands]
    for i in range(0, len(titles), 50):
        batch = titles[i:i+50]
        params = {"action": "query", "format": "json", "prop": "extracts|revisions|info",
                  "exintro": 1, "explaintext": 1, "rvprop": "ids", "inprop": "url",
                  "redirects": 1, "maxlag": 5, "titles": "|".join(batch)}
        url = WP_API + "?" + urllib.parse.urlencode(params)
        d = json.loads(get(url))
        norm = {n["from"]: n["to"] for n in (d["query"].get("normalized") or [])}
        redir = {r["from"]: r["to"] for r in (d["query"].get("redirects") or [])}
        for p in d["query"]["pages"].values():
            t = p.get("title")
            rev = (p.get("revisions") or [{}])[0].get("revid")
            by_title[t] = {"extract": (p.get("extract") or "").strip(),
                           "pageid": p.get("pageid"), "revid": rev,
                           "fullurl": p.get("fullurl")}
        time.sleep(1)
        if i % 500 == 0:
            print(f"  extracts {i}/{len(titles)}", flush=True)
    # map request titles (underscore form) -> canonical (space form + norm/redirect)
    def canon(t):
        t2 = t.replace("_", " ")
        t2 = norm.get(t2, t2)
        return redir.get(t2, t2)
    for t in titles:
        if t not in by_title and canon(t) in by_title:
            by_title[t] = by_title[canon(t)]
    # REST summary fallback for empty extracts
    fb = 0
    for t in titles:
        if t in by_title and by_title[t]["extract"]:
            continue
        try:
            d = json.loads(get(WP_REST + urllib.parse.quote(t)))
            ext = (d.get("extract") or "").strip()
            if ext:
                by_title.setdefault(t, {"extract": "", "pageid": None, "revid": None, "fullurl": None})
                by_title[t]["extract"] = ext
                by_title[t]["rest_title"] = d.get("title")
                fb += 1
        except Exception:
            pass
        time.sleep(0.5)
    out = {"by_title": by_title, "rest_fallback": fb}
    cput("extracts.json", out)
    return out

# ---------- stage 3: census ----------
def stage_census(cands):
    c = cget("census.json")
    if c: return c
    buf = io.StringIO()
    w = csv.writer(buf)
    for i, cd in enumerate(cands):
        w.writerow([i, cd["lon"], cd["lat"]])
    boundary = "PYBND"
    parts = (f"--{boundary}\r\nContent-Disposition: form-data; name=\"coordinatesFile\"; filename=\"c.csv\"\r\nContent-Type: text/csv\r\n\r\n{buf.getvalue()}\r\n"
             f"--{boundary}\r\nContent-Disposition: form-data; name=\"benchmark\"\r\n\r\n{BENCHMARK}\r\n"
             f"--{boundary}\r\nContent-Disposition: form-data; name=\"vintage\"\r\n\r\n{VINTAGE}\r\n"
             f"--{boundary}--\r\n")
    raw = get(CENSUS, data=parts.encode(),
              headers={"Content-Type": f"multipart/form-data; boundary={boundary}"})
    rows = list(csv.reader(io.StringIO(raw.decode("utf-8", "replace"))))
    result = {}
    for r in rows:
        # response: id,lon,lat,status,statefp,countyfp,tract,block — ID로 조인(순서 조인 금지)
        try:
            idx = int(r[0]); statefp = r[4] if len(r) > 4 and r[3] == "Match" else ""
        except Exception:
            continue
        result[idx] = {"statefp": statefp}
    # official state.txt: STATE|STUSAB|STATE_NAME|STATENS
    st = get(STATE_TXT).decode("utf-8", "replace")
    fips = {}
    for r in csv.DictReader(io.StringIO(st.replace("\ufeff", "")), delimiter="|"):
        fips[r["STATE"].strip()] = r["STATE_NAME"].strip()
    out = {"benchmark": BENCHMARK, "vintage": VINTAGE, "by_idx": result, "fips": fips}
    cput("census.json", out)
    return out

# ---------- stage 4: filter + select ----------
US_STATES = ["Alabama","Alaska","Arizona","Arkansas","California","Colorado","Connecticut",
 "Delaware","District of Columbia","Florida","Georgia","Hawaii","Idaho","Illinois","Indiana",
 "Iowa","Kansas","Kentucky","Louisiana","Maine","Maryland","Massachusetts","Michigan",
 "Minnesota","Mississippi","Missouri","Montana","Nebraska","Nevada","New Hampshire",
 "New Jersey","New Mexico","New York","North Carolina","North Dakota","Ohio","Oklahoma",
 "Oregon","Pennsylvania","Rhode Island","South Carolina","South Dakota","Tennessee","Texas",
 "Utah","Vermont","Virginia","Washington","West Virginia","Wisconsin","Wyoming"]
STATE_PAT = re.compile(r"\b(" + "|".join(re.escape(s) for s in US_STATES) + r")\b")
DC_PAT = re.compile(r"\b(Washington,?\s*D\.?C\.?|Washington,?\s*the District of Columbia)\b", re.I)
FORMER_PAT = re.compile(r"\b(former(ly)?|defunct|no longer|discontinued|cancelled|canceled|"
                        r"ceased|abandoned|proposed|unbuilt)\b", re.I)
WAS_TYPE_PAT = re.compile(r"^(?:[^\n.]{0,120})\bwas an?\b[^.]*?\b(festival|fair|attraction|"
                          r"park|museum|event|series)\b", re.I)
KO_RE = re.compile(r"[\uac00-\ud7a3\u1100-\u11ff]")

def lead_states(text):
    hits = set(STATE_PAT.findall(text or ""))
    if DC_PAT.search(text or ""):
        hits.add("District of Columbia")
    return hits

def clean_desc(t):
    return re.sub(r"\s+", " ", (t or "").replace("\r", " ")).strip()

def main():
    cand = stage_candidates()["rows"]
    ext = stage_extracts(cand)["by_title"]
    cen = stage_census(cand)
    report = {"target": TARGET, "candidates": len(cand), "dropped": {}, "counts": {}}
    drop = report["dropped"]
    def d(k): drop[k] = drop.get(k, 0) + 1

    pool = []
    for i, cd in enumerate(cand):
        e = ext.get(cd["title"]) or {}
        name, desc = cd["label"].strip(), clean_desc(e.get("extract"))
        if not name: d("empty_name"); continue
        if not desc: d("empty_desc"); continue
        if len(desc) < MIN_DESC: d("desc_lt_100"); continue
        if KO_RE.search(name) or KO_RE.search(desc): d("korean_chars"); continue
        if FORMER_PAT.search(desc) or WAS_TYPE_PAT.search(desc):
            d("former_defunct"); continue
        cst = cen["by_idx"].get(str(i))  # JSON 캐시의 키는 문자열
        if not cst or not cst.get("statefp"): d("census_nomatch"); continue
        c_state = cen["fips"].get(cst["statefp"])
        if not c_state: d("fips_unknown"); continue
        lst = lead_states(desc)
        if len(lst) > 1:
            d("state_multistate_or_conflict"); continue
        if len(lst) == 1:
            only = next(iter(lst))
            if only != c_state:
                d("state_lead_mismatch"); continue
            res = "CENSUS+ARTICLE"
        else:
            res = "CENSUS_ONLY"
        et = clean_desc(f"{name} {desc}")[:4000]
        rev = e.get("revid")
        pool.append({"id": cd["qid"][1:], "qid": cd["qid"], "name_en": name,
                     "desc_en": desc, "embed_text_en": et, "state": c_state,
                     "category": cd["type"], "article_url": e.get("fullurl") or cd["article_url"],
                     "revision_id": rev,
                     "revision_url": f"https://en.wikipedia.org/w/index.php?title={urllib.parse.quote(cd['title'])}&oldid={rev}" if rev else "",
                     "lat": cd["lat"], "lon": cd["lon"],
                     "state_fips": cst["statefp"], "state_resolution": res,
                     "source": "en.wikipedia.org+wikidata+census_geocoder",
                     "license": "CC BY-SA 4.0; Wikidata CC0; Census public domain"})

    ca = [r for r in pool if r["state"] == "California"]
    fes = [r for r in pool if r["category"] == "FESTIVAL"]
    att = [r for r in pool if r["category"] == "TOURIST_ATTRACTION"]
    report["counts"]["pool"] = len(pool)
    report["counts"]["pool_festival"] = len(fes)
    report["counts"]["pool_attraction"] = len(att)
    report["counts"]["pool_ca"] = len(ca)
    report["counts"]["census_plus_article"] = sum(1 for r in pool if r["state_resolution"] == "CENSUS+ARTICLE")
    report["counts"]["census_only"] = sum(1 for r in pool if r["state_resolution"] == "CENSUS_ONLY")

    # deterministic selection: prefer CENSUS+ARTICLE, balanced festival/attraction,
    # keep CA coverage; sort stable by (resolution, category, state, qid)
    pref = sorted(pool, key=lambda r: (0 if r["state_resolution"] == "CENSUS+ARTICLE" else 1,
                                       r["category"], r["state"], r["qid"]))
    sel = []
    ca_n = att_n = fes_n = 0
    for r in pref:
        if len(sel) >= TARGET: break
        sel.append(r)
        fes_n += r["category"] == "FESTIVAL"; att_n += r["category"] == "TOURIST_ATTRACTION"
        ca_n += r["state"] == "California"
    report["counts"]["selected"] = len(sel)
    report["counts"]["sel_festival"] = fes_n
    report["counts"]["sel_attraction"] = att_n
    report["counts"]["sel_ca"] = ca_n
    report["counts"]["sel_census_only"] = sum(1 for r in sel if r["state_resolution"] == "CENSUS_ONLY")
    report["counts"]["shortfall"] = max(0, TARGET - len(sel))
    report["census_only_examples"] = [r["name_en"] for r in sel if r["state_resolution"] == "CENSUS_ONLY"][:10]

    with open(OUT_CSV, "w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=list(sel[0].keys()) if sel else ["id"],
                           lineterminator="\n")
        w.writeheader(); w.writerows(sel)
    json.dump(report, open(OUT_REP, "w"), ensure_ascii=False, indent=1)
    print(json.dumps(report, ensure_ascii=False, indent=1))

if __name__ == "__main__":
    main()
