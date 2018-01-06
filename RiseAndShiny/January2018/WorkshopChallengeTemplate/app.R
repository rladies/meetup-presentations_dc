#
# Example Google Sheet into Shiny App Integration
# ******************TEMPLATE*********************
#
# R-Ladies Washington DC
# Rise & Shiny :: January 2018
#

library(shiny)
library(googlesheets)
library(DT)

# This section is your User Interface definition.
# Feel free to change the look&feel however you'd like!
ui <- fluidPage(

  titlePanel("Read a Google Sheet from your Personal Drive"),
  sidebarLayout(
    sidebarPanel(
      # Use this area for your user input controls
      # A text input box and action button might be useful here
    ),
    mainPanel(
      # Use this area for your dataTableOutput
    )
  )
)

# This section is for your server controller code
# Your googlesheets functions will probably in here
server <- function(input, output, session) {

  output$mysheet <- renderDataTable({
    # Fill this in with logic to get your sheets!
  })

}

shinyApp(ui = ui, server = server)
