-- soe — 파생 표 생성기
CREATE OR REPLACE PROCEDURE poc_ctas (
  p_target   IN VARCHAR2,              -- 만들 표
  p_source   IN VARCHAR2,              -- 원천 표·뷰
  p_dim      IN NUMBER  DEFAULT NULL,  -- 벡터 차원 (NULL이면 벡터 컬럼 없음)
  p_copy_all IN BOOLEAN DEFAULT FALSE) -- TRUE면 원천의 모든 컬럼을 복제
AUTHID CURRENT_USER AS
  c_cols CONSTANT VARCHAR2(200) :=
    'id, name, sido, addr, lat, lon, kind, start_date, end_date, embed_text';
BEGIN
  BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE ' || DBMS_ASSERT.SIMPLE_SQL_NAME(p_target) || ' PURGE';
  EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF;
  END;
  EXECUTE IMMEDIATE 'CREATE TABLE ' || DBMS_ASSERT.SIMPLE_SQL_NAME(p_target) || ' AS SELECT '
    || CASE WHEN p_copy_all THEN '*' ELSE c_cols END
    || ' FROM ' || DBMS_ASSERT.SIMPLE_SQL_NAME(p_source);
  IF NOT p_copy_all AND p_dim IS NOT NULL THEN
    EXECUTE IMMEDIATE 'ALTER TABLE ' || p_target
      || ' ADD (embedding VECTOR(' || TO_NUMBER(p_dim) || ', FLOAT32))';
  END IF;
  EXECUTE IMMEDIATE 'ALTER TABLE ' || p_target
    || ' ADD CONSTRAINT ' || p_target || '_PK PRIMARY KEY (id)';
  EXECUTE IMMEDIATE 'CREATE INDEX ' || p_target || '_SIDO ON ' || p_target || ' (sido)';
END;
/
