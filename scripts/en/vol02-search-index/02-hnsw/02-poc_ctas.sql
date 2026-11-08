-- soe — Clone the *_KURE tables as-is, vectors included (poc_ctas creates the PK and sido indexes)
EXEC poc_ctas('FESTIVALS_KURE_HNSW',     'FESTIVALS_KURE',     NULL, TRUE)
EXEC poc_ctas('TOURISM_SPOTS_KURE_HNSW', 'TOURISM_SPOTS_KURE', NULL, TRUE)
SELECT (SELECT COUNT(*) FROM festivals_kure_hnsw) AS f,
       (SELECT COUNT(*) FROM tourism_spots_kure_hnsw) AS s FROM dual;   -- same counts as the *_KURE tables
