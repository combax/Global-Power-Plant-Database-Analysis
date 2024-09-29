-- Creating database
CREATE DATABASE power_plant;

-- Using database
USE power_plant;

-- Creating TABLE
CREATE TABLE energy (
    country TEXT NOT NULL,  -- 3 character ISO 3166-1 alpha-3 country code
    country_long TEXT NOT NULL,  -- longer form of country designation
    name TEXT NOT NULL,  -- name of the power plant
    gppd_idnr TEXT NOT NULL,  -- 10 or 12 character identifier for the power plant
    capacity_mw FLOAT,  -- electrical generating capacity in megawatts
    latitude DECIMAL(10,7),  -- geolocation (latitude) in decimal degrees (WGS84)
    longitude DECIMAL(10,7),  -- geolocation (longitude) in decimal degrees (WGS84)
    primary_fuel TEXT,  -- energy source for primary electricity generation
    other_fuel1 TEXT,  -- secondary energy source
    other_fuel2 TEXT,  -- tertiary energy source
    other_fuel3 TEXT,  -- quaternary energy source
    commissioning_year INT,  -- year of plant operation
    owner VARCHAR(256),  -- majority shareholder of the plant
    source VARCHAR(128),  -- entity reporting the data
    url TEXT,  -- web document related to the source
    geolocation_source TEXT,  -- attribution for geolocation information
    wepp_id VARCHAR(64),  -- reference to unique plant identifier in PLATTS-WEPP
    year_of_capacity_data INT,  -- year the capacity information was reported
    generation_gwh_2013 FLOAT,  -- generation data for 2013
    generation_gwh_2014 FLOAT,  -- generation data for 2014
    generation_gwh_2015 FLOAT,  -- generation data for 2015
    generation_gwh_2016 FLOAT,  -- generation data for 2016
    generation_gwh_2017 FLOAT,  -- generation data for 2017
    generation_gwh_2018 FLOAT,  -- generation data for 2018
    generation_gwh_2019 FLOAT,  -- generation data for 2019
    generation_data_source TEXT,  -- source for the reported generation information
    estimated_generation_gwh_2013 FLOAT,  -- estimated generation data for 2013
    estimated_generation_gwh_2014 FLOAT,  -- estimated generation data for 2014
    estimated_generation_gwh_2015 FLOAT,  -- estimated generation data for 2015
    estimated_generation_gwh_2016 FLOAT,  -- estimated generation data for 2016
    estimated_generation_gwh_2017 FLOAT,  -- estimated generation data for 2017
    estimated_generation_note_2013 TEXT,  -- model/method label for 2013 estimated generation
    estimated_generation_note_2014 TEXT,  -- model/method label for 2014 estimated generation
    estimated_generation_note_2015 TEXT,  -- model/method label for 2015 estimated generation
    estimated_generation_note_2016 TEXT,  -- model/method label for 2016 estimated generation
    estimated_generation_note_2017 TEXT  -- model/method label for 2017 estimated generation
);

-- Importing CSV file
-- Load the data
LOAD DATA INFILE "E:/work/datasets/PowerPlant database/global_power_plant_database.csv"
INTO TABLE energy
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    country, country_long, name, gppd_idnr, 
    @capacity_mw, @latitude, @longitude,
    primary_fuel, other_fuel1, other_fuel2, other_fuel3,
    @commissioning_year, owner, source, url, geolocation_source,
    @wepp_id, @year_of_capacity_data,
    @generation_gwh_2013, @generation_gwh_2014, @generation_gwh_2015,
    @generation_gwh_2016, @generation_gwh_2017, @generation_gwh_2018,
    @generation_gwh_2019, generation_data_source,
    @estimated_generation_gwh_2013, @estimated_generation_gwh_2014,
    @estimated_generation_gwh_2015, @estimated_generation_gwh_2016,
    @estimated_generation_gwh_2017,
    estimated_generation_note_2013, estimated_generation_note_2014,
    estimated_generation_note_2015, estimated_generation_note_2016,
    estimated_generation_note_2017
)
SET
    capacity_mw = NULLIF(@capacity_mw, ''),
    latitude = NULLIF(@latitude, ''),
    longitude = NULLIF(@longitude, ''),
    commissioning_year = NULLIF(@commissioning_year, ''),
    wepp_id = NULLIF(@wepp_id, ''),
    year_of_capacity_data = NULLIF(@year_of_capacity_data, ''),
    generation_gwh_2013 = NULLIF(@generation_gwh_2013, ''),
    generation_gwh_2014 = NULLIF(@generation_gwh_2014, ''),
    generation_gwh_2015 = NULLIF(@generation_gwh_2015, ''),
    generation_gwh_2016 = NULLIF(@generation_gwh_2016, ''),
    generation_gwh_2017 = NULLIF(@generation_gwh_2017, ''),
    generation_gwh_2018 = NULLIF(@generation_gwh_2018, ''),
    generation_gwh_2019 = NULLIF(@generation_gwh_2019, ''),
    estimated_generation_gwh_2013 = NULLIF(@estimated_generation_gwh_2013, ''),
    estimated_generation_gwh_2014 = NULLIF(@estimated_generation_gwh_2014, ''),
    estimated_generation_gwh_2015 = NULLIF(@estimated_generation_gwh_2015, ''),
    estimated_generation_gwh_2016 = NULLIF(@estimated_generation_gwh_2016, ''),
    estimated_generation_gwh_2017 = NULLIF(@estimated_generation_gwh_2017, '');


