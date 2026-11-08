-- soe — synthetic embedding sentence for festivals (tourism spots use kind in place of venue, an intro in place of content)
CREATE OR REPLACE FUNCTION poc_fest_embed(
  p_name VARCHAR2, p_venue VARCHAR2, p_road VARCHAR2, p_jibun VARCHAR2,
  p_content VARCHAR2, p_related VARCHAR2) RETURN VARCHAR2 DETERMINISTIC IS
  addr VARCHAR2(1000) := NVL(TRIM(p_road), TRIM(p_jibun));
  txt  VARCHAR2(32767);
BEGIN
  txt := '지역: ' || poc_sido_label(addr) || ' ' || poc_sigungu(addr) || CHR(10) ||
         '이름: ' || p_name  || CHR(10) ||
         '장소: ' || p_venue || CHR(10) ||
         '주소: ' || NVL(addr, '미상') || CHR(10) ||
         '내용: ' || p_content;
  IF TRIM(p_related) IS NOT NULL THEN
    txt := txt || CHR(10) || '부가: ' || SUBSTR(TRIM(p_related), 1, 400);
  END IF;
  RETURN SUBSTR(txt, 1, 6000);
END;
/
