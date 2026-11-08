SELECT id, name, sido,
       VECTOR_DISTANCE(embedding, :v, COSINE) AS dist
  FROM festivals_kure
 ORDER BY VECTOR_DISTANCE(embedding, :v, COSINE)
 FETCH EXACT FIRST 10 ROWS ONLY