-- testing which columns have NULL values
SELECT 'country' AS column_name FROM energy WHERE country IS NULL
UNION
SELECT 'country_long' AS column_name FROM energy WHERE country_long IS NULL
UNION
SELECT 'name' AS column_name FROM energy WHERE name IS NULL
UNION
SELECT 'gppd_idnr' AS column_name FROM energy WHERE gppd_idnr IS NULL
UNION
SELECT 'capacity_mw' AS column_name FROM energy WHERE capacity_mw IS NULL
UNION
SELECT 'latitude' AS column_name FROM energy WHERE latitude IS NULL
UNION
SELECT 'longitude' AS column_name FROM energy WHERE longitude IS NULL
UNION
SELECT 'primary_fuel' AS column_name FROM energy WHERE primary_fuel IS NULL
UNION
SELECT 'other_fuel1' AS column_name FROM energy WHERE other_fuel1 IS NULL
UNION
SELECT 'other_fuel2' AS column_name FROM energy WHERE other_fuel2 IS NULL
UNION
SELECT 'other_fuel3' AS column_name FROM energy WHERE other_fuel3 IS NULL
UNION
SELECT 'commissioning_year' AS column_name FROM energy WHERE commissioning_year IS NULL
UNION
SELECT 'owner' AS column_name FROM energy WHERE owner IS NULL
UNION
SELECT 'source' AS column_name FROM energy WHERE source IS NULL
UNION
SELECT 'url' AS column_name FROM energy WHERE url IS NULL
UNION
SELECT 'geolocation_source' AS column_name FROM energy WHERE geolocation_source IS NULL
UNION
SELECT 'wepp_id' AS column_name FROM energy WHERE wepp_id IS NULL
UNION
SELECT 'year_of_capacity_data' AS column_name FROM energy WHERE year_of_capacity_data IS NULL
UNION
SELECT 'generation_gwh_2013' AS column_name FROM energy WHERE generation_gwh_2013 IS NULL
UNION
SELECT 'generation_gwh_2014' AS column_name FROM energy WHERE generation_gwh_2014 IS NULL
UNION
SELECT 'generation_gwh_2015' AS column_name FROM energy WHERE generation_gwh_2015 IS NULL
UNION
SELECT 'generation_gwh_2016' AS column_name FROM energy WHERE generation_gwh_2016 IS NULL
UNION
SELECT 'generation_gwh_2017' AS column_name FROM energy WHERE generation_gwh_2017 IS NULL
UNION
SELECT 'generation_gwh_2018' AS column_name FROM energy WHERE generation_gwh_2018 IS NULL
UNION
SELECT 'generation_gwh_2019' AS column_name FROM energy WHERE generation_gwh_2019 IS NULL
UNION
SELECT 'generation_data_source' AS column_name FROM energy WHERE generation_data_source IS NULL
UNION
SELECT 'estimated_generation_gwh_2013' AS column_name FROM energy WHERE estimated_generation_gwh_2013 IS NULL
UNION
SELECT 'estimated_generation_gwh_2014' AS column_name FROM energy WHERE estimated_generation_gwh_2014 IS NULL
UNION
SELECT 'estimated_generation_gwh_2015' AS column_name FROM energy WHERE estimated_generation_gwh_2015 IS NULL
UNION
SELECT 'estimated_generation_gwh_2016' AS column_name FROM energy WHERE estimated_generation_gwh_2016 IS NULL
UNION
SELECT 'estimated_generation_gwh_2017' AS column_name FROM energy WHERE estimated_generation_gwh_2017 IS NULL
UNION
SELECT 'estimated_generation_note_2013' AS column_name FROM energy WHERE estimated_generation_note_2013 IS NULL
UNION
SELECT 'estimated_generation_note_2014' AS column_name FROM energy WHERE estimated_generation_note_2014 IS NULL
UNION
SELECT 'estimated_generation_note_2015' AS column_name FROM energy WHERE estimated_generation_note_2015 IS NULL
UNION
SELECT 'estimated_generation_note_2016' AS column_name FROM energy WHERE estimated_generation_note_2016 IS NULL
UNION
SELECT 'estimated_generation_note_2017' AS column_name FROM energy WHERE estimated_generation_note_2017 IS NULL;

