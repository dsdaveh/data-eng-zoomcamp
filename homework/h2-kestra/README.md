### Quiz Questions

Complete the Quiz shown below. It’s a set of 6 multiple-choice questions to test your understanding of workflow orchestration, Kestra and ETL pipelines for data lakes and warehouses.

1) Within the execution for `Yellow` Taxi data for the year `2020` and month `12`: what is the uncompressed file size (i.e. the output file `yellow_tripdata_2020-12.csv` of the `extract` task)?
- 128.3 MB

Notes: added logs to [t02_postgres_taxi](flows/02_postgres_taxi.yaml) `extract` task, but they gave weird answers 
  * ls -lh -> 129M
  * du -h -> 145M
  * both commands on a locally downloaded file -> 128M

2) What is the rendered value of the variable `file` when the inputs `taxi` is set to `green`, `year` is set to `2020`, and `month` is set to `04` during execution?
- ~~`{{inputs.taxi}}_tripdata_{{inputs.year}}-{{inputs.month}}.csv`~~ 
- `green_tripdata_2020-04.csv`
- ~~`green_tripdata_04_2020.csv`~~
- ~~`green_tripdata_2020.csv`~~

`green_tripdata_2020-04.csv` is the correct answer, unless the question is about the rendered value of the variable `file`, not the rendered value of the `file` variable in the `extract` task, in which case the correct answer should be `{{inputs.taxi}}_tripdata_{{inputs.year}}-{{inputs.month}}.csv`

3) How many rows are there for the `Yellow` Taxi data for all CSV files in the year 2020?
- 13,537.299
- 24,648,499 <- correct>
- 18,324,219
- 29,430,127

```
SELECT EXTRACT(YEAR FROM tpep_pickup_datetime) AS year, COUNT(*) AS record_count
FROM yellow_tripdata
GROUP BY EXTRACT(YEAR FROM tpep_pickup_datetime)
ORDER BY year;
```

| year | record_count |
|------|--------------|
| 2020	| 24648219 |

4) How many rows are there for the `Green` Taxi data for all CSV files in the year 2020?
- 5,327,301
- 936,199
- 1,734,051 <- correct>
- 1,342,034

```
SELECT COUNT(*) 
FROM green_tripdata
WHERE EXTRACT(YEAR FROM lpep_pickup_datetime) = 2020;
```
1734038

5) How many rows are there for the `Yellow` Taxi data for the March 2021 CSV file?
- 1,428,092
- 706,911
- 1,925,152
- 2,561,031

* modify 02_postgres_taxi.yaml to include 2021 in inputs.year.values
* yellow_copy_in_to_staging_table: Outputs: rowCount = 1 925 152



6) How would you configure the timezone to New York in a Schedule trigger?
- ~~Add a `timezone` property set to `EST` in the `Schedule` trigger configuration~~
- Add a `timezone` property set to `America/New_York` in the `Schedule` trigger configuration
- ~~Add a `timezone` property set to `UTC-5` in the `Schedule` trigger configuration~~
- ~~Add a `location` property set to `New_York` in the `Schedule` trigger configuration~~  


## Submitting the solutions

* Form for submitting: https://courses.datatalks.club/de-zoomcamp-2025/homework/hw2
* Check the link above to see the due date

## Solution

Will be added after the due date