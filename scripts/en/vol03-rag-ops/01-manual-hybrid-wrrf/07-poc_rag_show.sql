-- soe — generation parameters (abridged): the reasoning key keeps reasoning text from leaking into the answer
c_params := '{"provider":"openai","credential_name":"OPENROUTER_VEC_CRED",'
         || '"url":"https://openrouter.ai/api/v1/chat/completions",'
         || '"model":"qwen/qwen3.5-flash-02-23","max_tokens":4096,'
         || '"temperature":0.1,"reasoning":{"enabled":false}}';

-- soe — runs retrieval and generation from a single question
SET SERVEROUTPUT ON SIZE UNLIMITED
EXEC poc_rag_show(N'경기도에서 가족과 함께 즐길 수 있는 축제')
