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

library(ggplot2)

#Question 4
coal<-as.vector(SCC[grep("Comb",SCC$Short.Name),])
coal<-as.vector(SCC[grep("Coal",coal$Short.Name),1])
us_coal<-NEI[NEI$SCC%in%coal,]
us_coal_total<-aggregate(us_coal$Emissions,list(us_coal$year),sum)
names(us_coal_total)<-c("year","coal.emissions")
d <- ggplot(us_coal_total, aes(year, coal.emissions))
d<- d + geom_line()
d<- d + labs(title = "Emissions from coal combustion-related sources change in 1999–2008")

ggsave("plot4.png",width = 10, height = 8.4, dpi = 72)


rm(list=ls()) 