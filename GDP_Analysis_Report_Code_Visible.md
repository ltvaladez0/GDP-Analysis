Introduction
------------

#### This report analyzes Gross Domestic Product (GDP) based on GDP value ranking obtained from the World Bank (1) and income group classification obtained from the World Bank EdStats All Indicator Query (2). Gross domestic product is primary way to measure a country’s economy and is determined by the total value of everything produced in the country. The “size” of the economy is a direct reference to the GDP (3). This analysis will address questions about the various countries’ economy for year 2012. The subsets of the GDP data used for this report for the GPD ranking and income group data can be downloaded, respectively, from the following links:

<https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv>
<https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv>

    knitr::opts_chunk$set(fig.width=12, fig.height=8, fig.path='Analysis/GDPdistribution',
                          echo=TRUE, warning=FALSE, message=TRUE)

    source("./mainHelper.R")

    ## Installing package into 'C:/Users/tish/Documents/R/win-library/3.3'
    ## (as 'lib' is unspecified)

    ## package 'downloader' successfully unpacked and MD5 sums checked
    ## 
    ## The downloaded binary packages are in
    ##  C:\Users\tish\AppData\Local\Temp\RtmpMpsUu7\downloaded_packages

    ## Installing package into 'C:/Users/tish/Documents/R/win-library/3.3'
    ## (as 'lib' is unspecified)

    ## package 'ggplot2' successfully unpacked and MD5 sums checked
    ## 
    ## The downloaded binary packages are in
    ##  C:\Users\tish\AppData\Local\Temp\RtmpMpsUu7\downloaded_packages

GDP Ranking Data
----------------

#### The GDP ranking file only includes rankings for those economies with confirmed GDP estimates. It has four columns of data with no header for the first column and "Ranking", "Economy", and "(millions of US dollars)" for the other columns. The headers are redefined in the code after reading the files into environment to "CountryCode", "Ranking", "Country", and "GDPvalue". The first four rows are deleted since they mainly empty except for the comment “Gross domestic product 2012” in one data cell. There is an empty column in between the other columns that is removed. The ranking data are converted to an integer data type for analysis. For the “GDPvalue” variable, the commas are removed and converted to an integer data type.

#### Data description –

#### 1. CountryCode – 3-digit country code

#### 2. Ranking – Ranks countries with confirmed GDP

#### 3. Country (Economy) – Name of country but sometimes not complete proper long name of country.

#### 4. GDPvalue((millions of US dollars)) – Monetary GPD value in US dollars in millions.

#### • Problems with the data –

#### 1. The data set contains countries or regions with no ranking but GDP values.

#### 2. Country codes are giving to regions or other types of classifications that are not countries.

Income Group Data
-----------------

#### The income group data has several columns of data but only the first three columns are relevant and retained for data analysis. The headers for these three columns "CountryCode", "Long.Name" and "Income.Group". Later during the analysis the “Long.Name" variable is change to “Country” after comparing the numbers of “CountryCodes”.

#### Data description –

#### 1. CountryCode – 3-digit country code

#### 2. Long.Name – Provides complete name of countries.

#### 3. Income.Group Name of country but sometimes not complete proper long name of country.

#### • Problems with the data –

#### 1. Country codes are giving to regions or other types of classifications that are not countries.

Merged Data
-----------

#### Both data sets are merged together by country code. The merged data set is exported into Analysis directory for viewing as "MergedData1.csv".

    source("./cleanMergeData.R")

1. Matched IDs for Country Code
-------------------------------

#### The “country shortcode” was loosely given to not only countries but also regions or territories for both sets of data. For example, Puerto Rico is a territory but it was found in both data sets. If using all “country shortcodes” then 224 had IDs that matched. If we are only looking at countries with rank, then 189 IDs matched since South Sudan had ranking but no income group classification.

#### The number 224 is obtained for the first matched IDs analysis because all “CountryCode” entries are compared. The matched IDs are determined by finding the total missing values for the variable "Country" from the GDP rank data and for the variable "Long.Name" from the income group data. This total is then subtracted from the 238 entries containing a “CountryCode”.

#### It makes more sense to compare entries that had ranked because these economies had confirmed GDP estimates. This second match IDs analysis gives 189 matched IDs. For the analysis, the countries having no rank are removed followed by the removal of any country with no “Long.Name” entry. The remaining countries give the final match ID count. The modified data set is named “mergedGDP\_EdStatsRank”.

#### Following the match IDs comparison, the country column deriving from the original GDP ranking data is removed and the “Long.Name” header is replaced by “Country”. Then a long name is provided for South Sudan.

