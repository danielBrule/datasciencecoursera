library(tm)
library(SnowballC)
library(stringr)
library(ggplot2)
library(data.tree)

Sys.time()
setwd("C:/datasciencecoursera/Capstone")



fct_PrepareData <- function(filepath){
    #read file 
    fileContent <- readChar(filepath, file.info(filepath)$size)
    
    #lower chartecters 
    fileContent <- tolower(fileContent)
    
    #lower chartecters 
    fileContent <- gsub(fileContent, pattern = "\t", replacement = " ")
    
    #remove characters
    fileContent <- removePunctuation(fileContent)

    #remove numbers 
    fileContent <- removeNumbers(fileContent)
    
    #split string in "phrase"
    fileContent <- strsplit(fileContent, "\r\n")[[1]]
    
    #remove empty "phrase"
    fileContent <- fileContent[fileContent != ""]
    
    #split string in word 
    fileContent <- sapply(fileContent, strsplit, split=" ", simplify = TRUE)
    
    #stem all words (not sure if it makes sense)
#    output <- sapply(fileContent, wordStem)    
    
    return(fileContent)
}

#############################################
#############################################
#############################################

fct_NbWordUsage <- function(subset){
    
    #create one long string 
    lString <- paste(sapply(subset,function(x){paste(x, collapse = " ")},simplify = T),collapse = " ")
    
    #create a corpus 
    corpus <- VCorpus(VectorSource(lString))


    #count the number of occurence of each word 
    tdm <- TermDocumentMatrix(corpus, control = list(global = c(1, Inf), wordLengths = c(1,20)))
    
    #put tdm in a data frame and order in on frequence (inverse)
    m <- as.matrix(tdm)
    output <- data.frame(word=rownames(m), freq = m)
    colnames(output) <- c("Word", "Count")
    output <- output[order(-output$Count), ]
    NbWords <- sum(output$Count)
    output$Freq <- output$Count / NbWords
    rownames(output) <- 1:nrow(output)
    
    return(output)
}

#############################################
#############################################
#############################################



fct_MostFrequentWord <- function(WordUsage, percent){
    WordUsage$Sum <- 0
    WordUsage[1,]$Sum <- WordUsage[1,]$Count
    
    for (i in 2:nrow(WordUsage)){
        WordUsage[i,]$Sum <- WordUsage[i,]$Count + WordUsage[i-1,]$Sum
    }
    TotalWord80PerCent <- sum(WordUsage$Count)*.95
    
    WordUsage$MostFreq <- WordUsage$Sum < TotalWord80PerCent
    MostFrequentWord <- WordUsage[WordUsage$MostFreq == TRUE,]$Word
    
    return(as.character(MostFrequentWord))
}





################################################################################
################################################################################
################################################################################
################################################################################




fct_build3Gram <- function(data, MostFrequentWord){
    
    root <- Node$new("RootNode")
    
    for(i in 1:length(data)){
        tmp <- data[i][[1]]
        tmp <- tmp[tmp != ""]
        if(length(tmp) < 3) {
            next
        }
        for (j in 1:(length(tmp) - 2)){
            w1 <- tmp[j]
            w2 <- tmp[j + 1]
            w3 <- tmp[j + 2]
            if (w1 %in% MostFrequentWord &
                w2 %in% MostFrequentWord &
                w3 %in% MostFrequentWord){
                
                N1 <- root$children[[w1]]
                if(is.null(N1))
                    N1 <- root$AddChild(w1)
                
                N2 <- N1$children[[w2]]
                if(is.null(N2))
                    N2 <- N1$AddChild(w2)
                
                N3 <- N2$children[[w3]]
                if(is.null(N3))
                    N3 <- N2$AddChild(w3)
                

                if(is.null(N3$nb)){
                    N3$nb <- 1
                } else {
                    N3$nb <- N3$nb +1 
                }
            }
        }
    }
    return(root)
}



#############################################
#############################################
#############################################


fct_cleanTree <- function(node){
    for (i in 1:length(node$children)){
        N1 <- node$children[[i]]
            
        for (j in 1:length(N1$children)){
            N2 <- N1$children[[j]]
            
            if (length(N2$children) != 1){
                leafs <- data.frame(nb= Get(N2$children, function(node) Aggregate(node, "nb", max)))
                leafs$name <- rownames(leafs)
                leafToKeep <- leafs[leafs$nb==max(leafs$nb),]$name
                k <- 1 
                while (k <= length(N2$children)){
                    if (N2$children[[k]]$name != leafToKeep){
                        N2$RemoveChild(N2$children[[k]]$name)
                    }
                    else {
                        k <- k + 1
                    }
                }
            }
        }
    }
    return(node)
}





#############################################
#############################################
#############################################


fct_treeToFrame <- function(node){
    #node <- ThreeGram
    nbLeaf <- node$leafCount
    
    output <- data.frame(w1 = rep("", nbLeaf),
                         w2 = rep("", nbLeaf),
                         w3 = rep("", nbLeaf), 
                         stringsAsFactors = FALSE)
    cpt <- 1 
    
    for (i in 1:length(node$children)){
        N1 <- node$children[[i]]
        w1 <- N1$name
        
        for (j in 1:length(N1$children)){
            N2 <- N1$children[[j]]
            w2 <- N2$name
            
            for (k in 1:length(N2$children)){
                N3 <- N2$children[[k]]
                w3 <- N3$name
                
                output[cpt, 1] <- w1 
                output[cpt, 2] <- w2 
                output[cpt, 3] <- w3
                cpt <- cpt +1 
            }
        }
    }

    return (output)
}

#############################################
#############################################
#############################################

Sys.time()
CleanUSBlog <- fct_PrepareData("final/en_US/en_US.blogs.txt")
CleanUSNews <- fct_PrepareData("final/en_us/en_US.news.txt")
CleanUSTwitter <- fct_PrepareData("final/en_US/en_US.twitter.txt")
wordset <- c(CleanUSBlog, CleanUSNews, CleanUSTwitter)
remove(list = c("CleanUSBlog", "CleanUSNews", "CleanUSTwitter"))

set.seed(42)
subset <- sample(wordset, 50000)

subsetStr <- paste(sapply(subset,function(x){paste(x, collapse = " ")},simplify = T),collapse = "\n")
write(subsetStr, "Subset50k.txt")

usedWord <- fct_NbWordUsage(subset)
MostFrequentWord <- fct_MostFrequentWord(usedWord, .95)
remove(usedWord)
write(MostFrequentWord, "MostFrequentWord50k.txt")

gc()

ThreeGram <- fct_build3Gram(subset, MostFrequentWord)
ThreeGram2 <- fct_cleanTree(ThreeGram)
ThreeGram3 <- fct_treeToFrame(ThreeGram2)

write.csv(ThreeGram3, file = "ThreeGram50k.csv")

ThreeGram4 <- fct_treeToFrame(ThreeGram2)
write.csv(ThreeGram4, file = "ThreeGram50k_notClean.csv")
