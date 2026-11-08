-- 같은 질문을 두 경로로 묻는다
SELECT title
FROM   festival
ORDER  BY VECTOR_DISTANCE(embedding, :qvec, COSINE)
FETCH EXACT FIRST 10 ROWS ONLY;

-- 인덱스가 후보를 먼저 추리게 한다
SELECT title
FROM   festival
ORDER  BY VECTOR_DISTANCE(embedding, :qvec, COSINE)
FETCH APPROX FIRST 10 ROWS ONLY;
