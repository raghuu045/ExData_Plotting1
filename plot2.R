## download the file
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2F
household_power_consumption.zip"
if(!file.exists("data")) {
        dir.create("./data")
}
download.file(fileUrl,destfile="./data/household_power_consumption.zip")

## Read the first Date column alone to find out the rows of interest for 
## the dates 2007-02-01 and 2007-02-02
data <- read.table(unz("./data/household_power_consumption.zip",
                   "household_power_consumption.txt"), sep = ";", 
                   header=TRUE, na.strings = "?", 
                   colClasses = c(rep("character",1),rep("NULL",8)), 
                   stringsAsFactors=FALSE)
date_req_log <- (data$Date == "1/2/2007" |  data$Date == "2/2/2007")
row_names <- 1:2072379
min_row <- min(row_names[date_req_log])
max_row <- max(row_names[date_req_log])
num_of_rows <- max_row - min_row + 1
skip_rows <- min_row - 1

## Read the first row alone to get the column names
data <- read.table(unz("./data/household_power_consumption.zip", 
                   "household_power_consumption.txt"), sep = ";", 
                   header=TRUE, na.strings = "?", 
                   stringsAsFactors=FALSE, nrows=1)
col_names <- names(data)

## Read the required rows from the dataset
data <- read.table(unz("./data/household_power_consumption.zip",
                   "household_power_consumption.txt"), sep = ";", 
                   header=TRUE, na.strings = "?",
                   stringsAsFactors=FALSE, skip=skip_rows,
                   nrows=num_of_rows)

## Update the column names
names(data) <- col_names

## merge Date and Time columns into a new column data_timestamp
data_timestamp <- strptime(paste(data$Date,data$Time),"%d/%m/%Y %H:%M:%S")
data <- cbind(data,data_timestamp)

## draw the histogram on the screen device
plot(data$data_timestamp,data$Global_active_power,type="l",
     ylab="Global Active Power (kilowatts)",xlab="")

## Copy the output on screen to a png file 
dev.copy(png, file="plot2.png")
dev.off()

