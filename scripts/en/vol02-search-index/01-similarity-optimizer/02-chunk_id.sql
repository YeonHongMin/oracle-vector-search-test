-- HNSW: explicitly sets the size of the graph traversal candidate queue
SELECT chunk_id, chunk_data
FROM   doc_chunks
ORDER  BY VECTOR_DISTANCE(chunk_embedding, :qv, COSINE)
FETCH  APPROXIMATE FIRST 10 ROWS ONLY
WITH TARGET ACCURACY PARAMETERS (EFSEARCH 500);

-- IVF: explicitly sets the number of cluster partitions probed in this search
SELECT chunk_id, chunk_data
FROM   doc_chunks
ORDER  BY VECTOR_DISTANCE(chunk_embedding, :qv, COSINE)
FETCH  APPROXIMATE FIRST 10 ROWS ONLY
WITH TARGET ACCURACY PARAMETERS (NEIGHBOR PARTITION PROBES 10);
