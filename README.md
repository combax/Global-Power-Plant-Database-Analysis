<div align="center">
  <center><h1>Global Power Plants Database EDA</h1></center>
</div>

This project:
- Uses ***MySQL to explore and calculate different metrics*** from dataset.
- Plot Important metrics in ***PowerBI after connecting it to MySQL server.***

All the files including the main PowerBI file (**Global_powerplants.pbix**) and main SQL file(**SQL_queries.sql**) are here. Images are in the Images folder.

---

## Dataset

**Global Power Plant Database** is a comprehensive, global, open source data base of power plants available [here](https://datasets.wri.org/dataset/globalpowerplantdatabase).

Data covers **167 countries** and includes **thermal plants** for example coal, gas, oil, nuclear, biomass, waste and geothermal, **renewables** like solar, hydro, and wind. Geolocation of each power plant, generation, capacity, ownership, and fuel types along with secondary, and tertiary fuel types are also provided.

It was updated last on **June 24, 2021**.

- Database creation query:
```sql

-- Creating database
CREATE DATABASE power_plant;

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

```

---

<div align="center">
 <h2>Which country is the greenest?
    <p align="center">
        <img src="/Images/leaf.png" alt="leaf" width="50">
    </p>
</div>

- Calculation of difference between energy produced by Renewable Sources to Non Renewable sources by all plants of the country is the determining factor here.

- But all **energy generation** columns have **67%** and all **estimated generation** column have **5.14%** empty rows. So we use **capacity** column which has **0 empty rows**:

```sql
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
```
- We also tested how many individual empty columns do all **estimated_generation** columns have:
    - This showed reduction in total number of missing rows over the years **reducing.**

- Also finding if Cogeneration(Using combination of fuels) and Other fuels come under Non-Renewable via their other_fuel1, other_fuel2, and other_fuel3.

- We subtract **capacity_mw** for Renewable to Non-Renewable resources for each country:

```sql
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
```

- Despite being the largest power producers, **USA & China rely heavily on non-renewable fuels.**


Finally we have this beautiful visual to represent it:

![Green Countries](/Images/Green.png)

---

<div align="center">
 <h2>Which is the most efficient fuel throughtout the years?
    <p align="center">
        <img src="/Images/Fuel.png" alt="Fuel icon" width="50">
    </p>
</div>

- Here we calculate efficiency of each fuel type with help of capacity column of the plants using that fuel as primary source of power generation.

- **Efficiency of a fuel type** = \( \frac{\text{Addiction of capacities of all Power Plants using that fuel}}{\text{Total number of Plants using that fuel}} \)

```sql
CREATE TABLE fuel_efficiency AS
SELECT
    primary_fuel,
    SUM(capacity_mw) AS total_capacity,
    COUNT(*) AS plant_count,
    SUM(capacity_mw) / COUNT(*) AS fuel_efficiency
FROM energy
GROUP BY primary_fuel
ORDER BY fuel_efficiency DESC;
```

- **Nuclear** is the **most efficient** followed by Coal, Gas, Petcoke, etc. and **Solar, Waste, and Storage** are the **least efficient** fuels.
 
Visual:

![Efficiency](/Images/Efficient1.png)

---

<div align="center">
 <h2>Where's the data!?
    <p align="center">
        <img src="/Images/miss.png" alt="Miss icon" width="50">
    </p>
</div>

- While exploring data we earlier noticed that **67%** data is missing from generation columns, which is very concerning.

- **Gas** has almost quarter of its data missing every year from 2014 to 2019, which adds up to **24.44%** on average. Gas is also **most used non-renewable source** of energy in the data.

- Another concerning thing is increasing number of missing data as years progress from major renewable sources of energy like Solar, Hydro, and Wind.

- **Solar** has 9.89%, 12,99%, 15.29%, 19.93%, 24.24%, 28.33%, and 33.8% missing data in 2013, 2014, 2015, 2016, 2017, 2018, and 2019 respectively.

- **Hydro** has 22.6%, 22.39%, 21.55%, 21.38%, 18.73%, 17.18%, and 14.71% missing data in 2013, 2014, 2015, 2016, 2017, 2018, and 2019 respectively.

- **Wind** has 12.62%, 11.88%, 11.41%, 11.17%, 11.27% 11.64%, and 11.77% missing data in 2013, 2014, 2015, 2016, 2017, 2018, and 2019 respectively.

- Having **tremendous amounts of missing data from almost all major non-renewable sources** is certainly something odd.

Formula used to calculate missing data% division for a year, which is repeated for every year:

```sql
CREATE TABLE missing_data_2013 AS
SELECT 
    2013 AS year,
    primary_fuel,
    COUNT(*) AS missing_count
FROM energy
WHERE generation_gwh_2013 IS NULL
GROUP BY primary_fuel;
```

Visual:

![Missing](/Images/missing1.png)

---

## Final Dashboard in PowerBI

![Final](/Images/final_dashboard.png)

---

## Conclusion

- From this analysis we see that despite recent advances and construction of new renewable power plants, **most countries** still heavily rely on **non-renewable sources**.

- Shocking amount of **missing data** from most notable **renewable sources** of energy set off an alarm, and may indicate that they are underreported because they don't compare the massive amounts produced by non-renewable sources.

- It is known that **construction of Solar, Hydro, and Wind plant** is very difficult and **nature dependent**.

- Perhaps if data was available more readily we together would see **issues with renewable power plants** and put our efforts towards **solving them.**

---

#### Why not publish PowerBI file?

- PowerBI doesn't let you publish a file without logging in with a business account.
- And Microsoft no longer let's you sign into their developer program to get a business e-mail.
- In future if I purchase PowerBI subscription, I will make sure to provide a link at top for the dashboard.
