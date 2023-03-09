#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

ui <- fluidPage(

    titlePanel("Info PS6"),
   tabsetPanel(
      tabPanel("Overview"),
    sidebarLayout(
        sidebarPanel(
            
        ),
        mainPanel(
           plotOutput("distPlot")
        )
    ),
    tabPanel("Data Plot"),
    sidebarLayout(
      sidebarPanel(
        
      ),
      mainPanel(
        
        
      )
    ),
    
    tabPanel("Table"),
    sidebarLayout(
      sidebarPanel(
        
      ),
      mainPanel(
        
      )
    ),
  
  
  )
)

server <- function(input, output) {

    output$distPlot <- renderPlot({
     
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
