-- soe — Local IVF on the sido LIST-partitioned clone table
CREATE VECTOR INDEX festivals_kure_livf_idx ON festivals_kure_livf (embedding)
  ORGANIZATION NEIGHBOR PARTITIONS DISTANCE COSINE WITH TARGET ACCURACY 95
  PARAMETERS (TYPE IVF, NEIGHBOR PARTITIONS 8) LOCAL;
