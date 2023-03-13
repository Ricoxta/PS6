#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)

libdata <- read_delim("Checkouts_by_Title.csv")

ui <- fluidPage(

    titlePanel("Info PS6"),
   tabsetPanel(
      tabPanel("Overview",
            p("The dataset I will be using is library data from the", strong("Seattle Public Library", ".")),
            p("This data consists of metadata on books including the", em("author"),",", em("ISBN"),",", em("Publication Year"),",", em("Subjects"),",", em("Usage Type"),",", "and", em("more")),
            p("The dataset has ", strong(em(ncol(libdata))), "columns and ", strong(em(nrow(libdata))), "rows"),
        mainPanel(
          
        )
    ),
    tabPanel("Data Plot",
    sidebarLayout(
      sidebarPanel(
      sliderInput("time", "Year Range",min = 2005, max = 2022, c(2005, 2022),sep = ""),
      radioButtons("pal", "Choose a color palette:", choices = c("Set2", "Accent")),
      checkboxGroupInput("usage", "Pick a usage form:", choices = c("Physical", "Digital"), selected = c("Physical"))
      ),
      mainPanel(
      plotOutput("usagePlot"),
      p("The amount of observations: ", textOutput("obs"))
      )
    )
    ),
    
    tabPanel("Table",
    sidebarLayout(
      sidebarPanel(
        radioButtons("period", "Choose period of checkouts:", choices = c("CheckoutYear", "CheckoutMonth"), selected = c("CheckoutYear")),
        p("Minimum:",textOutput("min"), "Maximum:", textOutput("max"))
  
        
        

      ),
      mainPanel(
        dataTableOutput("table"),
        
        
                
      )
    )
    )
  
  
  )
)

server <- function(input, output) {
  
  popData <- reactive({
    libdata %>% 
      group_by(CheckoutYear,UsageClass) %>%
      filter(CheckoutYear != 2023,
             CheckoutYear <= input$time[2] & CheckoutYear >= input$time[1],
             UsageClass %in% input$usage) %>% 
              summarise(n = sum(Checkouts))
  })
    
    output$usagePlot <- renderPlot({
     popData() %>% 
        ggplot(aes(x = CheckoutYear, y = n, fill = UsageClass))+
        geom_col(position = "dodge")+
        scale_fill_brewer(palette = input$pal)+
        labs(x = "Checkout Year",
             y = "Amount of Checkouts",
             title = "Usage between Digital and Physical Over Time")
    })

  output$obs <- renderText({
   popData() %>% 
     nrow()
      })
       
 
    output$table <- renderDataTable({
      if(input$period == "CheckoutYear"){
        libdata %>%
          group_by(CheckoutYear) %>%
          summarise(total_checkouts = sum(Checkouts))
        
      }else{
        libdata %>%
          group_by(CheckoutMonth) %>%
          summarise(total_checkouts = sum(Checkouts))
      }
    })
    
    #Getting min
    output$min <- renderText({
        if(input$period == "CheckoutYear"){
          mc <- libdata %>% group_by(CheckoutYear) %>%  summarise(sc = sum(Checkouts))
          mc %>% 
            summarise(m = min(sc)) %>% 
            pull(m)  
            
        }else{
          mc <- libdata %>% group_by(CheckoutMonth) %>% summarise(sc = sum(Checkouts))
          mc %>% 
            summarise(m = min(sc)) %>% 
            pull(m) 
        }
        

    })
      
        
    #getting max
    output$max <- renderText({
      if(input$period == "CheckoutYear"){
        mc <- libdata %>% 
          group_by(CheckoutYear) %>% 
          summarise(sc = sum(Checkouts))
        mc %>% 
          max()
      }else{
        mc <- libdata %>% 
          group_by(CheckoutMonth) %>% 
          summarise(sc = sum(Checkouts))
        mc %>% 
          summarise(m = max(sc)) %>% 
          pull(m)
      }
      
      
    })
    

      
 
    
}



# Run the application 
shinyApp(ui = ui, server = server)
