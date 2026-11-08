# scripts — 책 예제 발췌 모음

『Oracle AI Database 26ai Vector Search』 시리즈(3권 + 통합본) 본문의 예제 코드 블록을 장 단위로 발췌한 모음이다.

- [`kr/`](kr/) — 출간된 한국어 책의 충실 발췌(한글 주석)
- [`en/`](en/) — 영문 주석판. **코드 줄은 `kr/`과 동일**하며 주석과 사용자 대상 샘플 문자열만 영어로 바꿨다. 예제가 기능적으로 의존하는 한글 데이터 리터럴(한국어 코퍼스 질의·지역 필터·형태소 샘플)은 문서화된 결과가 재현되도록 보존했다.

> **실행 가능성** — 책 설명용 발췌다. 일부는 바인드 변수(`:qvec`), POC 보조 객체(`poc_*`·`cct_*`·`hvi_*`), 사전 적재 데이터(공공 데이터 표 — CSV는 [`../KO/`](../KO/)·[`../EN/`](../EN/))를 전제로 하므로 전체 재현은 책의 해당 절차부터.

> **Python 참고** — Python 발췌 3종은 `ast` 검증을 통과했다. `01-pathlib.py`는 DB 서버 Python에 OML4Py(`oml`) 필요. `01-array.py`는 `oracledb`와 `ORACLE_USER`/`ORACLE_PASSWORD`/`ORACLE_DSN` 환경변수로 접속하며 하드코딩된 자격증명이 없다. `04-get_json.py`는 수집 스크립트의 발췌(`BASE`/`get_json` 정의는 책 본문 흐름 참조).

> **개인정보** — kr·en 두 트리와 git 히스토리 전체에서 집 DDNS·개인 계정명·공인 IP 0건을 확인했다. 호스트는 `<dgx spark>` 자리표시자이며 `192.168.0.x`(사설 대역)와 `rac1`/`rac2`만 일반 구성값으로 남아 있다.

## 파일 색인

