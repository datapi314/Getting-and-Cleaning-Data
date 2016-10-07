# Week 4 Quiz

#Q1. The American Community Survey distributes downloadable data about United States communities. Download the 2006 microdata survey about housing for the state of Idaho using download.file() from here:
#https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv
#and load the data into R. The code book, describing the variable names is here:
#https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf
#Apply strsplit() to split all the names of the data frame on the characters "wgtp". What is the value of the 123 element of the resulting list?

names(Houses_Idaho)
splitNames <- strsplit(names(Houses_Idaho), "wgtp")
splitNames[123]

#q2. Load the Gross Domestic Product data for the 190 ranked countries in this data set:
#https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv
#Remove the commas from the GDP numbers in millions of dollars and average them. What is the average?
#Original data sources:
#http://data.worldbank.org/data-catalog/GDP-ranking-table


library(dplyr)
library(data.table)

file1 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
GDP_clean <- fread(file1, skip = 4, nrows = 190, select = c(1, 2, 4, 5), col.names = c("CountryCode", "Rank", "Economy", "Gdp"))

names(GDP_clean)
head(GDP_clean)
head(GDP_clean$Gdp)

GDP_clean$newGDP <- gsub(",", "", GDP_clean$Gdp)
GDP_clean$newGDP <- as.numeric(GDP_clean$newGDP)
head(GDP_clean$newGDP)

summarize(GDP_clean, average = mean(newGDP))

#Q3. In the data set from Question 2 what is a regular expression that would allow you to count the number of countries whose 
#name begins with "United"? Assume that the variable with the country names in it is named countryNames. How many countries begin with United?

length(grep("^United", GDP_clean$Economy))

#Q4. Load the Gross Domestic Product data for the 190 ranked countries in this data set:
#https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv
#Load the educational data from this data set:
#https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv
#Match the data based on the country shortcode. Of the countries for which the end of the fiscal year is available, how many end in June?
#Original data sources:
#http://data.worldbank.org/data-catalog/GDP-ranking-table
#http://data.worldbank.org/data-catalog/ed-stats

file1 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
GDP_clean <- fread(file1, skip = 4, nrows = 190, select = c(1, 2, 4, 5), col.names = c("CountryCode", "Rank", "Economy", "Gdp"))

mergedData <- merge(GDP_clean, Edu, by = "CountryCode")
names(mergedData)
head(mergedData$`Special Notes`)

june <- grep("^Fiscal year end: June*", mergedData$`Special Notes`)
length(june)




#Q5. You can use the quantmod (http://www.quantmod.com/) package to get historical stock prices for publicly traded companies on the NASDAQ and NYSE. Use the following code to download data on Amazon's stock price and get the times the data was sampled.
#library(quantmod)
#amzn = getSymbols("AMZN",auto.assign=FALSE)
#sampleTimes = index(amzn)

#How many values were collected in 2012? How many values were collected on Mondays in 2012?

library(quantmod)
amzn <- getSymbols("AMZN", auto.assign = F)
sampleTimes <- index(amzn)

class(sampleTimes)
head(sampleTimes, 30)
tail(sampleTimes, 30)

table(year(sampleTimes))
#250

table(weekdays(sampleTimes))

table(year(sampleTimes), weekdays(sampleTimes))
# 47

## Other way
year2012 <- grepl("^2012-*", sampleTimes)
is.logical(year2012)
table(year2012)
#250



data2012 <- subset(sampleTimes, year2012)

weekday <- format(data2012, "%A")
table(weekday)
#47
