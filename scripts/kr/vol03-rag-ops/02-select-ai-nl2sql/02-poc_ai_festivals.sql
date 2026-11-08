-- soe — 프로필의 comments 속성이 이 설명을 프롬프트에 포함한다
COMMENT ON TABLE  poc_ai_festivals IS '전국 문화축제 목록 (공공데이터 전국문화축제표준데이터)';
COMMENT ON COLUMN poc_ai_festivals.sido IS
  '시·도 약칭: 서울 부산 대구 인천 광주 대전 울산 세종 경기 강원 충북 충남 전북 전남 경북 경남 제주';
COMMENT ON COLUMN poc_ai_festivals.content_summary IS '축제 내용 앞 300자';
COMMENT ON TABLE  poc_ai_spots IS '전국 관광지 목록 (공공데이터 전국관광지정보표준데이터)';
COMMENT ON COLUMN poc_ai_spots.sido IS
  '시·도 약칭: 서울 부산 대구 인천 광주 대전 울산 세종 경기 강원 충북 충남 전북 전남 경북 경남 제주';
