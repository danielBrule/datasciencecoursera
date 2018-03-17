
setwd("C:/datasciencecoursera/ExploratoryDataAnalysis")

#dClassification <- readRDS("Source_Classification_Code.rds")
dSummary <- readRDS("summarySCC_PM25.rds")

dBaltimore <- subset(dSummary, fips == "24510")


data <- tapply(dBaltimore$Emissions, dBaltimore$year, sum)


data <- data.frame(year = row.names(data), emission = data)

barplot(data$emission, 
        names.arg = data$year, 
        xlab = "year", 
        ylab = "Emission", 
        main = "total emissions of PM2.5 for Baltimore")

dev.copy(png, "plot2.png" )
dev.off()