-- Making other columns not null
ALTER TABLE energy
MODIFY country TEXT NOT NULL,
MODIFY country_long TEXT NOT NULL,
MODIFY name TEXT NOT NULL,
MODIFY gppd_idnr TEXT NOT NULL,
MODIFY capacity_mw FLOAT NOT NULL,
MODIFY latitude DECIMAL(10,7) NOT NULL,
MODIFY longitude DECIMAL(10,7) NOT NULL,
MODIFY primary_fuel TEXT NOT NULL,
MODIFY other_fuel1 TEXT NOT NULL,
MODIFY other_fuel2 TEXT NOT NULL,
MODIFY other_fuel3 TEXT NOT NULL,
MODIFY owner VARCHAR(256) NOT NULL,
MODIFY source VARCHAR(128) NOT NULL,
MODIFY url TEXT NOT NULL,
MODIFY geolocation_source TEXT NOT NULL;

--------------------------------------------------------------------------------

-- Problem: 1 Greenest Country

SELECT COUNT(*) -- Entire empty rows Generated
FROM energy
WHERE generation_gwh_2013 IS NULL
AND generation_gwh_2014 IS NULL
AND generation_gwh_2015 IS NULL
AND generation_gwh_2016 IS NULL
AND generation_gwh_2017 IS NULL
AND generation_gwh_2018 IS NULL
AND generation_gwh_2019 IS NULL; -- 23546

SELECT COUNT(*) --total rows
FROM energy; -- 34936

-- 67.3975% 

SELECT COUNT(*) -- Entire empty rows Estimated
FROM energy
WHERE estimated_generation_gwh_2013 IS NULL
AND estimated_generation_gwh_2014 IS NULL
AND estimated_generation_gwh_2015 IS NULL
AND estimated_generation_gwh_2016 IS NULL
AND estimated_generation_gwh_2017 IS NULL; -- 1798

-- 5.417%

SELECT -- Empty rows in each column
    'estimated_generation_gwh_2013' AS column_name, 
    COUNT(*) AS null_count
FROM energy
WHERE estimated_generation_gwh_2013 IS NULL --18816
UNION
SELECT 
    'estimated_generation_gwh_2014' AS column_name,  -- 18433
    COUNT(*) AS null_count
FROM energy
WHERE estimated_generation_gwh_2014 IS NULL
UNION
SELECT 
    'estimated_generation_gwh_2015' AS column_name,  -- 17886
    COUNT(*) AS null_count
FROM energy
WHERE estimated_generation_gwh_2015 IS NULL
UNION
SELECT 
    'estimated_generation_gwh_2016' AS column_name, -- 17366
    COUNT(*) AS null_count
FROM energy
WHERE estimated_generation_gwh_2016 IS NULL
UNION
SELECT 
    'estimated_generation_gwh_2017' AS column_name,  -- 1798
    COUNT(*) AS null_count
FROM energy
WHERE estimated_generation_gwh_2017 IS NULL
ORDER BY null_count DESC;

-- So we see number of estimates going up and empty rows going down

SELECT COUNT(*) -- capacity column
FROM energy
WHERE capacity_mw IS NULL; -- 0

SELECT DISTINCT primary_fuel -- distinct fuel types
FROM energy;

SELECT  -- support of other fuels
    primary_fuel,
    COUNT(DISTINCT other_fuel1) AS count_other_fuel1,
    COUNT(DISTINCT other_fuel2) AS count_other_fuel2,
    COUNT(DISTINCT other_fuel3) AS count_other_fuel3
