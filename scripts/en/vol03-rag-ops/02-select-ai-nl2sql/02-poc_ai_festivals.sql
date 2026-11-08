-- soe — the profile's comments attribute includes these descriptions in the prompt
COMMENT ON TABLE  poc_ai_festivals IS 'List of nationwide cultural festivals (public data: National Culture Festival Standard Data)';
COMMENT ON COLUMN poc_ai_festivals.sido IS
  'City/province abbreviations: 서울 부산 대구 인천 광주 대전 울산 세종 경기 강원 충북 충남 전북 전남 경북 경남 제주';
COMMENT ON COLUMN poc_ai_festivals.content_summary IS 'First 300 characters of the festival description';
COMMENT ON TABLE  poc_ai_spots IS 'List of nationwide tourist spots (public data: National Tourist Spot Information Standard Data)';
COMMENT ON COLUMN poc_ai_spots.sido IS
  'City/province abbreviations: 서울 부산 대구 인천 광주 대전 울산 세종 경기 강원 충북 충남 전북 전남 경북 경남 제주';
