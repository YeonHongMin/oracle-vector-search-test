-- key views for the daily check (summary)
SELECT model_name, inmemory FROM user_mining_models;               -- models INMEMORY
SELECT idx_name, idx_status FROM ctx_user_indexes;                 -- Text and HVI INDEXED
SELECT COUNT(*) FROM ctx_user_index_errors;                        -- error growth 0
SELECT pool, alloc_bytes, used_bytes FROM v$vector_memory_pool;    -- Vector Pool headroom
SELECT index_name, num_vectors, index_used_count FROM v$vector_index;
SELECT event, time_waited FROM v$system_event WHERE event LIKE 'Vector%';
