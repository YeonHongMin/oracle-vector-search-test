-- soe : SYNC 전 검색. 새 행은 결과에 없다(ctx_user_pending에 대기 1행)
EXEC poc_hvi_search('HVI_SYNC_BEFORE', 'Q02', 'HYBRID', 'RRF', 'Y', 1)

-- soe : SYNC. 새 행의 벡터를 GPU로 만들고 색인한다
EXEC CTX_DDL.SYNC_INDEX('FESTIVALS_KURE_HVI_IDX')
EXEC poc_hvi_search('HVI_SYNC_CHECK', 'Q02', 'HYBRID', 'RRF', 'Y', 1)
-- SYNC 뒤 같은 검색에서 신규 행이 1위로 반환된다
