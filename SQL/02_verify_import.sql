USE aqi_project;
SELECT COUNT(*) AS rows_so_far FROM aqi_data;

-- Check 2: date range and locations (expect 2022-04-01, 2025-04-30, 292)
SELECT MIN(date) AS first_day,
       MAX(date) AS last_day,
       COUNT(DISTINCT location) AS locations
FROM aqi_data;

-- Check 3: AQI summary (expect 3, 500, about 111.13)
SELECT MIN(aqi_value) AS min_aqi,
       MAX(aqi_value) AS max_aqi,
       ROUND(AVG(aqi_value), 2) AS avg_aqi
FROM aqi_data;

-- Check 4: missing values (expect 0, 0, 0)
SELECT SUM(date IS NULL) AS null_dates,
       SUM(state IS NULL) AS null_states,
       SUM(aqi_value IS NULL) AS null_aqi
FROM aqi_data;

-- Check 5: status counts (expect Satisfactory 88897, Moderate 77537, Good 41971, Poor 21154, Very Poor 5671, Severe 555)
SELECT air_quality_status, COUNT(*) AS days
FROM aqi_data
GROUP BY air_quality_status
ORDER BY days DESC;
