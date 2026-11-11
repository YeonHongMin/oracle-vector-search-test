-- soe — MANUAL_HYBRID_SEARCH_TOK의 키워드 다리(5단계)만 발췌. 인자·결과 커서는 원판과 같다
  c_pfx := CASE WHEN c_tab LIKE 'FESTIVALS%' THEN 'F' ELSE 'S' END;
  ...
  -- 5) 키워드 검색 (자체 토큰 색인 — 필수어절 엄격 AND + BM25 순)
  IF c_kw IS NOT NULL THEN
    SELECT h.COLUMN_VALUE BULK COLLECT INTO k_ids
      FROM TABLE(poc_kwa(c_kw, p_cand, c_pfx)) h;
    -- sido 하드 필터는 후처리: 후보 id의 PK 조회로 지역이 아닌 것을 제외한다(순위 보존)
    IF p_sido IS NOT NULL THEN
      DECLARE
        kept SYS.ODCINUMBERLIST := SYS.ODCINUMBERLIST;
        vs   VARCHAR2(20);
      BEGIN
        FOR i IN 1 .. k_ids.COUNT LOOP
          EXECUTE IMMEDIATE 'SELECT sido FROM ' || c_tab || ' WHERE id = :1' INTO vs USING k_ids(i);
          IF vs = p_sido THEN kept.EXTEND; kept(kept.COUNT) := k_ids(i); END IF;
        END LOOP;
        k_ids := kept;
      END;
    END IF;
    FOR i IN 1 .. k_ids.COUNT LOOP bump(k_ids(i), p_wt / (p_k + i), NULL, i); END LOOP;
  END IF;
