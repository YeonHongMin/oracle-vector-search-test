-- 1) Single-query check: immediate comparison of approximate index results against Exact results
SET SERVEROUTPUT ON
DECLARE
  qv VECTOR;
  r  VARCHAR2(4000);
BEGIN
  qv := VECTOR_EMBEDDING(KURE_V1 USING '수변 공원 축제 일정' AS data);
  r := DBMS_VECTOR.INDEX_ACCURACY_QUERY(OWNER_NAME => USER,
                                        INDEX_NAME => 'FESTIVALS_KURE_HNSW_IDX',
                                        QV => qv, TOP_K => 10, TARGET_ACCURACY => 90);
  DBMS_OUTPUT.PUT_LINE(r);
END;
/

-- 2) Period report: aggregates achieved accuracy over the captured query population
VARIABLE v_task NUMBER
BEGIN
  :v_task := DBMS_VECTOR.INDEX_ACCURACY_REPORT(USER, 'FESTIVALS_KURE_HNSW_IDX');
END;
/

SELECT task_id, index_name, num_vectors, median_achieved_accuracy
  FROM user_vector_index_accuracy_report
 WHERE task_id = :v_task;
