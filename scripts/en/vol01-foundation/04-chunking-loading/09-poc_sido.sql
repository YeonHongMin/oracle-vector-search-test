-- soe — standard view: gives every derived table the same columns
CREATE OR REPLACE VIEW festivals_src AS
SELECT o.id, o.festival_name AS name,
       poc_sido(NVL(o.road_addr, o.jibun_addr)) AS sido,
       NVL(o.road_addr, o.jibun_addr) AS addr, o.lat, o.lon,
       o.venue AS kind, o.start_date, o.end_date,
       poc_fest_embed(o.festival_name, o.venue, o.road_addr, o.jibun_addr,
                      o.festival_content, o.related_info) AS embed_text
  FROM festivals_org o;
