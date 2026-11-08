-- soe : GPU embedder. Do not put a model key at the top level of the preference JSON (a top-level
-- model key would be interpreted as the DB model path)
-- The host and port in the url are example configuration values
BEGIN
  DBMS_VECTOR_CHAIN.DROP_PREFERENCE('poc_vectorizer_kure_gpu');
EXCEPTION
  WHEN OTHERS THEN NULL;  -- tolerate re-runs
END;
/
BEGIN
  DBMS_VECTOR_CHAIN.CREATE_PREFERENCE('poc_vectorizer_kure_gpu', DBMS_VECTOR_CHAIN.VECTORIZER,
    JSON('{"vector_idxtype":"ivf",
           "by":"chars","max":4000,"overlap":0,"split":"none","normalize":"all",
           "embedder_spec":{"provider":"openai","credential_name":"SPARK_KURE_CRED",
                            "url":"http://<dgx spark>:11444/v1/embeddings",
                            "model":"kure-v1"}}'));
END;
/
