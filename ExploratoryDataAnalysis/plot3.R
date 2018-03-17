library(ggplot2)

setwd("C:/datasciencecoursera/ExploratoryDataAnalysis")

#dClassification <- readRDS("Source_Classification_Code.rds")
dSummary <- readRDS("summarySCC_PM25.rds")
dBaltimore <- subset(dSummary, fips == "24510")


data <- aggregate(Emissions~year + type, data = dBaltimore, sum)


ggplot(data = data, aes(y = Emissions, x = year, group = type, color = type)) + 
    geom_line() + 
    ggtitle("PM2.5 emissions from 1999 to 2008 for Baltimore City") + 
    ylab("emissions of PM2.5 ")



dev.copy(png, "plot3.png" )
dev.off()

