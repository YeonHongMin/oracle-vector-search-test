-- Split unstructured documents into character-based chunks
SELECT d.doc_id,
       c.chunk_id,
       c.chunk_offset,
       c.chunk_text
  FROM manual_docs d,
       VECTOR_CHUNKS(
         TO_CLOB(d.body)
         BY CHARS MAX 500
         OVERLAP 50
         SPLIT BY SENTENCE
         LANGUAGE KOREAN
         NORMALIZE ALL
       ) c;
