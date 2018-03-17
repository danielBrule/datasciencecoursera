
setwd("C:/datasciencecoursera/ExploratoryDataAnalysis")

#dClassification <- readRDS("Source_Classification_Code.rds")
dSummary <- readRDS("summarySCC_PM25.rds")

data <- tapply(dSummary$Emissions, dSummary$year, sum)

data <- data.frame(year = row.names(data), emission = data)

barplot(data$emission, 
        names.arg = data$year, 
        xlab = "year", 
        ylab = "Emission", 
        main = "total emissions of PM2.5")

dev.copy(png, "plot1.png" )
dev.off()