| 권 | 장(원고 파일) | 파일(`kr/`·`en/` 동일 이름) | 언어 | 발췌 설명(첫 주석·첫 줄) |
| --- | --- | --- | --- | --- |
| 1권 기초 | `01-overview` | [`kr/vol01-foundation/01-overview/01-title.sql`](kr/vol01-foundation/01-overview/01-title.sql) | SQL | 같은 질문을 두 경로로 묻는다 |
| 1권 기초 | `02-vector-type-sql` | [`kr/vol01-foundation/02-vector-type-sql/01-sql_vec_demo.sql`](kr/vol01-foundation/02-vector-type-sql/01-sql_vec_demo.sql) | SQL | CREATE TABLE sql_vec_demo ( |
| 1권 기초 | `02-vector-type-sql` | [`kr/vol01-foundation/02-vector-type-sql/02-vector_dims.sql`](kr/vol01-foundation/02-vector-type-sql/02-vector_dims.sql) | SQL | SELECT id, |
| 1권 기초 | `02-vector-type-sql` | [`kr/vol01-foundation/02-vector-type-sql/03-title.sql`](kr/vol01-foundation/02-vector-type-sql/03-title.sql) | SQL | SELECT id, title, |
| 1권 기초 | `03-embedding-onnx` | [`kr/vol01-foundation/03-embedding-onnx/01-pathlib.py`](kr/vol01-foundation/03-embedding-onnx/01-pathlib.py) | Python | from pathlib import Path |
| 1권 기초 | `03-embedding-onnx` | [`kr/vol01-foundation/03-embedding-onnx/02-dbms_vector_load_onnx_model.sql`](kr/vol01-foundation/03-embedding-onnx/02-dbms_vector_load_onnx_model.sql) | SQL | BEGIN |
| 1권 기초 | `03-embedding-onnx` | [`kr/vol01-foundation/03-embedding-onnx/03-emb_db.sql`](kr/vol01-foundation/03-embedding-onnx/03-emb_db.sql) | SQL | DB 경로: DB 안 모델을 부른다 |
| 1권 기초 | `04-chunking-loading` | [`kr/vol01-foundation/04-chunking-loading/01-doc_id.sql`](kr/vol01-foundation/04-chunking-loading/01-doc_id.sql) | SQL | 비정형 문서를 문자 기준 청크로 나눈다 |
| 1권 기초 | `04-chunking-loading` | [`kr/vol01-foundation/04-chunking-loading/02-dbms_vector_chain_utl_to_embeddings.sql`](kr/vol01-foundation/04-chunking-loading/02-dbms_vector_chain_utl_to_embeddings.sql) | SQL | 문서 행 하나에서 청크 벡터 배열까지 (중첩 호출) |
| 1권 기초 | `04-chunking-loading` | [`kr/vol01-foundation/04-chunking-loading/03-dbms_network_acl_admin_append_host_ace.sql`](kr/vol01-foundation/04-chunking-loading/03-dbms_network_acl_admin_append_host_ace.sql) | SQL | GPU 임베딩 서버에 대한 접속 권한 (호스트와 포트는 예시 값) |
| 1권 기초 | `04-chunking-loading` | [`kr/vol01-foundation/04-chunking-loading/04-get_json.py`](kr/vol01-foundation/04-chunking-loading/04-get_json.py) | Python | 수집 스크립트의 핵심: 컬럼 목록 확인 후 페이지 단위로 전량 수신한다 |
| 1권 기초 | `04-chunking-loading` | [`kr/vol01-foundation/04-chunking-loading/05-poc_data.sh`](kr/vol01-foundation/04-chunking-loading/05-poc_data.sh) | Bash | 워크스테이션에서 수집하고 DB 서버로 옮긴다 |
| 1권 기초 | `04-chunking-loading` | [`kr/vol01-foundation/04-chunking-loading/06-festivals_ext.sql`](kr/vol01-foundation/04-chunking-loading/06-festivals_ext.sql) | SQL | soe — 축제 External Table (CSV 헤더 1행 건너뜀, 빈 칸은 NULL) |
| 1권 기초 | `04-chunking-loading` | [`kr/vol01-foundation/04-chunking-loading/07-festivals_org.sql`](kr/vol01-foundation/04-chunking-loading/07-festivals_org.sql) | SQL | soe — 원본 표로 복제 (불변 기준점) |
| 1권 기초 | `04-chunking-loading` | [`kr/vol01-foundation/04-chunking-loading/08-poc_fest_embed.sql`](kr/vol01-foundation/04-chunking-loading/08-poc_fest_embed.sql) | SQL | soe — 축제 합성 임베딩 문장 (관광지는 장소 대신 유형, 내용 대신 소개를 쓴다) |
| 1권 기초 | `04-chunking-loading` | [`kr/vol01-foundation/04-chunking-loading/09-poc_sido.sql`](kr/vol01-foundation/04-chunking-loading/09-poc_sido.sql) | SQL | soe — 표준 뷰: 파생 표가 모두 같은 컬럼을 갖게 한다 |
| 1권 기초 | `04-chunking-loading` | [`kr/vol01-foundation/04-chunking-loading/10-poc_ctas.sql`](kr/vol01-foundation/04-chunking-loading/10-poc_ctas.sql) | SQL | soe — 파생 표 생성기 |
| 1권 기초 | `04-chunking-loading` | [`kr/vol01-foundation/04-chunking-loading/11-poc_question.sql`](kr/vol01-foundation/04-chunking-loading/11-poc_question.sql) | SQL | soe — 공통 질문 세트 (12문항 중 2건 예) |
| 1권 기초 | `04-chunking-loading` | [`kr/vol01-foundation/04-chunking-loading/12-poc_embed_round.sql`](kr/vol01-foundation/04-chunking-loading/12-poc_embed_round.sql) | SQL | soe — 임베딩 회차: 표를 버킷 세션 수만큼 나눠 잡이 채운다 |
| 1권 기초 | `05-exact-search` | [`kr/vol01-foundation/05-exact-search/01-vector_distance.sql`](kr/vol01-foundation/05-exact-search/01-vector_distance.sql) | SQL | SELECT id, name, sido, |
| 1권 기초 | `05-exact-search` | [`kr/vol01-foundation/05-exact-search/02-poc_search_time.sql`](kr/vol01-foundation/05-exact-search/02-poc_search_time.sql) | SQL | CREATE TABLE poc_search_time ( |
| 1권 기초 | `05-exact-search` | [`kr/vol01-foundation/05-exact-search/03-poc_search_time.sql`](kr/vol01-foundation/05-exact-search/03-poc_search_time.sql) | SQL | v_fetch := CASE |
| 1권 기초 | `05-exact-search` | [`kr/vol01-foundation/05-exact-search/04-poc_run_suite.sql`](kr/vol01-foundation/05-exact-search/04-poc_run_suite.sql) | SQL | EXEC poc_run_suite('EXACT_CACHE', 'KURE', 'EXACT', 'CACHE', 10) |
| 1권 기초 | `05-exact-search` | [`kr/vol01-foundation/05-exact-search/05-poc_run_suite.sql`](kr/vol01-foundation/05-exact-search/05-poc_run_suite.sql) | SQL | EXEC poc_run_suite('EXACT_CACHE_FILTER', 'KURE', 'EXACT', 'CACHE', 3, NULL, 'Y') |
| 1권 기초 | `05-exact-search` | [`kr/vol01-foundation/05-exact-search/06-materialize.sql`](kr/vol01-foundation/05-exact-search/06-materialize.sql) | SQL | VAR q VARCHAR2(400) |
| 1권 기초 | `05-exact-search` | [`kr/vol01-foundation/05-exact-search/07-poc_run_log.sql`](kr/vol01-foundation/05-exact-search/07-poc_run_log.sql) | SQL | LOOP |
| 1권 기초 | `05-exact-search` | [`kr/vol01-foundation/05-exact-search/08-poc_dml_round.sql`](kr/vol01-foundation/05-exact-search/08-poc_dml_round.sql) | SQL | SET SERVEROUTPUT ON |
| 2권 인덱스 | `01-similarity-optimizer` | [`kr/vol02-search-index/01-similarity-optimizer/01-vector_distance.sql`](kr/vol02-search-index/01-similarity-optimizer/01-vector_distance.sql) | SQL | SELECT id, |
| 2권 인덱스 | `01-similarity-optimizer` | [`kr/vol02-search-index/01-similarity-optimizer/02-chunk_id.sql`](kr/vol02-search-index/01-similarity-optimizer/02-chunk_id.sql) | SQL | HNSW: 그래프 탐색 후보 큐의 크기를 직접 지정한다 |
| 2권 인덱스 | `01-similarity-optimizer` | [`kr/vol02-search-index/01-similarity-optimizer/03-chunk_id.sql`](kr/vol02-search-index/01-similarity-optimizer/03-chunk_id.sql) | SQL | SELECT chunk_id, chunk_data |
| 2권 인덱스 | `02-hnsw` | [`kr/vol02-search-index/02-hnsw/01-dbms_vector_index_vector_memory_advisor.sql`](kr/vol02-search-index/02-hnsw/01-dbms_vector_index_vector_memory_advisor.sql) | SQL | soe |
| 2권 인덱스 | `02-hnsw` | [`kr/vol02-search-index/02-hnsw/02-poc_ctas.sql`](kr/vol02-search-index/02-hnsw/02-poc_ctas.sql) | SQL | soe — *_KURE를 벡터 포함 그대로 복제 (PK·sido 인덱스는 poc_ctas가 만든다) |
| 2권 인덱스 | `02-hnsw` | [`kr/vol02-search-index/02-hnsw/03-festivals_kure_hnsw_idx.sql`](kr/vol02-search-index/02-hnsw/03-festivals_kure_hnsw_idx.sql) | SQL | soe |
| 2권 인덱스 | `02-hnsw` | [`kr/vol02-search-index/02-hnsw/04-docs_hnsw_sq_idx.sql`](kr/vol02-search-index/02-hnsw/04-docs_hnsw_sq_idx.sql) | SQL | CREATE VECTOR INDEX docs_hnsw_sq_idx ON doc_chunks (chunk_embedding) |
| 2권 인덱스 | `03-ivf` | [`kr/vol02-search-index/03-ivf/01-poc_ctas.sql`](kr/vol02-search-index/03-ivf/01-poc_ctas.sql) | SQL | soe |
| 2권 인덱스 | `03-ivf` | [`kr/vol02-search-index/03-ivf/02-festivals_kure_ivf_idx.sql`](kr/vol02-search-index/03-ivf/02-festivals_kure_ivf_idx.sql) | SQL | soe |
| 2권 인덱스 | `03-ivf` | [`kr/vol02-search-index/03-ivf/03-festivals_kure_livf_idx.sql`](kr/vol02-search-index/03-ivf/03-festivals_kure_livf_idx.sql) | SQL | soe — 시·도 LIST 파티션 복제 표에 로컬 IVF |
| 2권 인덱스 | `04-hybrid-vector-index` | [`kr/vol02-search-index/04-hybrid-vector-index/01-poc_ko_lexer.sql`](kr/vol02-search-index/04-hybrid-vector-index/01-poc_ko_lexer.sql) | SQL | soe : 한국어 형태소 lexer. 키워드 다리의 토큰 품질을 좌우한다 |
| 2권 인덱스 | `04-hybrid-vector-index` | [`kr/vol02-search-index/04-hybrid-vector-index/02-festivals_kure_hvi_idx.sql`](kr/vol02-search-index/04-hybrid-vector-index/02-festivals_kure_hvi_idx.sql) | SQL | soe : 텍스트만 복제한 표. 벡터 컬럼이 없어도 HVI가 내부에 청크와 임베딩을 만든다 |
| 2권 인덱스 | `04-hybrid-vector-index` | [`kr/vol02-search-index/04-hybrid-vector-index/03-idx_name.sql`](kr/vol02-search-index/04-hybrid-vector-index/03-idx_name.sql) | SQL | soe : 생성 확인 |
| 2권 인덱스 | `04-hybrid-vector-index` | [`kr/vol02-search-index/04-hybrid-vector-index/04-poc_vectorizer_kure_gpu.sql`](kr/vol02-search-index/04-hybrid-vector-index/04-poc_vectorizer_kure_gpu.sql) | SQL | soe : GPU embedder. 프리퍼런스 JSON의 최상위에는 model 키를 두지 않는다(두면 DB 모델 경로) |
| 2권 인덱스 | `04-hybrid-vector-index` | [`kr/vol02-search-index/04-hybrid-vector-index/05-dbms_hybrid_vector_search.sql`](kr/vol02-search-index/04-hybrid-vector-index/05-dbms_hybrid_vector_search.sql) | SQL | soe : 하이브리드 1건(RRF, 1:1, 지역 필터) |
| 2권 인덱스 | `04-hybrid-vector-index` | [`kr/vol02-search-index/04-hybrid-vector-index/06-poc_hvi_search.sql`](kr/vol02-search-index/04-hybrid-vector-index/06-poc_hvi_search.sql) | SQL | soe : SYNC 전 검색. 새 행은 결과에 없다(ctx_user_pending에 대기 1행) |
| 2권 인덱스 | `05-vector-pool` | [`kr/vol02-search-index/05-vector-pool/01-vector_memory_size.sql`](kr/vol02-search-index/05-vector-pool/01-vector_memory_size.sql) | SQL | 풀 크기를 4G로 지정하고 확인한다 (4G는 예시 값) |
| 2권 인덱스 | `05-vector-pool` | [`kr/vol02-search-index/05-vector-pool/02-dbms_vector_index_vector_memory_advisor.sql`](kr/vol02-search-index/05-vector-pool/02-dbms_vector_index_vector_memory_advisor.sql) | SQL | SET SERVEROUTPUT ON |
| 2권 인덱스 | `06-diagnostics` | [`kr/vol02-search-index/06-diagnostics/01-dbms_vector_index_accuracy_query.sql`](kr/vol02-search-index/06-diagnostics/01-dbms_vector_index_accuracy_query.sql) | SQL | 1) 단건 대조: 근사 인덱스 결과와 Exact 결과의 즉시 비교 |
| 2권 인덱스 | `06-diagnostics` | [`kr/vol02-search-index/06-diagnostics/02-poc_run_v.sql`](kr/vol02-search-index/06-diagnostics/02-poc_run_v.sql) | SQL | soe |
| 3권 운영 | `01-manual-hybrid-wrrf` | [`kr/vol03-rag-ops/01-manual-hybrid-wrrf/01-festivals_kure_mhs_idx.sql`](kr/vol03-rag-ops/01-manual-hybrid-wrrf/01-festivals_kure_mhs_idx.sql) | SQL | soe — 복제 표 생성(벡터 컬럼 포함 CTAS) |
| 3권 운영 | `01-manual-hybrid-wrrf` | [`kr/vol03-rag-ops/01-manual-hybrid-wrrf/02-count.sql`](kr/vol03-rag-ops/01-manual-hybrid-wrrf/02-count.sql) | SQL | soe — 조사가 붙은 원문에서도 명사로 일치하는지 확인한다 |
| 3권 운영 | `01-manual-hybrid-wrrf` | [`kr/vol03-rag-ops/01-manual-hybrid-wrrf/03-manual_hybrid_search.sql`](kr/vol03-rag-ops/01-manual-hybrid-wrrf/03-manual_hybrid_search.sql) | SQL | soe — 결과 행 타입 |
| 3권 운영 | `01-manual-hybrid-wrrf` | [`kr/vol03-rag-ops/01-manual-hybrid-wrrf/04-festivals_kure_mhs.sql`](kr/vol03-rag-ops/01-manual-hybrid-wrrf/04-festivals_kure_mhs.sql) | SQL | soe — 단일 SQL 형태: 같은 WRRF 계약(후보 30, k=60, 가중치 1:1)을 SELECT 한 문장으로 |
| 3권 운영 | `01-manual-hybrid-wrrf` | [`kr/vol03-rag-ops/01-manual-hybrid-wrrf/05-mhs_search.sql`](kr/vol03-rag-ops/01-manual-hybrid-wrrf/05-mhs_search.sql) | SQL | soe — 파이프라인 함수 호출 예: SELECT 안에서 같은 WRRF 계약을 쓴다 |
| 3권 운영 | `01-manual-hybrid-wrrf` | [`kr/vol03-rag-ops/01-manual-hybrid-wrrf/06-mhs_parse.sql`](kr/vol03-rag-ops/01-manual-hybrid-wrrf/06-mhs_parse.sql) | SQL | soe — 불용어 표(검색에 무의미한 토큰 제외용) |
| 3권 운영 | `01-manual-hybrid-wrrf` | [`kr/vol03-rag-ops/01-manual-hybrid-wrrf/07-poc_rag_show.sql`](kr/vol03-rag-ops/01-manual-hybrid-wrrf/07-poc_rag_show.sql) | SQL | soe — 생성 파라미터(축약): reasoning 키로 추론 문장 유출을 막는다 |
| 3권 운영 | `01-manual-hybrid-wrrf` | [`kr/vol03-rag-ops/01-manual-hybrid-wrrf/08-poc_tok.sql`](kr/vol03-rag-ops/01-manual-hybrid-wrrf/08-poc_tok.sql) | SQL | soe — 토큰 함수 (검색·색인 공용) |
| 3권 운영 | `01-manual-hybrid-wrrf` | [`kr/vol03-rag-ops/01-manual-hybrid-wrrf/09-poc_kw_doc.sql`](kr/vol03-rag-ops/01-manual-hybrid-wrrf/09-poc_kw_doc.sql) | SQL | soe — 자체 토큰 색인 표 구성 |
| 3권 운영 | `01-manual-hybrid-wrrf` | [`kr/vol03-rag-ops/01-manual-hybrid-wrrf/10-poc_kwa.sql`](kr/vol03-rag-ops/01-manual-hybrid-wrrf/10-poc_kwa.sql) | SQL | soe — 엄격 AND 키워드 다리: 순위순 id 목록을 돌려준다(p_tab은 F(축제)/S(관광지)) |
| 3권 운영 | `01-manual-hybrid-wrrf` | [`kr/vol03-rag-ops/01-manual-hybrid-wrrf/11-poc_kwa.sql`](kr/vol03-rag-ops/01-manual-hybrid-wrrf/11-poc_kwa.sql) | SQL | soe — MANUAL_HYBRID_SEARCH_TOK의 키워드 다리(5단계)만 발췌. 인자·결과 커서는 원판과 같다 |
| 3권 운영 | `02-select-ai-nl2sql` | [`kr/vol03-rag-ops/02-select-ai-nl2sql/01-poc_ai_festivals.sql`](kr/vol03-rag-ops/02-select-ai-nl2sql/01-poc_ai_festivals.sql) | SQL | soe — LLM에게 보여 줄 뷰: 벡터 컬럼 같은 내부 구현을 숨기고 이해 가능한 형태만 노출한다 |
| 3권 운영 | `02-select-ai-nl2sql` | [`kr/vol03-rag-ops/02-select-ai-nl2sql/02-poc_ai_festivals.sql`](kr/vol03-rag-ops/02-select-ai-nl2sql/02-poc_ai_festivals.sql) | SQL | soe — 프로필의 comments 속성이 이 설명을 프롬프트에 포함한다 |
| 3권 운영 | `02-select-ai-nl2sql` | [`kr/vol03-rag-ops/02-select-ai-nl2sql/03-poc_ai_or_llama.sql`](kr/vol03-rag-ops/02-select-ai-nl2sql/03-poc_ai_or_llama.sql) | SQL | soe — 표준 프로필: 비추론 모델 (이 장의 골든 채점은 추론 모델 프로필로 실행했다) |
| 3권 운영 | `02-select-ai-nl2sql` | [`kr/vol03-rag-ops/02-select-ai-nl2sql/04-poc_nl2sql_golden.sql`](kr/vol03-rag-ops/02-select-ai-nl2sql/04-poc_nl2sql_golden.sql) | SQL | soe — 골든 문항 표: 정답 SQL은 사람이 검증한 기준이다 |
| 3권 운영 | `02-select-ai-nl2sql` | [`kr/vol03-rag-ops/02-select-ai-nl2sql/05-poc_nl2sql_run.sql`](kr/vol03-rag-ops/02-select-ai-nl2sql/05-poc_nl2sql_run.sql) | SQL | soe — 문항 1개 × 3회 × (showsql, runsql). 재호출하면 해당 문항 기록을 지우고 새로 기록한다 |
| 3권 운영 | `02-select-ai-nl2sql` | [`kr/vol03-rag-ops/02-select-ai-nl2sql/06-mhs_ask.sql`](kr/vol03-rag-ops/02-select-ai-nl2sql/06-mhs_ask.sql) | SQL | soe — 검색 경로: GPU로 질문 임베딩 + 형태소 키워드 + 지역 필터 |
| 3권 운영 | `02-select-ai-nl2sql` | [`kr/vol03-rag-ops/02-select-ai-nl2sql/07-poc_ai_ask.sql`](kr/vol03-rag-ops/02-select-ai-nl2sql/07-poc_ai_ask.sql) | SQL | soe — 폴백 래퍼 함수: 1차가 실패·빈 응답이면 폴백으로 전달한다 |
| 3권 운영 | `02-select-ai-nl2sql` | [`kr/vol03-rag-ops/02-select-ai-nl2sql/08-poc_ai_qwen36.sql`](kr/vol03-rag-ops/02-select-ai-nl2sql/08-poc_ai_qwen36.sql) | SQL | soe — F2 주입: 1차 프로필 model을 없는 이름으로 바꾼다 (시험·원복은 같은 형태) |
| 3권 운영 | `02-select-ai-nl2sql` | [`kr/vol03-rag-ops/02-select-ai-nl2sql/09-poc_llm_round.sql`](kr/vol03-rag-ops/02-select-ai-nl2sql/09-poc_llm_round.sql) | SQL | soe — 회차 1: 로컬 LLM 4세션. 회차 2는 60초 쉰 뒤 Qwen, 회차 3·4는 순서를 바꾼 재현 |
| 3권 운영 | `03-clients-patterns` | [`kr/vol03-rag-ops/03-clients-patterns/01-array.py`](kr/vol03-rag-ops/03-clients-patterns/01-array.py) | Python | import array |
| 3권 운영 | `04-db-prep-ha` | [`kr/vol03-rag-ops/04-db-prep-ha/01-pga_aggregate_target.sql`](kr/vol03-rag-ops/04-db-prep-ha/01-pga_aggregate_target.sql) | SQL | SYS @ CDB$ROOT — CDB 먼저, 그다음 PDB(반대면 ORA-56747) |
| 3권 운영 | `04-db-prep-ha` | [`kr/vol03-rag-ops/04-db-prep-ha/02-cluster_database.sh`](kr/vol03-rag-ops/04-db-prep-ha/02-cluster_database.sh) | Bash | oracle @ rac1 — SYS @ CDB$ROOT (ORACLE_SID=PROD1) |
| 3권 운영 | `04-db-prep-ha` | [`kr/vol03-rag-ops/04-db-prep-ha/03-system.sql`](kr/vol03-rag-ops/04-db-prep-ha/03-system.sql) | SQL | SYS @ CDB$ROOT — 이미 Y인 fix에서 나는 ORA-59119는 무시하고 진행한다 |
| 3권 운영 | `04-db-prep-ha` | [`kr/vol03-rag-ops/04-db-prep-ha/04-poc_models.sql`](kr/vol03-rag-ops/04-db-prep-ha/04-poc_models.sql) | SQL | SYS @ PDB1 — 요지 |
| 3권 운영 | `04-db-prep-ha` | [`kr/vol03-rag-ops/04-db-prep-ha/05-con_name.sql`](kr/vol03-rag-ops/04-db-prep-ha/05-con_name.sql) | SQL | SYS @ PDB1 — CONTEXT 설치 요지 |
| 3권 운영 | `06-troubleshooting-ops` | [`kr/vol03-rag-ops/06-troubleshooting-ops/01-parse_calls.sql`](kr/vol03-rag-ops/06-troubleshooting-ops/01-parse_calls.sql) | SQL | CTXSYS 내부 SQL의 재파싱 확인(실행 직후, SYS) |
| 3권 운영 | `06-troubleshooting-ops` | [`kr/vol03-rag-ops/06-troubleshooting-ops/02-poc_qfc_store.sql`](kr/vol03-rag-ops/06-troubleshooting-ops/02-poc_qfc_store.sql) | SQL | filter cache 완화(요약): 크기 부여 뒤 인덱스 메타데이터만 교체 |
| 3권 운영 | `06-troubleshooting-ops` | [`kr/vol03-rag-ops/06-troubleshooting-ops/03-model_name.sql`](kr/vol03-rag-ops/06-troubleshooting-ops/03-model_name.sql) | SQL | 매일 점검의 핵심 뷰(요약) |

- 트리당 76개 파일 — SQL 71 · Python 3 · Bash 2
- 영문 색인: [`README.md`](README.md) · 데이터 CSV: [`../KO/`](../KO/)·[`../EN/`](../EN/)
