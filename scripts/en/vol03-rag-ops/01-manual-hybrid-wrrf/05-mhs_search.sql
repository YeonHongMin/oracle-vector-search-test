-- soe — pipeline function call example: the same WRRF contract inside a SELECT
SELECT rnk, id, name, wrrf FROM TABLE(mhs_search(p_qvec => (SELECT q_gpu FROM qvec_kure WHERE qid = 'Q01'),
                                                 p_keywords => N'가족', p_sido => '경기'));
