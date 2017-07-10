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

#Question 2
balt<-NEI[NEI$fips == "24510",]
balt_tot<-aggregate(balt$Emissions,list(balt$year),sum)
names(balt_tot)<-c("year","pm25.total")
png("plot2.png",
    width = 500,
    height = 420,
    res = 72)
plot(balt_tot$year,
     balt_tot$pm25.total / 1000,
     type = "l",
     yaxt = "n",
     ylab = "PM 25 K tons",
     xlab = "Years",
     col="red",
     main="Total emissions from PM2.5 in Baltimore from 1999 to 2008")
my.axis <- paste(axTicks(2), "K", sep = "")
axis(2, at = axTicks(2), labels = my.axis)
dev.off()
rm(list=ls()) 