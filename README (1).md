# Week 7 - Delta Lake Incremental Data Processing

## Objective
Implement an incremental data processing pipeline using Delta Lake by loading customer data, performing data cleaning, and applying MERGE operations to update and insert records.

## Technologies Used
- Databricks Community Edition
- Apache Spark (PySpark)
- Delta Lake
- Python

## Dataset
Two CSV datasets were used:
- customer_master.csv
- customer_incremental.csv

## Tasks Performed
- Loaded customer data into a Delta table
- Removed duplicate records
- Handled null values
- Loaded incremental customer data
- Performed MERGE operation to update existing records and insert new records
- Validated row count and duplicate records
- Displayed the final Delta table

## Learning Outcomes
- Delta Lake Fundamentals
- Delta Tables
- Data Cleaning
- Incremental Data Processing
- MERGE Operation
- Data Validation

## Repository Contents
- data/
  - customer_master.csv
  - customer_incremental.csv
- notebooks/
  - delta_scd_assignment.ipynb
- screenshots/
- README.md

## Summary
This assignment demonstrates how Delta Lake supports incremental data processing using MERGE operations. Customer data was cleaned, duplicate records were removed, null values were handled, and incremental updates and inserts were successfully applied to a Delta table.