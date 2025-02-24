# In this example we use the open-source "dlt" library (pip install dlt)
# to orchestrate a simple pipeline that:
# 1) Downloads the FHV CSV files from GitHub if not present locally
# 2) Uploads them to GCS
# 3) Creates (or updates) an external BigQuery table pointing to those files in GCS
#
# Adjust project IDs, dataset, and bucket as needed.

import os
import requests
import dlt
from google.cloud import storage, bigquery

PROJECT_ID = "zoomcamp-data-eng"
BUCKET_NAME = "zoomcamp-data-eng-h4-nyc_data"
DATASET_ID = "nyc_trips_fhv"
TABLE_ID = "fhv_external"

# Automatically generate the file list for 2019, months 1 through 12.
FHV_FILES = [
    f"fhv_tripdata_2019-{month:02d}.csv.gz"
    for month in range(1, 13)
]

@dlt.resource(name="upload_files_and_create_external_table", write_disposition="append")
def upload_files_and_create_external_table():
    storage_client = storage.Client(PROJECT_ID)
    bq_client = bigquery.Client(PROJECT_ID)
    bucket = storage_client.bucket(BUCKET_NAME)

    for file_name in FHV_FILES:
        github_url = f"https://github.com/DataTalksClub/nyc-tlc-data/releases/download/fhv/{file_name}"
        if not os.path.exists(file_name):
            r = requests.get(github_url)
            r.raise_for_status()
            with open(file_name, "wb") as f:
                f.write(r.content)

        blob_path = f"fhv/{file_name}"
        blob = bucket.blob(blob_path)
        blob.upload_from_filename(file_name)

    # Create or update an external BigQuery table referencing these files
    table_ref = f"{PROJECT_ID}.{DATASET_ID}.{TABLE_ID}"
    external_config = bigquery.ExternalConfig("CSV")
    external_config.source_uris = [f"gs://{BUCKET_NAME}/fhv/{{f}}" for f in FHV_FILES]
    external_config.options.skip_leading_rows = 1
    external_config.options.autodetect = True

    table = bigquery.Table(table_ref)
    table.external_data_configuration = external_config

    bq_client.create_table(table, exists_ok=True)

    yield {
        "status": "complete",
        "table": table_ref,
        "files_processed": FHV_FILES
    }

@dlt.source
def fhv_source():
    return [upload_files_and_create_external_table()]

if __name__ == "__main__":
    pipeline = dlt.pipeline(
        pipeline_name="fhv_pipeline",
        destination="bigquery",
        dataset_name=DATASET_ID
    )
    info = pipeline.run(fhv_source)
    print(info)
