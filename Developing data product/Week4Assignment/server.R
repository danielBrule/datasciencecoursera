# Define a server for the Shiny app
function(input, output) {
    
    # Fill in the spot we created for a plot
    output$NbCasualties <- renderPlot({
        DataToDisplay <- aggregate(data$Number_of_Casualties, by = list(data[, input$parameter]), FUN = sum)
        # Render a barplot
        row.names(DataToDisplay) <- DataToDisplay[,1]
        x <- as.matrix(DataToDisplay[, 2])
        rownames(x) <- DataToDisplay$Group.1
        
        barplot(t(x), 
                ylab="Number of casualties",
                las = 2)
    })
}