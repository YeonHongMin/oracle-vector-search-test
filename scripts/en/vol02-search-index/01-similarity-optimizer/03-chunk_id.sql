SELECT chunk_id, chunk_data
FROM   doc_chunks
ORDER  BY VECTOR_DISTANCE(chunk_embedding, :qv, COSINE)
FETCH  FIRST 2 PARTITIONS BY book_id,
                  3 PARTITIONS BY paragraph_id,
                  4 ROWS ONLY;
