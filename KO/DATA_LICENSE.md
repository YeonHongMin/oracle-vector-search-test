# DATA_LICENSE — data/KO

## 구성 요소별 라이선스

| 구성 | 출처 | 라이선스 |
|---|---|---|
| `name_ko`·`desc_ko`·`embed_text_ko` 텍스트 | 한국어 Wikipedia 기사(행별 `article_url`) | [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/) — 본문 `LICENSE-CC-BY-SA-4.0.txt` |
| `qid`·`id` | Wikidata 엔티티 | [CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/) |
| `sido`·`category` | Wikidata P131·P31 기반 정규화 | CC0 1.0 |
| `article_url` | Wikidata `kowiki` sitelink API 해석 | CC0 1.0 |

## Row attribution 방법

- 각 행의 Wikipedia 텍스트는 `article_url`이 가리키는 ko Wikipedia 기사에서 온다.
- 재배포·수정 시 CC BY-SA 4.0의 표시 의무에 따라 해당 기사 URL과 이 라이선스 표시를 함께 유지한다.
- 기사별 작성자는 각 `article_url`의 Wikipedia 페이지 이력에서 확인한다 — 개별 필자를 이 파일에 열거하지 않고 행 단위 URL로 추적한다.

## 변경 사항 기록

- `desc_ko`·`name_ko`는 원문 그대로 유지했다(수정 없음).
- `embed_text_ko`는 실제 임베딩 입력 규칙(`verify/verify_mac_split.py`)과 동일하게 생성했다: `name_ko`·`desc_ko` 각각 CR 제거+strip 후 `(name or "")+" "+(desc or "")`를 다시 strip해 4,000자 절단. **내부 연속 공백은 collapse하지 않는다** — 원본 공백이 남은 행이 있다(26건).
- `article_url` 컬럼은 이번 배포에서 새로 추가한 파생 메타데이터로, **현재 kowiki sitelink**다 — 원본 수집 시점의 revision은 확인할 수 없으며, 행별 oldid를 주장하지 않는다.
- `source_bilingual_spots.csv`는 원본 그대로(sha256 `467f0471…0fe3e1`).

## 수집·선정 기준

- 원본 477행 전량 유지 — 추가 필터·행 삭제 없음.
- `desc_ko`가 비어 있는 행이 8건 포함되며 이들은 `embed_text_ko`가 이름만으로 구성된다(`build_report.json`의 `empty_desc_ko`).

## 외부 서비스 고지

- Wikipedia·Wikidata 콘텐츠는 각 프로젝트의 이용 조건을 따른다.
- 이 데이터셋에는 개인정보·인증 정보가 포함되지 않는다.
