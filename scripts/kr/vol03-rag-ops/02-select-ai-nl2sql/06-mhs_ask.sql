-- soe — 검색 경로: GPU로 질문 임베딩 + 형태소 키워드 + 지역 필터
SET SERVEROUTPUT ON
VAR rc REFCURSOR
EXEC mhs_ask(N'강원도 여행지에서 바다와 가까운 축제는?', :rc)
PRINT rc

-- soe — 좌표 경로: 이름에 해수욕장이 포함된 강원 관광지에서 10km 안에 있는 강원 축제
SELECT DISTINCT f.id, f.name,
       MIN(ROUND(6371 * ACOS(LEAST(1, GREATEST(-1,
             COS(f.lat * 0.017453293) * COS(s.lat * 0.017453293) * COS((s.lon - f.lon) * 0.017453293)
           + SIN(f.lat * 0.017453293) * SIN(s.lat * 0.017453293)))), 1)) OVER (PARTITION BY f.id) AS km_to_beach
  FROM festivals_kure f
  JOIN tourism_spots_kure s ON s.sido = '강원' AND s.name LIKE '%해수욕장%' AND s.lat IS NOT NULL
 WHERE f.sido = '강원' AND f.lat IS NOT NULL
   AND 6371 * ACOS(LEAST(1, GREATEST(-1,
         COS(f.lat * 0.017453293) * COS(s.lat * 0.017453293) * COS((s.lon - f.lon) * 0.017453293)
       + SIN(f.lat * 0.017453293) * SIN(s.lat * 0.017453293)))) <= 10
 ORDER BY km_to_beach, f.name;
