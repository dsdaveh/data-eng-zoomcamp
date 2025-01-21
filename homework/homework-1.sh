# Question 1. Knowing docker tags
# Which tag has the following text? - Automatically remove the container when it exits
docker run --help | grep -i "automatically remove the container when it exits"
# Answer: --rm

# Question 2. Understanding docker first run
# Run docker with the python:3.9 image in an interactive mode and the entrypoint of bash. Now check the python modules that are installed ( use pip list ).
docker run -it --entrypoint /bin/bash python:3.9
# What is version of the package wheel ?
pip list | grep wheel
# Answer: wheel      0.45.1

# Prepare Postgres
wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2019-09.csv.gz
#wget https://s3.amazonaws.com/nyc-tlc/misc/taxi+_zone_lookup.csv #ERROR 403: forbidden
wget https://d37ci6vzurychx.cloudfront.net/misc/taxi_zone_lookup.csv

# Used ChatGPT to create 
# - docker-compose.yml
# - Dockerfile
# - load_data.sh

# Run Homework SQL queries
# How many taxi trips were totally made on September 18th 2019?

psql -h db -U myuser -d nyc_taxi_data -c "
SELECT COUNT(*)
FROM green_tripdata_2019_09
WHERE DATE(lpep_pickup_datetime) = '2019-09-18';
# Answer: 15767

# Which was the pick up day with the longest trip distance? Use the pick up time for your calculations.

psql -h db -U myuser -d nyc_taxi_data -c "
SELECT DATE(lpep_pickup_datetime) AS pickup_date, MAX(trip_distance) AS max_distance
FROM green_tripdata_2019_09
GROUP BY pickup_date
ORDER BY max_distance DESC
LIMIT 1;
#Answer: 2019-09-26  |       341.64

# Consider lpep_pickup_datetime in '2019-09-18' and ignoring Borough has Unknown
# Which were the 3 pick up Boroughs that had a sum of total_amount superior to 50000?

psql -h db -U myuser -d nyc_taxi_data -c "
SELECT pulocationid, SUM(total_amount) AS total_amount
FROM green_tripdata_2019_09
WHERE DATE(lpep_pickup_datetime) = '2019-09-18' AND pulocationid != 1
GROUP BY pulocationid
HAVING SUM(total_amount) > 50000
ORDER BY total_amount DESC
LIMIT 3;