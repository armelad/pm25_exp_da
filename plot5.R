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

motor<-as.vector(SCC[grep("Highway Veh",SCC$Short.Name),1])
balt_veh<-NEI[NEI$fips == "24510" & NEI$SCC%in%motor,]
balt_veh_total<-aggregate(balt_veh$Emissions,list(balt_veh$year),sum)
names(balt_veh_total)<-c("year","veh.emissions")
e <- ggplot(balt_veh_total, aes(year, veh.emissions))
e<- e + geom_line()
e<- e + labs(title = "Emissions from motor vehicle sources in Baltimore change in 1999–2008")

ggsave("plot5.png",width = 10, height = 8.4, dpi = 72)


rm(list=ls()) 