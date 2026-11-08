-- soe — 회차 1: 로컬 LLM 4세션. 회차 2는 60초 쉰 뒤 Qwen, 회차 3·4는 순서를 바꾼 재현
EXEC poc_llm_round('QWEN36', 'LLM_QWEN36_N4')
EXEC DBMS_SESSION.SLEEP(60)
EXEC poc_llm_round('QWEN', 'LLM_QWEN_N4')

-- soe — 집계: 처리량은 성공 호출 / 회차 벽시계
SELECT label, COUNT(*) AS calls,
       SUM(CASE WHEN ok = 'Y' THEN 1 ELSE 0 END) AS ok_calls,
       SUM(CASE WHEN correct = 'Y' THEN 1 ELSE 0 END) AS correct_calls,
       ROUND(PERCENTILE_CONT(0.5)  WITHIN GROUP (ORDER BY ms)) AS p50_ms,
       ROUND(PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY ms)) AS p95_ms,
       ROUND(100 * SUM(CASE WHEN ok = 'N' THEN 1 ELSE 0 END) / COUNT(*), 1) AS err_pct
  FROM poc_llm_call_log GROUP BY label ORDER BY label;
