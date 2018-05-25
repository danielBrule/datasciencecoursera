library(tm)

        
        
setwd("C:/Coursera/Capstone/ShinyApps/Capstone")

NGram3 <- read.csv("Data/nGram3-small.csv")
NGram4 <- read.csv("Data/nGram4-small.csv")


fct_guessNextList <- function(sentence){
    #sentence <- "Enter your sentence..."
    #sentence <- "I am"
    sentence <- removeNumbers(sentence)
    sentence <- removePunctuation(sentence)
    sentence <- tolower(sentence)

    words <- unlist(strsplit(sentence, split = " " ))

    # only focus on last 5 words
    words <- tail(words, 3)

    if (length(words)< 2)
        return(NULL)

    if(length(words) == 2){
        word1 <- words[1];
        word2 <- words[2];
        word3 <- "";
    } else {
        word1 <- words[1];
        word2 <- words[2];
        word3 <- words[3];
    } 

    datasub4 <- subset(NGram4, w1==word1 & w2==word2 & w3==word3)
    if(nrow(datasub4) > 0){
        return (as.character(datasub4$w4) )
    }

    datasub3 <- subset(NGram3, w1==word1 & w2==word2)
    
    return (as.character(datasub3$w3) )
}







shinyServer(function(input, output, session) {
   
  output$Test <- renderText({

      
  })
  
  observeEvent(
      input$go,
      {
              possibleWords <- fct_guessNextList(input$sentence)
#              showModal(modalDialog( title = "step1",paste(possibleWords, collapse = "")))
              
              if(length(possibleWords) == 0){
                possibleWords <- c("")  
              } else {
                possibleWords <- possibleWords[1:min(length(possibleWords), input$MaxProposition)]
              }
              updateRadioButtons(session,
                                 inputId = "ProposedWordsButton",
                                 label = "Proposed words:",
                                 choices = possibleWords
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




