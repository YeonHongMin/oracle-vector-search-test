  v_fetch := CASE
    WHEN UPPER(p_mode) = 'EXACT'  THEN ' FETCH EXACT FIRST :n ROWS ONLY'
    WHEN UPPER(p_mode) = 'APPROX' THEN ' FETCH APPROX FIRST :n ROWS ONLY WITH TARGET ACCURACY 95'
    WHEN UPPER(p_mode) LIKE 'PROBES:%' THEN ' FETCH APPROX FIRST :n ROWS ONLY WITH TARGET ACCURACY PARAMETERS (NEIGHBOR PARTITION PROBES '
                                           || TO_NUMBER(SUBSTR(p_mode, 8)) || ')'
    END;
  IF v_fetch IS NULL THEN RAISE_APPLICATION_ERROR(-20002, '허용되지 않은 모드: ' || p_mode); END IF;
  v_sql := 'SELECT id, name, sido, VECTOR_DISTANCE(embedding, :v1, COSINE) FROM ' || v_tab
        || CASE WHEN p_filter = 'Y' THEN ' WHERE sido = :s' END
        || ' ORDER BY VECTOR_DISTANCE(embedding, :v2, COSINE)' || v_fetch;

  FOR r IN 1 .. p_runs LOOP
    t0 := SYSTIMESTAMP;
    CASE UPPER(p_path)
      WHEN 'DB'    THEN EXECUTE IMMEDIATE 'SELECT VECTOR_EMBEDDING(KURE_V1 USING :1 AS data) FROM dual' INTO v USING q.question;
      WHEN 'GPU'   THEN v := emb_gpu(q.question);
      WHEN 'CACHE' THEN SELECT q_gpu INTO v FROM qvec_kure WHERE qid = p_qid;
    END CASE;
    t1 := SYSTIMESTAMP;
    IF p_filter = 'Y' THEN
      EXECUTE IMMEDIATE v_sql BULK COLLECT INTO ids, nms, sds, ds USING v, q.sido, v, p_topn;
    ELSE
      EXECUTE IMMEDIATE v_sql BULK COLLECT INTO ids, nms, sds, ds USING v, v, p_topn;
    END IF;
    t2 := SYSTIMESTAMP;
    INSERT INTO poc_search_time (label, qid, tbl, search_mode, path, run_no, embed_ms, search_ms, total_ms, dml_sessions)
    VALUES (p_label, p_qid, v_tab, UPPER(p_mode), UPPER(p_path), r, poc_ms(t0, t1), poc_ms(t1, t2), poc_ms(t0, t2), p_dml);
    IF r = 1 THEN
      DELETE FROM poc_search_log WHERE label = p_label AND qid = p_qid;
      rk := t_num; rk.EXTEND(ids.COUNT);
      FOR i IN 1 .. ids.COUNT LOOP rk(i) := i; END LOOP;   -- FORALL 인덱스 변수는 VALUES에 못 쓴다(PLS-00430)
      FORALL i IN 1 .. ids.COUNT
        INSERT INTO poc_search_log (label, qid, tbl, rnk, id, name, sido, dist)
        VALUES (p_label, p_qid, v_tab, rk(i), ids(i), nms(i), sds(i), ds(i));
    END IF;
    COMMIT;
