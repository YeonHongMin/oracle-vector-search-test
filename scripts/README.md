# scripts — 책 예제 발췌 모음

『Oracle AI Database 26ai Vector Search』 시리즈(3권 + 통합본) 본문의 예제 코드 블록을 장 단위로 발췌한 모음이다.

> **실행 가능성 안내** — 책 설명용 발췌다. 일부는 바인드 변수(`:qvec`), POC 보조 객체(`poc_*`·`cct_*`·`hvi_*`), 사전 적재 데이터(공공 축제·관광지 표)를 전제로 하므로 그대로 재현하려면 책의 해당 절차가 먼저 필요하다.
>
> **개인정보 검증** — 원고 전체에서 집 DDNS·개인 계정명·공인 IP·구버전 호스트 자리표시자 0건을 확인했다(현재는 `<dgx spark>` 표기로 통일). 호스트 자리는 `<dgx spark>` 표기이며, `192.168.0.x`(사설 대역)와 `rac1`/`rac2` 호스트명만 실값으로 남아 있다(일반 구성값).
>
> **주의** — 원천 문서 `references/test-poc/PUBLIC_Oracle26ai_POC.md`는 실제 개인 정보(집 DDNS·공인 IP)를 그대로 포함한다. **이 저장소를 GitHub에 올릴 때는 해당 파일(가능하면 `references/test-poc/` 전체)을 커밋 대상에서 제외하라.**

## 파일 색인

