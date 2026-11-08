-- soe — 문항 1개 × 3회 × (showsql, runsql). 재호출하면 해당 문항 기록을 지우고 새로 기록한다
CREATE OR REPLACE PROCEDURE poc_nl2sql_run (p_qid IN VARCHAR2, p_runs IN PLS_INTEGER DEFAULT 3) AS
  v CLOB; t0 TIMESTAMP; q VARCHAR2(1000); v_ms NUMBER; v_err VARCHAR2(1000);
BEGIN
  SELECT question INTO q FROM poc_nl2sql_golden WHERE qid = p_qid;
  DELETE FROM poc_nl2sql_log WHERE qid = p_qid;
  COMMIT;
  FOR r IN 1 .. p_runs LOOP
    FOR a IN (SELECT 'showsql' act FROM dual UNION ALL SELECT 'runsql' FROM dual) LOOP
      t0 := SYSTIMESTAMP; v := NULL;
      BEGIN
        v := DBMS_CLOUD_AI.GENERATE(prompt => q, profile_name => 'POC_AI_OR_QWEN', action => a.act);
        v_ms := poc_ms(t0, SYSTIMESTAMP);     -- 계측값은 변수에 담아 기록한다
        INSERT INTO poc_nl2sql_log (qid, run_no, action, elapsed_ms, result)
        VALUES (p_qid, r, a.act, v_ms, v);
      EXCEPTION WHEN OTHERS THEN
        v_ms := poc_ms(t0, SYSTIMESTAMP); v_err := SUBSTR(SQLERRM, 1, 1000);
        INSERT INTO poc_nl2sql_log (qid, run_no, action, elapsed_ms, err)
        VALUES (p_qid, r, a.act, v_ms, v_err);
      END;
      COMMIT;
    END LOOP;
  END LOOP;
  -- 자동 채점: COUNT형은 runsql 결과에 정답 숫자가 포함되는지 (최종 판정은 사람이 ok_manual로)
  UPDATE poc_nl2sql_log l
     SET ok_auto = CASE WHEN l.err IS NULL AND EXISTS (
                          SELECT 1 FROM poc_nl2sql_golden g
                           WHERE g.qid = l.qid AND g.kind = 'COUNT'
                             AND REGEXP_LIKE(DBMS_LOB.SUBSTR(l.result, 4000, 1),
                                   '(^|[^0-9])' || g.golden_answer || '([^0-9]|$)'))
                        THEN 'Y' ELSE 'N' END
   WHERE l.action = 'runsql' AND l.qid = p_qid;
  COMMIT;
END;
/
