library(maps)
library(maptools)
library(ggmap)
library(shiny)

fd <- read.csv("data/food.csv",header=TRUE,stringsAsFactors=FALSE)

states = c("alabama","arizona","arkansas","california",
"colorado","connecticut","delaware","district of columbia",
"florida","georgia","idaho","illinois",
"indiana","iowa","kansas","kentucky",
"louisiana","maine","maryland","massachusetts",
"michigan","minnesota","mississippi","missouri",
"montana","nebraska","nevada","new hampshire",
"new jersey","new mexico","new york","north carolina",
"north dakota","ohio","oklahoma","oregon",
"pennsylvania","rhode island","south carolina","south dakota",
"tennessee","texas","utah","vermont",
"virginia","washington","west virginia","wisconsin",
"wyoming")


shinyUI(navbarPage(
	
title = 'Data View Options',
tabPanel('Maps Visualization',	
	fluidPage(
	titlePanel("CC Maps Project v.5 : Shiny NCES State Data Explorer"),
	
	sidebarLayout(
	    sidebarPanel( 
			    selectInput("Test", label = h4("Data Set: Choose a Performance Test"), choices = list("Math"=1,"Reading"=2),selected=1),
				
				selectInput("Var", label = h4("Row Groups: Choose a Performance Variable"), choices = list("Gender"=1,"Lunch Program Elig"=2),selected=1),
				
				hr(),
				
				sliderInput("DIrange",label = h4("Color Groups: Test Score"), min = 254, max = 313, value = c(276,280)),
				h6("Red(Low)--Blue(Middle)--Green(High)"),
				
				hr(),
				
				#h6("Row 1 R-value:"),verbatimTextOutput("RvalueA"),
				#h6("Row 2 R-value:"),verbatimTextOutput("RvalueB")
				h6("Column 1 Differences:"),textOutput("respect1"),
				h6("Column 2 Differences:"),textOutput("respect2"),
				h6("Column 3 Differences:"),textOutput("respect3")
			),
			
			
	    mainPanel(
		
			fluidRow(
				column(12, align="center",
			    sliderInput("fin", label = h4("Column Groups: Food Insecurity (Percent of Households)"), min = min(fd$Percent-0.1), max = max(fd$Percent), value = c(14,16.5))
			    )
			),	
			
			fluidRow(
			      column(4,align="center",
			        textOutput("food1")
			      ),
			      column(4,align="center",
			        textOutput("food2")
			      ),
			      column(4,align="center",
			        textOutput("food3")
			      )
			),
			
			hr(),
	
			fluidRow(
			      column(12,
			        plotOutput("row1_Plot", height = "200px")
			      )
			),
	
			fluidRow(
			      column(12,
			        plotOutput("diff_Plot", height = "200px")
			      )
			),
	
			fluidRow(
			      column(12,
			        plotOutput("row2_Plot", height = "200px")
			      )
			)
		)
	  
		)
	)),
	tabPanel('Math Data Table', dataTableOutput('dataTabMath')),
	tabPanel('Reading Data Table', dataTableOutput('dataTabReading'))
))