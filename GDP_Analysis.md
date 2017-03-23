Introduction
------------

#### This report analyzes Gross Domestic Product (GDP) based on GDP value ranking obtained from the World Bank (1) and income group classification obtained from the World Bank EdStats All Indicator Query (2). Gross domestic product is primary way to measure a country’s economy and is determined by the total value of everything produced in the country. The “size” of the economy is a direct reference to the GDP (3). This analysis will address questions about the various countries’ economy for year 2012. The subsets of the GDP data used for this report for the GPD ranking and income group data can be downloaded, respectively, from the following links:

<https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv>
<https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv>

#### The “country shortcode” was loosely given to not only countries but also regions or territories for both sets of data. For example, Puerto Rico is a territory but it was found im both data sets. If using all “country shortcodes” then 224 had IDs that matched. If we are only looking at countries with rank, then 189 IDs matched since South Sadan had ranking but no income group classification.

    ## [1] 224

    ## [1] 189

#### The 13th country in the reuslting data frame was St. Kitts and Nevis.

    ## [1] "St. Kitts and Nevis"

#### Question 3: The average GDP rankings for the "High income: OECD" and "High income: nonOECD" groups were 33 and 92, respectively.

    ## [1] 32.96667

    ## [1] 91.91304

#### Question 4: Show the distribution of GDP value for all the countries and color plots by income group.

![](Analysis/GPDdistribution.jpegunnamed-chunk-6-1.png)

#### Question 5:The summary statistics of GDP by income groups are givin below.

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##     596    3814    7843   14410   17200  116400

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##      40    2549   24270  256700   81450 8227000

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##     228    9613   42940  231800  205800 2253000

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    2584   12840   28370  104300  131200  711000

    ##     Min.  1st Qu.   Median     Mean  3rd Qu.     Max. 
    ##    13580   211100   486500  1484000  1480000 16240000

#### Guestion 6. The GDP ranking was cut into 5 separate quantile groups and placed in a table versus income group. From the table, it was determined that the 5 countries from the lower middle income group were among the 38 nations with highest GDP.

    ##              
    ## RankQuantile  High income: nonOECD High income: OECD Low income
    ##   (1,38.6]                       4                17          0
    ##   (38.6,76.2]                    5                10          1
    ##   (76.2,114]                     8                 1          9
    ##   (114,152]                      4                 1         16
    ##   (152,190]                      2                 0         11
    ##              
    ## RankQuantile  Lower middle income Upper middle income
    ##   (1,38.6]                      5                  11
    ##   (38.6,76.2]                  13                   9
    ##   (76.2,114]                   11                   8
    ##   (114,152]                     9                   8
    ##   (152,190]                    16                   9

Conclusion
----------

#### References

#### (1)<http://data.worldbank.org/data-catalog/GDP-ranking-table>

#### (2)<http://data.worldbank.org/data-catalog/ed-stats>

#### (3)<https://www.thebalance.com/what-is-gdp-definition-of-gross-domestic-product-3306038>
