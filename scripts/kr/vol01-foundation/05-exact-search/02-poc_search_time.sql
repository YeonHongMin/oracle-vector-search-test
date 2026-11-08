CREATE TABLE poc_search_time (
  label VARCHAR2(60), qid VARCHAR2(10), tbl VARCHAR2(60), search_mode VARCHAR2(20), path VARCHAR2(10),
  run_no NUMBER, embed_ms NUMBER, search_ms NUMBER, total_ms NUMBER, dml_sessions NUMBER,
  run_at TIMESTAMP DEFAULT SYSTIMESTAMP);

CREATE OR REPLACE VIEW poc_latency_v AS
SELECT label, search_mode, path, dml_sessions, COUNT(*) AS n,
       ROUND(PERCENTILE_CONT(0.5)  WITHIN GROUP (ORDER BY total_ms))  AS p50_ms,
       ROUND(PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY total_ms))  AS p95_ms,
       ROUND(PERCENTILE_CONT(0.5)  WITHIN GROUP (ORDER BY embed_ms))  AS embed_p50_ms,
       ROUND(PERCENTILE_CONT(0.5)  WITHIN GROUP (ORDER BY search_ms)) AS search_p50_ms
  FROM poc_search_time WHERE run_no > 2
 GROUP BY label, search_mode, path, dml_sessions;
