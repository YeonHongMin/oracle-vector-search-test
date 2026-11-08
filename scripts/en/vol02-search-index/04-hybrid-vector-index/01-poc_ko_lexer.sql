-- soe : Korean morphological lexer. Determines token quality on the keyword leg
BEGIN
  CTX_DDL.CREATE_PREFERENCE('poc_ko_lexer', 'KOREAN_MORPH_LEXER');
EXCEPTION
  WHEN OTHERS THEN IF SQLCODE != -20000 THEN RAISE; END IF;  -- skip if it already exists
END;
/
