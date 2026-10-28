-- ============================================================
-- 01_create_database_and_table.sql
-- Project : Air Quality Analysis of Indian Cities (Apr 2022 - Apr 2025)
-- Purpose : Create the database and the table that holds the cleaned AQI data
-- Source  : aqi_cleaned.csv (235,785 rows, 24 columns), produced by the Python cleaning step
-- ============================================================

-- 1. Create the project database
CREATE DATABASE IF NOT EXISTS aqi_project;
USE aqi_project;

-- 2. Create the table (24 columns, same order as aqi_cleaned.csv)
CREATE TABLE aqi_data (
    date DATE,
    state VARCHAR(60),
    area VARCHAR(80),
    number_of_monitoring_stations INT,
    prominent_pollutants VARCHAR(40),
    aqi_value INT,
    air_quality_status VARCHAR(20),
    location VARCHAR(150),
    year INT,
    month INT,
    month_name VARCHAR(5),
    `year_month` VARCHAR(10),      -- backticks needed: year_month is a reserved word in MySQL
    season VARCHAR(20),
    aqi_category VARCHAR(20),
    is_poor_or_worse TINYINT,
    prom_co TINYINT,
    prom_nh3 TINYINT,
    prom_no2 TINYINT,
    prom_o3 TINYINT,
    prom_pm10 TINYINT,
    prom_pm25 TINYINT,
    prom_so2 TINYINT,
    prom_so3 TINYINT,
    n_prominent TINYINT,
    -- one reading per city per day (added after the duplicate fix, see 03_fix_duplicates.sql)
    UNIQUE KEY uq_day_location (date, location)
);

-- 3. Load the data
-- Done with MySQL Workbench: right-click aqi_data > Table Data Import Wizard >
-- choose aqi_cleaned.csv > "Use existing table" > Next until finished.
-- Note: the wizard is slow for this file (about two hours).

-- 4. Check the load (details in 02_verify_import.sql)
SELECT COUNT(*) AS total_rows FROM aqi_data;   -- expect 235785