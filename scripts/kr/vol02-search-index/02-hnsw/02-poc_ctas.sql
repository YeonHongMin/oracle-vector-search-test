-- soe — *_KURE를 벡터 포함 그대로 복제 (PK·sido 인덱스는 poc_ctas가 만든다)
EXEC poc_ctas('FESTIVALS_KURE_HNSW',     'FESTIVALS_KURE',     NULL, TRUE)
EXEC poc_ctas('TOURISM_SPOTS_KURE_HNSW', 'TOURISM_SPOTS_KURE', NULL, TRUE)
SELECT (SELECT COUNT(*) FROM festivals_kure_hnsw) AS f,
       (SELECT COUNT(*) FROM tourism_spots_kure_hnsw) AS s FROM dual;   -- *_KURE와 같은 수
