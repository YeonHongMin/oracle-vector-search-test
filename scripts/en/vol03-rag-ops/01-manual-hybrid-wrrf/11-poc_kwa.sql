-- soe — excerpt of the keyword leg (step 5) of MANUAL_HYBRID_SEARCH_TOK. Arguments and result cursor are identical to the base version
  c_pfx := CASE WHEN c_tab LIKE 'FESTIVALS%' THEN 'F' ELSE 'S' END;
  ...
  -- 5) keyword search (self-managed token index — strict AND on required terms + BM25 order)
  IF c_kw IS NOT NULL THEN
    SELECT h.COLUMN_VALUE BULK COLLECT INTO k_ids
      FROM TABLE(poc_kwa(c_kw, p_cand, c_pfx)) h;
    -- the sido hard filter runs afterward: PK lookups of the candidate ids drop rows outside the region (rank-preserving)
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
