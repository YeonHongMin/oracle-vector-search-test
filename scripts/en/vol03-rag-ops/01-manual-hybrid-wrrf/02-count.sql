-- soe — verify that nouns match even in source text where particles are attached
SELECT '바다' kw, COUNT(*) FROM festivals_kure_mhs WHERE CONTAINS(embed_text, N'바다', 1) > 0
UNION ALL SELECT '가족', COUNT(*) FROM festivals_kure_mhs WHERE CONTAINS(embed_text, N'가족', 1) > 0
UNION ALL SELECT '불꽃', COUNT(*) FROM festivals_kure_mhs WHERE CONTAINS(embed_text, N'불꽃', 1) > 0
UNION ALL SELECT '가족 AND 체험', COUNT(*) FROM festivals_kure_mhs WHERE CONTAINS(embed_text, N'가족 AND 체험', 1) > 0;
