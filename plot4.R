################################################################################
# Reading data

setwd("~/ExploratoryData")

## download files

if (!file.exists("./data")) {dir.create("./data") }

fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileUrl, destfile = "./data/power_consumption.zip", method = "curl")

## unzip file
unzip ("./data/power_consumption.zip", exdir = "./data")
       

## read data
importdata <- read.csv("./data/household_power_consumption.txt", sep=";")


## change the date format: 

importdata$Date <- as.Date(as.character(importdata$Date), "%d/%m/%Y")

subdata <- importdata[importdata$Date >= as.Date("2007-02-01", "%Y-%m-%d") & 
                              importdata$Date <= as.Date("2007-02-02", "%Y-%m-%d"), ]


## put datetime together
subdata$datetime <- strptime(paste(subdata$Date, subdata$Time), 
                             "%Y-%m-%d %H:%M:%S")


## turn vars into numeric
subdata$Global_active_power     <- as.numeric(as.character(subdata$Global_active_power))
subdata$Sub_metering_1          <- as.numeric(as.character(subdata$Sub_metering_1))
subdata$Sub_metering_2          <- as.numeric(as.character(subdata$Sub_metering_2))
subdata$Sub_metering_3          <- as.numeric(as.character(subdata$Sub_metering_3))
subdata$Voltage                 <- as.numeric(as.character(subdata$Voltage))
subdata$Global_reactive_power   <- as.numeric(as.character(subdata$Global_reactive_power))


##make sure the vars are numeric
sapply(subdata, is.numeric)
    

##test if the vars has "?" (NA)
library(dplyr)
for (i in 1:10) { "?" %in% subdata[,i] %>% print}


# save the file:
save (subdata, file = "Exsubdata1.Rda")

################################################################################

# plot 4:

load("Exsubdata1.Rda")
png("Rplot4.png", width = 480, height = 480, units = "px")

        par(mfcol= c(2,2))

        
##plot4.1    
        with(subdata, plot(datetime, Global_active_power, 
                   xlab ='',
                   ylab ='Global Active Power',
                   type = "l", 
                   col = 'black'))


##plot4.2         
        with(subdata, plot(datetime, Sub_metering_1, 
                   xlab ='',
                   ylab ='Energy sub metering',
                   type = "l", 
                   col = 'black'))

        with(subdata, lines(datetime, Sub_metering_2, col = 'red'))
        with(subdata, lines(datetime, Sub_metering_3, col = 'blue'))

        legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
                   bty ="n",
                   lty = 1, 
                   lwd =2, 
                   col = c("black", "red", "blue"))



##plot4.3 
        with(subdata, plot(datetime, as.numeric(as.character(Voltage)), 
                   xlab ='datetime',
                   ylab ='voltage',
                   type = "l", col = 'black'))


##plot4.4 
        with(subdata, plot(datetime, as.numeric(as.character(Global_reactive_power)), 
                   ylab ='Global_reactive_power',
                   type = "l"))


dev.off()

