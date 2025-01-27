variable "credentials" {
  description = "My Credentials"
  default     = "/Users/davidhurst/Documents/zoomcamp-data-eng/zoomcamp-data-eng-903c3c5f2174.json"
}


variable "project" {
  description = "Project"
  default     = "zoomcamp-data-eng"
}

variable "region" {
  description = "Region"
  #Update the below to your desired region
  default     = "us-west2"
}

variable "location" {
  description = "Project Location"
  #Update the below to your desired location
  default     = "US"
}

variable "bq_dataset_name" {
  description = "My BigQuery Dataset Name"
  #Update the below to what you want your dataset to be called
  default     = "m1_dataset"
}

variable "gcs_bucket_name" {
  description = "My Storage Bucket Name"
  #Update the below to a unique bucket name
  default     = "m1-terra-bucket"
}

variable "gcs_storage_class" {
  description = "Bucket Storage Class"
  default     = "STANDARD"
}