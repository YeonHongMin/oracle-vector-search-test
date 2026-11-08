# 워크스테이션에서 수집하고 DB 서버로 옮긴다
python3 collect_public_data.py ./poc_data
head -3 ./poc_data/columns_festivals.txt   # 컬럼 순서를 육안으로 확인
wc -l ./poc_data/*.csv                     # 헤더 1행이 더해진 수
scp ./poc_data/festivals.csv ./poc_data/tourism_spots.csv \
    oracle@192.168.0.111:/backup/poc_data/
