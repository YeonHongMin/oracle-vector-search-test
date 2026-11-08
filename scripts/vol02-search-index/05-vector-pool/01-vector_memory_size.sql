-- 풀 크기를 4G로 지정하고 확인한다 (4G는 예시 값)
ALTER SYSTEM SET vector_memory_size = 4G SCOPE=BOTH;

SHOW PARAMETER vector_memory_size

SELECT con_id, pool, alloc_bytes, used_bytes
FROM   v$vector_memory_pool
ORDER  BY con_id, pool;
