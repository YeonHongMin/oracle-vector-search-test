-- 매일 점검의 핵심 뷰(요약)
SELECT model_name, inmemory FROM user_mining_models;               -- 모델 INMEMORY
SELECT idx_name, idx_status FROM ctx_user_indexes;                 -- Text·HVI INDEXED
SELECT COUNT(*) FROM ctx_user_index_errors;                        -- 오류 증가 0
SELECT pool, alloc_bytes, used_bytes FROM v$vector_memory_pool;    -- Vector Pool 여유
SELECT index_name, num_vectors, index_used_count FROM v$vector_index;
SELECT event, time_waited FROM v$system_event WHERE event LIKE 'Vector%';
