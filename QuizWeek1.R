# Quiz Week 1

#Q1. The American Community Survey distributes downloadable data about United States communities. Download the 2006 microdata survey about housing for the state of Idaho using download.file() from here:
#https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv
#and load the data into R. The code book, describing the variable names is here:
#https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf
#How many properties are worth $1,000,000 or more?

## Downloading the file from the internet

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"

download.file(fileUrl, destfile = "./Data_Quiz1.csv")

list.files()

##Set the date of downloading

dateDownloaded <- date()

dateDownloaded

##Read the file from the directory

House_data <- read.csv("./Data_Quiz1.csv")

## Houses value greater or equalt than 1 millon
library(dplyr)

cran <- tbl_df(House_data)

rm(House_data)
cran

variables <- select(cran, TYPE, VAL)

### 24: value +1millon    Type 1 means houses

houses_value <- filter(variables, TYPE == 1, !is.na(VAL), VAL == 24)

dim(houses_value)

# 53 housing units in this survey are worth more than 1 millon dollars.

#Q2. Use the data you loaded from Question 1. Consider the variable FES in the code book. Which of the "tidy data" principles does this variable violate?
#Numeric values in tidy data can not represent categories.
#Tidy data has no missing values.
#Each variable in a tidy data set has been transformed to be interpretable.
#Tidy data has one variable per column.

fes <- select(cran, FES)

summary(fes)

head(fes, 10)

## Tidy data has one variable per column

#Q3. Download the Excel spreadsheet on Natural Gas Aquisition Program here:
#https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx
#Read rows 18-23 and columns 7-15 into R and assign the result to a variable called:
# dat
#What is the value of:
# sum(dat$Zip*dat$Ext,na.rm=T)
# (original data source: http://catalog.data.gov/dataset/natural-gas-acquisition-program)


library(xlsx)

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx"

download.file(fileUrl, destfile = "./Natural_Gas.xlsx", mode = "wb")

dateDownloaded <- date()

dateDownloaded

rowIndex <- 18:23
colIndex <- 7:15

dat <- read.xlsx("./Natural_Gas.xlsx", sheetIndex = 1, rowIndex = rowIndex, colIndex = colIndex, header = T)

dat

sum(dat$Zip*dat$Ext, na.rm = T)

#Q4. Read the XML data on Baltimore restaurants from here:
#https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml
# How many restaurants have zipcode 21231?

library(XML)
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"

doc <- xmlTreeParse(sub("s", "", fileUrl), useInternalNodes = T)
class(doc)

rootNode <- xmlRoot(doc)
xmlName(rootNode)
names(rootNode)

xmlSApply(rootNode, xmlValue)

## Select restaurants with zipcode 21231

zipcode <- xpathSApply(doc, "//zipcode", xmlValue)
sum(zipcode == 21231)

#Q5. The American Community Survey distributes downloadable data about United States communities. Download the 2006 microdata survey about housing for the state of Idaho using download.file() from here:
#https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv
# using the fread() command load the data into an R object
#DT
#The following are ways to calculate the average value of the variable
# pwgtp15
#broken down by sex. Using the data.table package, which will deliver the fastest user time?

library(data.table)

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
DT <- fread(input = fileUrl, sep = ",")

system.time(mean(DT$pwgtp15, by = DT$SEX))

system.time(tapply(DT$pwgtp15,DT$SEX,mean))

#system.time(rowMeans(DT)[DT$SEX==1], rowMeans(DT)[DT$SEX==2])

system.time(DT[ ,mean(pwgtp15),by=SEX])

system.time(mean(DT[DT$SEX==1,]$pwgtp15), mean(DT[DT$SEX==2,]$pwgtp15))

system.time(sapply(split(DT$pwgtp15,DT$SEX),mean))

# the faster
DT[ ,mean(pwgtp15),by=SEX]
