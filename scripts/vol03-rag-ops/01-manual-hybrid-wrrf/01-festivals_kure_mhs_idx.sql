-- soe — 복제 표 생성(벡터 컬럼 포함 CTAS)
EXEC poc_ctas('FESTIVALS_KURE_MHS',     'FESTIVALS_KURE', NULL, TRUE)
EXEC poc_ctas('TOURISM_SPOTS_KURE_MHS', 'TOURISM_SPOTS_KURE', NULL, TRUE)
SELECT (SELECT COUNT(*) FROM festivals_kure_mhs) AS f,
       (SELECT COUNT(*) FROM tourism_spots_kure_mhs) AS s FROM dual;   -- 원본과 같은 수

-- 벡터 다리: HNSW 벡터 인덱스
SET TIMING ON
CREATE VECTOR INDEX festivals_kure_mhs_idx ON festivals_kure_mhs (embedding)
  ORGANIZATION INMEMORY NEIGHBOR GRAPH DISTANCE COSINE WITH TARGET ACCURACY 95
  PARAMETERS (TYPE HNSW, NEIGHBORS 32, EFCONSTRUCTION 200);
CREATE VECTOR INDEX tourism_spots_kure_mhs_idx ON tourism_spots_kure_mhs (embedding)
  ORGANIZATION INMEMORY NEIGHBOR GRAPH DISTANCE COSINE WITH TARGET ACCURACY 95
  PARAMETERS (TYPE HNSW, NEIGHBORS 32, EFCONSTRUCTION 200);
SELECT index_name, status FROM user_indexes WHERE index_name LIKE '%KURE_MHS_IDX';   -- VALID 2

-- 키워드 다리: 한국어 형태소 lexer를 쓰는 CONTEXT 인덱스
BEGIN CTX_DDL.CREATE_PREFERENCE('poc_ko_lexer', 'KOREAN_MORPH_LEXER');
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -20000 THEN RAISE; END IF;   -- 이미 존재하면 건너뛴다
END;
/
CREATE INDEX festivals_kure_ctx ON festivals_kure_mhs (embed_text)
  INDEXTYPE IS CTXSYS.CONTEXT PARAMETERS ('LEXER poc_ko_lexer SYNC (ON COMMIT)');
CREATE INDEX tourism_spots_kure_ctx ON tourism_spots_kure_mhs (embed_text)
  INDEXTYPE IS CTXSYS.CONTEXT PARAMETERS ('LEXER poc_ko_lexer SYNC (ON COMMIT)');
SELECT idx_name, idx_status FROM ctx_user_indexes WHERE idx_name LIKE '%KURE_CTX';   -- INDEXED
