
library(tm)
library(SnowballC)
library(stringr)
library(ggplot2)
library(data.tree)
library(data.table)
library(dplyr)
Sys.time()
setwd("C:/coursera/Capstone")



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



################################################################################
################################################################################
################################################################################
################################################################################




fct_buildNGram <- function(data, N){
# data <- corp    
# N <- 3 
  
  tokens <- function(x) unlist(lapply(ngrams(words(x), N), paste, collapse = " "), use.names = FALSE)
  tdm <- TermDocumentMatrix(data, control = list(tokenize = tokens))
  tdmr <- sort(slam::row_sums(tdm, na.rm = T), decreasing=TRUE)
  tdmr.t <- data.table(token = names(tdmr), count = unname(tdmr)) 
  tdmr.t[,  paste0("w", seq(N)) := tstrsplit(token, " ", fixed=TRUE)]
  # remove source token to save memory
  tdmr.t$token <- NULL
  return(as.data.frame(tdmr.t))
}


#####################################################################
Sys.time()
CleanUSBlog <- fct_PrepareData("final/en_US/en_US.blogs.txt")
CleanUSNews <- fct_PrepareData("final/en_us/en_US.news.txt")
CleanUSTwitter <- fct_PrepareData("final/en_US/en_US.twitter.txt")
wordset <- c(CleanUSBlog, CleanUSNews, CleanUSTwitter)
remove(list = c("CleanUSBlog", "CleanUSNews", "CleanUSTwitter"))
set.seed(42)
subset <- sample(wordset, length(wordset)*.2)
remove(wordset)
subsetStr <- paste(sapply(subset,function(x){paste(x, collapse = " ")},simplify = T),collapse = "\n")
write(subsetStr, "Subset.txt")
gc()



corp <- VCorpus(VectorSource(subsetStr))
corp <- tm_map(corp, PlainTextDocument)
NGram <- fct_buildNGram(corp, 5)
write.csv(NGram, "NGram5.csv")
gc()
NGram <- fct_buildNGram(corp, 6)
write.csv(NGram, "NGram6.csv")
gc()
rm(NGram)
rm(corp)
rm(subsetStr)
rm(subset)












Sys.time()
CleanUSBlog <- fct_PrepareData("final/en_US/en_US.blogs.txt")
CleanUSNews <- fct_PrepareData("final/en_us/en_US.news.txt")
CleanUSTwitter <- fct_PrepareData("final/en_US/en_US.twitter.txt")
wordset <- c(CleanUSBlog, CleanUSNews, CleanUSTwitter)
remove(list = c("CleanUSBlog", "CleanUSNews", "CleanUSTwitter"))
set.seed(42)
subset <- sample(wordset, length(wordset)*.6)
remove(wordset)
subsetStr <- paste(sapply(subset,function(x){paste(x, collapse = " ")},simplify = T),collapse = "\n")
write(subsetStr, "Subset.txt")
gc()
corp <- VCorpus(VectorSource(subsetStr))
corp <- tm_map(corp, PlainTextDocument)
rm(subsetStr)
rm(subset)
gc()
NGram <- fct_buildNGram(corp, 3)
write.csv(NGram, "NGram3-3.csv")
gc()
NGram <- fct_buildNGram(corp, 4)
write.csv(NGram, "NGram4-3.csv")
gc()
