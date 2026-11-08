-- 문서 행 하나에서 청크 벡터 배열까지 (중첩 호출)
SELECT et.*
  FROM manual_docs d,
       DBMS_VECTOR_CHAIN.UTL_TO_EMBEDDINGS(
         DBMS_VECTOR_CHAIN.UTL_TO_CHUNKS(
           DBMS_VECTOR_CHAIN.UTL_TO_TEXT(d.doc_blob),
           JSON('{"by":"words","max":100,"overlap":10,
                  "split":"recursively","normalize":"all"}')
         ),
         JSON('{"provider":"database","model":"ALL_MINILM_L12"}')
       ) et
 WHERE d.doc_id = 1;
