# Collect on the workstation, then move the files to the DB server
python3 collect_public_data.py ./poc_data
head -3 ./poc_data/columns_festivals.txt   # visually check the column order
wc -l ./poc_data/*.csv                     # count includes the 1 header row
scp ./poc_data/festivals.csv ./poc_data/tourism_spots.csv \
    oracle@192.168.0.111:/backup/poc_data/
