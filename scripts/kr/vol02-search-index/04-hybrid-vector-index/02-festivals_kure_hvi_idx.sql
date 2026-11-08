-- soe : 텍스트만 복제한 표. 벡터 컬럼이 없어도 HVI가 내부에 청크와 임베딩을 만든다
EXEC poc_ctas('FESTIVALS_KURE_HVI', 'FESTIVALS_SRC')
EXEC poc_ctas('TOURISM_SPOTS_KURE_HVI', 'TOURISM_SPOTS_SRC')

-- FILTER BY 컬럼 크기 제한 대비: EXTENDED 환경 복제 표의 SIDO는 VARCHAR2(32767)이므로 축소
DROP INDEX festivals_kure_hvi_sido;
DROP INDEX tourism_spots_kure_hvi_sido;
ALTER TABLE festivals_kure_hvi MODIFY sido VARCHAR2(100);
ALTER TABLE tourism_spots_kure_hvi MODIFY sido VARCHAR2(100);

-- soe : HVI 생성(관광지 표도 같은 문장으로 생성). 임베딩은 GPU에서 수행된다
CREATE HYBRID VECTOR INDEX festivals_kure_hvi_idx ON festivals_kure_hvi (embed_text)
  FILTER BY sido
  PARAMETERS ('VECTORIZER poc_vectorizer_kure_gpu LEXER poc_ko_lexer');