#### Finally, this modified data set is exported as “AnalysisOfMatchedID.csv” into Analysis directory for viewing.

    matchID=nrow(mergedGDP_EdStats)-sum(is.na(mergedGDP_EdStats$Country))-sum(is.na(mergedGDP_EdStats$Long.Name))
    matchID

    ## [1] 224

    mergedGDP_EdStatsRank<- subset(mergedGDP_EdStats, !is.na(Ranking))
    RankMatchID=sum(!is.na(mergedGDP_EdStatsRank$Long.Name))
    RankMatchID

    ## [1] 189

    missingName<-which(is.na(mergedGDP_EdStatsRank$Long.Name))
    missingName<-mergedGDP_EdStatsRank[155,5]  
    mergedGDP_EdStatsRank[155,2] <-  mergedGDP_EdStatsRank[155,5]
    mergedGDP_EdStatsRank<-mergedGDP_EdStatsRank[-5]
    colnames(mergedGDP_EdStatsRank)[2] <- "Country"
    write.csv(mergedGDP_EdStatsRank, "Analysis/AnalysisOfMatchedID.csv")

2.Thirteenth Country
--------------------

#### After ranking the countries in descending order, St. Kitts and Nevis is ranked as the 13th country.

#### The merged data set from the analysis of matched IDs is ordered by descending rank and renamed “DataDecendingRank”. From this data set the 13th entry is found. The data set is then exported as to the "AnalysisOfDecendingRank.csv" for viewing.

    DataDecendingRank<-mergedGDP_EdStatsRank[order(-mergedGDP_EdStatsRank$Ranking),]
    ThirteenthCountry=DataDecendingRank[13,2]
    ThirteenthCountry

    ## [1] "St. Kitts and Nevis"

    write.csv(DataDecendingRank, "Analysis/DataDecendingRank.csv")

3. Average GDP rankings for High income: OECD vs. High income: nonOECD
----------------------------------------------------------------------

#### The average GDP rankings for the "High income: OECD" and "High income: nonOECD" groups are 33 and 92, respectively. OECD stands for the Organization for Economic Co-operation and Development. It is an organization that promotes economic growth, prosperity, and sustainable development. Economies that are part of the organization have higher average ranking than economies that are not members. It appears the organization is beneficial in boosting the economy for their members.

#### To obtain this information the respective groups are extracted from the “DataDecendingRank” data. Then the mean of the rank is determined from each group.

    HighIncomeOECD <- DataDecendingRank[which(DataDecendingRank$Income.Group == "High income: OECD"),]
    mean(HighIncomeOECD$Ranking)

    ## [1] 32.96667

    HighIncomeNonOECD<- DataDecendingRank[which(DataDecendingRank$Income.Group == "High income: nonOECD"),]
    mean(HighIncomeNonOECD$Ranking)

    ## [1] 91.91304

4. GDP Distribution
-------------------

#### A plot showing the distribution GDP value for all the countries versus income group is created. The A logged y-axis scale is used to allow a better spread of data points in the plot. There is a vast amount of overlapped amongst the different income groups. The labels of the income groups are not very indicative of the GPD value. For the labels to be useful I would expect more separation with very little overlap between the groups. The High income: OECD group should have the highest GDP, followed by High income: nonOECD group, etc. Indeed, the High income: OECD group has one of the highest GDP but then the rest of the GDP values are lower than the other groups. However, the other groups have several GDP that are much higher than the found in the High income: OECD group. Even, the Low income group does not include one GDP that is lower than the rest of the groups. This distribution suggests that the criteria for dividing the groups should probably be reevaluated.

#### This plot is generated using the library ggplot2. Any group that does not have an income group label is removed and the new modified data set is called “GDPplots”. The y-axis scale is changed to log scale to view spread of data better. The gray default back ground is removed and the x-axis label is adjusted to 30 degrees to preventer overlapping of labels. The R Markfile exports this plot into the Anaylsis directory and is labeled “GDPdistrubtionunnamed-chunk-6-1.png”.

    GDPplots <- subset(DataDecendingRank, !is.na(Income.Group))

    ggplot(GDPplots, aes(x=Income.Group, y=GDPvalue)) + geom_point(aes(colour = Income.Group), size = 4) +
      scale_y_log10()+
      ggtitle("Income Group Versus GDP Monetary Value") +
      xlab("Income Groups of Selected Countries") +
      ylab("Gross Domestic Product Value (Dollars)") + 
      scale_fill_discrete(name="Income Groups") +
      theme_bw()+
      theme( axis.text.x=element_text(angle=30, hjust = 1))

![](Analysis/GDPdistributionunnamed-chunk-6-1.png)

5. Summary Statistics of GDP by Income Group.
---------------------------------------------

#### The summary statistics of GDP by income groups are given below. The values represent US dollars in millions. The median and mean increase from Low income group, Lower middle income group, Upper middle income to the High income OECD group. The median and mean for the High income nonOECD group falls below the Upper middle income group but above the Lower middle income group. Based on median and mean, the income group classification appears to reflect the proper GDP value for each income group except for the Upper middle income group. Again, it might be beneficial to reevaluate the criteria for dividing the groups.

