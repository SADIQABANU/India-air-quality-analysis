USE aqi_project;
# question1. which city has the worst air? 
-- Q1: Top 10 most polluted cities (average AQI) which city has the worst air? 
SELECT location,
       ROUND(AVG(aqi_value), 1) AS avg_aqi,
       COUNT(*) AS days_recorded
FROM aqi_data
GROUP BY location
HAVING COUNT(*) >= 300
ORDER BY avg_aqi DESC
LIMIT 10;

#question2. which city has the worst air? 
-- Q2: Top 10 states by average AQI
SELECT state,
       ROUND(AVG(aqi_value), 1) AS avg_aqi,
       COUNT(DISTINCT location) AS cities
FROM aqi_data
GROUP BY state
HAVING COUNT(*) >= 300
ORDER BY avg_aqi DESC
LIMIT 10;

#question3. Which season is worst?
-- Q3: Average AQI and share of Poor-or-worse days by season
SELECT season,
       ROUND(AVG(aqi_value), 1) AS avg_aqi,
       ROUND(100 * AVG(is_poor_or_worse), 1) AS pct_poor_or_worse
FROM aqi_data
GROUP BY season
ORDER BY avg_aqi DESC;

#question4. Which months are best and worst?
-- Q4: Average AQI by month
SELECT month, month_name,
       ROUND(AVG(aqi_value), 1) AS avg_aqi
FROM aqi_data
GROUP BY month, month_name
ORDER BY month;

#question5. Is the air improving over time?
-- Q5: Trend using only cities with (almost) full data in all three periods
WITH periods AS (
    SELECT location, aqi_value,
           CASE WHEN date <= '2023-03-31' THEN 'FY2022-23'
                WHEN date <= '2024-03-31' THEN 'FY2023-24'
                ELSE 'FY2024-25' END AS period
    FROM aqi_data
    WHERE date BETWEEN '2022-04-01' AND '2025-03-31'
),
city_period AS (
    SELECT location, period, COUNT(*) AS days
    FROM periods
    GROUP BY location, period
),
stable_cities AS (
    SELECT location
    FROM city_period
    WHERE days >= 300
    GROUP BY location
    HAVING COUNT(*) = 3
)
SELECT period,
       COUNT(DISTINCT location) AS cities,
       ROUND(AVG(aqi_value), 1) AS avg_aqi
FROM periods
WHERE location IN (SELECT location FROM stable_cities)
GROUP BY period
ORDER BY period;

#question6.Which cities have the most unhealthy days?
-- Q6: Share of days that were Poor, Very Poor or Severe
SELECT location,
       COUNT(*) AS days_recorded,
       SUM(is_poor_or_worse) AS poor_or_worse_days,
       ROUND(100 * AVG(is_poor_or_worse), 1) AS pct_poor_or_worse
FROM aqi_data
GROUP BY location
HAVING COUNT(*) >= 300
ORDER BY pct_poor_or_worse DESC
LIMIT 10;

#question7. Which pollutants dominate?
-- Q7: How often each pollutant was a prominent pollutant
SELECT ROUND(100 * AVG(prom_pm10), 1) AS pm10_pct,
       ROUND(100 * AVG(prom_pm25), 1) AS pm25_pct,
       ROUND(100 * AVG(prom_o3), 1)   AS o3_pct,
       ROUND(100 * AVG(prom_co), 1)   AS co_pct,
       ROUND(100 * AVG(prom_no2), 1)  AS no2_pct,
       ROUND(100 * AVG(prom_so2), 1)  AS so2_pct
FROM aqi_data;

#question8. Delhi-NCR versus the rest of India?
-- Q8a: Delhi-NCR compared with the rest of India
SELECT CASE WHEN location IN ('Delhi (Delhi)', 'NOIDA (Uttar Pradesh)',
                              'Greater Noida (Uttar Pradesh)', 'Ghaziabad (Uttar Pradesh)',
                              'Gurugram (Haryana)', 'Faridabad (Haryana)')
            THEN 'Delhi-NCR' ELSE 'Rest of India' END AS region,
       COUNT(DISTINCT location) AS cities,
       ROUND(AVG(aqi_value), 1) AS avg_aqi,
       ROUND(100 * AVG(is_poor_or_worse), 1) AS pct_poor_or_worse
FROM aqi_data
GROUP BY region;

-- Q8b: The same comparison by season
SELECT CASE WHEN location IN ('Delhi (Delhi)', 'NOIDA (Uttar Pradesh)',
                              'Greater Noida (Uttar Pradesh)', 'Ghaziabad (Uttar Pradesh)',
                              'Gurugram (Haryana)', 'Faridabad (Haryana)')
            THEN 'Delhi-NCR' ELSE 'Rest of India' END AS region,
       season,
       ROUND(AVG(aqi_value), 1) AS avg_aqi
FROM aqi_data
GROUP BY region, season
ORDER BY region, avg_aqi DESC;

#question9. How do the six metro cities compare?
-- Q9: Six big metros side by side
SELECT location,
       ROUND(AVG(aqi_value), 1) AS avg_aqi,
       ROUND(100 * AVG(is_poor_or_worse), 1) AS pct_poor_or_worse,
       MAX(aqi_value) AS max_aqi,
       ROUND(AVG(CASE WHEN season = 'Winter'  THEN aqi_value END), 1) AS winter_avg,
       ROUND(AVG(CASE WHEN season = 'Monsoon' THEN aqi_value END), 1) AS monsoon_avg
FROM aqi_data
WHERE location IN ('Delhi (Delhi)', 'Mumbai (Maharashtra)', 'Kolkata (West Bengal)',
                   'Hyderabad (Telangana)', 'Bengaluru (Karnataka)', 'Chennai (Tamil Nadu)')
GROUP BY location
ORDER BY avg_aqi DESC;

#question10. The most extreme pollution events
#10a: The 10 highest readings ever recorded
-- Q10a: Top 10 highest single-day AQI readings
SELECT date, location, aqi_value
FROM aqi_data
ORDER BY aqi_value DESC, date
LIMIT 10;

#10b: Which cities have the most Severe days?
-- Q10b: Cities with the most Severe days (AQI 401 and above)
-- Q10b (updated): ties broken alphabetically
SELECT location,
       COUNT(*) AS severe_days
FROM aqi_data
WHERE aqi_category = 'Severe'
GROUP BY location
ORDER BY severe_days DESC, location
LIMIT 11;

#10c: When do Severe days happen?
-- Q10c: Severe days by season
SELECT season,
       COUNT(*) AS severe_days
FROM aqi_data
WHERE aqi_category = 'Severe'
GROUP BY season
ORDER BY severe_days DESC;