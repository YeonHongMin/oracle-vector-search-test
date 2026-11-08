-- From one document row to an array of chunk vectors (nested calls)
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
