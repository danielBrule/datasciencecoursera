library(shiny)
library(tm)


# setwd("C:/Coursera/Capstone/ShinyApps/Capstone")
# 
# NGram3 <- read.csv("Data/nGram3-small.csv")
# NGram4 <- read.csv("Data/nGram4-small.csv")
# NGram5 <- read.csv("Data/nGram5-small.csv")
# NGram6 <- read.csv("Data/nGram6-small.csv")
# 
# 
# fct_guessNext <- function(sentence){
#     #sentence <- "I am"
#     sentence <- removeNumbers(sentence)
#     sentence <- removePunctuation(sentence)
#     sentence <- tolower(sentence)
#     
#     words <- unlist(strsplit(sentence, split = " " ))
#     
#     # only focus on last 5 words
#     words <- tail(words, 5)
#     
#     if (length(words)< 2)
#         return(NULL)
#     
#     if(length(words) == 2){
#         word1 <- "";
#         word2 <- "";
#         word3 <- "";
#         word4 <- words[1];
#         word5 <- words[2];
#     } else if (length(words) == 3){
#         word1 <- "";
#         word2 <- "";
#         word3 <- words[1];
#         word4 <- words[2];
#         word5 <- words[3];
#     } else if (length(words) == 4){
#         word1 <- "";
#         word2 <- words[1];
#         word3 <- words[2];
#         word4 <- words[3];
#         word5 <- words[4];
#     } else {
#         word1 <- words[1];
#         word2 <- words[2];
#         word3 <- words[3];
#         word4 <- words[4];
#         word5 <- words[5];
#     }
#     
#     
#     
#     
#     datasub6 <- subset(NGram6, w1==word1 & w2==word2 & w3==word3 & w4==word4 & w5==word5)
#     if(nrow(datasub6) > 0){
#         return(datasub6)
#     }
#     
#     datasub5 <- subset(NGram5, w1==word1 & w2==word2 & w3==word4 & w4==word5)
#     if(nrow(datasub5) > 0){
#         return(datasub5)
#     }
#     
#     datasub4 <- subset(NGram4, w1==word3 & w2==word4 & w3==word5)
#     if(nrow(datasub4) > 0){
#         return(datasub4)
#     }
#     
#     datasub3 <- subset(NGram3, w1==word4 & w2==word5)
#     return(datasub3)
# }







shinyServer(function(input, output, session) {
   
  output$Test <- renderText({

      
  })
  
  observeEvent(
      input$go,
      {
              # possibleWords <- fct_guessNext(input$sentence)
              # options <- c("item 1", "item 2", "item 3")
              updateRadioButtons(session,
                                 inputId = "ProposedWordsButton",
                                 label = "Proposed words:",
                                 choices = c("item 1", "item 2", "item 3")
                                 )
      }
  )
  
  observeEvent(
      input$submit,
      {
          updateTextInput(session, 
                          inputId =  "sentence", 
                          value = paste(input$sentence, input$ProposedWordsButton))
      }
  )
  
  

  output$Documentation <- renderText({
    "The objective of the App is implementing a predictive model that offers hints to one or more words, coherent to the sentence that's been input by its user. The Capstone dataset used includes twitter, news and blogs from HC Corpora. After performing data cleansing, sampling and sub-setting, we gather all data in R data frames. Applying some Text Mining (TM) and NLP techniques, is created some set of word combinations (N-grams)."
  })
  
})




