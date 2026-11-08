-- SYS @ CDB$ROOT — CDB 먼저, 그다음 PDB(반대면 ORA-56747)
ALTER SYSTEM SET pga_aggregate_target = 12G SCOPE=BOTH SID='*';
ALTER SYSTEM SET pga_aggregate_limit  = 0   SCOPE=BOTH SID='*';
-- PDB1에서도 같은 두 파라미터를 실행한다
-- vector_memory_size는 CDB root에서 SPFILE로만 바꾸고 재기동한다
