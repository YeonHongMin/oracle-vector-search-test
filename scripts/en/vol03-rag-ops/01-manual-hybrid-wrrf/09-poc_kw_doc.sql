-- soe — self-managed token index tables
CREATE TABLE poc_kw_doc (
  docno     NUMBER        CONSTRAINT pk_poc_kw_doc PRIMARY KEY,
  chunk_key VARCHAR2(40)  NOT NULL CONSTRAINT uk_poc_kw_doc UNIQUE,
  doc_len   NUMBER        NOT NULL);

CREATE TABLE poc_kw_tok (
  token VARCHAR2(40) NOT NULL,
  docno NUMBER       NOT NULL,
  tf    NUMBER       NOT NULL,
  w     NUMBER       NOT NULL,      -- BM25 tf component (k1=1.2, b=0.75, avgdl-based at load time)
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

-- representative stopword tokens: fill by converting stopwords with the representative-token rule (33 measured)
INSERT INTO poc_kw_stop
SELECT DISTINCT w.COLUMN_VALUE
  FROM poc_stopword s CROSS JOIN TABLE(poc_wtok(s.word)) w;
COMMIT;
