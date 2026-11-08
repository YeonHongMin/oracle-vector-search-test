-- soe — token function (shared by search and indexing)
CREATE OR REPLACE FUNCTION poc_tok (p_text IN VARCHAR2) RETURN SYS.ODCIVARCHAR2LIST DETERMINISTIC AS
  s   VARCHAR2(32767);
  res SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST;
  run VARCHAR2(4000);
  run_asc BOOLEAN := FALSE;
  ch  VARCHAR2(8);
  is_asc BOOLEAN;
  PROCEDURE flush IS
  BEGIN
    IF run IS NOT NULL THEN
      IF run_asc OR LENGTH(run) = 1 THEN
        res.EXTEND; res(res.COUNT) := SUBSTR(run, 1, 40);
      ELSE
        FOR i IN 1 .. LENGTH(run) - 1 LOOP
          res.EXTEND; res(res.COUNT) := SUBSTR(run, i, 2);
        END LOOP;
      END IF;
    END IF;
    run := NULL;
  END flush;
BEGIN
  s := REGEXP_REPLACE(LOWER(p_text), '[^[:alnum:]]', ' ');
  FOR i IN 1 .. NVL(LENGTH(s), 0) LOOP
    ch := SUBSTR(s, i, 1);
    -- KO16MSWIN949 symbol area (first byte 0xA1-0xAF) is treated as a delimiter even though it passes [:alnum:]
    IF ASCII(ch) >= 256 AND TRUNC(ASCII(ch) / 256) BETWEEN 161 AND 175 THEN
      ch := ' ';
    END IF;
    IF ch = ' ' THEN
      flush;
    ELSE
      is_asc := ASCII(ch) < 128;
      IF run IS NOT NULL AND is_asc <> run_asc THEN
        flush;              -- boundary between alphanumerics and Hangul (e.g., 18세 splits into 18 and 세)
      END IF;
      run := run || ch;
      run_asc := is_asc;
    END IF;
  END LOOP;
  flush;
  RETURN res;
END poc_tok;
/

-- soe — split verification and measured output
SELECT LISTAGG(COLUMN_VALUE, '|') WITHIN GROUP (ORDER BY ROWNUM) AS tok
  FROM TABLE(poc_tok(N'수원화성 야간개장(7월) 만 18세 festival 1.2%'));
-- measured: 수원|원화|화성|야간|간개|개장|7|월|만|18|세|festival|1|2

SELECT LISTAGG(COLUMN_VALUE, '|') WITHIN GROUP (ORDER BY ROWNUM) AS wtok
  FROM TABLE(poc_wtok(N'가족과 함께 즐기는 2026 expo 축제'));
-- measured: 가족|함께|즐기|2026|expo|축제
