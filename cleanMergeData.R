##This code "cleans" and merges data sets for question 1.

##First tidy the GPD data.
##Delete the first 4 rows since they are empty amd rename modified data frame.
GDPdata <- GDP[-c(1:4),]

##Select columns applicable for data analysis.
GDPdata <- GDPdata[c(1,2,4,5)]

##Provide proper variables names for each column.
names(GDPdata)<-c("CountryCode", "Ranking", "Country", "GDPvalue")

##Remove rows with blank values for variable "CountryCode".
GDPdata <- GDPdata[GDPdata$CountryCode != "", c(1,2,3,4)]

##For variable GDPvalue, remove commas, then convert to integer data type.
GDPdata$GDPvalue <- gsub(",", "", GDPdata$GDPvalue)
GDPdata$GDPvalue <- as.integer(GDPdata$GDPvalue)

##Convert variable Ranking  to integer data type.
GDPdata$Ranking <- as.integer(GDPdata$Ranking)

##Next tidy the EdStats data and rename data frame.
EdStatsData <- EdStats

##Select variables applicable for complete data analysis.
EdStatsData <- EdStatsData[c(1:3)]

##Merge the two data frames GDPdata and EdStatsData.
mergedGDP_EdStats<-merge(EdStatsData, GDPdata, "CountryCode", all=TRUE)

#Export merged data in Analysis directory for viewing.
write.csv(mergedGDP_EdStats, "Analysis/MergedData1.csv")
