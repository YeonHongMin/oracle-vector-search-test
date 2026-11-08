-- soe — 생성 파라미터(축약): reasoning 키로 추론 문장 유출을 막는다
c_params := '{"provider":"openai","credential_name":"OPENROUTER_VEC_CRED",'
         || '"url":"https://openrouter.ai/api/v1/chat/completions",'
         || '"model":"qwen/qwen3.5-flash-02-23","max_tokens":4096,'
         || '"temperature":0.1,"reasoning":{"enabled":false}}';

-- soe — 질문 한 줄로 검색과 생성을 실행한다
SET SERVEROUTPUT ON SIZE UNLIMITED
EXEC poc_rag_show(N'경기도에서 가족과 함께 즐길 수 있는 축제')
