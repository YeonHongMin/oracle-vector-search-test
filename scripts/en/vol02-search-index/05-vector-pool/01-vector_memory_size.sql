-- Set the pool size to 4G and verify (4G is an example value)
ALTER SYSTEM SET vector_memory_size = 4G SCOPE=BOTH;

SHOW PARAMETER vector_memory_size

SELECT con_id, pool, alloc_bytes, used_bytes
FROM   v$vector_memory_pool
ORDER  BY con_id, pool;
