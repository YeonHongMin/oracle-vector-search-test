-- SYS @ CDB$ROOT — CDB first, then the PDB (the other way around raises ORA-56747)
ALTER SYSTEM SET pga_aggregate_target = 12G SCOPE=BOTH SID='*';
ALTER SYSTEM SET pga_aggregate_limit  = 0   SCOPE=BOTH SID='*';
-- run the same two parameters on PDB1 as well
-- vector_memory_size is changed only via SPFILE on the CDB root, followed by a restart
