-- soe : 하이브리드 1건(RRF, 1:1, 지역 필터)
SELECT j.rnk, t.id, t.name, t.sido,
       ROUND(j.score, 4) AS score, ROUND(j.vs, 4) AS vscore, ROUND(j.ts, 4) AS tscore
  FROM JSON_TABLE(
         DBMS_HYBRID_VECTOR.SEARCH(JSON('{
           "hybrid_index_name": "FESTIVALS_KURE_HVI_IDX",
           "search_scorer": "RRF", "search_fusion": "UNION",
           "vector": {"search_text": "강원도 바닷가에서 열리는 여름 축제",
                      "search_mode": "DOCUMENT", "score_weight": 1, "rank_penalty": 1},
           "text":   {"contains": "바다", "score_weight": 1, "rank_penalty": 1},
           "filter_by": {"op": "=", "col": "SIDO", "type": "string", "args": ["강원"]},
           "return": {"values": ["rowid","score","vector_score","text_score"], "topN": 10}}')),
         '$[*]' COLUMNS (rnk FOR ORDINALITY,
                         rid VARCHAR2(32) PATH '$.rowid', sc NUMBER PATH '$.score',
                         vs NUMBER PATH '$.vector_score', ts NUMBER PATH '$.text_score')) j
  JOIN festivals_kure_hvi t ON t.ROWID = CHARTOROWID(j.rid)
 ORDER BY j.rnk;
