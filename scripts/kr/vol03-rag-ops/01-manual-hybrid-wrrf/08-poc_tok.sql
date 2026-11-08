-- soe — 토큰 함수 (검색·색인 공용)
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
    -- KO16MSWIN949 기호 영역(첫 바이트 0xA1~0xAF)은 [:alnum:]을 통과해도 구분자로 간주한다
    IF ASCII(ch) >= 256 AND TRUNC(ASCII(ch) / 256) BETWEEN 161 AND 175 THEN
      ch := ' ';
    END IF;
    IF ch = ' ' THEN
      flush;
    ELSE
      is_asc := ASCII(ch) < 128;
      IF run IS NOT NULL AND is_asc <> run_asc THEN
        flush;              -- 영숫자와 한글 경계(예: 18세는 18과 세)
      END IF;
      run := run || ch;
      run_asc := is_asc;
    END IF;
  END LOOP;
  flush;
  RETURN res;
END poc_tok;
/

-- soe — 분할 확인과 실측 결과
SELECT LISTAGG(COLUMN_VALUE, '|') WITHIN GROUP (ORDER BY ROWNUM) AS tok
  FROM TABLE(poc_tok(N'수원화성 야간개장(7월) 만 18세 festival 1.2%'));
-- 실측: 수원|원화|화성|야간|간개|개장|7|월|만|18|세|festival|1|2

SELECT LISTAGG(COLUMN_VALUE, '|') WITHIN GROUP (ORDER BY ROWNUM) AS wtok
  FROM TABLE(poc_wtok(N'가족과 함께 즐기는 2026 expo 축제'));
-- 실측: 가족|함께|즐기|2026|expo|축제
