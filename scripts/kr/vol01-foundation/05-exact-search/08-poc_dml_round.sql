SET SERVEROUTPUT ON
EXEC poc_dml_round('KURE', 'EXACT', 0)   -- 기준 회차
EXEC poc_dml_round('KURE', 'EXACT', 1)   -- 배경 DML 1세션
EXEC poc_dml_round('KURE', 'EXACT', 3)   -- 배경 DML 3세션
