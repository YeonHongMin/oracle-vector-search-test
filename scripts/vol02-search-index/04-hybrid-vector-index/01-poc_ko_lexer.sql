-- soe : 한국어 형태소 lexer. 키워드 다리의 토큰 품질을 좌우한다
BEGIN
  CTX_DDL.CREATE_PREFERENCE('poc_ko_lexer', 'KOREAN_MORPH_LEXER');
EXCEPTION
  WHEN OTHERS THEN IF SQLCODE != -20000 THEN RAISE; END IF;  -- 이미 있으면 건너뜀
END;
/
