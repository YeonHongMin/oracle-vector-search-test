# Oracle 26ai Vector Search Test Data

[한국어](README.kr.md)

**Repository:** <https://github.com/YeonHongMin/oracle-vector-search-test>

Public test data for Oracle AI Database **26ai 23.26.3** Vector Search examples. The CSV files contain source text and metadata, not precomputed vectors or database dumps.

## Dataset overview

| Item | Korean (KO) | English (EN) |
|---|---|---|
| Execution CSV | [`KO/spots_ko.csv`](KO/spots_ko.csv) | [`EN/spots_us_en.csv`](EN/spots_us_en.csv) |
| Contents | Korean tourist spots, museums, temples, parks, festivals, fortresses, and palaces | U.S. festivals and tourist attractions |
| Data rows | 477, excluding the header | 477, excluding the header |
| Region column | `sido`: abbreviations such as `서울` and `경기` | `state`: full names such as `California` |
| Embedding input | `embed_text_ko` | `embed_text_en` |
| Sources | Korean Wikipedia and Wikidata | English Wikipedia, Wikidata, and US Census Geocoder |
| Detailed guide | [`KO/README.md`](KO/README.md) | [`EN/README.md`](EN/README.md) |
| Korean guide | [`README.kr.md`](README.kr.md) | [`README.kr.md`](README.kr.md) |

The datasets are independent. Their row counts match because the English selection target was 477, not because their QIDs or rows correspond. The English rows are not translations of the Korean rows.

## Files

| Path | Purpose |
|---|---|
| `KO/spots_ko.csv` | Final CSV used by the Korean examples |
| `KO/source_bilingual_spots.csv` | Preserved source copy used to build the Korean CSV; not an execution input |
| `KO/build_report.json` | Row counts, QID uniqueness, empty descriptions, and embedding-rule checks |
| `EN/spots_us_en.csv` | Final CSV used by the English examples |
| `EN/collect_us_data.py` | Standard-library-only English collector; no database connection or API key required |
| `EN/collection_report.json` | Candidate counts, exclusion reasons, and final selection counts |
| `KO/README.md`, `EN/README.md` | Full column definitions, collection rules, and text normalization |
| `KO/DATA_LICENSE.md`, `EN/DATA_LICENSE.md` | Component licenses and per-row attribution |
| `KO/LICENSE-CC-BY-SA-4.0.txt`, `EN/LICENSE-CC-BY-SA-4.0.txt` | CC BY-SA 4.0 legal text |

## CSV format and main columns

- Both files use UTF-8, LF line endings, and a header row. Use a CSV parser or database loader because descriptions contain commas.
- `id` is the numeric part of a Wikidata QID, and `qid` has the form `Q<digits>`. Each file has 477 unique IDs and QIDs.
- `name_ko`/`name_en` contain names; `desc_ko`/`desc_en` contain descriptions.
- `embed_text_ko`/`embed_text_en` are derived plain-text inputs for embedding, not vector values.
- The datasets use different whitespace-normalization rules. Use the supplied embedding column unchanged instead of rebuilding it.
- `article_url` identifies the Wikipedia source for each row. English rows also include `revision_id` and `revision_url` when available.

See the dataset-specific README files for the exact normalization rules and all columns.

## Data characteristics and limitations

### Korean

- Categories: `관광지` 195, `박물관` 78, `사찰` 70, `공원` 60, `축제` 35, `성곽` 32, and `궁궐` 7.
- Eight rows have an empty `desc_ko`; their `embed_text_ko` contains only the name.
- **125 rows have an empty `sido`.** Region-filtered queries can only match rows with a populated region, so exclusion of empty-region rows is expected.
- `article_url` is the current Wikidata sitelink used for attribution, not proof of the Wikipedia revision used during original collection.

### English

- Categories: `FESTIVAL` 296 and `TOURIST_ATTRACTION` 181.
- Every row has a populated `state`; there are 47 state values, including 156 California rows.
- No row has an empty `desc_en`, and names and descriptions contain no Hangul.
- Re-running the collector can produce different data as Wikidata, Wikipedia, and Census results change. Use the included `spots_us_en.csv` for reproduction instead of recollecting it.

These files are a static test corpus for vector search and region filtering, not a current travel-information service. Source freshness and travel accuracy are not guaranteed.

## Using the data in the examples

1. Load the Korean and English CSV files into separate tables.
2. Use `sido` for Korean region filters and `state` for English filters. Do not treat the two region schemes as one convention.
3. Generate vectors from each file's supplied embedding-input column.
4. Do not compare vector distances or Top-k rankings directly across languages or embedding models.

Follow the public guides for table creation, loading, indexing, and queries:

- [Korean Oracle 26ai Vector Search guide](../KOR_BLOG_Oracle26ai_Vector_Search.md)
- [English Oracle 26ai Vector Search guide](../ENG_BLOG_Oracle26ai_Vector_Search.md)

Run this basic integrity check from the repository root:

```bash
python3 - <<'PY'
import csv

for path in ("data/KO/spots_ko.csv", "data/EN/spots_us_en.csv"):
    with open(path, encoding="utf-8", newline="") as f:
        rows = list(csv.DictReader(f))
    assert len(rows) == 477, (path, len(rows))
    assert len({row["qid"] for row in rows}) == 477, path
    with open(path, "rb") as f:
        assert b"\r" not in f.read(), path
    print(f"{path}: 477 rows, 477 unique QIDs, UTF-8/LF OK")
PY
```

## Licenses and redistribution

- Wikipedia-derived descriptions and embedding text are subject to **CC BY-SA 4.0**.
- When redistributing, retain each row's `article_url`, `revision_url` where available, the relevant `DATA_LICENSE.md`, and the CC BY-SA 4.0 notice. Article authors are available through each article's revision history.
- Wikidata identifiers and structured metadata are **CC0 1.0**. US Census-derived state information is public domain as a U.S. government work. Exact field-level scope is defined in each `DATA_LICENSE.md`.
- These notices apply to the data and do not relicense every script or document in the repository.

See the [Korean data license](KO/DATA_LICENSE.md) and [English data license](EN/DATA_LICENSE.md) for sources and changes.
