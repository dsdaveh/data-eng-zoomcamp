#!/bin/bash
set -e

# Download compressed CSV
wget -O green_tripdata_2019-09.csv.gz \
  https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2019-09.csv.gz

# Decompress
gunzip -f green_tripdata_2019-09.csv.gz

# Create table (if it doesn’t exist)
psql -h db -U myuser -d nyc_taxi_data -c "
CREATE TABLE IF NOT EXISTS green_tripdata_2019_09 (
  vendorid INT,
  lpep_pickup_datetime TIMESTAMP,
  lpep_dropoff_datetime TIMESTAMP,
  store_and_fwd_flag TEXT,
  ratecodeid INT,
  pulocationid INT,
  dolocationid INT,
  passenger_count INT,
  trip_distance NUMERIC,
  fare_amount NUMERIC,
  extra NUMERIC,
  mta_tax NUMERIC,
  tip_amount NUMERIC,
  tolls_amount NUMERIC,
  ehail_fee NUMERIC,
  improvement_surcharge NUMERIC,
  total_amount NUMERIC,
  payment_type INT,
  trip_type INT,
  congestion_surcharge NUMERIC
);
"

# Load CSV
psql -h db -U myuser -d nyc_taxi_data -c "\COPY green_tripdata_2019_09 FROM 'green_tripdata_2019-09.csv' CSV HEADER"
echo "Data load complete."




