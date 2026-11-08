-- easing the filter cache (summary): grant the size, then replace only the index metadata
CTX_DDL.SET_ATTRIBUTE('poc_qfc_store', 'QUERY_FILTER_CACHE_SIZE', '268435456');
ALTER INDEX festivals_kure_ctx REBUILD PARAMETERS('REPLACE METADATA STORAGE poc_qfc_store');