| 권 | 장(원고 파일) | 절 | 파일 | 언어 | 발췌 설명(첫 주석·첫 줄) |
| --- | --- | --- | --- | --- | --- |
| 1권 기초 | `01-overview` | Exact 검색과 Approximate 검색 | [`vol01-foundation/01-overview/01-title.sql`](vol01-foundation/01-overview/01-title.sql) | sql | 같은 질문을 두 경로로 묻는다 |
| 1권 기초 | `02-vector-type-sql` | 내부 저장 구조와 제약의 경계 | [`vol01-foundation/02-vector-type-sql/01-sql_vec_demo.sql`](vol01-foundation/02-vector-type-sql/01-sql_vec_demo.sql) | sql | CREATE TABLE sql_vec_demo ( |
| 1권 기초 | `02-vector-type-sql` | 벡터를 만들고 꺼내는 함수와 산술 | [`vol01-foundation/02-vector-type-sql/02-vector_dims.sql`](vol01-foundation/02-vector-type-sql/02-vector_dims.sql) | sql | SELECT id, |
| 1권 기초 | `02-vector-type-sql` | 거리 메트릭과 사용자 정의 거리 | [`vol01-foundation/02-vector-type-sql/03-title.sql`](vol01-foundation/02-vector-type-sql/03-title.sql) | sql | SELECT id, title, |
| 1권 기초 | `03-embedding-onnx` | KURE-v1 선정과 변환 장애 | [`vol01-foundation/03-embedding-onnx/01-pathlib.py`](vol01-foundation/03-embedding-onnx/01-pathlib.py) | python | from pathlib import Path |
| 1권 기초 | `03-embedding-onnx` | INMEMORY 적재와 공유 메모리 | [`vol01-foundation/03-embedding-onnx/02-dbms_vector_load_onnx_model.sql`](vol01-foundation/03-embedding-onnx/02-dbms_vector_load_onnx_model.sql) | sql | BEGIN |
| 1권 기초 | `03-embedding-onnx` | DB와 GPU 임베딩 정합 검증 | [`vol01-foundation/03-embedding-onnx/03-emb_db.sql`](vol01-foundation/03-embedding-onnx/03-emb_db.sql) | sql | DB 경로: DB 안 모델을 부른다 |
| 1권 기초 | `04-chunking-loading` | VECTOR_CHUNKS: 원문 행을 청크 행으로 | [`vol01-foundation/04-chunking-loading/01-doc_id.sql`](vol01-foundation/04-chunking-loading/01-doc_id.sql) | sql | 비정형 문서를 문자 기준 청크로 나눈다 |
| 1권 기초 | `04-chunking-loading` | DBMS_VECTOR와 DBMS_VECTOR_CHAIN: SQL 체인 파 | [`vol01-foundation/04-chunking-loading/02-dbms_vector_chain_utl_to_embeddings.sql`](vol01-foundation/04-chunking-loading/02-dbms_vector_chain_utl_to_embeddings.sql) | sql | 문서 행 하나에서 청크 벡터 배열까지 (중첩 호출) |
| 1권 기초 | `04-chunking-loading` | 외부 공급자의 세 관문과 임베딩 경로 | [`vol01-foundation/04-chunking-loading/03-dbms_network_acl_admin_append_host_ace.sql`](vol01-foundation/04-chunking-loading/03-dbms_network_acl_admin_append_host_ace.sql) | sql | GPU 임베딩 서버에 대한 접속 권한 (호스트와 포트는 예시 값) |
| 1권 기초 | `04-chunking-loading` | 설계 사례: 공공데이터를 전량 수집한다 | [`vol01-foundation/04-chunking-loading/04-get_json.py`](vol01-foundation/04-chunking-loading/04-get_json.py) | python | 수집 스크립트의 핵심: 컬럼 목록 확인 후 페이지 단위로 전량 수신한다 |
| 1권 기초 | `04-chunking-loading` | 설계 사례: 공공데이터를 전량 수집한다 | [`vol01-foundation/04-chunking-loading/05-poc_data.sh`](vol01-foundation/04-chunking-loading/05-poc_data.sh) | bash | 워크스테이션에서 수집하고 DB 서버로 옮긴다 |
| 1권 기초 | `04-chunking-loading` | External Table에서 원본 표까지 | [`vol01-foundation/04-chunking-loading/06-festivals_ext.sql`](vol01-foundation/04-chunking-loading/06-festivals_ext.sql) | sql | soe — 축제 External Table (CSV 헤더 1행 건너뜀, 빈 칸은 NULL) |
| 1권 기초 | `04-chunking-loading` | External Table에서 원본 표까지 | [`vol01-foundation/04-chunking-loading/07-festivals_org.sql`](vol01-foundation/04-chunking-loading/07-festivals_org.sql) | sql | soe — 원본 표로 복제 (불변 기준점) |
| 1권 기초 | `04-chunking-loading` | 합성 임베딩 문장 embed_text | [`vol01-foundation/04-chunking-loading/08-poc_fest_embed.sql`](vol01-foundation/04-chunking-loading/08-poc_fest_embed.sql) | sql | soe — 축제 합성 임베딩 문장 (관광지는 장소 대신 유형, 내용 대신 소개를 쓴다) |
| 1권 기초 | `04-chunking-loading` | 합성 임베딩 문장 embed_text | [`vol01-foundation/04-chunking-loading/09-poc_sido.sql`](vol01-foundation/04-chunking-loading/09-poc_sido.sql) | sql | soe — 표준 뷰: 파생 표가 모두 같은 컬럼을 갖게 한다 |
| 1권 기초 | `04-chunking-loading` | 객체 명명 규칙과 객체 지도 | [`vol01-foundation/04-chunking-loading/10-poc_ctas.sql`](vol01-foundation/04-chunking-loading/10-poc_ctas.sql) | sql | soe — 파생 표 생성기 |
| 1권 기초 | `04-chunking-loading` | 측정 도구와 완료 게이트 | [`vol01-foundation/04-chunking-loading/11-poc_question.sql`](vol01-foundation/04-chunking-loading/11-poc_question.sql) | sql | soe — 공통 질문 세트 (12문항 중 2건 예) |
| 1권 기초 | `04-chunking-loading` | 측정 도구와 완료 게이트 | [`vol01-foundation/04-chunking-loading/12-poc_embed_round.sql`](vol01-foundation/04-chunking-loading/12-poc_embed_round.sql) | sql | soe — 임베딩 회차: 표를 버킷 세션 수만큼 나눠 잡이 채운다 |
| 1권 기초 | `05-exact-search` | Exact 검색과 측정 도구 | [`vol01-foundation/05-exact-search/01-vector_distance.sql`](vol01-foundation/05-exact-search/01-vector_distance.sql) | sql | SELECT id, name, sido, |
| 1권 기초 | `05-exact-search` | Exact 검색과 측정 도구 | [`vol01-foundation/05-exact-search/02-poc_search_time.sql`](vol01-foundation/05-exact-search/02-poc_search_time.sql) | sql | CREATE TABLE poc_search_time ( |
| 1권 기초 | `05-exact-search` | Exact 검색과 측정 도구 | [`vol01-foundation/05-exact-search/03-poc_search_time.sql`](vol01-foundation/05-exact-search/03-poc_search_time.sql) | sql | v_fetch := CASE |
| 1권 기초 | `05-exact-search` | 질의 벡터 세 경로와 기준선 | [`vol01-foundation/05-exact-search/04-poc_run_suite.sql`](vol01-foundation/05-exact-search/04-poc_run_suite.sql) | sql | EXEC poc_run_suite('EXACT_CACHE', 'KURE', 'EXACT', 'CACHE', 10) |
| 1권 기초 | `05-exact-search` | 지역 하드 필터와 환각 제거 | [`vol01-foundation/05-exact-search/05-poc_run_suite.sql`](vol01-foundation/05-exact-search/05-poc_run_suite.sql) | sql | EXEC poc_run_suite('EXACT_CACHE_FILTER', 'KURE', 'EXACT', 'CACHE', 3, NULL, 'Y') |
| 1권 기초 | `05-exact-search` | 의미, 지역, 거리를 한 SQL로 | [`vol01-foundation/05-exact-search/06-materialize.sql`](vol01-foundation/05-exact-search/06-materialize.sql) | sql | VAR q VARCHAR2(400) |
| 1권 기초 | `05-exact-search` | DML 영향도 실측 | [`vol01-foundation/05-exact-search/07-poc_run_log.sql`](vol01-foundation/05-exact-search/07-poc_run_log.sql) | sql | LOOP |
| 1권 기초 | `05-exact-search` | DML 영향도 실측 | [`vol01-foundation/05-exact-search/08-poc_dml_round.sql`](vol01-foundation/05-exact-search/08-poc_dml_round.sql) | sql | SET SERVEROUTPUT ON |
| 2권 인덱스 | `01-similarity-optimizer` | EXACT와 APPROXIMATE: 같은 질의의 두 가지 풀이 | [`vol02-search-index/01-similarity-optimizer/01-vector_distance.sql`](vol02-search-index/01-similarity-optimizer/01-vector_distance.sql) | sql | SELECT id, |
| 2권 인덱스 | `01-similarity-optimizer` | TARGET ACCURACY와 탐색 폭 파라미터 | [`vol02-search-index/01-similarity-optimizer/02-chunk_id.sql`](vol02-search-index/01-similarity-optimizer/02-chunk_id.sql) | sql | HNSW: 그래프 탐색 후보 큐의 크기를 직접 지정한다 |
| 2권 인덱스 | `01-similarity-optimizer` | 다중 벡터 검색과 IVF 반복 확장 | [`vol02-search-index/01-similarity-optimizer/03-chunk_id.sql`](vol02-search-index/01-similarity-optimizer/03-chunk_id.sql) | sql | SELECT chunk_id, chunk_data |
| 2권 인덱스 | `02-hnsw` | 파라미터와 메모리 산정 | [`vol02-search-index/02-hnsw/01-dbms_vector_index_vector_memory_advisor.sql`](vol02-search-index/02-hnsw/01-dbms_vector_index_vector_memory_advisor.sql) | sql | soe |
| 2권 인덱스 | `02-hnsw` | 복제 표와 인덱스 생성 | [`vol02-search-index/02-hnsw/02-poc_ctas.sql`](vol02-search-index/02-hnsw/02-poc_ctas.sql) | sql | soe — *_KURE를 벡터 포함 그대로 복제 (PK·sido 인덱스는 poc_ctas가 만든다) |
| 2권 인덱스 | `02-hnsw` | 복제 표와 인덱스 생성 | [`vol02-search-index/02-hnsw/03-festivals_kure_hnsw_idx.sql`](vol02-search-index/02-hnsw/03-festivals_kure_hnsw_idx.sql) | sql | soe |
| 2권 인덱스 | `02-hnsw` | 확장 기능과 제약 | [`vol02-search-index/02-hnsw/04-docs_hnsw_sq_idx.sql`](vol02-search-index/02-hnsw/04-docs_hnsw_sq_idx.sql) | sql | CREATE VECTOR INDEX docs_hnsw_sq_idx ON doc_chunks (chunk_embedding) |
| 2권 인덱스 | `03-ivf` | IVF 인덱스 만들기 | [`vol02-search-index/03-ivf/01-poc_ctas.sql`](vol02-search-index/03-ivf/01-poc_ctas.sql) | sql | soe |
| 2권 인덱스 | `03-ivf` | IVF 인덱스 만들기 | [`vol02-search-index/03-ivf/02-festivals_kure_ivf_idx.sql`](vol02-search-index/03-ivf/02-festivals_kure_ivf_idx.sql) | sql | soe |
| 2권 인덱스 | `03-ivf` | Exact·HNSW와 나란히 놓고 보기 | [`vol02-search-index/03-ivf/03-festivals_kure_livf_idx.sql`](vol02-search-index/03-ivf/03-festivals_kure_livf_idx.sql) | sql | soe — 시·도 LIST 파티션 복제 표에 로컬 IVF |
| 2권 인덱스 | `04-hybrid-vector-index` | 생성: 텍스트 컬럼 하나에 인덱스를 놓는다 | [`vol02-search-index/04-hybrid-vector-index/01-poc_ko_lexer.sql`](vol02-search-index/04-hybrid-vector-index/01-poc_ko_lexer.sql) | sql | soe : 한국어 형태소 lexer. 키워드 다리의 토큰 품질을 좌우한다 |
| 2권 인덱스 | `04-hybrid-vector-index` | 생성: 텍스트 컬럼 하나에 인덱스를 놓는다 | [`vol02-search-index/04-hybrid-vector-index/02-festivals_kure_hvi_idx.sql`](vol02-search-index/04-hybrid-vector-index/02-festivals_kure_hvi_idx.sql) | sql | soe : 텍스트만 복제한 표. 벡터 컬럼이 없어도 HVI가 내부에 청크와 임베딩을 만든다 |
| 2권 인덱스 | `04-hybrid-vector-index` | 생성: 텍스트 컬럼 하나에 인덱스를 놓는다 | [`vol02-search-index/04-hybrid-vector-index/03-idx_name.sql`](vol02-search-index/04-hybrid-vector-index/03-idx_name.sql) | sql | soe : 생성 확인 |
| 2권 인덱스 | `04-hybrid-vector-index` | 임베딩 경로: DB 모델을 지워도 돌아간다 | [`vol02-search-index/04-hybrid-vector-index/04-poc_vectorizer_kure_gpu.sql`](vol02-search-index/04-hybrid-vector-index/04-poc_vectorizer_kure_gpu.sql) | sql | soe : GPU embedder. 프리퍼런스 JSON의 최상위에는 model 키를 두지 않는다(두면 DB 모델 경로) |
| 2권 인덱스 | `04-hybrid-vector-index` | 검색: DBMS_HYBRID_VECTOR의 융합 질의 | [`vol02-search-index/04-hybrid-vector-index/05-dbms_hybrid_vector_search.sql`](vol02-search-index/04-hybrid-vector-index/05-dbms_hybrid_vector_search.sql) | sql | soe : 하이브리드 1건(RRF, 1:1, 지역 필터) |
| 2권 인덱스 | `04-hybrid-vector-index` | SYNC와 증분 반영 | [`vol02-search-index/04-hybrid-vector-index/06-poc_hvi_search.sql`](vol02-search-index/04-hybrid-vector-index/06-poc_hvi_search.sql) | sql | soe : SYNC 전 검색. 새 행은 결과에 없다(ctx_user_pending에 대기 1행) |
| 2권 인덱스 | `05-vector-pool` | VECTOR_MEMORY_SIZE가 정하는 것 | [`vol02-search-index/05-vector-pool/01-vector_memory_size.sql`](vol02-search-index/05-vector-pool/01-vector_memory_size.sql) | sql | 풀 크기를 4G로 지정하고 확인한다 (4G는 예시 값) |
| 2권 인덱스 | `05-vector-pool` | 필요 크기를 계산하는 방법 | [`vol02-search-index/05-vector-pool/02-dbms_vector_index_vector_memory_advisor.sql`](vol02-search-index/05-vector-pool/02-dbms_vector_index_vector_memory_advisor.sql) | sql | SET SERVEROUTPUT ON |
| 2권 인덱스 | `06-diagnostics` | 정확도를 보는 두 함수 | [`vol02-search-index/06-diagnostics/01-dbms_vector_index_accuracy_query.sql`](vol02-search-index/06-diagnostics/01-dbms_vector_index_accuracy_query.sql) | sql | 1) 단건 대조: 근사 인덱스 결과와 Exact 결과의 즉시 비교 |
| 2권 인덱스 | `06-diagnostics` | 측정표 추출 — 로그에서 문서 표까지 | [`vol02-search-index/06-diagnostics/02-poc_run_v.sql`](vol02-search-index/06-diagnostics/02-poc_run_v.sql) | sql | soe |
| 3권 운영 | `01-manual-hybrid-wrrf` | 설계 전제: 복제 표와 인덱스 두 벌 | [`vol03-rag-ops/01-manual-hybrid-wrrf/01-festivals_kure_mhs_idx.sql`](vol03-rag-ops/01-manual-hybrid-wrrf/01-festivals_kure_mhs_idx.sql) | sql | soe — 복제 표 생성(벡터 컬럼 포함 CTAS) |
| 3권 운영 | `01-manual-hybrid-wrrf` | 설계 전제: 복제 표와 인덱스 두 벌 | [`vol03-rag-ops/01-manual-hybrid-wrrf/02-count.sql`](vol03-rag-ops/01-manual-hybrid-wrrf/02-count.sql) | sql | soe — 조사가 붙은 원문에서도 명사로 일치하는지 확인한다 |
| 3권 운영 | `01-manual-hybrid-wrrf` | MANUAL_HYBRID_SEARCH의 계약과 구현 | [`vol03-rag-ops/01-manual-hybrid-wrrf/03-manual_hybrid_search.sql`](vol03-rag-ops/01-manual-hybrid-wrrf/03-manual_hybrid_search.sql) | sql | soe — 결과 행 타입 |
| 3권 운영 | `01-manual-hybrid-wrrf` | 호출 형태 세 가지 | [`vol03-rag-ops/01-manual-hybrid-wrrf/04-festivals_kure_mhs.sql`](vol03-rag-ops/01-manual-hybrid-wrrf/04-festivals_kure_mhs.sql) | sql | soe — 단일 SQL 형태: 같은 WRRF 계약(후보 30, k=60, 가중치 1:1)을 SELECT 한 문장으로 |
| 3권 운영 | `01-manual-hybrid-wrrf` | 호출 형태 세 가지 | [`vol03-rag-ops/01-manual-hybrid-wrrf/05-mhs_search.sql`](vol03-rag-ops/01-manual-hybrid-wrrf/05-mhs_search.sql) | sql | soe — 파이프라인 함수 호출 예: SELECT 안에서 같은 WRRF 계약을 쓴다 |
| 3권 운영 | `01-manual-hybrid-wrrf` | 자연어 질문을 파라미터로 바꾸는 래퍼 | [`vol03-rag-ops/01-manual-hybrid-wrrf/06-mhs_parse.sql`](vol03-rag-ops/01-manual-hybrid-wrrf/06-mhs_parse.sql) | sql | soe — 불용어 표(검색에 무의미한 토큰 제외용) |
| 3권 운영 | `01-manual-hybrid-wrrf` | 검색 결과를 근거로 답을 만들기까지 | [`vol03-rag-ops/01-manual-hybrid-wrrf/07-poc_rag_show.sql`](vol03-rag-ops/01-manual-hybrid-wrrf/07-poc_rag_show.sql) | sql | soe — 생성 파라미터(축약): reasoning 키로 추론 문장 유출을 막는다 |
| 3권 운영 | `01-manual-hybrid-wrrf` | 자체 토큰 색인: 내 스키마에 만든 역색인 | [`vol03-rag-ops/01-manual-hybrid-wrrf/08-poc_tok.sql`](vol03-rag-ops/01-manual-hybrid-wrrf/08-poc_tok.sql) | sql | soe — 토큰 함수 (검색·색인 공용) |
| 3권 운영 | `01-manual-hybrid-wrrf` | 자체 토큰 색인: 내 스키마에 만든 역색인 | [`vol03-rag-ops/01-manual-hybrid-wrrf/09-poc_kw_doc.sql`](vol03-rag-ops/01-manual-hybrid-wrrf/09-poc_kw_doc.sql) | sql | soe — 자체 토큰 색인 표 구성 |
| 3권 운영 | `01-manual-hybrid-wrrf` | 자체 토큰 색인: 내 스키마에 만든 역색인 | [`vol03-rag-ops/01-manual-hybrid-wrrf/10-poc_kwa.sql`](vol03-rag-ops/01-manual-hybrid-wrrf/10-poc_kwa.sql) | sql | soe — 엄격 AND 키워드 다리: 순위순 id 목록을 돌려준다(p_tab은 F(축제)/S(관광지)) |
| 3권 운영 | `01-manual-hybrid-wrrf` | 토큰 경로의 계약과 실측 | [`vol03-rag-ops/01-manual-hybrid-wrrf/11-poc_kwa.sql`](vol03-rag-ops/01-manual-hybrid-wrrf/11-poc_kwa.sql) | sql | soe — MANUAL_HYBRID_SEARCH_TOK의 키워드 다리(5단계)만 발췌. 인자·결과 커서는 원판과 같다 |
| 3권 운영 | `02-select-ai-nl2sql` | Select AI 프로필과 LLM이 볼 데이터 | [`vol03-rag-ops/02-select-ai-nl2sql/01-poc_ai_festivals.sql`](vol03-rag-ops/02-select-ai-nl2sql/01-poc_ai_festivals.sql) | sql | soe — LLM에게 보여 줄 뷰: 벡터 컬럼 같은 내부 구현을 숨기고 이해 가능한 형태만 노출한다 |
| 3권 운영 | `02-select-ai-nl2sql` | Select AI 프로필과 LLM이 볼 데이터 | [`vol03-rag-ops/02-select-ai-nl2sql/02-poc_ai_festivals.sql`](vol03-rag-ops/02-select-ai-nl2sql/02-poc_ai_festivals.sql) | sql | soe — 프로필의 comments 속성이 이 설명을 프롬프트에 포함한다 |
| 3권 운영 | `02-select-ai-nl2sql` | Select AI 프로필과 LLM이 볼 데이터 | [`vol03-rag-ops/02-select-ai-nl2sql/03-poc_ai_or_llama.sql`](vol03-rag-ops/02-select-ai-nl2sql/03-poc_ai_or_llama.sql) | sql | soe — 표준 프로필: 비추론 모델 (이 장의 골든 채점은 추론 모델 프로필로 실행했다) |
| 3권 운영 | `02-select-ai-nl2sql` | 골든 문항 채점: 12문항 × 3회 | [`vol03-rag-ops/02-select-ai-nl2sql/04-poc_nl2sql_golden.sql`](vol03-rag-ops/02-select-ai-nl2sql/04-poc_nl2sql_golden.sql) | sql | soe — 골든 문항 표: 정답 SQL은 사람이 검증한 기준이다 |
| 3권 운영 | `02-select-ai-nl2sql` | 골든 문항 채점: 12문항 × 3회 | [`vol03-rag-ops/02-select-ai-nl2sql/05-poc_nl2sql_run.sql`](vol03-rag-ops/02-select-ai-nl2sql/05-poc_nl2sql_run.sql) | sql | soe — 문항 1개 × 3회 × (showsql, runsql). 재호출하면 해당 문항 기록을 지우고 새로 기록한다 |
| 3권 운영 | `02-select-ai-nl2sql` | 같은 질문을 세 경로로: 집계형과 의미형의 경계 | [`vol03-rag-ops/02-select-ai-nl2sql/06-mhs_ask.sql`](vol03-rag-ops/02-select-ai-nl2sql/06-mhs_ask.sql) | sql | soe — 검색 경로: GPU로 질문 임베딩 + 형태소 키워드 + 지역 필터 |
| 3권 운영 | `02-select-ai-nl2sql` | 생성 LLM 폴백 래퍼 poc_ai_ask | [`vol03-rag-ops/02-select-ai-nl2sql/07-poc_ai_ask.sql`](vol03-rag-ops/02-select-ai-nl2sql/07-poc_ai_ask.sql) | sql | soe — 폴백 래퍼 함수: 1차가 실패·빈 응답이면 폴백으로 전달한다 |
| 3권 운영 | `02-select-ai-nl2sql` | 폴백 시험: 장애를 의도적으로 유발한다 | [`vol03-rag-ops/02-select-ai-nl2sql/08-poc_ai_qwen36.sql`](vol03-rag-ops/02-select-ai-nl2sql/08-poc_ai_qwen36.sql) | sql | soe — F2 주입: 1차 프로필 model을 없는 이름으로 바꾼다 (시험·원복은 같은 형태) |
| 3권 운영 | `02-select-ai-nl2sql` | 4세션 동시 비교: 로컬 LLM vs 외부 OpenRouter | [`vol03-rag-ops/02-select-ai-nl2sql/09-poc_llm_round.sql`](vol03-rag-ops/02-select-ai-nl2sql/09-poc_llm_round.sql) | sql | soe — 회차 1: 로컬 LLM 4세션. 회차 2는 60초 쉰 뒤 Qwen, 회차 3·4는 순서를 바꾼 재현 |
| 3권 운영 | `03-clients-patterns` | 드라이버와 벡터 바인딩 | [`vol03-rag-ops/03-clients-patterns/01-array.py`](vol03-rag-ops/03-clients-patterns/01-array.py) | python | import array |
| 3권 운영 | `04-db-prep-ha` | 메모리 파라미터: PGA와 vector_memory_size | [`vol03-rag-ops/04-db-prep-ha/01-pga_aggregate_target.sql`](vol03-rag-ops/04-db-prep-ha/01-pga_aggregate_target.sql) | sql | SYS @ CDB$ROOT — CDB 먼저, 그다음 PDB(반대면 ORA-56747) |
| 3권 운영 | `04-db-prep-ha` | 32,767바이트 문자열 상한과 되돌릴 수 없는 절차 | [`vol03-rag-ops/04-db-prep-ha/02-cluster_database.sh`](vol03-rag-ops/04-db-prep-ha/02-cluster_database.sh) | bash | oracle @ rac1 — SYS @ CDB$ROOT (ORACLE_SID=PROD1) |
| 3권 운영 | `04-db-prep-ha` | Two-Stage fix: 클러스터에서 벡터 인덱스가 DML을 받게 한다 | [`vol03-rag-ops/04-db-prep-ha/03-system.sql`](vol03-rag-ops/04-db-prep-ha/03-system.sql) | sql | SYS @ CDB$ROOT — 이미 Y인 fix에서 나는 ORA-59119는 무시하고 진행한다 |
| 3권 운영 | `04-db-prep-ha` | 작업 스키마와 권한 | [`vol03-rag-ops/04-db-prep-ha/04-poc_models.sql`](vol03-rag-ops/04-db-prep-ha/04-poc_models.sql) | sql | SYS @ PDB1 — 요지 |
| 3권 운영 | `04-db-prep-ha` | Oracle Text(CONTEXT) 설치 | [`vol03-rag-ops/04-db-prep-ha/05-con_name.sql`](vol03-rag-ops/04-db-prep-ha/05-con_name.sql) | sql | SYS @ PDB1 — CONTEXT 설치 요지 |
| 3권 운영 | `06-troubleshooting-ops` | 경합 대기의 판독 | [`vol03-rag-ops/06-troubleshooting-ops/01-parse_calls.sql`](vol03-rag-ops/06-troubleshooting-ops/01-parse_calls.sql) | sql | CTXSYS 내부 SQL의 재파싱 확인(실행 직후, SYS) |
| 3권 운영 | `06-troubleshooting-ops` | 경합 대기의 판독 | [`vol03-rag-ops/06-troubleshooting-ops/02-poc_qfc_store.sql`](vol03-rag-ops/06-troubleshooting-ops/02-poc_qfc_store.sql) | sql | filter cache 완화(요약): 크기 부여 뒤 인덱스 메타데이터만 교체 |
| 3권 운영 | `06-troubleshooting-ops` | 모니터링 지표와 매일 점검 | [`vol03-rag-ops/06-troubleshooting-ops/03-model_name.sql`](vol03-rag-ops/06-troubleshooting-ops/03-model_name.sql) | sql | 매일 점검의 핵심 뷰(요약) |

- 총 76개 파일 (SQL 71 · Python 3 · Bash 2)
- 대응 문서: 책 본문은 루트의 `oracle26ai-vector-search-vol01~03.{pdf,md,html}`과 `oracle26ai-vector-search-통합본.*`