FROM energy
GROUP BY primary_fuel; -- at max 11


SELECT DISTINCT other_fuel1 AS fuel_type -- cogeneration means combine 2
FROM energy
WHERE primary_fuel = "Cogeneration" AND other_fuel1 IS NOT NULL

UNION

SELECT DISTINCT other_fuel2 AS fuel_type
FROM energy
WHERE primary_fuel = "Cogeneration" AND other_fuel2 IS NOT NULL

UNION

SELECT DISTINCT other_fuel3 AS fuel_type
FROM energy
WHERE primary_fuel = "Cogeneration" AND other_fuel3 IS NOT NULL; -- Gas + Oil + Other


SELECT DISTINCT other_fuel1 AS fuel_type -- If to put other in Renewabe or Non
FROM energy
WHERE primary_fuel = "Other" AND other_fuel1 IS NOT NULL

UNION

SELECT DISTINCT other_fuel2 AS fuel_type
FROM energy
WHERE primary_fuel = "Other" AND other_fuel2 IS NOT NULL

UNION

SELECT DISTINCT other_fuel3 AS fuel_type
FROM energy
WHERE primary_fuel = "Other" AND other_fuel3 IS NOT NULL; -- Gas + Oil + Coal + Biomass


CREATE TABLE country_capacity_balance AS -- Greneest country table
SELECT 
    country_long,
    
    -- Subtract Renewable from Non-Renewable
    SUM(CASE 
        WHEN primary_fuel NOT IN ('Hydro', 'Solar', 'Wind', 'Nuclear', 'Waste', 'Biomass', 'Wave and Tidal', 'Geothermal', 'Storage') 
        THEN capacity_mw 
        ELSE 0 
    END)
    -
    SUM(CASE 
        WHEN primary_fuel IN ('Hydro', 'Solar', 'Wind', 'Nuclear', 'Waste', 'Biomass', 'Wave and Tidal', 'Geothermal', 'Storage') 
        THEN capacity_mw 
        ELSE 0 
    END) AS CapacityDifference
FROM energy
GROUP BY country_long
ORDER BY CapacityDifference DESC;

------------------------------------------------------------

-- problem-2 most efficient fuel

CREATE TABLE fuel_efficiency AS
SELECT
    primary_fuel,
    SUM(capacity_mw) AS total_capacity,
    COUNT(*) AS plant_count,
    SUM(capacity_mw) / COUNT(*) AS fuel_efficiency
FROM energy
GROUP BY primary_fuel
ORDER BY fuel_efficiency DESC;

----------------------------------------------------------

-- problem-3 missing data

-- taking missing data for each year

CREATE TABLE missing_data_2013 AS
SELECT 
    2013 AS year,
    primary_fuel,
    COUNT(*) AS missing_count
FROM energy
WHERE generation_gwh_2013 IS NULL
GROUP BY primary_fuel;

CREATE TABLE missing_data_2014 AS
SELECT 
    2014 AS year,
    primary_fuel,
    COUNT(*) AS missing_count
FROM energy
WHERE generation_gwh_2014 IS NULL
GROUP BY primary_fuel;


CREATE TABLE missing_data_2015 AS
SELECT 
    2015 AS year,
    primary_fuel,
    COUNT(*) AS missing_count
FROM energy
WHERE generation_gwh_2015 IS NULL
GROUP BY primary_fuel;


CREATE TABLE missing_data_2016 AS
SELECT 
    2016 AS year,
    primary_fuel,
    COUNT(*) AS missing_count
FROM energy
WHERE generation_gwh_2016 IS NULL
GROUP BY primary_fuel;


CREATE TABLE missing_data_2017 AS
SELECT 
    2017 AS year,
    primary_fuel,
    COUNT(*) AS missing_count
FROM energy
WHERE generation_gwh_2017 IS NULL
GROUP BY primary_fuel;


CREATE TABLE missing_data_2018 AS
SELECT 
    2018 AS year,
    primary_fuel,
    COUNT(*) AS missing_count
FROM energy
WHERE generation_gwh_2018 IS NULL
GROUP BY primary_fuel;


CREATE TABLE missing_data_2019 AS
SELECT 
    2019 AS year,
    primary_fuel,
    COUNT(*) AS missing_count
FROM energy
WHERE generation_gwh_2019 IS NULL
GROUP BY primary_fuel;
