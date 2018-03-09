library(plyr)

setwd("C:/datasciencecoursera/R_Programming/week4")




################################################################################
################################################################################
################################################################################
dataOutcome <- read.csv("outcome-of-care-measures.csv", colClasses = "character")

head(dataOutcome)
ncol(dataOutcome)
names(dataOutcome)

dataOutcome[, 11] <- as.numeric(dataOutcome[, 11])
hist(dataOutcome[, 11])

dataOutcome<- dataOutcome[c(2,7,11,17,23)]
names(dataOutcome) <- c ("name", "state", "heart attack","heart failure", "pneumonia")

dataOutcome[,3] <- as.numeric(dataOutcome[,3])
dataOutcome[,4] <- as.numeric(dataOutcome[,4])
dataOutcome[,5] <- as.numeric(dataOutcome[,5])



best <- function(state, outcome){
    data <- dataOutcome
    #test if valid state 
    if (!state %in% unique(data$state)){
        stop("invalid state")
    }
    
    if (!outcome %in% c("heart attack","heart failure", "pneumonia")){
        stop("invalid outcome")
    }
    data <- data[data$state == state, ]
        
    if (outcome == "heart attack"){
        data <- data[!is.na(data[3]),]
        data <- arrange(data, data[3], data$name)
        
    } else if (outcome == "heart failure"){
        data <- data[!is.na(data[4]),]
        data <- arrange(data, data[4], data$name)
        
    } else {
        data <- data[!is.na(data$pneumonia),]
        data <- arrange(data, data$pneumonia, data$name)
        
    }
    data$name[1]
}

best("TX", "heart attack")
best("TX", "heart failure")
best("MD", "heart attack")
best("MD", "pneumonia")

best("BB", "heart attack")
best("NY", "hert attack")

best("SC", "heart attack")
best("NY", "pneumonia")
best("AK", "pneumonia")

################################################################################
################################################################################
################################################################################

dataOutcome <- read.csv("outcome-of-care-measures.csv", colClasses = "character")

dataOutcome<- dataOutcome[c(2,7,11,17,23)]
names(dataOutcome) <- c ("name", "state", "heart attack","heart failure", "pneumonia")

dataOutcome[,3] <- as.numeric(dataOutcome[,3])
dataOutcome[,4] <- as.numeric(dataOutcome[,4])
dataOutcome[,5] <- as.numeric(dataOutcome[,5])


rankhospital <- function(state, outcome, num = "best") {
    data <- dataOutcome
    if (!state %in% unique(data$state)){
        stop("invalid state")
    }
    
    if (!outcome %in% c("heart attack","heart failure", "pneumonia")){
        stop("invalid outcome")
    }
        if (!is.numeric(num) & num != "best" & num != "worst"){
        stop("invalid num")
    }
    
    data <- data[data$state == state, ]
    if (outcome == "heart attack"){
        data <- data[!is.na(data[3]),]
        data <- arrange(data, data[3], data$name)
        
    } else if (outcome == "heart failure"){
        data <- data[!is.na(data[4]),]
        data <- arrange(data, data[4], data$name)
        
    } else {
        data <- data[!is.na(data$pneumonia),]
        data <- arrange(data, data$pneumonia, data$name)
        
    }
    if(is.numeric(num)){
        if (num > nrow(data)){
            return (NA)
        } else {
            return (data$name[num])
            
        }
    } else if (num == "best"){
        return (data$name[1])
    } else {
        return (data$name[nrow(data)])
    }
    
}
rankhospital("TX", "heart failure", 4)
rankhospital("MD", "heart attack", "worst")
rankhospital("MN", "heart attack", 5000)

rankhospital("NC", "heart attack", "worst")
rankhospital("WA", "heart attack", 7)
rankhospital("TX", "pneumonia", 10)
rankhospital("NY", "heart attack", 7)

################################################################################
################################################################################
################################################################################

dataOutcome <- read.csv("outcome-of-care-measures.csv", colClasses = "character")

dataOutcome<- dataOutcome[c(2,7,11,17,23)]
names(dataOutcome) <- c ("name", "state", "heart attack","heart failure", "pneumonia")


dataOutcome[,2] <- as.factor(dataOutcome[,2])
dataOutcome[,3] <- as.numeric(dataOutcome[,3])
dataOutcome[,4] <- as.numeric(dataOutcome[,4])
dataOutcome[,5] <- as.numeric(dataOutcome[,5])


extract <- function(data, outcome, num){
    if (outcome == "heart attack"){
        data <- data[!is.na(data[3]),]
        data <- arrange(data, data[3], data$name)
        
    } else if (outcome == "heart failure"){
        data <- data[!is.na(data[4]),]
        data <- arrange(data, data[4], data$name)
        
    } else {
        data <- data[!is.na(data$pneumonia),]
        data <- arrange(data, data$pneumonia, data$name)
        
    }
    
    if(is.numeric(num)){
        if (num > nrow(data)){
            outcome <- NA
        } else {
            outcome <- data$name[num]
            
        }
    } else if (num == "best"){
        outcome <- data$name[1]
    } else {
        outcome <- data$name[nrow(data)]
    }
    data.frame(hospital = outcome, state =data$state[1])
}


rankall <- function(outcome, num = "best") {
    data <- dataOutcome
    if (!outcome %in% c("heart attack","heart failure", "pneumonia")){
        stop("invalid outcome")
    }
    if (!is.numeric(num) & num != "best" & num != "worst"){
        stop("invalid num")
    }

    data <- split(data, data$state)
    
    output <- lapply(data, extract, outcome = outcome, num = num)
    

    return (    do.call(rbind, output))
}
head(rankall("heart attack", 20), 10)
tail(rankall("pneumonia", "worst"), 3)
tail(rankall("heart failure"), 10)

r <- rankall("heart attack", 4)
as.character(subset(r, state == "HI")$hospital)
r <- rankall("pneumonia", "worst")
as.character(subset(r, state == "NJ")$hospital)

r <- rankall("heart failure", 10)
as.character(subset(r, state == "NV")$hospital)
