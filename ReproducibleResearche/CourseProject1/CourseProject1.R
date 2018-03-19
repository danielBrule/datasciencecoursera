library(ggplot2)
setwd("C:/datasciencecoursera/ReproducibleResearche/CourseProject1")


#read data 
dActivity <- read.csv("activity.csv")
#set date format 
dActivity$date <- as.Date(dActivity$date)
dActivity$interval2 <- paste(as.integer(dActivity$interval / 100), formatC(dActivity$interval %% 100, width = 2, flag = 0), sep =":")


#Q1.1 
dStepsPerDay <- aggregate(steps~date, data = dActivity, FUN = sum, na.rm = TRUE)
dStepsPerDay

#Q1.2
barplot(dStepsPerDay$steps, 
        names.arg = dStepsPerDay$date, 
        main = "total step per day", 
        ylab = "# steps", 
        xlab = "date")


#Q1.3 
dMeanStepsPerDay   <- aggregate(steps~date, data = dActivity, FUN = mean)
dMedianStepsPerDay <- aggregate(steps~date, data = dActivity, FUN = median)
dMeanMedStepsPerDay <- merge(dMeanStepsPerDay, dMedianStepsPerDay, by = "date")
colnames(dMeanMedStepsPerDay) <- c("date", "mean", "median")
dMeanMedStepsPerDay



#Q2.1 

dStepsPerInterval <- aggregate(steps~interval, data = dActivity, FUN = mean, na.rm = TRUE)
dStepsPerInterval$interval2 <- paste(as.integer(dStepsPerInterval$interval / 100), formatC(dStepsPerInterval$interval %% 100, width = 2, flag = 0), sep =":")

ggplot(data = dStepsPerInterval, aes(x = interval, y = steps)) + 
    geom_line() + 
    ggtitle("average steps through the day")
#Q2.2
dStepsPerInterval[which.max(dStepsPerInterval$steps), c("interval2", "steps")]


#Q3.1 input missing values 

sum(!complete.cases(dActivity))

sum(is.na(dActivity$date))
sum(is.na(dActivity$interval))
sum(is.na(dActivity$steps))

#Q3.2
#Q3.3
dMeanStepsPerInterval   <- aggregate(steps~interval, data = dActivity, FUN = mean)

dActivityNoNA <- dActivity
dActivityNoNA <- merge (dActivityNoNA, dMeanStepsPerInterval, by = "interval")
dActivityNoNA$steps.x <- ifelse (is.na(dActivityNoNA$steps.x), dActivityNoNA$steps.y, dActivityNoNA$steps.x)

dActivityNoNA <- dActivityNoNA[order(dActivityNoNA$date), ]
dActivityNoNA <- subset(dActivityNoNA, select = -c(steps.y))
colnames(dActivityNoNA)[2] <- "steps"
dActivityNoNA<- dActivityNoNA[,c(2,3,1,4)]


#Q3.4
dStepsPerDayNoNA <- aggregate(steps~date, data = dActivityNoNA, FUN = sum, na.rm = TRUE)
barplot(dStepsPerDayNoNA$steps, 
        names.arg = dStepsPerDayNoNA$date, 
        main = "total step per day", 
        ylab = "# steps", 
        xlab = "date")

dMeanStepsPerDayNoNA   <- aggregate(steps~date, data = dActivityNoNA, FUN = mean)
dMedianStepsPerDayNoNA <- aggregate(steps~date, data = dActivityNoNA, FUN = median)
dMeanMedStepsPerDayNoNA <- merge(dMeanStepsPerDayNoNA, dMedianStepsPerDayNoNA, by = "date")
colnames(dMeanMedStepsPerDayNoNA) <- c("date", "mean", "median")
dMeanMedStepsPerDayNoNA


#Q4
dActivityNoNA$date <- as.POSIXlt(dActivityNoNA$date)
dActivityNoNA$isWeekend <- dActivityNoNA$date$wday >=6


dStepsPerIntervalWeekDayvsWeekens <- aggregate(steps~interval + isWeekend, data = dActivityNoNA, FUN = mean, na.rm = TRUE)


ggplot(data = dStepsPerIntervalWeekDayvsWeekens, aes(x = interval, y = steps, color = isWeekend)) +
    geom_line() +  
    ggtitle("average steps through the day: weekdday vs. weekend")
