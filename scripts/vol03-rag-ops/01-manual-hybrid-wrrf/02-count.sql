-- soe — 조사가 붙은 원문에서도 명사로 일치하는지 확인한다
SELECT '바다' kw, COUNT(*) FROM festivals_kure_mhs WHERE CONTAINS(embed_text, N'바다', 1) > 0
UNION ALL SELECT '가족', COUNT(*) FROM festivals_kure_mhs WHERE CONTAINS(embed_text, N'가족', 1) > 0
UNION ALL SELECT '불꽃', COUNT(*) FROM festivals_kure_mhs WHERE CONTAINS(embed_text, N'불꽃', 1) > 0
UNION ALL SELECT '가족 AND 체험', COUNT(*) FROM festivals_kure_mhs WHERE CONTAINS(embed_text, N'가족 AND 체험', 1) > 0;
