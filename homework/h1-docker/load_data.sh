#!/bin/bash
set -e

# Download compressed CSV for green trip data
wget -O green_tripdata_2019-10.csv.gz \
  https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2019-10.csv.gz

# Decompress
gunzip -f green_tripdata_2019-10.csv.gz

# Download taxi zone lookup CSV
wget -O taxi_zone_lookup.csv \
  https://github.com/DataTalksClub/nyc-tlc-data/releases/download/misc/taxi_zone_lookup.csv

# Create table for green trip data (if it doesn’t exist)
psql -h db -U myuser -d nyc_taxi_data -c "
CREATE TABLE IF NOT EXISTS green_tripdata_2019_10 (
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

# Load the green trip data CSV
psql -h db -U myuser -d nyc_taxi_data -c "\COPY green_tripdata_2019_10 FROM 'green_tripdata_2019-10.csv' CSV HEADER"

# Create table for taxi zone lookup (if it doesn’t exist)
psql -h db -U myuser -d nyc_taxi_data -c "
CREATE TABLE IF NOT EXISTS taxi_zone_lookup (
  LocationID INT PRIMARY KEY,
  Borough TEXT,
  Zone TEXT,
  service_zone TEXT
);
"

# Load the taxi zone lookup CSV
psql -h db -U myuser -d nyc_taxi_data -c "\COPY taxi_zone_lookup FROM 'taxi_zone_lookup.csv' CSV HEADER"
echo "Data load complete."

echo "psql -h localhost -U myuser -d nyc_taxi_data -p 5432"
