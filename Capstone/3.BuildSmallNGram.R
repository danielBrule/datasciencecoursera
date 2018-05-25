library(tm)
library(SnowballC)

setwd("C:/coursera/Capstone")






NGram6 <- read.csv("NGram6.csv")
NGram5 <- read.csv("NGram5.csv")
NGram4 <- read.csv("NGram4.csv")
NGram3 <- read.csv("NGram3.csv")


NGram6 <- subset(NGram6, select = -c(X))
NGram6 <- NGram6[order(NGram6$w1,
                       NGram6$w2,
                       NGram6$w3,
                       NGram6$w4,
                       NGram6$w5, 
                       NGram6$count, 
                       decreasing = TRUE),]
NGram6 <- NGram6[NGram6$count!=1,]




NGram5 <- subset(NGram5, select = -c(X))
NGram5 <- NGram5[order(NGram5$w1,
                       NGram5$w2,
                       NGram5$w3,
                       NGram5$w4,
                       NGram5$count, 
                       decreasing = TRUE),]
NGram5 <- NGram5[NGram5$count!=1,]


NGram4 <- subset(NGram4, select = -c(X))
NGram4 <- NGram4[order(NGram4$w1,
                       NGram4$w2,
                       NGram4$w3,
                       NGram4$count, 
                       decreasing = TRUE),]
NGram4 <- NGram4[NGram4$count!=1,]


NGram3 <- subset(NGram3, select = -c(X))
NGram3 <- NGram6[order(NGram3$w1,
                       NGram3$w2,
                       NGram3$count, 
                       decreasing = TRUE),]
NGram3 <- NGram3[NGram3$count!=1,]



write.csv(NGram3, file = "nGram3-small.csv")
write.csv(NGram4, file = "nGram4-small.csv")
write.csv(NGram5, file = "nGram5-small.csv")
write.csv(NGram6, file = "nGram6-small.csv")