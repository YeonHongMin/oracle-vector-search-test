-- soe — 골든 문항 표: 정답 SQL은 사람이 검증한 기준이다
CREATE TABLE poc_nl2sql_golden (
  qid VARCHAR2(10) PRIMARY KEY, question VARCHAR2(1000), kind VARCHAR2(20),   -- COUNT / LIST / REFUSE
  golden_sql VARCHAR2(4000), golden_answer VARCHAR2(4000), note VARCHAR2(400));

INSERT INTO poc_nl2sql_golden VALUES ('N01','경기도 여행지에서 몇개의 축제가 있나?','COUNT',
 q'[SELECT TO_CHAR(COUNT(*)) FROM poc_ai_festivals WHERE sido = '경기']', NULL, '「여행지」= 지역 조건으로 해석');
INSERT INTO poc_nl2sql_golden VALUES ('N12','올해 가장 인기 있는 축제는?','REFUSE',
 NULL, '데이터에 인기 지표 없음', '거절(또는 근거 없음 답변)이 정답');
-- N02~N11 9문항을 같은 방식으로 등록한다 (LIST형은 LISTAGG로 결과를 문자열 하나로 묶는다)
COMMIT;
SELECT COUNT(*) FROM poc_nl2sql_golden;             -- 12

-- soe — 정답 SQL을 실행해 정답값을 자동으로 채운다
DECLARE v VARCHAR2(4000);
BEGIN
  FOR r IN (SELECT qid, golden_sql FROM poc_nl2sql_golden WHERE golden_sql IS NOT NULL) LOOP
    EXECUTE IMMEDIATE r.golden_sql INTO v;
    UPDATE poc_nl2sql_golden SET golden_answer = v WHERE qid = r.qid;
  END LOOP;
  COMMIT;
END;
/
