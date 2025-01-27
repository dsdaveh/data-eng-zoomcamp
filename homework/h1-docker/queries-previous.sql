-- Run Homework SQL queries
-- How many taxi trips were totally made on September 18th 2019?

-- psql -h db -U myuser -d nyc_taxi_data -c "
SELECT COUNT(*)
FROM green_tripdata_2019_09
WHERE DATE(lpep_pickup_datetime) = '2019-09-18';"
-- Answer: 15767

-- Which was the pick up day with the longest trip distance? Use the pick up time for your calculations.

SELECT DATE(lpep_pickup_datetime) AS pickup_date, MAX(trip_distance) AS max_distance
FROM green_tripdata_2019_09
GROUP BY pickup_date
ORDER BY max_distance DESC
LIMIT 1;
--Answer: 2019-09-26  |       341.64


-- Consider lpep_pickup_datetime in '2019-09-18' and ignoring Borough has Unknown
-- Which were the 3 pick up Boroughs that had a sum of total_amount superior to 50000?
-- Join the green trip data with the taxi zone lookup table to get the Borough names
SELECT tzl.Borough, SUM(gtd.total_amount) AS total_amount
FROM green_tripdata_2019_09 gtd 
JOIN taxi_zone_lookup tzl ON gtd.pulocationid = tzl.LocationID
WHERE DATE(gtd.lpep_pickup_datetime) = '2019-09-18' AND tzl.Borough != 'Unknown'    
GROUP BY tzl.Borough
HAVING SUM(gtd.total_amount) > 50000
ORDER BY total_amount DESC
LIMIT 3;

-- Consider lpep_pickup_datetime in '2019-09-18' and ignoring Borough has Unknown
-- Which were the 3 pick up Boroughs that had a sum of total_amount superior to 50000?

SELECT pulocationid, SUM(total_amount) AS total_amount
FROM green_tripdata_2019_09
WHERE DATE(lpep_pickup_datetime) = '2019-09-18' AND pulocationid != 1
GROUP BY pulocationid
HAVING SUM(total_amount) > 50000
ORDER BY total_amount DESC
LIMIT 3;

-- For the passengers picked up in September 2019 in the zone name Astoria 
-- which was the drop off zone that had the largest tip? We want the name of the zone, not the id.

SELECT
  pup.zone AS pickup_zone,
  dop.zone AS dropoff_zone,
  MAX(g.tip_amount) AS max_tip
FROM green_tripdata_2019_09 AS g
JOIN taxi_zone_lookup AS pup
  ON g.pulocationid = pup.locationid
JOIN taxi_zone_lookup AS dop
  ON g.dolocationid = dop.locationid
WHERE pup.zone = 'Astoria'
  AND DATE(g.lpep_pickup_datetime) >= '2019-09-01'
  AND DATE(g.lpep_pickup_datetime) <= '2019-09-30'
GROUP BY dop.zone, pup.zone
ORDER BY max_tip DESC
LIMIT 1;


-- Answer: Astoria     | JFK Airport  |   62.31