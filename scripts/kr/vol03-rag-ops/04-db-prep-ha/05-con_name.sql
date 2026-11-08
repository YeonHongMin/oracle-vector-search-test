-- SYS @ PDB1 — CONTEXT 설치 요지
SHOW CON_NAME                                                  -- PDB1
@?/ctx/admin/catctx.sql ctxsys SYSAUX TEMP NOLOCK
@?/ctx/admin/defaults/dr0defin.sql "AMERICAN"
ALTER USER ctxsys ACCOUNT LOCK;         -- PASSWORD EXPIRE를 붙이면 ORA-28010
SELECT comp_id, status, version_full FROM dba_registry WHERE comp_id = 'CONTEXT';
