-- soe — round 1: local LLM with 4 sessions. Round 2 runs Qwen after a 60-second pause; rounds 3 and 4 repeat with the order reversed
EXEC poc_llm_round('QWEN36', 'LLM_QWEN36_N4')
EXEC DBMS_SESSION.SLEEP(60)
EXEC poc_llm_round('QWEN', 'LLM_QWEN_N4')

-- soe — aggregation: throughput is successful calls per round wall clock
SELECT label, COUNT(*) AS calls,
       SUM(CASE WHEN ok = 'Y' THEN 1 ELSE 0 END) AS ok_calls,
       SUM(CASE WHEN correct = 'Y' THEN 1 ELSE 0 END) AS correct_calls,
       ROUND(PERCENTILE_CONT(0.5)  WITHIN GROUP (ORDER BY ms)) AS p50_ms,
       ROUND(PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY ms)) AS p95_ms,
       ROUND(100 * SUM(CASE WHEN ok = 'N' THEN 1 ELSE 0 END) / COUNT(*), 1) AS err_pct
  FROM poc_llm_call_log GROUP BY label ORDER BY label;
