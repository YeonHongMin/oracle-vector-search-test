-- soe : Clone table holding text only. The HVI creates chunks and embeddings internally even without a vector column
EXEC poc_ctas('FESTIVALS_KURE_HVI', 'FESTIVALS_SRC')
EXEC poc_ctas('TOURISM_SPOTS_KURE_HVI', 'TOURISM_SPOTS_SRC')

-- Guard against the FILTER BY column size limit: SIDO in the clone table is VARCHAR2(32767) under the
-- EXTENDED data-type setting, so shrink it
DROP INDEX festivals_kure_hvi_sido;
DROP INDEX tourism_spots_kure_hvi_sido;
ALTER TABLE festivals_kure_hvi MODIFY sido VARCHAR2(100);
ALTER TABLE tourism_spots_kure_hvi MODIFY sido VARCHAR2(100);

-- soe : Create the HVI (create the tourism table with the same statement). Embedding runs on the GPU
CREATE HYBRID VECTOR INDEX festivals_kure_hvi_idx ON festivals_kure_hvi (embed_text)
  FILTER BY sido
  PARAMETERS ('VECTORIZER poc_vectorizer_kure_gpu LEXER poc_ko_lexer');
