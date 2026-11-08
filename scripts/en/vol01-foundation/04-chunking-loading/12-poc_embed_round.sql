-- soe — embedding round: split the table across bucket sessions and let the jobs fill it
CREATE OR REPLACE PROCEDURE poc_embed_round (
  p_label IN VARCHAR2, p_table IN VARCHAR2, p_model IN VARCHAR2,
  p_sessions IN PLS_INTEGER DEFAULT 1, p_batch IN PLS_INTEGER DEFAULT 50,
  p_reset IN VARCHAR2 DEFAULT 'N', p_pga IN VARCHAR2 DEFAULT 'N') AS
BEGIN
  IF p_sessions NOT BETWEEN 1 AND 4 THEN
    RAISE_APPLICATION_ERROR(-20001, 'only 1 to 4 sessions allowed');
  END IF;
  IF p_reset = 'Y' THEN
    EXECUTE IMMEDIATE 'UPDATE ' || DBMS_ASSERT.SIMPLE_SQL_NAME(p_table)
      || ' SET embedding = NULL';
    COMMIT;
  END IF;
  FOR k IN 0 .. p_sessions - 1 LOOP
    DBMS_SCHEDULER.CREATE_JOB(job_name => 'POC_EMB_' || k,
      job_type => 'PLSQL_BLOCK',
      job_action => 'BEGIN poc_embed_bucket(''' || p_label || ''','''
                     || p_table || ''',''' || p_model || ''','
                     || p_sessions || ',' || k || ',' || p_batch || '); END;',
      enabled => TRUE, auto_drop => TRUE);
  END LOOP;
  IF p_pga = 'Y' THEN
    poc_pga_sample(p_label, 14400, 5, 'POC_EMB_');
  END IF;
  poc_wait_jobs('POC_EMB_');
END;
/
