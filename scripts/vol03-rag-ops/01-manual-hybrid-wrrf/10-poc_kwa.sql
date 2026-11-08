-- soe — 엄격 AND 키워드 다리: 순위순 id 목록을 돌려준다(p_tab은 F(축제)/S(관광지))
CREATE OR REPLACE FUNCTION poc_kwa (p_kw IN VARCHAR2, p_cand IN NUMBER, p_tab IN VARCHAR2 DEFAULT 'F')
RETURN SYS.ODCINUMBERLIST AS
  c_dfmax CONSTANT NUMBER := 0.3;
  pfx  VARCHAR2(1) := SUBSTR(UPPER(NVL(p_tab, 'F')), 1, 1);
  kw   VARCHAR2(4000);
  ids  SYS.ODCINUMBERLIST := SYS.ODCINUMBERLIST;
  qt   SYS.ODCIVARCHAR2LIST;
  wt   SYS.ODCIVARCHAR2LIST;
  req  SYS.ODCIVARCHAR2LIST;
  nreq PLS_INTEGER;
BEGIN
  IF pfx NOT IN ('F','S') THEN RAISE_APPLICATION_ERROR(-20004, '허용되지 않은 표 구분: ' || p_tab); END IF;
  kw := TRIM(REGEXP_REPLACE(REPLACE(REPLACE(' ' || p_kw || ' ', '{', ' '), '}', ' '),
                            ' (accum|and|or|not|minus|near) ', ' ', 1, 0, 'i'));
  IF kw IS NULL THEN RETURN ids; END IF;
  qt := poc_tok(kw);
  wt := poc_wtok(kw);
  -- 필수 토큰: 불용·df 30% 초과 제외. df 미등록 신규 토큰은 희귀어로 필수에 포함한다(외부 조인)
  SELECT DISTINCT w.COLUMN_VALUE BULK COLLECT INTO req
    FROM TABLE(wt) w LEFT JOIN poc_kw_df f ON f.token = w.COLUMN_VALUE
   WHERE NVL(f.df_ratio, 0) <= c_dfmax
     AND NOT EXISTS (SELECT 1 FROM poc_kw_stop s WHERE s.token = w.COLUMN_VALUE);
  nreq := req.COUNT;
  IF nreq = 0 THEN RETURN ids; END IF;
  -- ① 필수 토큰의 게시 목록 교집합(모두 가진 문서만) → ② 그 문서만 BM25 점수
  SELECT TO_NUMBER(SUBSTR(d.chunk_key, 2)) BULK COLLECT INTO ids
    FROM (SELECT c.docno, NVL(s.sc, 0) sc
            FROM (SELECT /*+ CARDINALITY(r 5) */ t2.docno
                    FROM TABLE(req) r JOIN poc_kw_tok t2 ON t2.token = r.COLUMN_VALUE
                    JOIN poc_kw_doc d2 ON d2.docno = t2.docno AND d2.chunk_key LIKE pfx || '%'
                   GROUP BY t2.docno
                  HAVING COUNT(*) = nreq) c
            LEFT JOIN (SELECT t.docno, SUM(q.idf * t.w) sc
                         FROM (SELECT /*+ CARDINALITY(x 10) */ DISTINCT x.COLUMN_VALUE tok, f.idf
                                 FROM TABLE(qt) x JOIN poc_kw_df f ON f.token = x.COLUMN_VALUE
                                WHERE f.df_ratio <= c_dfmax) q
                         JOIN poc_kw_tok t ON t.token = q.tok
                        GROUP BY t.docno) s ON s.docno = c.docno
           ORDER BY sc DESC, c.docno
           FETCH FIRST p_cand ROWS ONLY) x
    JOIN poc_kw_doc d ON d.docno = x.docno
   ORDER BY x.sc DESC, x.docno;
  RETURN ids;
END poc_kwa;
/
