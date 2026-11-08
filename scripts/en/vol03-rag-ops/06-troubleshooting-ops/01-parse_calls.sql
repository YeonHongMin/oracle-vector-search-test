-- check reparsing of CTXSYS internal SQL (right after execution, as SYS)
SELECT parse_calls, executions, SUBSTR(sql_text, 1, 60)
  FROM v$sql
 WHERE executions > 10 AND parse_calls >= executions
   AND sql_text LIKE '%DR$%'
 ORDER BY parse_calls DESC FETCH FIRST 8 ROWS ONLY;
