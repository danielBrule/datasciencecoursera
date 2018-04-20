# Use a fluid Bootstrap layout
fluidPage(    
    
    # Give the page a title
        titlePanel("Incident By Cause"),
    
    # Generate a row with a sidebar
    sidebarLayout(      
        
        # Define the sidebar with one input
        sidebarPanel(
            selectInput("parameter", "Parameter:", 
                        choices=c(        
                                  "Number_of_Casualties", 
                                  "Number_of_Vehicles",           
                                  "Road_Type", 
                                  "Date", 
                                  "Light_Conditions",         
                                  "Weather_Conditions")),
            hr(),
            helpText("fatal incident in UK 2016 downloaded from UK open data website: http://data.dft.gov.uk/road-accidents-safety-data/")
        ),
        
        # Create a spot for the barplot
        mainPanel(
            plotOutput("NbCasualties")  
        )
        
    )
)