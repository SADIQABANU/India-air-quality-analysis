USE aqi_project;

-- Check whether the extra rows are copies
SELECT COUNT(*) AS total_rows,
       COUNT(DISTINCT date, location) AS distinct_day_city
FROM aqi_data;

#1.Check that the copies are exact
USE aqi_project;

SELECT COUNT(*) AS unique_rows
FROM (SELECT DISTINCT * FROM aqi_data) AS t;

#2.Build a clean copy
CREATE TABLE aqi_data_clean LIKE aqi_data;
INSERT INTO aqi_data_clean
SELECT DISTINCT * FROM aqi_data;

#3. Check the clean copy
SELECT COUNT(*) AS clean_rows FROM aqi_data_clean;

#4.Swap the tables
RENAME TABLE aqi_data TO aqi_data_old,
             aqi_data_clean TO aqi_data;
             
# when everything matches delete the old table
DROP TABLE aqi_data_old;

#6.Block duplicates in future (optional)
ALTER TABLE aqi_data ADD UNIQUE KEY uq_day_location (date, location);

#Confirm the final state
USE aqi_project;
-- 1. Should list only aqi_data (no aqi_data_old, no aqi_data_clean)
SHOW TABLES;

-- 2. Both numbers should be 235785
SELECT COUNT(*) AS total_rows,
       COUNT(DISTINCT date, location) AS distinct_day_city
FROM aqi_data;

-- 3. Should show a row named uq_day_location
SHOW INDEX FROM aqi_data;