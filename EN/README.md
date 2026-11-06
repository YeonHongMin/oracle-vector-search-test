# spots_us_en.csv — US festivals & tourist attractions (English)

477 rows of English original data — US festivals and tourist attractions, not translations of the Korean dataset. Built for the Oracle AI Database 26ai vector-search POC as public test data.

## Files

| File | Contents |
|---|---|
| `spots_us_en.csv` | Final dataset, 477 rows, UTF-8 LF |
| `collect_us_data.py` | Stdlib-only collector — re-runnable, caches raw responses outside the repo |
| `collection_report.json` | Candidate pool, drop reasons, selection counts |
| `LICENSE-CC-BY-SA-4.0.txt` | Official CC BY-SA 4.0 legalcode |
| `DATA_LICENSE.md` | Sources, licenses, row attribution |
| `README.md` | This file |

## Columns

| Column | Description |
|---|---|
| `id` | QID numeric part |
| `qid` | Wikidata QID (`Q<digits>`) |
| `name_en` | English name (Wikidata label) |
| `desc_en` | English description (en Wikipedia lead extract, whitespace-normalized; REST summary only when the extract was empty) |
| `embed_text_en` | `name_en` + space + `desc_en` (CR removed, whitespace normalized, ≤4,000 chars — the same rule used for vector embedding input) |
| `state` | English state name resolved by US Census Geocoder from P625 coordinates (benchmark `Public_AR_Current`, vintage `Current_Current`, FIPS→name via official `state.txt`) |
| `category` | `FESTIVAL` or `TOURIST_ATTRACTION` (from Wikidata P31 type) |
| `article_url` | en Wikipedia article URL for the row |
| `revision_id` | Wikipedia page revision id used for the extract (empty when only REST summary was available) |
| `revision_url` | `…?oldid=<rev>` permalink (empty when no revision id was available) |
| `lat` / `lon` | Wikidata P625 coordinates |
| `state_fips` | Census state FIPS code |
| `state_resolution` | `CENSUS+ARTICLE` (state named in the lead text and matches Census) or `CENSUS_ONLY` (not stated in lead) |
| `source` / `license` | Provenance and license identifiers |

## Collection method

1. **Wikidata (WDQS/qlever)**: items with `P17=US`, `P31*` of `Q132241` (festival) or `Q570116` (tourist attraction), `P625`, and an en Wikipedia sitelink → 2,517 candidates (festival 452 + attraction 2,066 pool before dedup).
2. **en Wikipedia**: `prop=extracts|revisions|info` batch API (≤50 titles, `maxlag=5`, serial) for lead text + revision id; REST `page/summary` used **only** for empty extracts.
3. **US Census Geocoder** `geographies/coordinatesbatch` (file field `coordinatesFile`, CSV `id,lon,lat`, benchmark `Public_AR_Current`, vintage `Current_Current`): joined back by row ID, never by order.
4. **Quality filter** (see `collection_report.json` for per-rule drop counts): duplicate QIDs, empty name/description, description <100 chars, any Hangul in name/desc, former/defunct/proposed/cancelled/discontinued items (lead-text patterns; plain past-tense phrasing like "was designated" is kept), Census no-match, lead naming multiple states or a state conflicting with the Census state (e.g., a "Connecticut" festival geocoded to Utah is rejected, not silently trusted).

## Selection criteria (deterministic, no ranking manipulation)

- Actual order: rows with `state_resolution=CENSUS+ARTICLE` rank first; the pool is sorted by `(resolution rank, category, state, qid)` and the first 477 are taken. With 1,515 `CENSUS+ARTICLE` rows available, `sel_census_only` is 0.
- Actual result: festival 296 + tourist attraction 181; 47 states; California 156 rows.
- If fewer than 477 rows had passed quality rules, the shortfall would have been reported instead of padding — no duplication, translation, or invented rows.

## Text normalization

- `name_en` is the Wikidata label (CC0), stripped.
- `desc_en` is the Wikipedia lead extract with **mechanical whitespace normalization applied**: CR removed, all whitespace runs collapsed to single spaces, and stripped (the collector's `clean_desc`). Wording is unchanged — nothing was translated, summarized, paraphrased, or generated.
- `embed_text_en` is a derived field: normalized name + single space + normalized description, truncated at 4,000 characters — the same rule used for vector embedding input.

## License

`desc_en` (and the desc part of `embed_text_en`) is English Wikipedia content under **CC BY-SA 4.0** (`LICENSE-CC-BY-SA-4.0.txt`); each row carries `article_url` (+`revision_url` when available) for attribution. `name_en` is a Wikidata label (CC0); other Wikidata fields and Census Geocoder output are CC0 / US government public domain. See `DATA_LICENSE.md`.

## Reproduction check

```bash
python3 - <<'PY'
import csv, re
rows = list(csv.DictReader(open("data/EN/spots_us_en.csv", encoding="utf-8")))
assert len(rows) == 477
assert len({r["qid"] for r in rows}) == 477
cd = lambda t: re.sub(r"\s+", " ", (t or "").replace("\r", " ")).strip()
mm = sum(1 for r in rows if r["embed_text_en"] != cd(r["name_en"] + " " + r["desc_en"])[:4000])
assert mm == 0, mm  # actual embed rule mismatch = 0
assert open("data/EN/spots_us_en.csv", "rb").read().count(b"\r") == 0
PY
```
