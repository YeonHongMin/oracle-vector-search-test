-- soe — 파이프라인 함수 호출 예: SELECT 안에서 같은 WRRF 계약을 쓴다
SELECT rnk, id, name, wrrf FROM TABLE(mhs_search(p_qvec => (SELECT q_gpu FROM qvec_kure WHERE qid = 'Q01'),
                                                 p_keywords => N'가족', p_sido => '경기'));
