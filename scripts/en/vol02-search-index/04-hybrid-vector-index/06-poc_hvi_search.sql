-- soe : Search before SYNC. The new row is absent from the results (1 row pending in ctx_user_pending)
EXEC poc_hvi_search('HVI_SYNC_BEFORE', 'Q02', 'HYBRID', 'RRF', 'Y', 1)

-- soe : SYNC. The new row's vector is generated on the GPU and indexed
EXEC CTX_DDL.SYNC_INDEX('FESTIVALS_KURE_HVI_IDX')
EXEC poc_hvi_search('HVI_SYNC_CHECK', 'Q02', 'HYBRID', 'RRF', 'Y', 1)
-- After SYNC, the same search returns the new row at rank 1
