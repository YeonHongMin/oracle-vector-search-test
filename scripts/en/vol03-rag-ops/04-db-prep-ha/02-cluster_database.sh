# oracle @ rac1 — SYS @ CDB$ROOT (ORACLE_SID=PROD1)
sqlplus / as sysdba <<'EOF'
ALTER SYSTEM SET cluster_database = FALSE SCOPE=SPFILE SID='*';
EOF
srvctl stop database -d PROD -o immediate
sqlplus / as sysdba <<'EOF'
STARTUP UPGRADE
ALTER SYSTEM SET max_string_size = EXTENDED SCOPE=SPFILE SID='*';
SHUTDOWN IMMEDIATE
STARTUP UPGRADE
SHOW PARAMETER max_string_size
EOF
# run utl32k.sql on root, PDB$SEED, and all PDBs (prompts for the SYS password)
mkdir -p /tmp/utl32k_out
$ORACLE_HOME/perl/bin/perl $ORACLE_HOME/rdbms/admin/catcon.pl -u SYS --force_pdb_mode 'UPGRADE' \
  -d $ORACLE_HOME/rdbms/admin -l /tmp/utl32k_out -b utl32k_cdb utl32k.sql
# normal startup, then PDB OPEN and SAVE STATE, restore cluster_database, restart via srvctl, then utlrp
sqlplus / as sysdba <<'EOF'
SHUTDOWN IMMEDIATE
STARTUP
ALTER PLUGGABLE DATABASE ALL OPEN;
ALTER PLUGGABLE DATABASE ALL SAVE STATE;
ALTER SYSTEM SET cluster_database = TRUE SCOPE=SPFILE SID='*';
EOF
srvctl stop database -d PROD
srvctl start database -d PROD
mkdir -p /tmp/utlrp_out
$ORACLE_HOME/perl/bin/perl $ORACLE_HOME/rdbms/admin/catcon.pl -u SYS \
  -d $ORACLE_HOME/rdbms/admin -l /tmp/utlrp_out -b utlrp_cdb utlrp.sql
