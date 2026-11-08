EXEC poc_run_suite('EXACT_CACHE_FILTER', 'KURE', 'EXACT', 'CACHE', 3, NULL, 'Y')
SELECT l.qid, q.sido, SUM(CASE WHEN l.sido = q.sido THEN 1 ELSE 0 END) AS hit_top5
  FROM poc_search_log l JOIN poc_question q ON q.qid = l.qid
 WHERE l.label = 'EXACT_CACHE_FILTER' AND l.rnk <= 5 AND q.sido IS NOT NULL
 GROUP BY l.qid, q.sido ORDER BY 1;          -- 전부 5 (구조적으로 확정)
