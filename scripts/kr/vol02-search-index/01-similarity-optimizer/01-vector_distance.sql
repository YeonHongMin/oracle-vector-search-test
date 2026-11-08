SELECT id,
       VECTOR_DISTANCE(embedding,
                       TO_VECTOR('[1,0,0]', 3, FLOAT32),
                       COSINE) AS distance
FROM   demo_vs26_docs
WHERE  tenant_id = 10
ORDER  BY distance
FETCH  EXACT FIRST 2 ROWS ONLY;

SELECT chunk_id, chunk_data
FROM   doc_chunks
WHERE  doc_id = :doc_id
ORDER  BY VECTOR_DISTANCE(
            chunk_embedding,
            VECTOR_EMBEDDING(ALL_MINILM_L12 USING :q AS data),
            COSINE
          )
FETCH  APPROXIMATE FIRST 10 ROWS ONLY WITH TARGET ACCURACY 90;
