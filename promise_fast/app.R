#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(ggplot2)

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("mtcars Data"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      # uiOutput("my_ui")
      selectizeInput("cyl",
                     "Number of cylinders:",
                     choices = c("Choose cyl" = "", sort(unique(mtcars$cyl))),
                     selected = "",
                     multiple = FALSE)
      # actionButton("done", "Not Done Yet", icon = icon("refresh"))
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      tableOutput("mtcarsTable"),
      plotOutput("mtcarsPlot")
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
  
  # output$my_ui <- renderUI({
  #   tagList(
  #     selectizeInput("cyl",
  #                    "Number of cylinders:",
  #                    choices = c("Choose cyl" = "", sort(unique(mtcars$cyl))),
  #                    selected = "",
  #                    multiple = FALSE),
  #     tags$style("#mtcarsTable {background-color:#ff0000;}")
  #   )
  # })
  
  slow_mtcars <- function() {
    future({
      Sys.sleep(5)
      mtcars
    })
  }
  
  slow_table <- reactive({
    slow_mtcars() %...>% 
      filter(cyl == input$cyl) %...>%
      arrange(hp) %...>%
      head(10)
  })
  
  fast_table <- mtcars %>% 
    arrange(cyl) %>% 
    head(10)
  
  output$mtcarsTable <- renderTable({
    if (input$cyl != "") {
      slow_table()
    } else {
      fast_table
    }
  })
  
  slow_plot <- reactive({
    
    # future({ 
    #   # Sys.sleep(10)
    #   insertUI(
    #     selector = "body > div > div > div.col-sm-4",
    #     where = "afterEnd",
    #     ui = tags$div(
    #       tags$p("Finished Calculation!"), 
    #       id = "donetxt"
    #     )
    #   )
    # })
    
    slow_mtcars() %...>% 
      filter(cyl == input$cyl) %...>%
      arrange(hp) %...>%
      { ggplot(., aes(mpg, hp)) + geom_point() }
  })
  
  output$mtcarsPlot <- renderPlot({
    if (input$cyl == "") {
      ggplot()
    } else {
      slow_plot()
    }
    
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)

