-- soe — 단일 SQL 형태: 같은 WRRF 계약(후보 30, k=60, 가중치 1:1)을 SELECT 한 문장으로
WITH vraw AS (
  SELECT id FROM festivals_kure_mhs
   WHERE embedding IS NOT NULL AND sido = '경기'
   ORDER BY VECTOR_DISTANCE(embedding, (SELECT q_gpu FROM qvec_kure WHERE qid = 'Q01'), COSINE)
   FETCH APPROX FIRST 30 ROWS ONLY WITH TARGET ACCURACY 95
),
vc AS (SELECT id, ROWNUM AS vrank FROM vraw),
kraw AS (
  SELECT id FROM festivals_kure_mhs
   WHERE CONTAINS(embed_text, N'가족', 1) > 0 AND sido = '경기'
   ORDER BY SCORE(1) DESC FETCH FIRST 30 ROWS ONLY
),
kc AS (SELECT id, ROWNUM AS trank FROM kraw),
hits AS (
  SELECT COALESCE(vc.id, kc.id) AS id,
         CASE WHEN vc.vrank IS NOT NULL THEN 1 / (60 + vc.vrank) ELSE 0 END
       + CASE WHEN kc.trank IS NOT NULL THEN 1 / (60 + kc.trank) ELSE 0 END AS wrrf,
         vc.vrank, kc.trank
    FROM vc FULL OUTER JOIN kc ON vc.id = kc.id
)
SELECT h.id, t.name, t.sido, t.addr, ROUND(h.wrrf, 5) AS wrrf, h.vrank, h.trank
  FROM hits h JOIN festivals_kure_mhs t ON t.id = h.id
 ORDER BY h.wrrf DESC, NVL(h.vrank, 1e9)
 FETCH FIRST 10 ROWS ONLY;
