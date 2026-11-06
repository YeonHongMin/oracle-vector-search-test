# spots_ko.csv — 한국 관광지·축제 한국어 테스트 데이터

한국 장소 477행의 한국어 이름·소개·메타데이터로 구성한 독립 데이터셋이다. Oracle AI Database 26ai 벡터 검색 POC의 공개 테스트 데이터로, 이 디렉터리만으로 재현할 수 있다.

## 파일

| 파일 | 내용 |
|---|---|
| `spots_ko.csv` | 최종 데이터 477행 |
| `source_bilingual_spots.csv` | 원본 `data/bilingual_spots.csv`의 byte-identical 복사(sha256 `467f0471…0fe3e1` 검증 완료) |
| `build_report.json` | 생성·검증 결과(행수·QID 유니크·CR·article_url 해석 등) |
| `LICENSE-CC-BY-SA-4.0.txt` | CC BY-SA 4.0 공식 legalcode 본문 |
| `DATA_LICENSE.md` | 출처·라이선스·row attribution 방법 |
| `README.md` | 이 파일 |

## 컬럼

| 컬럼 | 설명 |
|---|---|
| `id` | QID 숫자부(기존 원본과 동일) |
| `qid` | Wikidata QID(`Q<숫자>`) |
| `name_ko` | 한국어 이름 |
| `desc_ko` | 한국어 소개(ko Wikipedia lead 계열 텍스트) |
| `sido` | 시·도 약칭(서울·경기·… — Wikidata P131 조상 정규화) |
| `category` | 유형 분류(관광지·박물관·사찰·공원·축제·성곽·궁궐 — P31 기반) |
| `embed_text_ko` | `name_ko` + 공백 + `desc_ko`(CR 제거·공백 정리·≤4,000자 — 벡터 임베딩 입력과 동일 규칙) |
| `article_url` | 행별 ko Wikipedia 기사 URL(Wikidata `kowiki` sitelink로 해석, 전 행 존재 확인) |
| `source` | 출처 식별자(`ko.wikipedia.org+wikidata`) |

## 출처·선정 기준

- 원본: `source_bilingual_spots.csv`(477행) — ko/en Wikipedia 기사 페어 + Wikidata(QID·P131·P31)로 구축된 기존 코퍼스의 선별본.
- 이번 작업은 한국어 필드만 독립 추출 + `embed_text_ko` 생성 + `article_url`을 Wikidata sitelink API(`wbgetentities`)로 해석해 추가했다. 원문은 번역·요약·창작하지 않았다.
- 텍스트 정규화: 임베딩 입력용 `embed_text_ko`만 실제 검증 코드(`verify/verify_mac_split.py`)와 같은 규칙으로 생성했다 — `name_ko`·`desc_ko` 각각 CR 제거+strip 후 `(name or "")+" "+(desc or "")`를 다시 strip해 4,000자로 절단. **필드 내부의 연속 공백·공백 run은 collapse하지 않는다**(원본 연속 공백이 남은 행이 26건 있다). `name_ko`·`desc_ko` 원문은 변경하지 않았다.

## 라이선스·한계

본문 텍스트(name/desc/embed_text)는 **Wikipedia 기사 텍스트로 CC BY-SA 4.0** 대상이며, 행별 기사는 `article_url`로 개별 식별한다. QID·좌표 등 구조화 식별자는 **Wikidata(CC0)** 출처다. `article_url`은 attribution용 **현재 sitelink**이며, 원본 수집 시점의 revision은 확인할 수 없으므로 특정 oldid를 주장하지 않는다. 상세는 `DATA_LICENSE.md`와 `LICENSE-CC-BY-SA-4.0.txt`를 본다.

## 재현 검증

```bash
python3 - <<'PY'
import csv, hashlib
rows = list(csv.DictReader(open("data/KO/spots_ko.csv", encoding="utf-8")))
assert len(rows) == 477
assert len({r["qid"] for r in rows}) == 477
assert all("ko.wikipedia.org" in r["article_url"] or "wikidata.org" in r["article_url"] for r in rows)
mm = 0
for r in rows:
    nk = (r["name_ko"] or "").replace("\r", "").strip()
    dk = (r["desc_ko"] or "").replace("\r", "").strip()
    if r["embed_text_ko"] != ((nk or "") + " " + (dk or "")).strip()[:4000]:
        mm += 1
assert mm == 0, mm  # 실제 embed 규칙 불일치 0
b = open("data/KO/spots_ko.csv", "rb").read()
assert b.count(b"\r") == 0  # UTF-8 LF, 바이트 수준 CR 0
print("sha256:", hashlib.sha256(open("data/KO/source_bilingual_spots.csv","rb").read()).hexdigest())
PY
```
