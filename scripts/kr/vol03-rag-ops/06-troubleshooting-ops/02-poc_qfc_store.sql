-- filter cache 완화(요약): 크기 부여 뒤 인덱스 메타데이터만 교체
CTX_DDL.SET_ATTRIBUTE('poc_qfc_store', 'QUERY_FILTER_CACHE_SIZE', '268435456');
ALTER INDEX festivals_kure_ctx REBUILD PARAMETERS('REPLACE METADATA STORAGE poc_qfc_store');
