-- soe — F2 injection: change the primary profile's model to a nonexistent name (test and restore use the same form)
EXEC DBMS_CLOUD_AI.SET_ATTRIBUTE('POC_AI_QWEN36', 'model', 'no-such-model')

-- soe — test in a fresh session: run F1 as SYS after removing the 443 proxy ACE
EXEC poc_fallback_case('F2')
SELECT label, served_by, attempts, SUBSTR(primary_err, 1, 80) AS primary_err, total_ms
  FROM poc_ai_route_log WHERE label LIKE 'F2:%' ORDER BY call_id;

-- soe — restore
EXEC DBMS_CLOUD_AI.SET_ATTRIBUTE('POC_AI_QWEN36', 'model', 'qwen3.6-35b-a3b')

-- soe — F3 injection: induce an empty response with max_tokens 16
EXEC DBMS_CLOUD_AI.SET_ATTRIBUTE('POC_AI_QWEN36', 'max_tokens', '16')
