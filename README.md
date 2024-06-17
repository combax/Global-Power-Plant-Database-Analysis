<div align="center">
  <center><h1>EDA of Global Power Plants Database using Mircosoft PowerBI</h1></center>
</div>

<p align="center"><img src="/Images/powerBi.png" alt="Icon Description" width="100"></p>

## Dataset

**Global Power Plant Database** is a comprehensive, global, open source data base of power plants available [here](https://datasets.wri.org/dataset/globalpowerplantdatabase).

Data covers **167 countries** and includes **thermal plants** for example coal, gas, oil, nuclear, biomass, waste and geothermal, **renewables** like solar, hydro, and wind. Geolocation of each power plant, generation, capacity, ownership, and fuel types along with secondary, and tertiary fuel types are also provided.

It was updated last on **June 24, 2021**.

---

<div align="center">
 <h2>Which country is the greenest?
    <p align="center">
        <img src="/Images/leaf.png" alt="Icon Description" width="50">
    </p>
</div>

- Calculation of difference between energy produced by Renewable Sources to Non Renewable sources by all plants of the country is the determining factor here.

- But all **energy generation** columns have **67%** and all **estimated generation** column have **5.14%** empty rows. So we use **capacity** column which has **0 empty rows**.

- By using the capacity column we can see if the country has potential of producing more green energy.

- First we calculate *RenewableCapacity* and *Non-RenewableCapcity* in **PowerBI Dax** using:

```
RenewableCapacity = CALCULATE(SUM('global_power_plant_database'[capacity_mw]), 'global_power_plant_database'[EnergySourceCategory] = "Renewable")
```

```
Non-RenewableCapacity = CALCULATE(SUM('global_power_plant_database'[capacity_mw]), 'global_power_plant_database'[EnergySourceCategory] = "Non-Renewable")
```

- And *CapacityDifference* using:

```
CapacityDifference = [RenewableCapacity] - [Non-RenewableCapacity]
```

- Despite being the largest power producers, **USA & China rely heavily on non-renewable fuels.**

- Creating **Pivot Table** of top 25 countries which have **largest energy production capacity**:

```
Top 25 Countries by Capacity = 
TOPN(
    25,
    SUMMARIZE(
        'global_power_plant_database',
        'global_power_plant_database'[country_long],
        "Total Capacity MW", CALCULATE(SUM('global_power_plant_database'[capacity_mw]))
    ),
    [Total Capacity MW], DESC
)

```

Finally we have this beautiful visual to represent it:

![Green Countries](/Images/Green.png)

---

<div align="center">
 <h2>Which is the most efficient fuel throughtout the years?
    <p align="center">
        <img src="/Images/fuel.png" alt="Fuel icon" width="50">
    </p>
</div>

- Here we calculate efficiency of each fuel type with help of capacity column of the plants using that fuel as primary source of power generation.

- **Efficiency of a fuel type** = \( \frac{\text{Addiction of capacities of all Power Plants using that fuel}}{\text{Total number of Plants using that fuel}} \)

- Efficiency \% = \(\frac{\text{Efficiency of a fuel type}}{100}\)


```
Efficiency = 
(CALCULATE(
    SUM('global_power_plant_database'[capacity_mw]),
    ALLEXCEPT('global_power_plant_database', 'global_power_plant_database'[primary_fuel])
) / COUNT('global_power_plant_database'[gppd_idnr])) / 100
```

- **Nuclear** is the **most efficient** followed by Coal, Gas, Petcoke, etc. and **Solar, Waste, and Storage** are the **least efficient** fuels.
 
Visual:

![Efficiency](/Images/Efficient.png)

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

Formula used to calculate missing data% division for a year:

```
MissingData2013 = 
COUNTROWS (
    FILTER (
        'global_power_plant_database',
        'global_power_plant_database'[generation_gwh_2013] <> BLANK ()
            && (
                'global_power_plant_database'[primary_fuel] = "Biomass"
                || 'global_power_plant_database'[primary_fuel] = "Coal"
                || 'global_power_plant_database'[primary_fuel] = "Cogeneration"
                || 'global_power_plant_database'[primary_fuel] = "Gas"
                || 'global_power_plant_database'[primary_fuel] = "Geothermal"
                || 'global_power_plant_database'[primary_fuel] = "Hydro"
                || 'global_power_plant_database'[primary_fuel] = "Nuclear"
                || 'global_power_plant_database'[primary_fuel] = "Oil"
                || 'global_power_plant_database'[primary_fuel] = "Petcoke"
                || 'global_power_plant_database'[primary_fuel] = "Solar"
                || 'global_power_plant_database'[primary_fuel] = "Storage"
                || 'global_power_plant_database'[primary_fuel] = "Waste"
                || 'global_power_plant_database'[primary_fuel] = "Wave and Tidal"
                || 'global_power_plant_database'[primary_fuel] = "Wind"
            )
    )
)
```

Visual:

![Missing](/Images/missing.png)

---

## Final Dashboard in PowerBI

![Final](/Images/Global_powerplants-1.png)

---

## Conclusion

- From this analysis we see that despite recent advances and construction of new renewable power plants, **most countries** still heavily rely on **non-renewable sources**.

- Shocking amount of **missing data** from most notable **renewable sources** of energy set off an alarm, and may indicate that they are underreported because they don't compare the massive amounts produced by non-renewable sources.

- It is known that **construction of Solar, Hydro, and Wind plant** is very difficult and **nature dependent**.

- Perhaps if data was available more readily we together would see **issues with renewable power plants** and put our efforts towards **solving them.**

---

All the files including the main PowerBI file (**Global_powerplants.pbix**) and included here. Images and icons are in Images folder.
