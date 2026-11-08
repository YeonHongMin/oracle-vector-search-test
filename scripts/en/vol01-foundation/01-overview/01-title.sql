-- Ask the same question through both paths
SELECT title
FROM   festival
ORDER  BY VECTOR_DISTANCE(embedding, :qvec, COSINE)
FETCH EXACT FIRST 10 ROWS ONLY;

-- Let the index narrow the candidate set first
SELECT title
FROM   festival
ORDER  BY VECTOR_DISTANCE(embedding, :qvec, COSINE)
FETCH APPROX FIRST 10 ROWS ONLY;
