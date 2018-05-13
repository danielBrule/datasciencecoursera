#install.packages("SnowballC")
library(tm)
library(SnowballC)
library(stringr)

setwd("C:/datasciencecoursera/Capstone")



fct_PrepareData <- function(filepath){
    #filepath <- "final/en_US/en_US.blogs.txt"
    
    #read file 
    fileContent <- readChar(filepath, file.info(filepath)$size)
    
    #lower chartecters 
    fileContent <- tolower(fileContent)
    
    #remove numbers 
    fileContent <- removeNumbers(fileContent)
    
    #split string in "phrase"
    fileContent <- strsplit(fileContent, "\\.|\r\n|\\?|!|\\(|\\)|-|_")[[1]]

    #remove empty "phrase"
    fileContent <- fileContent[fileContent != ""]
    
    #split string in word 
    fileContent <- sapply(fileContent, strsplit, split=" ", simplify = TRUE)
    
    #stem all words (not sure if it makes sense)
    output <- sapply(fileContent, wordStem)    

    return(output)
}




fct_MostUsedWords <- function(wordsSet, NbDocuments){
    #wordsSet <- wordset
    #NbDocuments <- 10
    
    set.seed(42)
    #take a subset of the documents
    subset <- sample(wordsSet, NbDocuments)
    
    #create one long string 
    lString <- paste(sapply(subset,function(x){paste(x, collapse = " ")},simplify = T),collapse = ";")
    
    #create a corpus 
    corpus <- Corpus(VectorSource(lString))
    
    #count the number of occurence of each word 
    tdm <- TermDocumentMatrix(corpus, control = list(list(global = c(1, Inf), wordLengths = c(1,20)))) 
    
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




fct_build3Gram <- function(data, output){
    #data <- head(CleanUSTwitter, 1000)
    #output <- NULL
    #i <- 1
    #j <- 1 
#    Rprof("out")
    nbRow <- 1000000
    curPos <- 1 
    if(is.null(output)){
        output <- data.frame(Word1 = rep("", nbRow), 
                             Word2 = rep("", nbRow), 
                             Word3 = rep("", nbRow), 
                             Freq = rep(0, nbRow), stringsAsFactors = FALSE)
    }
    for(i in 1:length(data)){
        tmp <- data[i][[1]]
        tmp <- tmp[tmp != ""]
#        cat("i :", i, "\n")
 #       cat("curPos :", curPos,  "\n")
        if(length(tmp) < 3) {
            next
            }
        
        for (j in 1:(length(tmp) - 2)){
            w1 <- tmp[j]
            w2 <- tmp[j + 1]
            w3 <- tmp[j + 2]

            lineId <- output[output$Word1 == w1 & output$Word2 == w2 & output$Word3 == w3, ]
            if (nrow(lineId) == 0){
                output[curPos, ] <- list(w1, w2, w3, 1)
                curPos <- curPos + 1 
            }else{
                output[output$Word1 == w1 & output$Word2 == w2 & output$Word3 == w3, ]$Freq <- 
                    lineId[1,4]+ 1 
            }
            }
    }
#    Rprof(NULL)
 #   summaryRprof("out")
    return(output)
    
}



Sys.time()
CleanUSBlog <- fct_PrepareData("final/en_US/en_US.blogs.txt")
Sys.time()
CleanUSNews <- fct_PrepareData("final/en_US/en_US.news.txt")
Sys.time()
CleanUSTwitter <- fct_PrepareData("final/en_US/en_US.twitter.txt")
Sys.time()


wordset <- c(CleanUSBlog, CleanUSNews, CleanUSTwitter)

remove(CleanUSBlog)
remove(CleanUSNews)
remove(CleanUSTwitter)



Sys.time()
wordSet50K <- fct_MostUsedWords(wordset, 50000)
Sys.time()
wordSet100K <- fct_MostUsedWords(wordset, 100000)
Sys.time()
wordSet200K <- fct_MostUsedWords(wordset, 200000)
Sys.time()
wordSet500K <- fct_MostUsedWords(wordset, 500000)
Sys.time()
wordSet1000K <- fct_MostUsedWords(wordset, 1000000)
Sys.time()

Sys.time()
a <- fct_build3Gram(head(CleanUSTwitter, 500), NULL)
Sys.time()
b <- fct_build3Gram(head(CleanUSTwitter, 1000), NULL)
Sys.time()
c <- fct_build3Gram(head(CleanUSTwitter, 5000), NULL)
Sys.time()
d <- fct_build3Gram(head(CleanUSTwitter, 50000), NULL)
Sys.time()

fct_build3Gram(CleanUSTwitter, NULL)


