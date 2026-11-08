-- soe — copy the external table into a raw table (immutable baseline)
CREATE TABLE festivals_org (
  id NUMBER CONSTRAINT festivals_org_pk PRIMARY KEY,
  festival_name VARCHAR2(1000), venue VARCHAR2(1000),
  start_date DATE, end_date DATE, festival_content VARCHAR2(32767),
  host_org VARCHAR2(1000), main_org VARCHAR2(1000), sponsor_org VARCHAR2(1000),
  phone VARCHAR2(200), homepage VARCHAR2(2000), related_info VARCHAR2(32767),
  road_addr VARCHAR2(1000), jibun_addr VARCHAR2(1000),
  lat NUMBER, lon NUMBER, std_date VARCHAR2(40));

INSERT /*+ APPEND */ INTO festivals_org
SELECT TO_NUMBER(id), TRIM(festival_name), TRIM(venue),
       TO_DATE(start_date DEFAULT NULL ON CONVERSION ERROR, 'YYYY-MM-DD'),
       TO_DATE(end_date   DEFAULT NULL ON CONVERSION ERROR, 'YYYY-MM-DD'),
       TRIM(festival_content), TRIM(host_org), TRIM(main_org), TRIM(sponsor_org),
       TRIM(phone), TRIM(homepage), TRIM(related_info), TRIM(road_addr), TRIM(jibun_addr),
       TO_NUMBER(lat_y DEFAULT NULL ON CONVERSION ERROR),
       TO_NUMBER(lon_x DEFAULT NULL ON CONVERSION ERROR), TRIM(std_date)
  FROM festivals_ext;
COMMIT;
