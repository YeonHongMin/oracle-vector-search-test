-- soe
SET SERVEROUTPUT ON
DECLARE resp CLOB;
BEGIN
  FOR r IN (SELECT 'F' s, COUNT(*) n FROM festivals_kure UNION ALL SELECT 'S', COUNT(*) FROM tourism_spots_kure) LOOP
    DBMS_VECTOR.INDEX_VECTOR_MEMORY_ADVISOR(
      INDEX_TYPE => 'HNSW', NUM_VECTORS => r.n, DIM_COUNT => 1024, DIM_TYPE => 'FLOAT32',
      PARAMETER_JSON => '{"neighbors":32}', RESPONSE_JSON => resp);
    DBMS_OUTPUT.PUT_LINE(r.s || ' ' || r.n || ' vectors -> ' || resp);
  END LOOP;
END;
/
SELECT con_id, pool, ROUND(alloc_bytes/1048576) alloc_mb, ROUND(used_bytes/1048576) used_mb
  FROM v$vector_memory_pool ORDER BY 1, 2;
