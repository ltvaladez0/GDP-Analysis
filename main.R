#Author: Leticia Valadez
#This code is used to analyzes Gross Domestic Product(GDP)
#sessionInfo()
#R version 3.3.3 (2017-03-06)
#Platform: x86_64-w64-mingw32/x64 (64-bit)
#Running under: Windows 7 x64 (build 7601) Service Pack 1

##Before proceeding set your root directory first.
##For example, setwd("C:/Rprojects/GDP Analysis")
##Use getwd() to verify working director

##Download files needed for data analysis.
source("./mainHelper.R")

##Clean up both data frames for data analysis.
source("./cleanMergeData.R")

##Question 1: How many of the IDs match?
##Determine how many missing values "NA" for the variable "Country" from the GDPdata
##and for the variable "Long.Name" from the EdStatsData.
matchID=nrow(mergedGDP_EdStats)-sum(is.na(mergedGDP_EdStats$Country))-sum(is.na(mergedGDP_EdStats$Long.Name))
matchID

##Determine how many IDs match for countries that have ranking.
##First remove countries that do not have ranking.
##Then determine which country has NA for the Long.Name variable
mergedGDP_EdStatsRank<- subset(mergedGDP_EdStats, !is.na(Ranking))
RankMatchID=sum(!is.na(mergedGDP_EdStatsRank$Long.Name))
RankMatchID

##There are two columns with countries' long names and it is best to remove one column.
##Aftering deleting colunm one country will not have long name, hence, one will be provided.
##Which is the unmatched ID's country code?
missingName<-which(is.na(mergedGDP_EdStatsRank$Long.Name))
missingName<-mergedGDP_EdStatsRank[155,5]  

##Add miss "Country" Variable  ("South Sudan") to corresponding Long.Name missing variable
mergedGDP_EdStatsRank[155,2] <-  mergedGDP_EdStatsRank[155,5]

##Remove "Country" columnn to remove duplication of providing a country's name.
mergedGDP_EdStatsRank<-mergedGDP_EdStatsRank[-5]

##Replace "Long.Name" variable to "Country" Variable.
colnames(mergedGDP_EdStatsRank)[2] <- "Country"

#Export mergedGDP_EdStatsRank data in Analysis directory for viewing.
write.csv(mergedGDP_EdStatsRank, "Analysis/AnalysisOfMatchedID.csv")

##Question 2: Sort the data frame in ascending order by GDP (so United States is last).
##What is the 13th  country in the resulting data frame?
DataDecendingRank<-mergedGDP_EdStatsRank[order(-mergedGDP_EdStatsRank$Ranking),]
ThirteenthCountry=DataDecendingRank[13,2]
ThirteenthCountry


#Export DataDecendingRank data in Analysis directory for viewing.
write.csv(DataDecendingRank, "Analysis/AnalysisOfDecendingRank.csv")

##Question 3: What are the average GDP rankings for the "High income: OECD" and "High income: nonOECD" groups?
##Extra the respective groups from the data set.
HighIncomeOECD <- DataDecendingRank[which(DataDecendingRank$Income.Group == "High income: OECD"),]
mean(HighIncomeOECD$Ranking)

HighIncomeNonOECD<- DataDecendingRank[which(DataDecendingRank$Income.Group == "High income: nonOECD"),]
mean(HighIncomeNonOECD$Ranking)


##Question 4: Show the distribution of GDP value for all the countries and color plots by income group. 
##Use ggplot2 to create your plot.

##Prepare data for plotting by removing any rows with "NA" values
##and rename the data frame to GDPplots.
GDPplots <- subset(DataDecendingRank, !is.na(Income.Group))

##Plot the data using ggplot2.
##Change the y-axis scale to log scale to view spread of data.

ggplot(GDPplots, aes(x=Income.Group, y=GDPvalue)) + geom_point(aes(colour = Income.Group), size = 4) +
  scale_y_log10()+
  ggtitle("Income Group Versus GDP Monetary Value") +
  xlab("Income Groups of Selected Countries") +
  ylab("Gross Domestic Product Value (Dollars)") + 
  scale_fill_discrete(name="Income Groups") +
  theme_bw()+
  theme( axis.text.x=element_text(angle=30, hjust = 1))


##Question 5: Provide summary statistics of GDP by income groups.
##Separate each income group and rename each subset followed by summary statistics.
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

#Export Summary statistics data in Analysis directory for viewing.
capture.output(SummaryStats, file = "Analysis/SummaryStats.txt")

##Guestion 6. Cut the GDP ranking into 5 separate quantile groups. Make a table versus Income.Group.
##How many countries are Lower middle income but among the 38 nations with highest
##GDP?

##Rename data frame to use in quantile analysis.
RankQuantile<-GDPplots

##Determine the division lines for separating the GDP ranking into 5 groups.
cuts<-quantile(RankQuantile$Ranking, probs = seq(0, 1, 0.2))

##Place each group in proper division and place data in table
RankQuantile<- cut(GDPplots$Ranking, cuts)
RankQuantile<-table(RankQuantile, GDPplots$Income.Group)
RankQuantile

#Export RankQuantile in Analysis directory for viewing.
write.csv(RankQuantile, "Analysis/RankQuantile.csv")