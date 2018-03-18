library(ggplot2)

setwd("C:/datasciencecoursera/ExploratoryDataAnalysis")

dClassification <- readRDS("Source_Classification_Code.rds")
dSummary <- readRDS("summarySCC_PM25.rds")

dBaltimoreLA <- subset(dSummary, fips == "24510" | fips == "06037" )

dBaltimoreLA <- merge(dBaltimoreLA, dClassification, all.x = TRUE, all.y = FALSE)



dBaltimoreLA <- subset(dBaltimoreLA, grepl(pattern = "vehicle", dBaltimoreLA$SCC.Level.Two, ignore.case = TRUE))

dCounty <- data.frame(fips = c( "24510", "06037"), county = c("Baltimore City", "Los Angeles County"))

data <- aggregate(Emissions~year + fips, data = dBaltimoreLA, sum)

data <- merge(data, dCounty, all.x = TRUE, all.y = FALSE)


ggplot(data = data, aes(y = Emissions, x = year, group = county, color = county)) + 
    geom_line() + 
    ggtitle("PM2.5 emissions from 1999 to 2008 for Baltimore City") + 
    ylab("emissions of PM2.5 ")





dev.copy(png, "plot6.png" )
dev.off()

