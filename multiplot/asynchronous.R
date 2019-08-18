#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(future)
library(promises)
library(dplyr)
plan(multiprocess, workers = 4)
# plan(sequential)

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("Asynchronous Plotting"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput("long", "Long-Running", c("11", "12", "13",
                                                   "21", "22", "23",
                                                   "31", "32", "33")),
      actionButton("makePlot", "GO!")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      column(3,
             fluidRow(
               plotOutput("slice11", width="200px", height="200px"),
               plotOutput("slice12", width="200px", height="200px"),
               plotOutput("slice13", width="200px", height="200px")
             )),
      column(3,
             fluidRow(
               plotOutput("slice21", width="200px", height="200px"),
               plotOutput("slice22", width="200px", height="200px"),
               plotOutput("slice23", width="200px", height="200px")
             )),
      column(3,
             fluidRow(
               plotOutput("slice31", width="200px", height="200px"),
               plotOutput("slice32", width="200px", height="200px"),
               plotOutput("slice33", width="200px", height="200px")
             ))
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  future_dat <- eventReactive(input$makePlot, {
    cat("Taking a long time: ", isolate(input$long))
    function(long) {
    future({ 
      n <- ifelse(long, 3, 1)
      Sys.sleep(ifelse(long, 2, 0))
      data.frame(x = runif(10^n), y = runif(10^n))
    })
    } 
  })
  
  clean_plot <- function(d) {
    ggplot(d, aes(x, y)) + 
      geom_point() + 
      coord_equal(xlim = c(0, 1), ylim = c(0, 1)) +
      theme_minimal() + 
      theme(axis.text = element_blank(), 
            axis.title = element_blank(),
            panel.border = element_rect(colour = "black", fill=NA, size=2))
  }
  
  output$slice11 <- renderPlot({
    future_dat()(long = ("11" %in% isolate(input$long))) %...>%
      clean_plot()
  })
  
  output$slice12 <- renderPlot({
    future_dat()(long = ("12" %in% isolate(input$long))) %...>%
      clean_plot()
  })
  
  output$slice13 <- renderPlot({
    future_dat()(long = ("13" %in% isolate(input$long))) %...>%
      clean_plot()
  })
  
  output$slice21 <- renderPlot({
    future_dat()(long = ("21" %in% isolate(input$long))) %...>%
      clean_plot()
  })
  
  output$slice22 <- renderPlot({
    future_dat()(long = ("22" %in% isolate(input$long))) %...>%
      clean_plot()
  })
  
  output$slice23 <- renderPlot({
    future_dat()(long = ("23" %in% isolate(input$long))) %...>%
      clean_plot()
  })
  
  output$slice31 <- renderPlot({
    future_dat()(long = ("31" %in% isolate(input$long))) %...>%
      clean_plot()
  })
  
  output$slice32 <- renderPlot({
    future_dat()(long = ("32" %in% isolate(input$long))) %...>%
      clean_plot()
  })
  
  output$slice33 <- renderPlot({
    future_dat()(long = ("33" %in% isolate(input$long))) %...>%
      clean_plot()
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)

