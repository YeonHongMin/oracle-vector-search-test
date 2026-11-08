-- DB 경로: DB 안 모델을 부른다
CREATE OR REPLACE FUNCTION emb_db(p_text IN VARCHAR2) RETURN VECTOR AUTHID DEFINER AS
  v VECTOR;
BEGIN
  SELECT VECTOR_EMBEDDING(KURE_V1 USING p_text AS data) INTO v FROM dual;
  RETURN v;
END;
/
-- GPU 경로: OpenAI 호환 REST 엔드포인트를 부른다
CREATE OR REPLACE FUNCTION emb_gpu(p_text IN CLOB) RETURN VECTOR AUTHID DEFINER AS
  c_params CONSTANT VARCHAR2(400) :=
    '{"provider":"openai","credential_name":"SPARK_KURE_CRED",'
    || '"url":"http://<dgx spark>:11444/v1/embeddings","model":"kure-v1"}';
BEGIN
  RETURN DBMS_VECTOR.UTL_TO_EMBEDDING(p_text, JSON(c_params));
END;
/
SELECT ROUND(1 - VECTOR_DISTANCE(emb_db(N'경기도 가족 축제'),
                                 emb_gpu(N'경기도 가족 축제'), COSINE), 8) AS cos FROM dual;
