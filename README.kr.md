# Oracle 26ai Vector Search 테스트 데이터

[English](README.md)

**저장소:** <https://github.com/YeonHongMin/oracle-vector-search-test>

Oracle AI Database **26ai 23.26.3** Vector Search 예제에서 사용하는 공개 테스트 데이터입니다. CSV에는 임베딩할 원문과 메타데이터가 있으며, 미리 계산한 벡터나 데이터베이스 덤프는 포함하지 않습니다.

## 데이터셋 개요

| 구분 | 한국어(KO) | English(EN) |
|---|---|---|
| 실행 CSV | [`KO/spots_ko.csv`](KO/spots_ko.csv) | [`EN/spots_us_en.csv`](EN/spots_us_en.csv) |
| 내용 | 한국의 관광지·박물관·사찰·공원·축제·성곽·궁궐 | 미국의 축제·관광지 |
| 데이터 행 수 | 477행(헤더 제외) | 477행(헤더 제외) |
| 지역 컬럼 | `sido`: `서울`, `경기` 같은 시·도 약칭 | `state`: `California` 같은 주 전체 이름 |
| 임베딩 입력 | `embed_text_ko` | `embed_text_en` |
| 출처 | 한국어 Wikipedia, Wikidata | 영어 Wikipedia, Wikidata, US Census Geocoder |
| 상세 설명 | [`KO/README.md`](KO/README.md) | [`EN/README.md`](EN/README.md) |
| 영어 안내서 | [`README.md`](README.md) | [`README.md`](README.md) |

두 데이터셋은 독립적입니다. 행 수가 같은 것은 영어 데이터의 선정 목표를 477행으로 정했기 때문이며, 같은 QID나 행끼리 대응한다는 의미가 아닙니다. 한국어 행을 영어로 번역한 데이터도 아닙니다.

## 파일 구성

| 경로 | 설명 |
|---|---|
| `KO/spots_ko.csv` | 한국어 예제에서 사용하는 최종 CSV |
| `KO/source_bilingual_spots.csv` | 한국어 CSV를 만드는 데 사용한 원본 보존 복사본. 현재 예제의 실행 입력이 아님 |
| `KO/build_report.json` | 행 수, QID 중복 여부, 빈 설명, 임베딩 입력 규칙 검증 결과 |
| `EN/spots_us_en.csv` | 영어 예제에서 사용하는 최종 CSV |
| `EN/collect_us_data.py` | Python 표준 라이브러리만 사용하는 영어 데이터 수집기. DB 연결과 API 키가 필요 없음 |
| `EN/collection_report.json` | 후보 수, 제외 사유, 최종 선정 건수 |
| `KO/README.md`, `EN/README.md` | 전체 컬럼 정의, 수집·선정 방법, 텍스트 정규화 규칙 |
| `KO/DATA_LICENSE.md`, `EN/DATA_LICENSE.md` | 구성 요소별 출처, 라이선스, 행 단위 저작자 표시 방법 |
| `KO/LICENSE-CC-BY-SA-4.0.txt`, `EN/LICENSE-CC-BY-SA-4.0.txt` | CC BY-SA 4.0 전문 |

## CSV 형식과 주요 컬럼

- 두 CSV 모두 UTF-8, LF 줄바꿈, 첫 행 헤더 형식입니다. 설명에 쉼표가 포함되어 있으므로 텍스트를 직접 나누지 말고 CSV 파서나 데이터베이스 로더를 사용해야 합니다.
- `id`는 Wikidata QID의 숫자 부분이고, `qid`는 `Q<숫자>` 형식입니다. 각 파일 안에서 `id`와 `qid`는 모두 중복 없이 477개입니다.
- `name_ko`/`name_en`은 이름, `desc_ko`/`desc_en`은 소개문입니다.
- `embed_text_ko`/`embed_text_en`은 이름과 소개문을 결합한 임베딩 입력용 파생 컬럼입니다. 벡터 값이 아니라 평문입니다.
- 두 데이터셋의 공백 정리 규칙은 다릅니다. 임베딩 입력을 다시 조합하지 말고 CSV에 있는 컬럼을 그대로 사용해야 예제와 같은 입력을 재현할 수 있습니다.
- `article_url`은 행별 Wikipedia 출처를 식별합니다. 영어 데이터는 revision을 확보한 행에 `revision_id`와 `revision_url`도 제공합니다.

