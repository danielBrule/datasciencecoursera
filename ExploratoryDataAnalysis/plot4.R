library(ggplot2)

setwd("C:/datasciencecoursera/ExploratoryDataAnalysis")

dClassification <- readRDS("Source_Classification_Code.rds")
dSummary <- readRDS("summarySCC_PM25.rds")

dPolluant <- merge(dSummary, dClassification)

dPolluant <- subset(dPolluant, grepl(pattern = "Combustion", dPolluant$SCC.Level.One))
dPolluant <- subset(dPolluant, grepl(pattern = "Coal", dPolluant$SCC.Level.Four, ignore.case = TRUE))


data <- aggregate(Emissions~year, data = dPolluant, sum)


ggplot(data = data, aes(y = Emissions, x = year)) + 
    geom_bar(stat = "identity") + 
    ggtitle("PM2.5 emissions from coal combustion-related sourcesfrom 1999 to 2008") + 
    ylab("emissions of PM2.5 ")



dev.copy(png, "plot4.png" )
dev.off()

