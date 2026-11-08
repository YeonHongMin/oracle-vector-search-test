-- soe — LLM에게 보여 줄 뷰: 벡터 컬럼 같은 내부 구현을 숨기고 이해 가능한 형태만 노출한다
CREATE OR REPLACE VIEW poc_ai_festivals AS
SELECT id AS festival_id, festival_name, venue,
       poc_sido(NVL(road_addr, jibun_addr)) AS sido,
       poc_sigungu(NVL(road_addr, jibun_addr)) AS sigungu,
       NVL(road_addr, jibun_addr) AS address,
       start_date, end_date,
       SUBSTR(festival_content, 1, 300) AS content_summary
  FROM festivals_org;
