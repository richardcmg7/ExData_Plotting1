# Install Package for reading our Dataset

# install.packages("readr")
# library("csv")

# Download the file
if(!file.exists("data")){dir.create("data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip?accessType=DOWNLOAD"
download.file(fileUrl,destfile = "./data/pw_cs.zip")

# Unzip the data
unzip("./data/pw_cs.zip", exdir = "./data")

# View the file unziped - Delete zip file

list.files('data')
# [1] "household_power_consumption.txt" "pw_cs.zip"       

unlink('data/pw_cs.zip')
file.exists('data/pw_cs.zip') # False if the file was deleted correctly

# Read the Data with the rows needed - Use csv2 for ";" separate
readr::read_csv2('data/household_power_consumption.txt', col_names = TRUE) -> df_a
summary(df_a)
dim(df_a)
# [1] 2075259       9

# Subsetting and Remove Electrical full_dataset
use_data <- subset(df_a, Date %in% c("1/2/2007", "2/2/2007") )
# rm(electrical)
# head(use_data)
summary(use_data)
dim(use_data)
# [1] 2880    9
use_data$Global_active_power <- as.numeric(use_data$Global_active_power)
use_data$Date <- as.Date(use_data$Date, format="%d/%m/%Y")
use_data$Date <- as.Date(use_data$Date, format="%d/m/Y%%")
datetime <- paste(as.Date(use_data$Date), use_data$Time)
use_data$Datetime <- as.POSIXct(datetime)

# PLOT 4

par(mfrow=c(2,2), mar=c(4,4,2,1), oma=c(0,0,2,0))
with(use_data, {
  plot(Global_active_power~Datetime, type="l", 
       ylab="Global Active Power (kilowatts)", xlab="")
  plot(Voltage~Datetime, type="l", 
       ylab="Voltage (volt)", xlab="")
  plot(Sub_metering_1~Datetime, type="l", 
       ylab="Global Active Power (kilowatts)", xlab="")
  lines(Sub_metering_2~Datetime,col='Red')
  lines(Sub_metering_3~Datetime,col='Blue')
  legend("topright", col=c("black", "red", "blue"), lty=1, lwd=2, bty="n",
         legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
  plot(Global_reactive_power~Datetime, type="l", 
       ylab="Global Rective Power (kilowatts)",xlab="")
  
})

dev.copy(png, file="plot4.png", height = 480, width = 480)
# quartz_off_screen 
# 4 
dev.off()

# END 