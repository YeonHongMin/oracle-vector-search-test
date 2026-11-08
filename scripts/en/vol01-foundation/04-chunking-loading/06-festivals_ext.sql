-- soe — festival external table (skips the CSV header row, empty fields become NULL)
CREATE TABLE festivals_ext (
  id VARCHAR2(20), festival_name VARCHAR2(4000), venue VARCHAR2(4000),
  start_date VARCHAR2(40), end_date VARCHAR2(40), festival_content VARCHAR2(32767),
  host_org VARCHAR2(4000), main_org VARCHAR2(4000), sponsor_org VARCHAR2(4000),
  phone VARCHAR2(400), homepage VARCHAR2(4000), related_info VARCHAR2(32767),
  road_addr VARCHAR2(4000), jibun_addr VARCHAR2(4000),
  lat_y VARCHAR2(40), lon_x VARCHAR2(40), std_date VARCHAR2(40))
ORGANIZATION EXTERNAL (
  TYPE ORACLE_LOADER DEFAULT DIRECTORY poc_data_dir
  ACCESS PARAMETERS (
    RECORDS DELIMITED BY NEWLINE CHARACTERSET AL32UTF8
    SKIP 1
    BADFILE poc_data_dir:'festivals_ext.bad'
    LOGFILE poc_data_dir:'festivals_ext.log'
    FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
    MISSING FIELD VALUES ARE NULL
    ( id CHAR(20), festival_name CHAR(4000), venue CHAR(4000),
      start_date CHAR(40), end_date CHAR(40), festival_content CHAR(32767),
      host_org CHAR(4000), main_org CHAR(4000), sponsor_org CHAR(4000),
      phone CHAR(400), homepage CHAR(4000), related_info CHAR(32767),
      road_addr CHAR(4000), jibun_addr CHAR(4000),
      lat_y CHAR(40), lon_x CHAR(40), std_date CHAR(40) ))
  LOCATION ('festivals.csv'))
REJECT LIMIT UNLIMITED;
