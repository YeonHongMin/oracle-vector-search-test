-- 1) 단건 대조: 근사 인덱스 결과와 Exact 결과의 즉시 비교
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

-- 2) 기간 리포트: 캡처된 질의 모임의 달성 정확도 집계
VARIABLE v_task NUMBER
BEGIN
  :v_task := DBMS_VECTOR.INDEX_ACCURACY_REPORT(USER, 'FESTIVALS_KURE_HNSW_IDX');
END;
/

SELECT task_id, index_name, num_vectors, median_achieved_accuracy
  FROM user_vector_index_accuracy_report
 WHERE task_id = :v_task;
