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

#Question 6
m1<-as.vector(SCC[grep("Highway Veh",SCC$Short.Name),1])
la_bl<-NEI[NEI$fips == "24510" | NEI$fips == "06037" & NEI$SCC%in%m1,]
library(dplyr)
sum_labl<-as.data.frame(summarise(group_by(la_bl, fips,year), sum(Emissions)))
sum_labl$fips<-as.factor(sum_labl$fips)
levels(sum_labl$fips)<-c("Los Angeles County","Baltimore City")
names(sum_labl)[1]<-"County"
names(sum_labl)[3]<-"Total.Emissions"

f <- ggplot(sum_labl, aes(year, Total.Emissions, color=County))
f<- f + geom_line(size = 2, alpha = 1/2) + facet_wrap(~ County, ncol = 2)
f<- f + labs(title = paste(strwrap("Emissions from motor vehicle sources in Los Angeles County and Baltimore City change in 1999–2008", width=80), collapse="\n"))

ggsave("plot6.png",width = 10, height = 8.4, dpi = 72)


rm(list=ls()) 