#### For this analysis, each group is separated by income group and each subset is renamed. The summary statistics is then exported as "SummaryStats.txt" to the Analysis for viewing.

    LowIncome<- subset(GDPplots, Income.Group == 'Low income')
    LowerMiddleIncome<- subset(GDPplots, Income.Group == 'Lower middle income')
    UpperMiddleIncome<- subset(GDPplots, Income.Group == 'Upper middle income')
    HighIncomeNonOECD2<- subset(GDPplots, Income.Group == 'High income: nonOECD')
    HighIncomeOECD2<- subset(GDPplots, Income.Group == 'High income: OECD')

    LowIncome<-tapply(LowIncome$GDPvalue, LowIncome$Income.Group, summary, digits = 42)
    LowerMiddleIncome<-tapply(LowerMiddleIncome$GDPvalue, LowerMiddleIncome$Income.Group, summary, digits = 42)
    UpperMiddleIncome<-tapply(UpperMiddleIncome$GDPvalue, UpperMiddleIncome$Income.Group, summary, digits = 42)
    HighIncomeNonOECD<-tapply(HighIncomeNonOECD$GDPvalue, HighIncomeNonOECD$Income.Group, summary, digits = 42)
    HighIncomeOECD<-tapply(HighIncomeOECD$GDPvalue, HighIncomeOECD$Income.Group, summary, digits = 42)
    SummaryStats<-c(LowIncome,LowerMiddleIncome, UpperMiddleIncome, HighIncomeNonOECD, HighIncomeOECD)
    SummaryStats

    ## $`Low income`
    ##      Min.   1st Qu.    Median      Mean   3rd Qu.      Max. 
    ##    596.00   3814.00   7843.00  14410.78  17204.00 116355.00 
    ## 
    ## $`Lower middle income`
    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##      40    2549   24272  256663   81448 8227103 
    ## 
    ## $`Upper middle income`
    ##      Min.   1st Qu.    Median      Mean   3rd Qu.      Max. 
    ##     228.0    9613.0   42945.0  231847.8  205789.0 2252664.0 
    ## 
    ## $`High income: nonOECD`
    ##     Min.  1st Qu.   Median     Mean  3rd Qu.     Max. 
    ##   2584.0  12838.0  28373.0 104349.8 131204.5 711050.0 
    ## 
    ## $`High income: OECD`
    ##     Min.  1st Qu.   Median     Mean  3rd Qu.     Max. 
    ##    13579   211147   486528  1483917  1480047 16244600

    capture.output(SummaryStats, file = "Analysis/SummaryStats.txt")

6. Quantiles for GDP Ranking
----------------------------

#### The GDP ranking was cut into 5 separate quantile groups and placed in a table versus income group. From the table, it was determined that the 5 countries from the lower middle income group were amongst the 38 nations with highest GDP. The criteria for determining how to place each country into the different income group doesn’t appear to be solely based on GDP value alone.

#### For the quantile analysis, the “GDPplot” data is renamed “RankQuantile”. The ranking will be divided into 5 groups but first the range of each group is determined. Then the groups are separated into these divisions. The table of GDP ranking separated into 5 separate quantile groups versus income group is exported as "Analysis/RankQuantile.csv" to an external file in Analysis directory.

    RankQuantile<-GDPplots
    cuts<-quantile(RankQuantile$Ranking, probs = seq(0, 1, 0.2))
    RankQuantile<- cut(GDPplots$Ranking, cuts)
    RankQuantile<-table(RankQuantile, GDPplots$Income.Group)
    RankQuantile

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

    write.csv(RankQuantile, "Analysis/RankQuantile.csv")

Conclusion
----------

#### After analyzing GDP 2012 for various economies using GDP ranking and income group classification it was determined that several economies do not have confirmed GDP estimates. This report does not include all economies; thus, the ranking may not represent true GDP ranking for the World in 2012. It was determined that the income classification by Income group is not represented by individual GDP values but perhaps the group’s median or mean except for the Upper middle income group. Based on individual GDP values and quantile analysis, it might be beneficial to reevaluate the criteria for Income group classification for each economy. However, it appears that High income OECD group has a highest mean and median GDP values and 17 nations among the 38 nations with highest GDP. It appears the OECD is beneficial in boosting the economy for their members.

Further Work
------------

#### This report can be expanded to other years beside 2012 and analyze how ranking and GDP values change over time. Also, review or reevaluate the criteria for income group classification for each economy. Finally, for a true representation of GDP ranking, finding more ways or information about unconfirmed GDP estimated for economies that are not included in the report’s analyses.

#### References

#### (1)<http://data.worldbank.org/data-catalog/GDP-ranking-table>

#### (2)<http://data.worldbank.org/data-catalog/ed-stats>

#### (3)<https://www.thebalance.com/what-is-gdp-definition-of-gross-domestic-product-3306038>
