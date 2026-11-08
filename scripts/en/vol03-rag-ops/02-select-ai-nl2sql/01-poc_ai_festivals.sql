-- soe — the view shown to the LLM: hides internal implementation such as the vector column and exposes only an understandable shape
CREATE OR REPLACE VIEW poc_ai_festivals AS
SELECT id AS festival_id, festival_name, venue,
       poc_sido(NVL(road_addr, jibun_addr)) AS sido,
       poc_sigungu(NVL(road_addr, jibun_addr)) AS sigungu,
       NVL(road_addr, jibun_addr) AS address,
       start_date, end_date,
       SUBSTR(festival_content, 1, 300) AS content_summary
  FROM festivals_org;
