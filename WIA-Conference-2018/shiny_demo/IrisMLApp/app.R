# WIA Conference Shiny Application Demo
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(glue)

# Define UI for application that predicts Iris Species Type
ui <- fluidPage(

   # Application title
   titlePanel("Excellent Iris Data Explorer App"),

   # Sidebar with slider input for Sepal and Petal variables
   sidebarLayout(
      sidebarPanel(
         h3("Create a New Iris Observation:"),
         sliderInput("Sepal.Length", "Sepal Length:",
                     min = 4.0, max = 7.9, value = 6.0),
         sliderInput("Sepal.Width", "Sepal Width:",
                     min = 2.0, max = 4.5, value = 3.2),
         sliderInput("Petal.Length", "Petal Length:",
                     min = 1.0, max = 7.1, value = 3.5),
         sliderInput("Petal.Width", "Petal Width:",
                     min = 0.1, max = 2.5, value = 1)
      ),

      # Show a plot of the generated distribution
      mainPanel(
        htmlOutput("prediction"),
        hr(),
        radioButtons("plot.type", "Plot Variable Type:",
                     c("Petal Plot" = "petal",
                       "Sepal Plot" = "sepal")),
         plotOutput("irisPlot")
      )
   )
)

# Define server logic
server <- function(input, output) {

  output$prediction <- renderText({
    new.iris <- data.frame(Petal.Length=input$Petal.Length, Petal.Width=input$Petal.Width,
                           Sepal.Length=input$Sepal.Length, Sepal.Width=input$Sepal.Width)

    prediction <- predict(fit.knn, new.iris)
    species <- as.character(prediction)
    glue('<h4 style="text-align:center; font-weight:bold; color:#7b8a8b;">Species Prediction: {species}</h4>') %>% HTML
  })

   output$irisPlot <- renderPlot({
     new.iris <- data.frame(Petal.Length=input$Petal.Length, Petal.Width=input$Petal.Width,
                            Sepal.Length=input$Sepal.Length, Sepal.Width=input$Sepal.Width)

     if(input$plot.type == 'sepal'){
        i <- new.iris %>% select(starts_with("Sepal"))
        x_var = "Sepal.Width"
        y_var = "Sepal.Length"
      } else {
        i <- new.iris %>% select(starts_with("Petal"))
        x_var = "Petal.Width"
        y_var = "Petal.Length"
      }

      ggplot(iris, aes_string(x = x_var, y = y_var, colour = "Species")) +
        geom_point(data = new.iris, colour = "black", alpha = 1) +
        geom_point(alpha = .5) +
        facet_wrap(~ Species) +
        guides(colour = FALSE) +
        theme_bw()
   })
}

# Run the application
shinyApp(ui = ui, server = server)
