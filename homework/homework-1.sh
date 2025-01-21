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

