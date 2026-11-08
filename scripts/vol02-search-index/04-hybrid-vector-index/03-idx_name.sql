-- soe : 생성 확인
SELECT idx_name, idx_status FROM ctx_user_indexes
 WHERE idx_name LIKE '%KURE_HVI_IDX' ORDER BY 1;              -- INDEXED
SELECT COUNT(*) AS err FROM ctx_user_index_errors;            -- 0
SELECT COUNT(*) AS vec_rows,
       SUM(CASE WHEN doc_chunk_embedding IS NULL THEN 1 ELSE 0 END) AS null_vec
  FROM festivals_kure_hvi_idx$vectors;                        -- null_vec 0
