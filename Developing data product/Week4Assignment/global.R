library(dplyr)
library(lubridate)

#setwd("C:/datasciencecoursera/Developing data product/Week4Assignment")
data <- read.csv("data/dftRoadSafety_Accidents_2016.csv")


#select needed columns
data <- data[,c("Accident_Severity",         
                "Number_of_Casualties", 
                "Number_of_Vehicles",           
                "Road_Type", 
                "Date", 
                "Light_Conditions",         
                "Weather_Conditions")]        


#compute label

data <- data[data$Accident_Severity == 1, ]


fLight <- c("1"="Daylight", "4"="Darkness - lights lit", 
            "5"="Darkness - lights unlit", "6"="Darkness - no lighting", 
            "7"="Darkness - lighting unknown", 
            "-1"="Data missing or out of range")
data$Light_Conditions <- factor(data$Light_Conditions, levels=1:6, 
                                labels=fLight)

fWeather <- c("1"="Fine no high winds", "2"="Raining no high winds",
              "3"="Snowing no high winds", "4"="Fine + high winds",
              "5"="Raining + high winds", "6"="Snowing + high winds",
              "7"="Fog or mist", "8"="Other", "9"="Unknown",
              "-1"="Data missing or out of range")
data$Weather_Conditions <- factor(data$Weather_Conditions, levels=1:10, 
                                  labels=fWeather)

fRoadType <- c("1"="Roundabout", "2"="One way street", "3"="Dual carriageway",
               "6"="Single carriageway", "7"="Slip road", "9"="Unknown",
               "12"="One way street/Slip road", 
               "-1"="Data missing or out of range")
data$Road_Type <- factor(data$Road_Type, levels=1:8, labels=fRoadType)

data$Date <- factor(month(as.POSIXlt(data$Date,tz=Sys.timezone())), levels=1:12, labels=month.name)

