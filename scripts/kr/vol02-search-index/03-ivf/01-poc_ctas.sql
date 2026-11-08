-- soe
EXEC poc_ctas('FESTIVALS_KURE_IVF',     'FESTIVALS_KURE',     NULL, TRUE)
EXEC poc_ctas('TOURISM_SPOTS_KURE_IVF', 'TOURISM_SPOTS_KURE', NULL, TRUE)
SELECT (SELECT COUNT(*) FROM festivals_kure_ivf) AS f,
       (SELECT COUNT(*) FROM tourism_spots_kure_ivf) AS s FROM dual;
