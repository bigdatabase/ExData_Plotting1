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

# Plot 1:

load("Exsubdata1.Rda")
png("Rplot1.png", width = 480, height = 480, units = "px")
        hist(subdata$Global_active_power,
                col = 'red', 
                xlab = 'Global Active Power (kilowatts)',
                ylab = 'Frequency',
                main = "Global Active Power")
dev.off()



