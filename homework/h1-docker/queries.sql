-- Run Homework SQL queries
-- Q3. During the period of October 1st 2019 (inclusive) and November 1st 2019 (exclusive), how many trips, respectively, happened:

-- Up to 1 mile
-- In between 1 (exclusive) and 3 miles (inclusive),
-- In between 3 (exclusive) and 7 miles (inclusive),
-- In between 7 (exclusive) and 10 miles (inclusive),
-- Over 10 miles

SELECT COUNT(*) FROM green_tripdata_2019_10 WHERE trip_distance <= 1;
SELECT COUNT(*) FROM green_tripdata_2019_10 WHERE trip_distance > 1 AND trip_distance <= 3;
SELECT COUNT(*) FROM green_tripdata_2019_10 WHERE trip_distance > 3 AND trip_distance <= 7;
SELECT COUNT(*) FROM green_tripdata_2019_10 WHERE trip_distance > 7 AND trip_distance <= 10;
SELECT COUNT(*) FROM green_tripdata_2019_10 WHERE trip_distance > 10;
-- Answers: 104838,  199013,  109645,  27688,  35202

-- Q4. Which was the pick up day with the longest trip distance? Use the pick up time for your calculations.

SELECT DATE(lpep_pickup_datetime) AS pickup_date, MAX(trip_distance) AS max_distance
FROM green_tripdata_2019_10
GROUP BY pickup_date
ORDER BY max_distance DESC
LIMIT 1;
-- Answer:  2019-10-31  |       515.89


-- Q5. Which were the top pickup locations with over 13,000 in total_amount (across all trips) for 2019-10-18?
-- Consider only lpep_pickup_datetime when filtering by date.
--- Join the green trip data with the taxi zone lookup table to get the Borough names

SELECT pulocationid, tzl.zone as zone, SUM(total_amount) AS total_amount
FROM green_tripdata_2019_10 gtd
JOIN taxi_zone_lookup tzl ON gtd.pulocationid = tzl.LocationID
WHERE DATE(lpep_pickup_datetime) = '2019-10-18'
GROUP BY pulocationid, zone
HAVING SUM(total_amount) > 13000
ORDER BY total_amount DESC;

          --  74 | East Harlem North   |     18686.68
          --  75 | East Harlem South   |     16797.26
          -- 166 | Morningside Heights |     13029.79


-- Which was the pick up day with the longest trip distance? Use the pick up time for your calculations.

SELECT DATE(lpep_pickup_datetime) AS pickup_date, MAX(trip_distance) AS max_distance
FROM green_tripdata_2019_09
GROUP BY pickup_date
ORDER BY max_distance DESC
LIMIT 1;
--Answer: 2019-09-26  |       341.64

-- Q6. For the passengers picked up in October 2019 in the zone named "East Harlem North" which was the drop off zone that had the largest tip?

SELECT
  pup.zone AS pickup_zone,
  dop.zone AS dropoff_zone,
  MAX(g.tip_amount) AS max_tip
FROM green_tripdata_2019_10 AS g
JOIN taxi_zone_lookup AS pup
  ON g.pulocationid = pup.locationid
JOIN taxi_zone_lookup AS dop
  ON g.dolocationid = dop.locationid
WHERE pup.zone = 'East Harlem North'
  AND DATE(g.lpep_pickup_datetime) >= '2019-10-01'
  AND DATE(g.lpep_pickup_datetime) <= '2019-10-31'  
GROUP BY dop.zone, pup.zone
ORDER BY max_tip DESC
LIMIT 1;

