BEGIN
  DBMS_VECTOR.LOAD_ONNX_MODEL(
    directory => 'ONNX_DIR', file_name => 'kure_v1.onnx', model_name => 'KURE_V1',
    metadata  => JSON('{"function":"embedding","embeddingOutput":"embedding","input":{"input":["DATA"]}}'));
END;
/
BEGIN DBMS_VECTOR.INMEMORY_ONNX_MODEL(model_name => 'KURE_V1', enable => TRUE); END;
/
SELECT model_name, model_size, external_data, inmemory
  FROM user_mining_models WHERE model_name = 'KURE_V1';
