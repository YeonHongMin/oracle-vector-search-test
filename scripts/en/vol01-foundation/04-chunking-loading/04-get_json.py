# Core of the collection script: check the column list, then fetch all rows page by page
def fetch(pk: str):
    head = get_json(f"{BASE}/columList.json?pk={pk}&ext=CSV")
    cols = [(c["columCode"], c["columNm"]) for c in head["columList"]]
    total = int(head["totalCount"])
    per = 10000
    rows = []
    for page in range(1, (total + per - 1) // per + 1):
        q = [("publicDataPk", pk), ("totalCount", str(total)),
             ("svcTableNm", head["tableVO"]["svcTableNm"]),
             ("perPage", str(per)), ("page", str(page))]
        q += [("colNmList", c) for c in head["tableVO"]["colNmList"]]
        rows += get_json(f"{BASE}/standard.json?" + urllib.parse.urlencode(q))
    if len(rows) != total:
        sys.exit(f"{pk}: totalCount {total} != received {len(rows)}")
    return cols, rows


def clean(v) -> str:
    s = "" if v is None else str(v)
    return " ".join(s.replace("\r", " ").replace("\n", " ").split)
