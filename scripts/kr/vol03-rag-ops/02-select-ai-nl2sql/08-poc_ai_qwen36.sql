-- soe — F2 주입: 1차 프로필 model을 없는 이름으로 바꾼다 (시험·원복은 같은 형태)
EXEC DBMS_CLOUD_AI.SET_ATTRIBUTE('POC_AI_QWEN36', 'model', 'no-such-model')

-- soe — 새 세션에서 시험: F1은 SYS에서 443 프록시 ACE를 제거한 뒤 실행한다
EXEC poc_fallback_case('F2')
SELECT label, served_by, attempts, SUBSTR(primary_err, 1, 80) AS primary_err, total_ms
  FROM poc_ai_route_log WHERE label LIKE 'F2:%' ORDER BY call_id;

-- soe — 원복
EXEC DBMS_CLOUD_AI.SET_ATTRIBUTE('POC_AI_QWEN36', 'model', 'qwen3.6-35b-a3b')

-- soe — F3 주입: max_tokens 16으로 빈 응답을 유도한다
EXEC DBMS_CLOUD_AI.SET_ATTRIBUTE('POC_AI_QWEN36', 'max_tokens', '16')
