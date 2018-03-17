library(ggplot2)

setwd("C:/datasciencecoursera/ExploratoryDataAnalysis")

dClassification <- readRDS("Source_Classification_Code.rds")
dSummary <- readRDS("summarySCC_PM25.rds")

dBaltimore <- subset(dSummary, fips == "24510")

dBaltimore <- merge(dBaltimore, dClassification, all.x = TRUE, all.y = FALSE)



dBaltimore <- subset(dBaltimore, grepl(pattern = "vehicle", dBaltimore$SCC.Level.Two, ignore.case = TRUE))



data <- aggregate(Emissions~year, data = dBaltimore, sum)


ggplot(data = data, aes(y = Emissions, x = year)) + 
    geom_bar(stat = "identity") + 
    ggtitle("PM2.5 emissions from motor vehicle sources from 1999 to 2008") + 
    ylab("emissions of PM2.5 ")



dev.copy(png, "plot5.png" )
dev.off()

