-- soe — derived table generator
CREATE OR REPLACE PROCEDURE poc_ctas (
  p_target   IN VARCHAR2,              -- table to create
  p_source   IN VARCHAR2,              -- source table or view
  p_dim      IN NUMBER  DEFAULT NULL,  -- vector dimension (NULL means no vector column)
  p_copy_all IN BOOLEAN DEFAULT FALSE) -- TRUE copies every source column
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
