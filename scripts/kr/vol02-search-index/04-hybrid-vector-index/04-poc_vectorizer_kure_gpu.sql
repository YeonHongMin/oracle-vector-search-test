-- soe : GPU embedder. 프리퍼런스 JSON의 최상위에는 model 키를 두지 않는다(두면 DB 모델 경로)
-- url의 호스트와 포트는 예시 구성 값이다
BEGIN
  DBMS_VECTOR_CHAIN.DROP_PREFERENCE('poc_vectorizer_kure_gpu');
EXCEPTION
  WHEN OTHERS THEN NULL;  -- 재실행 대비
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
