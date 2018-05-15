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

Sys.time()
CleanUSBlog <- fct_PrepareData("final/en_US/en_US.blogs.txt")
CleanUSNews <- fct_PrepareData("final/en_US/en_US.news.txt")
CleanUSTwitter <- fct_PrepareData("final/en_US/en_US.twitter.txt")
Sys.time()

wordset <- c(CleanUSBlog, CleanUSNews, CleanUSTwitter)



fct_MostUsedWords <- function(wordsSet, NbDocuments){
    set.seed(42)
    #take a subset of the documents
    subset <- sample(wordsSet, NbDocuments)
    
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
wordSet200K <- fct_MostUsedWords(wordset, 200000)




wordSet200K$Sum <- 0
wordSet200K[1,]$Sum <- wordSet200K[1,]$Count

for (i in 2:nrow(wordSet200K)){
    wordSet200K[i,]$Sum <- wordSet200K[i,]$Count + wordSet200K[i-1,]$Sum
}
TotalWord80PerCent <- sum(wordSet200K$Count)*.95

wordSet200K$MostFreq <- wordSet200K$Sum < TotalWord80PerCent
MostFrequentWord <- wordSet200K[wordSet200K$MostFreq == TRUE,]$Word




remove(list=c("wordSet200K","TotalWord80PerCent","i"))


################################################################################
################################################################################
################################################################################
################################################################################


MostFrequentWord2 <- as.character(MostFrequentWord)



fct_build3Gram <- function(data, NbDocuments){
    set.seed(42)
    data <- sample(data, NbDocuments)
    
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
            if (w1 %in% MostFrequentWord2 &
                w2 %in% MostFrequentWord2 &
                w3 %in% MostFrequentWord2){
                
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

Sys.time()
t <- Sys.time()
ThreeGram <- fct_build3Gram(wordset, 200000)
Sys.time() - t        



save(ThreeGram, file = 'threeGram.Rdata')


remove(list = c("CleanUSBlog", "CleanUSNews", "CleanUSTwitter", "MostFrequentWord"))
remove(list=c("fct_build3Gram", "fct_MostUsedWords", "fct_PrepareData"))



#############################################

#t <- Sys.time()
#load('threeGram.Rdata')
#Sys.time() - t        


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


ThreeGramClean <- fct_cleanTree(ThreeGram)
save(ThreeGramClean, file = 'threeGramClean.Rdata')

