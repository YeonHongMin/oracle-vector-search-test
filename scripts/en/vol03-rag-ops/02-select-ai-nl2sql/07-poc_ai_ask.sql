-- soe — fallback wrapper function: hands over to the fallback when the primary fails or returns an empty response
CREATE OR REPLACE FUNCTION poc_ai_ask (
  p_prompt   IN VARCHAR2,
  p_action   IN VARCHAR2    DEFAULT 'runsql',
  p_label    IN VARCHAR2    DEFAULT NULL,
  p_primary  IN VARCHAR2    DEFAULT 'POC_AI_QWEN36',
  p_fallback IN VARCHAR2    DEFAULT 'POC_AI_OR_QWEN',
  p_retries  IN PLS_INTEGER DEFAULT 1) RETURN CLOB AS
  res     CLOB;
  served  VARCHAR2(30);
  perr    VARCHAR2(1000);
  ferr    VARCHAR2(1000);
  tries   PLS_INTEGER := 0;
  t0 TIMESTAMP := SYSTIMESTAMP;
  t1 TIMESTAMP;

  FUNCTION bad(p CLOB) RETURN BOOLEAN IS
  BEGIN
    RETURN p IS NULL OR DBMS_LOB.GETLENGTH(p) = 0
        OR DBMS_LOB.INSTR(p, 'Sorry, unfortunately a valid response was not generated') > 0;
  END;
BEGIN
  -- 1) primary (including retry)
  FOR i IN 0 .. p_retries LOOP
    tries := tries + 1;
    BEGIN
      res := DBMS_CLOUD_AI.GENERATE(prompt => p_prompt, profile_name => p_primary, action => p_action);
      IF bad(res) THEN
        RAISE_APPLICATION_ERROR(-20010, 'empty or invalid response');
      END IF;
      served := p_primary;
      EXIT;
    EXCEPTION WHEN OTHERS THEN
      perr := SUBSTR(SQLERRM, 1, 1000);
      res  := NULL;
    END;
  END LOOP;
  t1 := SYSTIMESTAMP;
  -- 2) fallback
  IF served IS NULL THEN
    BEGIN
      res := DBMS_CLOUD_AI.GENERATE(prompt => p_prompt, profile_name => p_fallback, action => p_action);
      IF bad(res) THEN
        RAISE_APPLICATION_ERROR(-20011, 'fallback empty or invalid response');
      END IF;
      served := p_fallback;
    EXCEPTION WHEN OTHERS THEN
      ferr := SUBSTR(SQLERRM, 1, 1000);
      res  := NULL;
      served := 'NONE';
    END;
  END IF;
  poc_ai_log(p_label, p_prompt, p_action, served, tries, perr, ferr,
             poc_ms(t0, t1), poc_ms(t0, SYSTIMESTAMP),
             CASE WHEN res IS NULL THEN 0 ELSE DBMS_LOB.GETLENGTH(res) END);
  RETURN res;     -- NULL when both fail (the caller treats NULL as "no answer")
END poc_ai_ask;
/
