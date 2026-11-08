-- soe — result row types
CREATE OR REPLACE TYPE mhs_hit AS OBJECT (id NUMBER, wrrf NUMBER, vrank NUMBER, trank NUMBER);
/
CREATE OR REPLACE TYPE mhs_hit_tab AS TABLE OF mhs_hit;
/

-- soe — manual hybrid search procedure
CREATE OR REPLACE PROCEDURE manual_hybrid_search (
  p_query    IN  VARCHAR2 DEFAULT NULL,
  p_qvec     IN  VECTOR   DEFAULT NULL,
  p_keywords IN  VARCHAR2 DEFAULT NULL,
  p_sido     IN  VARCHAR2 DEFAULT NULL,
  p_table    IN  VARCHAR2 DEFAULT 'FESTIVALS_KURE_MHS',
  p_topn     IN  NUMBER   DEFAULT 10,
  p_cand     IN  NUMBER   DEFAULT 30,
  p_wv       IN  NUMBER   DEFAULT 1,
  p_wt       IN  NUMBER   DEFAULT 1,
  p_k        IN  NUMBER   DEFAULT 60,
  p_rc       OUT SYS_REFCURSOR)
AUTHID DEFINER AS
  c_bad  CONSTANT VARCHAR2(64) := '[?!.,;:"''·~' || CHR(8230) || '—/"-]+';   -- symbols rejected by CONTAINS
  c_tab  VARCHAR2(128);
  c_kw   VARCHAR2(4000);
  v      VECTOR;
  TYPE t_map IS TABLE OF mhs_hit INDEX BY VARCHAR2(40);
  m      t_map;
  v_ids  SYS.ODCINUMBERLIST;
  k_ids  SYS.ODCINUMBERLIST;
  hits   mhs_hit_tab := mhs_hit_tab;
  idx    VARCHAR2(40);
  v_sql  VARCHAR2(2000);

  -- inner procedure that accumulates candidates from both legs by id
  PROCEDURE bump(p_id NUMBER, p_w NUMBER, p_v PLS_INTEGER, p_t PLS_INTEGER) IS
    key VARCHAR2(40) := TO_CHAR(p_id);
  BEGIN
    IF m.EXISTS(key) THEN
      m(key) := mhs_hit(p_id, m(key).wrrf + p_w,
                        LEAST(NVL(m(key).vrank, 1e9), NVL(p_v, 1e9)),
                        LEAST(NVL(m(key).trank, 1e9), NVL(p_t, 1e9)));
    ELSE
      m(key) := mhs_hit(p_id, p_w, p_v, p_t);
    END IF;
  END bump;
BEGIN
  -- 1) whitelist — user values are never concatenated into the SQL string
  c_tab := UPPER(p_table);
  IF c_tab NOT IN ('FESTIVALS_KURE_MHS','TOURISM_SPOTS_KURE_MHS') THEN
    RAISE_APPLICATION_ERROR(-20001, 'table not allowed: ' || p_table);
  END IF;

  -- 2) query vector — passed value first, GPU otherwise
  IF p_qvec IS NOT NULL THEN v := p_qvec;
  ELSIF p_query IS NOT NULL THEN v := emb_gpu(p_query);
  END IF;

  -- 3) defensive keyword normalization — vector-only if empty after cleanup
  c_kw := TRIM(REGEXP_REPLACE(REGEXP_REPLACE(p_keywords, c_bad, ' '), ' +', ' '));
  IF v IS NULL AND c_kw IS NULL THEN
    RAISE_APPLICATION_ERROR(-20002, 'query text, vector, or keywords required');
  END IF;

  -- 4) vector search (HNSW approximate) — all values bound
  IF v IS NOT NULL THEN
    v_sql := 'SELECT id FROM ' || c_tab || ' WHERE embedding IS NOT NULL'
          || CASE WHEN p_sido IS NOT NULL THEN ' AND sido = :s' END
          || ' ORDER BY VECTOR_DISTANCE(embedding, :v, COSINE)'
          || ' FETCH APPROX FIRST :n ROWS ONLY WITH TARGET ACCURACY 95';
    IF p_sido IS NOT NULL THEN
      EXECUTE IMMEDIATE v_sql BULK COLLECT INTO v_ids USING p_sido, v, p_cand;
    ELSE
      EXECUTE IMMEDIATE v_sql BULK COLLECT INTO v_ids USING v, p_cand;
    END IF;
    FOR i IN 1 .. v_ids.COUNT LOOP bump(v_ids(i), p_wv / (p_k + i), i, NULL); END LOOP;
  END IF;

  -- 5) keyword search (CONTEXT, ordered by SCORE)
  IF c_kw IS NOT NULL THEN
    v_sql := 'SELECT id FROM ' || c_tab || ' WHERE CONTAINS(embed_text, :kw, 1) > 0'
          || CASE WHEN p_sido IS NOT NULL THEN ' AND sido = :s' END
          || ' ORDER BY SCORE(1) DESC FETCH FIRST :n ROWS ONLY';
    IF p_sido IS NOT NULL THEN
      EXECUTE IMMEDIATE v_sql BULK COLLECT INTO k_ids USING c_kw, p_sido, p_cand;
    ELSE
      EXECUTE IMMEDIATE v_sql BULK COLLECT INTO k_ids USING c_kw, p_cand;
    END IF;
    FOR i IN 1 .. k_ids.COUNT LOOP bump(k_ids(i), p_wt / (p_k + i), NULL, i); END LOOP;
  END IF;

  -- 6) move the map into a nested table and open a cursor ordered by WRRF descending (ties broken by vector rank)
  idx := m.FIRST;
  WHILE idx IS NOT NULL LOOP
    hits.EXTEND; hits(hits.COUNT) := m(idx);
    idx := m.NEXT(idx);
  END LOOP;
  OPEN p_rc FOR
    'SELECT h.id, t.name, t.sido, t.addr, ROUND(h.wrrf, 5) AS wrrf,'
 || '       NULLIF(h.vrank, 1e9) AS vrank, NULLIF(h.trank, 1e9) AS trank'
 || '  FROM TABLE(:1) h JOIN ' || c_tab || ' t ON t.id = h.id'
 || ' ORDER BY h.wrrf DESC, NVL(h.vrank, 1e9) FETCH FIRST :2 ROWS ONLY'
    USING hits, p_topn;
END manual_hybrid_search;
/
SELECT object_name, object_type, status FROM user_objects
 WHERE object_name IN ('MHS_HIT','MHS_HIT_TAB','MANUAL_HYBRID_SEARCH') ORDER BY 1;   -- VALID 3
