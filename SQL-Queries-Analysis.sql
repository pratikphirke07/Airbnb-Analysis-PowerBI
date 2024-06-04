--SQL queries used for data cleaning and analysis:

-- Dropping columns from the table

ALTER TABLE   Air_Bnb
DROP COLUMN last_review, scrape_id, last_scraped, name, first_review, reviews_per_month;

--------------------------------------------------------------------------------------------------
-- Average Price by Room Type and Accommodation Size

SELECT 
    [Room Type],
    ROUND(AVG(Price), 2) AS [Average Price],
    COUNT(*) AS [Total Rooms]
FROM 
      Air_Bnb
GROUP BY 
    [Room Type];

--------------------------------------------------------------------------------------------------
-- Average Review Scores by Neighbourhood 
SELECT 
    Neighbourhood,
    ROUND(AVG([Reviews Per Month]), 2) AS [Average Review Score]
FROM 
      Air_Bnb
GROUP BY 
    Neighbourhood 
ORDER BY 
    [Average Review Score] DESC;

--------------------------------------------------------------------------------------------------
-- Grouping by price per neighbourhood group:

SELECT DISTINCT 
    [Neighbourhood Group], 
    AVG(Price) AS avg_price
FROM 
      Air_Bnb
GROUP BY 
    [Neighbourhood Group];

--------------------------------------------------------------------------------------------------
-- Grouping by neighbourhoods and price:

SELECT DISTINCT 
    Neighbourhood, 
    [Neighbourhood Group], 
    AVG(Price) OVER (PARTITION BY Neighbourhood) AS avg_price
FROM 
      Air_Bnb
ORDER BY 
    [Neighbourhood Group];

--------------------------------------------------------------------------------------------------
-- Counting number of Airbnb per neighbourhood

SELECT 
    Neighbourhood, 
    [Neighbourhood Group],
    COUNT(*) AS [No of AirBnb]
FROM 
      Air_Bnb
GROUP BY 
    Neighbourhood, 
    [Neighbourhood Group]
ORDER BY 
    [No of AirBnb] DESC;

--------------------------------------------------------------------------------------------------
-- Common Table Expression for neighbourhood data

WITH NeighbourhoodData AS (
    SELECT 
        Neighbourhood, 
        AVG(CAST(Price AS FLOAT)) OVER (PARTITION BY Neighbourhood) AS avg_price, 
        COUNT(*) OVER (PARTITION BY Neighbourhood) AS number_of_airbnb
    FROM 
          Air_Bnb
)
SELECT DISTINCT 
    Neighbourhood, 
    ROUND(avg_price, 2) AS rounded_avg_price, 
    number_of_airbnb
FROM 
    NeighbourhoodData
ORDER BY 
    rounded_avg_price DESC, 
    number_of_airbnb
OFFSET 0 ROWS
FETCH NEXT 10 ROWS ONLY;

--------------------------------------------------------------------------------------------------
-- Number of Room Types available

SELECT 
    [Room Type], 
    COUNT([Room Type]) AS number_of_airbnb
FROM 
      Air_Bnb
GROUP BY 
    [Room Type]
ORDER BY 
    [Room Type] DESC;

--------------------------------------------------------------------------------------------------
-- Average price and number of Airbnb available per room type

SELECT DISTINCT 
    [Room Type], 
    AVG(Price) OVER (PARTITION BY [Room Type]) AS avg_price,
    COUNT(id) OVER (PARTITION BY [Room Type]) AS number_of_airbnb
FROM 
      Air_Bnb
GROUP BY 
    Price, [Room Type], id
ORDER BY 
    avg_price DESC, number_of_airbnb;

--------------------------------------------------------------------------------------------------
-- Average price per room type in each neighbourhood group

SELECT DISTINCT 
    [Neighbourhood Group], 
    [Room Type], 
    AVG(Price) AS avg_price
FROM 
      Air_Bnb
GROUP BY 
    [Room Type], [Neighbourhood Group]
ORDER BY 
    [Neighbourhood Group], [Room Type];

--------------------------------------------------------------------------------------------------
-- Availability throughout the year

SELECT DISTINCT 
    [Neighbourhood Group], 
    AVG([Availability 365]) AS availability
FROM 
      Air_Bnb
GROUP BY 
    [Neighbourhood Group];
