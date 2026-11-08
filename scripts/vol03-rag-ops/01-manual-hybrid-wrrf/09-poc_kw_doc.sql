-- soe — 자체 토큰 색인 표 구성
CREATE TABLE poc_kw_doc (
  docno     NUMBER        CONSTRAINT pk_poc_kw_doc PRIMARY KEY,
  chunk_key VARCHAR2(40)  NOT NULL CONSTRAINT uk_poc_kw_doc UNIQUE,
  doc_len   NUMBER        NOT NULL);

CREATE TABLE poc_kw_tok (
  token VARCHAR2(40) NOT NULL,
  docno NUMBER       NOT NULL,
  tf    NUMBER       NOT NULL,
  w     NUMBER       NOT NULL,      -- BM25 tf 성분(k1=1.2, b=0.75, 적재 시 avgdl 기준)
  CONSTRAINT pk_poc_kw_tok PRIMARY KEY (token, docno))
  ORGANIZATION INDEX COMPRESS 1;

CREATE TABLE poc_kw_df (
  token    VARCHAR2(40) CONSTRAINT pk_poc_kw_df PRIMARY KEY,
  df       NUMBER NOT NULL,
  idf      NUMBER NOT NULL,
  df_ratio NUMBER NOT NULL);

CREATE TABLE poc_kw_stat (n NUMBER, avgdl NUMBER, built_at DATE);
CREATE TABLE poc_kw_stop (token VARCHAR2(40) CONSTRAINT pk_poc_kw_stop PRIMARY KEY);
CREATE TABLE poc_kw_raw (docno NUMBER, token VARCHAR2(40)) NOLOGGING;
CREATE SEQUENCE poc_kw_docno_seq START WITH 1 NOCACHE;

-- 불용 대표토큰: 불용어를 대표토큰 규칙으로 변환해 채운다(실측 33개)
INSERT INTO poc_kw_stop
SELECT DISTINCT w.COLUMN_VALUE
  FROM poc_stopword s CROSS JOIN TABLE(poc_wtok(s.word)) w;
COMMIT;
