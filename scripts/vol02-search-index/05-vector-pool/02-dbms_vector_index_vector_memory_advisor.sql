SET SERVEROUTPUT ON
DECLARE
  mem_resp CLOB;
BEGIN
  DBMS_VECTOR.INDEX_VECTOR_MEMORY_ADVISOR(
    index_type     => 'HNSW',
    num_vectors    => 500000,
    dim_count      => 768,
    dim_type       => 'FLOAT32',
    parameter_json => '{"accuracy":90}',
    response_json  => mem_resp
  );
  DBMS_OUTPUT.PUT_LINE(DBMS_LOB.SUBSTR(mem_resp, 32767, 1));
END;
/
