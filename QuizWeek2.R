# Quiz 2 Getting and cleaning data

#Q1. Register an application with the Github API here https://github.com/settings/applications. Access the API to get information on your instructors repositories (hint: this is the url you want "https://api.github.com/users/jtleek/repos"). Use this data to find the time that the datasharing repo was created. What time was it created?
#This tutorial may be useful (https://github.com/hadley/httr/blob/master/demo/oauth2-github.r). You may also need to run the code in the base R package and not R studio.

# OAuth settings for github:

oauth_endpoints("github")

myapp <- oauth_app("github", 
          key = "f7d2d5baf08569d08399",
          secret = "316239b8e8f695c4fa400877a032af8c4ff303cd")

# Get OAuth credentials

github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)

# Use API

req <- GET("https://api.github.com/users/jtleek/repos", config(token = github_token))
stop_for_status(req)
json1 <- content(req)
class(json1)

# Convert the list to Json 
library(jsonlite)
json2 <- jsonlite::fromJSON(jsonlite::toJSON(json1))
class(json2) # data frame

names(json2)
str(json2$full_name) #jtleek/datasharing
str(json2$created_at)

library(dplyr)
select1 <- select(json2, full_name, created_at)

answer <- filter(select1, full_name == "jtleek/datasharing")

answer

#Q2. The sqldf package allows for execution of SQL commands on R data frames. We will use the sqldf package to practice the queries we might send with the dbSendQuery command in RMySQL.
#Download the American Community Survey data and load it into an R object called
#acs
#https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv
#Which of the following commands will select only the data for the probability weights pwgtp1 with ages less than 50?

library(DBI)
library(RSQLite)
library(sqldf)

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"

download.file(fileUrl, destfile = "./Data_Quiz2.csv")

dateDownloaded <- date()

dateDownloaded

list.files()

acs <- read.csv("./Data_Quiz2.csv")
str(acs)

answer1 <- sqldf("select pwgtp1 from acs where AGEP<50")

#other way

select <- select(acs, pwgtp1, AGEP)

answer <- filter(select, AGEP < 50)

head(answer)

dim(answer)

#Q3. Using the same data frame you created in the previous problem, what is the equivalent function to unique(acs$AGEP)

unique(acs$AGEP)
 
# or

sqldf("select distinct AGEP from acs")


#Q4 How many characters are in the 10th, 20th, 30th and 100th lines of HTML from this page:
#http://biostat.jhsph.edu/~jleek/contact.html
#(Hint: the nchar() function in R may be helpful)

library(XML)

con <- url("http://biostat.jhsph.edu/~jleek/contact.html")

# To read some or all text lines from a connection.

htmlCode <- readLines(con) 

close(con) #close connection

nchar(htmlCode[c(10, 20, 30, 100)]) # to select the lines

#Q5. Read this data set into R and report the sum of the numbers in the fourth of the nine columns.
#https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for
#Original source of the data: http://www.cpc.ncep.noaa.gov/data/indices/wksst8110.for
#(Hint this is a fixed width file format)

# Read fixed format data. The width argument indicates the width of each variable, instead
# of using the sep argument to indicate the start of each variable.

file <- "http://www.cpc.ncep.noaa.gov/data/indices/wksst8110.for"

colNames <- c("Week", "Nino12_SST", "Nino12_SSTA", "Nino3_SST", "Nino3_SSTA", "Nino34_SST", "Nino34_SSTA", "Nino4_SST", "Nino4_SSTA")

data <- read.fwf(file, skip = 4, widths = c(12, 7, 4, 9, 4, 9, 4, 9, 4), col.names = colNames)

class(data)

select <- select(data, Nino3_SST)

sum(select)

#another way

sum(data[, 4])
