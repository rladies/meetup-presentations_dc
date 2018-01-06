#
# Example Google Sheet into Shiny App Integration
# R-Ladies Washington DC
# Rise & Shiny :: January 2018
#

library(shiny)
library(googlesheets)
library(DT)

ui <- fluidPage(

    titlePanel("Read a Google Sheet from your Personal Drive"),
    sidebarLayout(
      sidebarPanel(
        textInput('sheet_name', "Sheet Name:"),
        actionButton('findSheet', "Find This Sheet")
      ),
      mainPanel(
        DT::dataTableOutput("mysheet")
      )
    )
)

server <- function(input, output, session) {

  output$mysheet <- renderDataTable({

    if (input$findSheet == 0){
      return()
    }

    sheet <- isolate(input$sheet_name)

    my_sheet <- gs_title(sheet)
    sheet_data <- gs_read(my_sheet)

    datatable(sheet_data)
  })
}

shinyApp(ui = ui, server = server)
