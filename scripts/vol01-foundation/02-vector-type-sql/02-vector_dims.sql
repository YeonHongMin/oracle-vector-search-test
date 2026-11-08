SELECT id,
       VECTOR_DIMS(embedding)                     AS dims,
       VECTOR_DIMENSION_FORMAT(embedding)         AS fmt,
       VECTOR_NORM(embedding)                     AS norm,
       VECTOR_SERIALIZE(embedding RETURNING CLOB) AS vec_text
FROM   sql_vec_demo
ORDER  BY id;

SELECT VECTOR_SERIALIZE(
         TO_VECTOR('[1, 2, 3]', 3, FLOAT32) + TO_VECTOR('[4, 5, 6]', 3, FLOAT32)
         RETURNING CLOB) AS vec_sum
FROM   dual;

SELECT VECTOR_SERIALIZE(AVG(embedding) RETURNING CLOB) AS mean_vec
FROM   sql_vec_demo;
