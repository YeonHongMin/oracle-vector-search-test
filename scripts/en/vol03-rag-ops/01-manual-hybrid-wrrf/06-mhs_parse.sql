-- soe — stopword table (excludes tokens that carry no meaning for search)
CREATE TABLE poc_stopword (word VARCHAR2(100) PRIMARY KEY);
INSERT INTO poc_stopword
SELECT COLUMN_VALUE FROM TABLE(SYS.ODCIVARCHAR2LIST(
  '축제','관광지','여행지','여행','곳','추천','알려줘','알려주세요','있는','있나','있나요','있어','좋은','수',
  '어디','무엇','뭐','하는','열리는','가까운','근처','주변','함께','즐길','해주세요','찾아줘','몇','개','몇개',
  '가볼','만한','중','및','그리고','에서','의'));
COMMIT;

-- soe — parse function (p_part: SIDO / KEYWORDS / TABLE)
CREATE OR REPLACE FUNCTION mhs_parse(p_query IN VARCHAR2, p_part IN VARCHAR2) RETURN VARCHAR2 AS
  c_bad CONSTANT VARCHAR2(64) := '[?!.,;:"''·~' || CHR(8230) || '—/"-]+';
  v_sido VARCHAR2(20);
  v_q    VARCHAR2(4000) := TRIM(REGEXP_REPLACE(p_query, c_bad, ' '));
  v_kw   VARCHAR2(4000);
  w      VARCHAR2(400);
  n      PLS_INTEGER;
  hit    PLS_INTEGER;
BEGIN
  FOR a IN (SELECT alias, sido FROM poc_sido_alias ORDER BY LENGTH(alias) DESC) LOOP
    IF INSTR(v_q, a.alias) > 0 THEN v_sido := a.sido; EXIT; END IF;
  END LOOP;
  IF p_part = 'SIDO' THEN RETURN v_sido; END IF;
  IF p_part = 'TABLE' THEN
    RETURN CASE WHEN INSTR(v_q, '축제') > 0 THEN 'FESTIVALS_KURE_MHS'
                WHEN INSTR(v_q, '관광지') > 0 OR INSTR(v_q, '가볼') > 0 OR INSTR(v_q, '명소') > 0
                  OR INSTR(v_q, '곳') > 0 THEN 'TOURISM_SPOTS_KURE_MHS'
                ELSE 'FESTIVALS_KURE_MHS' END;
  END IF;
  n := REGEXP_COUNT(v_q, '[^ ]+');
  FOR i IN 1 .. n LOOP
    w := REGEXP_SUBSTR(v_q, '[^ ]+', 1, i);
    w := REGEXP_REPLACE(w, '(에서는|에서|에게|으로|을|를|은|는|과|와|의|에)$', '');   -- strip trailing particles
    SELECT COUNT(*) INTO hit FROM poc_stopword WHERE word = w;
    IF hit = 0 THEN SELECT COUNT(*) INTO hit FROM poc_sido_alias WHERE alias = w OR alias LIKE w || '%'; END IF;
    IF hit = 0 AND LENGTH(w) >= 2 THEN
      v_kw := v_kw || CASE WHEN v_kw IS NOT NULL THEN ' ACCUM ' END || '{' || w || '}';
    END IF;
  END LOOP;
  RETURN v_kw;
END;
/

-- soe — top-level wrapper that parses one natural-language line and runs the search
CREATE OR REPLACE PROCEDURE mhs_ask (p_query IN VARCHAR2, p_rc OUT SYS_REFCURSOR) AS
  v_sido VARCHAR2(20)  := mhs_parse(p_query, 'SIDO');
  v_kw   VARCHAR2(4000):= mhs_parse(p_query, 'KEYWORDS');
  v_tab  VARCHAR2(128) := mhs_parse(p_query, 'TABLE');
BEGIN
  DBMS_OUTPUT.PUT_LINE('table=' || v_tab || ' sido=' || NVL(v_sido, '(all regions)') || ' keywords=' || NVL(v_kw, '(none)'));
  manual_hybrid_search(p_query => p_query, p_keywords => v_kw, p_sido => v_sido, p_table => v_tab, p_rc => p_rc);
END;
/

-- soe — called with the user question as-is
SET SERVEROUTPUT ON
VAR rc REFCURSOR
EXEC mhs_ask(N'강원도 여행지에서 바다와 가까운 축제는?', :rc)
PRINT rc
