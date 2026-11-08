VAR q VARCHAR2(400)
EXEC :q := N'경기도에서 가족과 함께 즐길 수 있는 축제와 근처 관광지'
WITH qv AS (SELECT /*+ MATERIALIZE */ emb_gpu(:q) AS v FROM dual),   -- 두 곳에서 참조 — GPU 호출 1회로 고정
top_f AS (
  SELECT f.id, f.name, f.lat, f.lon, VECTOR_DISTANCE(f.embedding, qv.v, COSINE) AS d
    FROM festivals_kure f CROSS JOIN qv
   WHERE f.sido = '경기' AND f.lat IS NOT NULL AND f.lon IS NOT NULL
   ORDER BY VECTOR_DISTANCE(f.embedding, qv.v, COSINE)
   FETCH FIRST 3 ROWS ONLY),
spots AS (
  SELECT f.id AS fid, s.name,
         VECTOR_DISTANCE(s.embedding, qv.v, COSINE) AS d,
         6371 * ACOS(LEAST(1, GREATEST(-1,
           COS(f.lat * 0.017453293) * COS(s.lat * 0.017453293) * COS((s.lon - f.lon) * 0.017453293)
         + SIN(f.lat * 0.017453293) * SIN(s.lat * 0.017453293)))) AS km
    FROM top_f f CROSS JOIN qv
    JOIN tourism_spots_kure s ON s.lat IS NOT NULL AND s.lon IS NOT NULL AND s.sido = '경기')
SELECT 'FESTIVAL' AS kind, f.name, ROUND(f.d, 4) AS dist, NULL AS km, f.id AS fid, 0 AS rk FROM top_f f
UNION ALL
SELECT 'SPOT', name, ROUND(d, 4), ROUND(km, 1), fid, rk
  FROM (SELECT s.*, ROW_NUMBER OVER (PARTITION BY fid ORDER BY d) AS rk FROM spots s WHERE km <= 50)
 WHERE rk <= 3
ORDER BY fid, rk;
