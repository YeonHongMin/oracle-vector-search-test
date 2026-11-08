  LOOP
    nid := -(p_worker * 1000000 + n + 1);
    EXECUTE IMMEDIATE 'INSERT INTO ' || v_tab
      || ' (id, name, sido, addr, lat, lon, kind, start_date, end_date, embed_text, embedding)'
      || ' SELECT :1, name || '' (DML)'', sido, addr, lat, lon, kind, start_date, end_date,'
      || '        embed_text || '' 추가 안내'', ' || v_expr || '(embed_text || '' 추가 안내'')'
      || '   FROM ' || v_tab || ' WHERE id = :2'
      USING nid, MOD(n * 37 + p_worker * 101, v_max) + 1;
    COMMIT;
    EXECUTE IMMEDIATE 'UPDATE ' || v_tab || ' SET embed_text = embed_text || '' 개정'','
      || ' embedding = ' || v_expr || '(embed_text || '' 개정'') WHERE id = :1' USING nid;
    COMMIT;
    EXECUTE IMMEDIATE 'DELETE FROM ' || v_tab || ' WHERE id = :1' USING nid;
    COMMIT;
    n := n + 1; ops := ops + 3;
    EXIT WHEN SYSTIMESTAMP - t0 > NUMTODSINTERVAL(p_seconds, 'SECOND');
  END LOOP;
  UPDATE poc_run_log SET rows_done = ops, t_end = SYSTIMESTAMP WHERE run_id = rid;
  COMMIT;
