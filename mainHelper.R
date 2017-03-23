##This code is used to download required packages and datasets.

options(repos="https://cran.rstudio.com" )

##The following libraries are required for the following complete analysis.
##Library required for downloading files:
install.packages("downloader", repos = "https://cran.rstudio.com")
library(downloader)

##Library required for plots:
install.packages("ggplot2", repos = "https://cran.rstudio.com")
library(ggplot2)

##Download data files
download("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv", destfile="Data/GDP.csv")
download("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv", destfile="Data/EdStats.csv")

##Assign imported data files into data frame "GPD" and "EdStats"
##which represent the Gross Domestic Product data and Education Statistics data, respectivley.
GDP <- read.csv("Data/GDP.csv", stringsAsFactors=FALSE, header=TRUE)
EdStats<-read.csv("Data/EdStats.csv",stringsAsFactors=FALSE, header=TRUE)

##This are riginal data sources for reference:
##http://data.worldbank.org/data-catalog/GDP-ranking-table
##http://data.worldbank.org/data-catalog/ed-stats

