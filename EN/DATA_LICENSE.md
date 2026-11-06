# DATA_LICENSE — data/EN

## Component licenses

| Content | Source | License |
|---|---|---|
| `desc_en` | English Wikipedia lead extract (`article_url` per row; `revision_url` when the batch API returned a revision id) | [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/) — full text in `LICENSE-CC-BY-SA-4.0.txt` |
| `name_en` | Wikidata label — not Wikipedia article text | [CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/) |
| `embed_text_en` | Derived field = normalized `name_en` + normalized `desc_en` (≤4,000 chars) | CC BY-SA 4.0 (contains Wikipedia-derived text) |
| `qid`·`id`·`lat`·`lon`·`category` | Wikidata entities/statements (P17, P31, P625, sitelinks) | [CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/) |
| `state`·`state_fips` | US Census Geocoder `geographies/coordinatesbatch` + official `state.txt` | US government work — public domain |
| `state_resolution`·`source`·`license` | Derived metadata generated for this dataset | CC0 1.0 |

## Row attribution

- Every row's Wikipedia text traces to `article_url`; where a revision id was returned, `revision_url` is a permanent link to the exact revision the extract came from. Rows collected through the REST summary fallback may lack a revision id (empty `revision_id`/`revision_url` fields).
- Do not strip `article_url` when redistributing — it is the per-row attribution mechanism required by CC BY-SA.
- Article authors are listed in each article's revision history on Wikipedia, reachable through `article_url`; individual author names are not duplicated here.

## Changes made to source text

- `name_en` (Wikidata label) was stripped; `desc_en` had CR removed, all whitespace runs collapsed to single spaces, and was stripped (the collector's `clean_desc`). Wording itself is unchanged — no translation, summarization, paraphrasing, or generation.
- `embed_text_en` is a derived field: normalized `name_en` + single space + normalized `desc_en`, truncated at 4,000 characters. Documented, mechanical normalization only.
- Filtering was exclusion-only: rows failing the quality rules in `README.md`/`collection_report.json` were dropped whole; no row text was edited to make it pass.

## Census notice

This product uses the Census Bureau Data API but is not endorsed or certified by the Census Bureau.

## Collection notes

- Sources: Wikidata Query Service / qlever, en.wikipedia.org Action API + REST API, US Census Geocoder batch service, Census `state.txt`.
- Raw API responses are cached outside the published tree (build cache); the published files are the final CSV, the collector, this license, README, and `collection_report.json`.
- No personal data, credentials, API keys, or secrets are included.
