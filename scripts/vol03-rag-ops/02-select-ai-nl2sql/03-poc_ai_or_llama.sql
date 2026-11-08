-- soe — 표준 프로필: 비추론 모델 (이 장의 골든 채점은 추론 모델 프로필로 실행했다)
BEGIN
  BEGIN DBMS_CLOUD_AI.DROP_PROFILE('POC_AI_OR_LLAMA'); EXCEPTION WHEN OTHERS THEN NULL; END;
  DBMS_CLOUD_AI.CREATE_PROFILE(
    profile_name => 'POC_AI_OR_LLAMA',
    attributes   => '{
      "provider": "openai",
      "credential_name": "OPENROUTER_CRED",
      "provider_endpoint": "https://openrouter.ai/api",
      "model": "meta-llama/llama-3.3-70b-instruct",
      "object_list": [{"owner":"SOE","name":"POC_AI_FESTIVALS"},
                      {"owner":"SOE","name":"POC_AI_SPOTS"}],
      "comments": true,
      "conversation": false,
      "temperature": 0.1,
      "max_tokens": 4096
    }');
END;
/
