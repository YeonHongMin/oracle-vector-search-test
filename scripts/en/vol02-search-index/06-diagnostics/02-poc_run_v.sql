-- soe
SELECT label, tbl, model, path, sessions, bucket, rows_done, secs,
       ROUND(rows_done/NULLIF(secs,0), 2) AS per_s, err
  FROM poc_run_v ORDER BY run_id;                                   -- embedding, inference, DML
SELECT * FROM poc_latency_v ORDER BY label;                         -- search latency
SELECT label, MAX(pga_max_mb), MIN(os_free_mb) FROM poc_pga_log GROUP BY label ORDER BY label;   -- PGA
SELECT t.label, ROUND(AVG(CASE WHEN b.id IS NOT NULL THEN 1 ELSE 0 END), 3) AS recall_at_10
  FROM poc_search_log t
  LEFT JOIN poc_search_log b ON b.label = 'EXACT_CACHE' AND b.qid = t.qid AND b.id = t.id
 GROUP BY t.label ORDER BY 1;                                       -- Recall
SELECT qid, action, run_no, elapsed_ms, ok_auto, ok_manual, err FROM poc_nl2sql_log ORDER BY qid, run_no, action;   -- NL2SQL