각 데이터셋의 전체 컬럼과 정확한 정규화 식은 해당 디렉터리의 README에 기록했습니다.

## 데이터 특성과 제한

### 한국어

- 분류는 `관광지` 195, `박물관` 78, `사찰` 70, `공원` 60, `축제` 35, `성곽` 32, `궁궐` 7건입니다.
- `desc_ko`가 빈 행은 8건입니다. 이 경우 `embed_text_ko`는 이름만 포함합니다.
- **`sido`가 빈 행은 125건입니다.** 지역 조건을 사용하는 쿼리는 `sido`가 채워진 행만 대상으로 하므로, 빈 지역의 행이 결과에서 제외되는 것은 오류가 아닙니다.
- `article_url`은 현재 Wikidata sitelink로 확인한 출처입니다. 원본 수집 시점의 Wikipedia revision을 뜻하지는 않습니다.

### 영어

- 분류는 `FESTIVAL` 296건, `TOURIST_ATTRACTION` 181건입니다.
- `state`는 비어 있지 않으며 47개 값이 있습니다. California는 156건입니다.
- `desc_en`이 빈 행은 없습니다. 이름과 소개문에는 한글이 없습니다.
- 수집기를 다시 실행하면 Wikidata, Wikipedia, Census 결과가 변경되어 공개 CSV와 달라질 수 있습니다. 예제 재현에는 수집기 실행 대신 이미 포함된 `spots_us_en.csv`를 사용하세요.

이 데이터는 최신 여행 정보를 제공하기 위한 서비스 데이터가 아니라 벡터 검색과 지역 필터를 시험하기 위한 정적 테스트 코퍼스입니다. 원문의 최신성이나 여행 정보의 정확성을 보장하지 않습니다.

## 예제에서 사용하는 방법

1. 한국어와 영어 CSV를 서로 다른 테이블에 적재합니다.
2. 한국어는 `sido`, 영어는 `state`를 지역 필터에 사용합니다. 두 지역 체계를 한 컬럼 규칙으로 취급하지 않습니다.
3. 각 CSV의 임베딩 입력 컬럼을 사용해 별도로 벡터를 생성합니다.
4. 언어가 다르거나 임베딩 모델이 다른 테이블 사이에서 벡터 거리나 Top-k 순위를 직접 비교하지 않습니다.

테이블 생성, CSV 적재, 벡터 인덱스 생성, 쿼리 실행은 다음 공개 절차서를 따릅니다.

- [한국어 Oracle 26ai Vector Search 절차서](../KOR_BLOG_Oracle26ai_Vector_Search.md)
- [영어 Oracle 26ai Vector Search 절차서](../ENG_BLOG_Oracle26ai_Vector_Search.md)

저장소 루트에서 다음 명령으로 두 CSV의 기본 무결성을 확인할 수 있습니다.

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

## 라이선스와 재배포 조건

- Wikipedia에서 가져온 설명문과 이를 포함하는 임베딩 입력 텍스트는 **CC BY-SA 4.0**이 적용됩니다.
- 재배포할 때는 행별 `article_url`, 가능한 경우 `revision_url`, 해당 `DATA_LICENSE.md`, CC BY-SA 4.0 라이선스 전문을 함께 유지해야 합니다. 기사별 작성자는 연결된 Wikipedia 기사의 편집 이력에서 확인합니다.
- Wikidata 식별자와 구조화 메타데이터는 **CC0 1.0**, US Census Geocoder에서 파생한 주 정보는 미국 정부 저작물로서 퍼블릭 도메인입니다. 필드별 적용 범위는 각 `DATA_LICENSE.md`가 기준입니다.
- 이 고지는 데이터에 관한 것이며 저장소의 코드와 문서 전체를 CC BY-SA 4.0으로 변경한다는 의미가 아닙니다.

자세한 출처와 변경 내역은 [한국어 데이터 라이선스](KO/DATA_LICENSE.md)와 [영어 데이터 라이선스](EN/DATA_LICENSE.md)를 참조하세요.
