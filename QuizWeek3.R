# Week 3 Quiz

#q1. The American Community Survey distributes downloadable data about United States communities. Download the 2006 microdata survey about housing for the state of Idaho using download.file() from here:
#https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv
#and load the data into R. The code book, describing the variable names is here:
#https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf
#Create a logical vector that identifies the households on greater than 10 acres who sold more than $10,000 worth of agriculture products. Assign that logical vector to the variable agricultureLogical. Apply the which() function like this to identify the rows of the data frame where the logical vector is TRUE.
#which(agricultureLogical)
#What are the first 3 values that result?

Houses_Idaho <- read_csv("~/IT_learning/Coursera/Data_Cleaning/Week3/Houses_Idaho.csv")

str(Houses_Idaho)
names(Houses_Idaho)

Houses_Idaho$ACR
summary(Houses_Idaho$ACR)

agricultureLogical <- Houses_Idaho$ACR == 3 & Houses_Idaho$AGS == 6
head(agricultureLogical)
head(which(agricultureLogical))

##other way (if we want the values)
agri1 <- Houses_Idaho[which(Houses_Idaho$ACR == 3 & Houses_Idaho$AGS == 6), ] # Does not return NAs
head(agri1)

#Q2. Using the jpeg package read in the following picture of your instructor into R
#https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg
#Use the parameter native=TRUE. What are the 30th and 80th quantiles of the resulting data? 
#(some Linux systems may produce an answer 638 different for the 30th quantile)

library(jpeg)

file <- "https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg"

download.file(file, "./Image.jpg")


image <- readJPEG("./Image.jpg",native = T)

list.files()
class(image)

head(image)
str(image)
dim(image)


quantile(image, probs = c(0.3, 0.8))

#Q3. Load the Gross Domestic Product data for the 190 ranked countries in this data set:
#https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv
#Load the educational data from this data set:
#https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv
#Match the data based on the country shortcode. How many of the IDs match? Sort the data frame in descending order by GDP rank (so United States is last). What is the 13th country in the resulting data frame?
#Original data sources:
#http://data.worldbank.org/data-catalog/GDP-ranking-table
#http://data.worldbank.org/data-catalog/ed-stats

file1 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"

download.file(file1, "./GPD.csv")

GDP <- read.csv("./GPD.csv")


file2 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"

download.file(file2, "./Edu.csv")

Edu <- read.csv("./Edu.csv")

names(GDP) # Skip the first 4 rows and 190 countries
names(Edu) #Ok

library(dplyr)
library(data.table)


GDP_clean <- fread(file1, skip = 4, nrows = 190, select = c(1, 2, 4, 5), col.names = c("CountryCode", "Rank", "Economy", "Gdp"))

mergedData <- merge(GDP_clean, Edu, by = "CountryCode")
dim(mergedData)

mergedData %>%
    select(1:4) %>%
    arrange(desc(Rank))

#Q4. What is the average GDP ranking for the "High income: OECD" and "High income: nonOECD" group?

Income_group <- group_by(mergedData, Income.Group)

summarize(Income_group, AverGDP = mean(Rank))

## Other way

mergedData %>%
    filter(Income.Group == "High income: OECD" | Income.Group == "High income: nonOECD") %>%
    group_by(Income.Group) %>%
    summarize(avgRank = mean(Rank)) %>%
    print()

#Q5. Cut the GDP ranking into 5 separate quantile groups. Make a table versus Income.Group. How many countries
#are Lower middle income but among the 38 nations with highest GDP? 

breaks <- quantile(mergedData$Rank, probs = c(0.2, 0.4, 0.6, 0.8, 1), na.rm = T)

mergedData$groupsRank <- cut(mergedData$Rank, breaks = breaks)

names(mergedData)

table(mergedData$groupsRank, mergedData$Income.Group)

# Better view
mergedData[Income.Group == "Lower middle income", .N, by = c("Income.Group", "groupsRank")]

#or 

data <- mergedData %>%
    select(Income.Group, groupsRank) %>%
    group_by(Income.Group) %>%
    filter(Income.Group== "Lower middle income", !is.na(groupsRank))

table(data)

