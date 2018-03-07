setwd("C:/datasciencecoursera/R_Programming/week2")


computeFileName <- function (id){
    if (id < 10){
        filename <- paste("00", id, sep = "")
    } else if (id < 100){
        filename <- paste("0", id, sep = "")
    } else {
        filename <- as.character(id)
    }
    paste(filename, "csv", sep = ".")
}

################################################################################
################################################################################
################################################################################


pollutantmean <- function(directory, polluant, id=1:332){
    oldDirectory <- getwd()
    setwd(directory)
    values <- vector()
    for (i in id){
        data <- read.csv(computeFileName(i))       
        data <- data[[polluant]]
        data <- data[!is.na(data)]
        values<- c(values, data)
    }
    setwd(oldDirectory)
    mean(values)
}

pollutantmean("specdata", "sulfate", 1:10)
pollutantmean("specdata", "nitrate", 70:72)
pollutantmean("specdata", "nitrate", 23)


################################################################################ 
################################################################################
################################################################################

complete <- function (directory, id= 1:332){
    oldDirectory <- getwd()
    setwd(directory)
    output <- data.frame(id=integer(), nobs=integer())
    for (i in id){
        data <- read.csv(computeFileName(i))       
        data <- data[complete.cases(data),]
        df <- data.frame(id=i, nobs= nrow(data))
        output <- rbind(output, df)
    }
    setwd(oldDirectory)
    output
}

complete("specdata", 1)
complete("specdata", c(2, 4, 8, 10, 12))
complete("specdata", 30:25)
complete("specdata", 3)

################################################################################
################################################################################
################################################################################

corr <- function (directory, threshold= 0){
    oldDirectory <- getwd()
    setwd(directory)
    output <- vector()
    for (i in list.files()){
        data <- read.csv(i)       
        data <- data[complete.cases(data),]
        if (nrow(data) > threshold){
            output <- c(output, cor(data$nitrate, data$sulfate, use="complete.obs"))
        }
    }
    setwd(oldDirectory)
    output
}
cr <- corr("specdata", 150)
head(cr)
summary(cr)

cr <- corr("specdata", 400)
head(cr)
summary(cr)

cr <- corr("specdata", 5000)
summary(cr)
length(cr)

cr <- corr("specdata")
summary(cr)
length(cr)