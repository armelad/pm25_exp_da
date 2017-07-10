#load library for quick load of the csv data
library(readr)

#get the current folder and set is as a working folder
curdir <- getwd()
setwd(curdir)

#Load File
if (!file.exists("data.zip")) {
        #assign the location of the file
        fileUrl <-
                "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
        # download the file
        download.file(fileUrl, destfile = "data.zip", method = "libcurl")
        
        #UNzip the file
        unzip ("data.zip", exdir = ".")
}

# Read the files into the variables
NEI <- read_rds("summarySCC_PM25.rds")             # PM2.5 Emissions Data
SCC <- read_rds("Source_Classification_Code.rds")  # Source Classification Code Table 
balt<-NEI[NEI$fips == "24510",]
library(ggplot2)
library(dplyr)
#Question 3
bsource<-as.data.frame(summarise(group_by(balt, type,year), sum(Emissions)))
names(bsource)[3]<-"Total.Emissions"

g <- ggplot(bsource, aes(year, Total.Emissions,color=type))
g<- g + geom_line() + facet_wrap(~ type, nrow = 2)
g<- g + labs(title = "Sources of emissions from 1999–2008 for Baltimore City")
ggsave("plot3.png",width = 10, height = 8.4, dpi = 72)


rm(list=ls()) 