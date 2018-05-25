



fluidPage(
    titlePanel("Coursera Data Science - Capstone Project"),
    
    sidebarLayout(
        
        sidebarPanel(
            textInput("sentence", "Sentence to be completed", "Enter your sentence..."),
            sliderInput("MaxProposition", "Maximum number of proposition",
                        0, 10, 5, step = 1),
            hr(),
            actionButton("go", label = "Guess next word")
            ),
        
        mainPanel(
            tabsetPanel(
                tabPanel("Words", 
                         textOutput("ProposedWords"),
                         radioButtons('ProposedWordsButton', "Proposed words:", c("")),
                         actionButton('submit', label = "Insert word")
                         ),
                tabPanel("Documentation", textOutput("Documentation"))
                )
            )
        )
  )

