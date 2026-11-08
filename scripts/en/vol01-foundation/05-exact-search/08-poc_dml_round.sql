SET SERVEROUTPUT ON
EXEC poc_dml_round('KURE', 'EXACT', 0)   -- baseline round
EXEC poc_dml_round('KURE', 'EXACT', 1)   -- 1 background DML session
EXEC poc_dml_round('KURE', 'EXACT', 3)   -- 3 background DML sessions
