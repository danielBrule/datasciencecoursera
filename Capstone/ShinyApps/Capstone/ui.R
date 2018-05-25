



fluidPage(
    titlePanel("Coursera Data Science - Capstone Project"),
    
    sidebarLayout(
        
        sidebarPanel(
            textInput("sentence", "Sentence to be completed", "Enter your sentence..."),
            sliderInput("MaxProposition", "Maximum number of proposition",
                        0, 10, 5, step = 1),
            hr(),
            actionButton("go", label = "Go")
            ),
        
        mainPanel(
            tabsetPanel(
                tabPanel("Words", 
                         textOutput("ProposedWords"),
                         radioButtons('ProposedWordsButton', "Proposed words:", c("NULL")),
                         actionButton('submit', label = "Submit")
                         ),
                tabPanel("NGram", tableOutput("NGram")),
                tabPanel("Documentation", textOutput("Documentation"))
                )
            )
        )
  )

