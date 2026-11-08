SELECT id, title,
       VECTOR_DISTANCE(embedding, TO_VECTOR('[1, 0, 0]', 3, FLOAT32), COSINE) AS dist
FROM   sql_vec_demo
ORDER  BY dist;
