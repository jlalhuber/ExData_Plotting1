library(data.table)
path <- getwd()
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(url, file.path(path, "dataFiles.zip"))
unzip(zipfile = "dataFiles.zip")

hpc <- fread(file.path(path, "household_power_consumption.txt"), na.strings = "?")

# Prevents scientific notation
hpc[, Global_active_power := lapply(.SD, as.numeric), .SDcols = c("Global_active_power")]

# Making a POSIXct date capable of being filtered and graphed by time of day
hpc[, dateTime := as.POSIXct(paste(Date, Time), format = "%d/%m/%Y %H:%M:%S")]

# Filter Dates for 2007-02-01 and 2007-02-02
hpc <- hpc[(dateTime >= "2007-02-01") & (dateTime <= "2007-02-03")]

png("plot3.png", width=480, height=480)

#Plot3
with(hpc, plot(dateTime, Sub_metering_1, type="l",xlab = "", ylab = "Energy sub metering"))
lines(hpc$dateTime, hpc$Sub_metering_2, col = "red")
lines(hpc$dateTime, hpc$Sub_metering_3, col = "blue")
legend("topright", col = c("black", "red", "blue"), c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty = 1, lwd = 1)


dev.off()