CREATE TABLE sql_vec_demo (
  id        NUMBER PRIMARY KEY,
  title     VARCHAR2(200),
  embedding VECTOR(3, FLOAT32)
);

INSERT INTO sql_vec_demo VALUES (1, 'axis x', TO_VECTOR('[1, 0, 0]', 3, FLOAT32));
INSERT INTO sql_vec_demo VALUES (2, 'axis y', TO_VECTOR('[0, 1, 0]', 3, FLOAT32));
INSERT INTO sql_vec_demo VALUES (3, 'near x', TO_VECTOR('[0.8, 0.2, 0]', 3, FLOAT32));
COMMIT;
