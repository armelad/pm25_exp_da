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

#Question 1
total<-aggregate(NEI$Emissions,list(NEI$year),sum)
names(total)<-c("year","pm25.total")
png("plot1.png",
    width = 500,
    height = 420,
    res = 72)
plot(total$year,
     total$pm25.total / 1000000,
     type = "l",
     yaxt = "n",
     ylab = "PM 25 Mil tons",
     xlab = "Years",
     col="red",
     main="Total emissions from PM2.5 in the United States from 1999 to 2008")
my.axis <- paste(axTicks(2), "MM", sep = "")
axis(2, at = axTicks(2), labels = my.axis)
dev.off()

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
#Question 3
library(ggplot2)
g <- ggplot(balt, aes(year, Emissions,color=type))
g<- g + geom_point(size = 4, alpha = 1 / 3) + facet_wrap(~ type, nrow = 2)
g<- g + labs(title = "Sources of emissions from 1999–2008 for Baltimore City")
g<- g + stat_summary(fun.y=mean, geom="line", size = 1)
png("plot3.png",
    width = 500,
    height = 420,
    res = 72)
g
dev.off()
#Question 4
coal<-as.vector(SCC[grep("Comb",SCC$Short.Name),])
coal<-as.vector(SCC[grep("Coal",coal$Short.Name),1])
us_coal<-NEI[NEI$SCC%in%coal,]
us_coal_total<-aggregate(us_coal$Emissions,list(us_coal$year),sum)
names(us_coal_total)<-c("year","coal.emissions")
d <- ggplot(us_coal_total, aes(year, coal.emissions))
d<- d + geom_line()
d<- d + labs(title = "Emissions from coal combustion-related sources change in 1999–2008")
png("plot4.png",
    width = 500,
    height = 420,
    res = 72)
d
dev.off()

#Question 5
motor<-as.vector(SCC[grep("Highway Veh",SCC$Short.Name),1])
balt_veh<-NEI[NEI$fips == "24510" & NEI$SCC%in%motor,]
balt_veh_total<-aggregate(balt_veh$Emissions,list(balt_veh$year),sum)
names(balt_veh_total)<-c("year","veh.emissions")
e <- ggplot(balt_veh_total, aes(year, veh.emissions))
e<- e + geom_line()
e<- e + labs(title = "Emissions from motor vehicle sources in Baltimore change in 1999–2008")
png("plot5.png",
    width = 500,
    height = 420,
    res = 72)
e
dev.off()

#Question 6
m1<-as.vector(SCC[grep("Highway Veh",SCC$Short.Name),1])
la_bl<-NEI[NEI$fips == "24510" | NEI$fips == "06037" & NEI$SCC%in%m1,]
la_bl$fips<-as.factor(la_bl$fips)
levels(la_bl$fips)<-c("Los Angeles County","Baltimore City")
names(la_bl)[1]<-"County"
f <- ggplot(la_bl, aes(year, Emissions, color=County))
f<- f + geom_point(size = 2, alpha = 1/2) + facet_wrap(~ County, ncol = 2)
f<- f + labs(title = paste(strwrap("Emissions from motor vehicle sources in Los Angeles County and Baltimore City change in 1999–2008", width=80), collapse="\n"))
f<- f + stat_summary(fun.y=mean, geom="line", size = 1)

png("plot6.png",
    width = 600,
    height = 420,
    res = 72)
f
dev.off()

