-- soe — common question set (2 of the 12 questions, shown as examples)
CREATE TABLE poc_question (
  qid VARCHAR2(10) PRIMARY KEY, target CHAR(1) NOT NULL,
  question VARCHAR2(1000) NOT NULL, sido VARCHAR2(20),
  keywords VARCHAR2(200), intent VARCHAR2(100));
INSERT INTO poc_question VALUES
  ('Q01','F','경기도에서 가족과 함께 즐길 수 있는 축제','경기','가족','지역+의미');
INSERT INTO poc_question VALUES
  ('Q10','F','아이들과 농촌 체험을 할 수 있는 축제',NULL,'체험','의미(지역 없음)');
COMMIT;
