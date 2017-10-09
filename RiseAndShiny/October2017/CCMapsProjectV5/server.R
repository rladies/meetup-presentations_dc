library(maps)
library(ggplot2)
library(dplyr)
library(shiny)
library(gridExtra)

MGdat <- read.csv("data/mathgender.csv",header=TRUE,stringsAsFactors=FALSE)
MLdat <- read.csv("data/mathlunch.csv",header=TRUE,stringsAsFactors=FALSE)
RGdat <- read.csv("data/readinggender.csv",header=TRUE,stringsAsFactors=FALSE)
RLdat <- read.csv("data/readinglunch.csv",header=TRUE,stringsAsFactors=FALSE)
all <- read.csv("data/all.csv",header=TRUE,stringsAsFactors=FALSE)


food <- read.csv("data/food.csv",header=TRUE,stringsAsFactors=FALSE)

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


shinyServer(
	function(input,output) {
		
		#Filter Data, Return Data Frame
		dataR <- reactive({
			
			minDI <- input$DIrange[1]
			maxDI <- input$DIrange[2]

			
			if(input$Test==1){
				if(input$Var==1){
					data = MGdat
					rowAtitle = "Gender \n MALE"
					rowBtitle = "Gender \n FEMALE"
				}
					else{
						data = MLdat
						rowAtitle = "Lunch Program \n Eligible"
						rowBtitle = "Lunch Program \n Not Eligible"
					}
			} 
			if(input$Test!=1){
				if(input$Var==1){
					data = RGdat
					rowAtitle = "Gender \n MALE"
					rowBtitle = "Gender \n FEMALE"
				}
					else{ 
						data = RLdat
						rowAtitle = "Lunch Program \n Eligible"
						rowBtitle = "Lunch Program \n Not Eligible"
					}
			}
			
			
			output$titleA <- renderPrint({ rowAtitle })
			output$summA <- renderPrint({ sumA })
			output$titleB <- renderPrint({ rowBtitle })
			output$summB <- renderPrint({ sumB })
			
			minFD <- input$fin[1]
			maxFD <- input$fin[2]
			
			
			ctColr1 <- cut(data$One, breaks = c(min(data$One),minDI,maxDI,max(data$One)), include.lowest=TRUE)
			ctColr2 <- cut(data$Two, breaks = c(min(data$Two),minDI,maxDI,max(data$Two)), include.lowest=TRUE)
			
			cbreaks <- c(min(food$Percent),minFD,maxFD,max(food$Percent))
			grpCol <- cut(food$Percent,breaks=cbreaks,inc=TRUE,lab=FALSE)
			
			food <- cbind(food,grpCol)
			
			lev <- c("L","M","H","B") 
			 
			
			A1 = seq(1,49)
			for (ai in 1:length(food$region)) {
				if (food$grpCol[ai] == 1)	{
					A1[ai] = TRUE
					} else A1[ai] = FALSE
				}

			tfA1 <- ifelse(A1,ctColr1,4)
			lvA1 <- factor(lev[tfA1],levels=lev)	
			data$lvA1 <- lvA1
			
			
			A2 = seq(1,49)
			for (aj in 1:length(food$region)) {
				if (food$grpCol[aj] == 2)	{
					A2[aj] = TRUE
					} else A2[aj] = FALSE
				}

			tfA2 <- ifelse(A2,ctColr1,4)
			lvA2 <- factor(lev[tfA2],levels=lev)	
			data$lvA2 <- lvA2

			
			A3 = seq(1,49)
			for (ak in 1:length(food$region)) {
				if (food$grpCol[ak] == 3)	{
					A3[ak] = TRUE
					} else A3[ak] = FALSE
				}

			tfA3 <- ifelse(A3,ctColr1,4)
			lvA3 <- factor(lev[tfA3],levels=lev)	
			data$lvA3 <- lvA3
			
			B1 = seq(1,49)
			for (bi in 1:length(food$region)) {
				if (food$grpCol[bi] == 1)	{
					B1[bi] = TRUE
					} else B1[bi] = FALSE
				}

			tfB1 <- ifelse(B1,ctColr2,4)
			lvB1 <- factor(lev[tfB1],levels=lev)	
			data$lvB1 <- lvB1
			
			B2 = seq(1,49)
			for (bj in 1:length(food$region)) {
				if (food$grpCol[bj] == 2)	{
					B2[bj] = TRUE
					} else B2[bj] = FALSE
				}

			tfB2 <- ifelse(B2,ctColr2,4)
			lvB2 <- factor(lev[tfB2],levels=lev)	
			data$lvB2 <- lvB2
			
			B3 = seq(1,49)
			for (bk in 1:length(food$region)) {
				if (food$grpCol[bk] == 3)	{
					B3[bk] = TRUE
					} else B3[bk] = FALSE
				}

			tfB3 <- ifelse(B3,ctColr2,4)
			lvB3 <- factor(lev[tfB3],levels=lev)	
			data$lvB3 <- lvB3
			
			dlev <- c("N","Y")
			
			DiffC1 = numeric()
			for (d1 in 1:49) {
				if (lvA1[d1]==lvB1[d1]){
					DiffC1[d1] = FALSE
					} else DiffC1[d1] = TRUE
			}
			DiffC1 <- ifelse(DiffC1,"Y","N")
			data$DiffC1 <- DiffC1
			
			DiffC2 = numeric()
			for (d2 in 1:49) {
				if (lvA2[d2]==lvB2[d2]){
					DiffC2[d2] = FALSE
					} else DiffC2[d2] = TRUE
			}
			DiffC2 <- ifelse(DiffC2,"Y","N")
			data$DiffC2 <- DiffC2
			
			DiffC3 = numeric()
			for (d3 in 1:49) {
				if (lvA3[d3]==lvB3[d3]){
					DiffC3[d3] = FALSE
					} else DiffC3[d3] = TRUE
			}
			DiffC3 <- ifelse(DiffC3,"Y","N")
			data$DiffC3 <- DiffC3
			
			frm <- data.frame(data)
			
			rr1 = cor(data$One,food$Percent)
			rr2 = cor(data$Two,food$Percent)

			output$RvalueA <- renderText({ rr1 })
			output$RvalueB <- renderText({ rr2 })
			
			fdmin = min(food$Percent)
			fdmax = max(food$Percent)
		
			minfin <- input$fin[1]
			maxfin <- input$fin[2]
		
			output$food1 <- renderText({paste(fdmin,"-",minfin,"% Food Insecurity")})
			output$food2 <- renderText({paste(minfin,"-",maxfin,"% Food Insecurity")})
			output$food3 <- renderText({paste(maxfin,"-",fdmax,"% Food Insecurity")})

			output$dataTabMath <- renderDataTable(all[,1:6], options = list(pageLength = 49))
			reading <- data.frame(c(all[,1:2],all[,7:10]))
			output$dataTabReading <- renderDataTable(reading, options = list(pageLength = 49))
			
			us_state_map <- map_data('state')
			mdata <- merge(us_state_map, frm, by='region', all=T)
			mdata <- mdata[order(mdata$order), ]
			
			mlist = list(mdata,rowAtitle,rowBtitle,frm)
			mlist

		})
		
		output$respect1 <- renderPrint({
			me = dataR()
			fm = me[[4]]
			DiffC1 = numeric()
			for (d1 in 1:49) {
				if (fm$lvA1[d1]==fm$lvB1[d1]){
					DiffC1[d1] = FALSE
					} else DiffC1[d1] = TRUE
			}
			DiffC1 <- ifelse(DiffC1,states,"N")
			print1 = numeric()
			w1=1
			for (e1 in 1:49){
				if(DiffC1[e1]!="N"){
					print1[w1] = DiffC1[e1]
					w1 = w1+1
				}
			}
			if(length(print1)==0){
				print1[1]="No Differences"
			}
			print1
		})
		output$respect2 <- renderPrint({
			me = dataR()
			fm = me[[4]]
			DiffC2 = numeric()
			for (d2 in 1:49) {
				if (fm$lvA2[d2]==fm$lvB2[d2]){
					DiffC2[d2] = FALSE
					} else DiffC2[d2] = TRUE
			}
			DiffC2 <- ifelse(DiffC2,states,"N")
			print2 = numeric()
			w2=1
			for (e2 in 1:49){
				if(DiffC2[e2]!="N"){
					print2[w2] = DiffC2[e2]
					w2 = w2+1
				}
			}
			if(length(print2)==0){
				print2[1]="No Differences"
			}
			print2
		})
		output$respect3 <- renderPrint({
			me = dataR()
			fm = me[[4]]
			DiffC3 = numeric()
			for (d3 in 1:49) {
				if (fm$lvA3[d3]==fm$lvB3[d3]){
					DiffC3[d3] = FALSE
					} else DiffC3[d3] = TRUE
			}
			DiffC3 <- ifelse(DiffC3,states,"N")
			print3 = numeric()
			w3=1
			for (e3 in 1:49){
				if(DiffC3[e3]!="N"){
					print3[w3] = DiffC3[e3]
					w3 = w3+1
				}
			}
			if(length(print3)==0){
				print3[1]="No Differences"
			}
			print3
		})
		
		bdr <- c("B" = "wheat3","L" = "white","M" = "white","H" = "white")
		cols <- c("L" = "tomato2","M" = "royalblue2","H" = "olivedrab","B" = "white") 
		dbdr <-c("N" = "wheat3", "Y" = "wheat3")
		dcols <- c("N" = "white","Y"="black")
		
		fdmin = min(food$Percent)
		fdmax = max(food$Percent)
		
	    output$diff_Plot <- renderPlot({
			hh = dataR()
			frame = hh[[4]]
			datapl = hh[[1]]
			dlev <- c("N","Y")

		
			pD1<-(qplot(long, lat, data=datapl, geom="polygon", group=group, colour=DiffC1, fill=DiffC1)
			+ theme_bw()
			+ theme(plot.background = element_blank(),
	   	 			panel.grid.major = element_blank(),
	   			 	panel.grid.minor = element_blank(),
	   			 	panel.border = element_blank(),
					axis.line = element_blank(),
					axis.ticks = element_blank(), 
					axis.text.y = element_blank(),
					axis.text.x = element_blank(),
					axis.title.y= element_text(size=18),
					axis.title.x=element_blank(),
					legend.position = "none")
			+ scale_fill_manual(breaks=c("0","1"),values = dcols)
			+ scale_colour_manual(breaks=c("0","1"),values = dbdr)
			+ labs(y="Differences")
			)
		
			pD2<-(qplot(long, lat, data=datapl, geom="polygon", group=group, colour=DiffC2, fill=DiffC2)
			+ theme_bw()
			+ theme(plot.background = element_blank(),
	   	 			panel.grid.major = element_blank(),
	   			 	panel.grid.minor = element_blank(),
	   			 	panel.border = element_blank(),
					axis.line = element_blank(),
					axis.ticks = element_blank(), 
					axis.text.y = element_blank(),
					axis.text.x = element_blank(),
					axis.title.y=element_blank(),
					axis.title.x=element_blank(),
					legend.position = "none")
			+ scale_fill_manual(breaks=c("0","1"),values = dcols)
			+ scale_colour_manual(breaks=c("0","1"),values = dbdr)
			)
	
			pD3<-(qplot(long, lat, data=datapl, geom="polygon", group=group, colour=DiffC3, fill=DiffC3)
			+ theme_bw()
			+ theme(plot.background = element_blank(),
	   	 			panel.grid.major = element_blank(),
	   			 	panel.grid.minor = element_blank(),
	   			 	panel.border = element_blank(),
					axis.line = element_blank(),
					axis.ticks = element_blank(), 
					axis.text.y = element_blank(),
					axis.text.x = element_blank(),
					axis.title.y=element_blank(),
					axis.title.x=element_blank(),
					legend.position = "none")
			+ scale_fill_manual(breaks=c("0","1"),values = dcols)
			+ scale_colour_manual(breaks=c("0","1"),values = dbdr)
			)
		
			grid.arrange(pD1,pD2,pD3,ncol=3)
		
	    })
		
    output$row1_Plot <- renderPlot({
	
		minfin <- input$fin[1]
		maxfin <- input$fin[2]
		
		hh = dataR()
		frame = hh[[1]]
		
		pA1<-(qplot(long, lat, data=frame, geom="polygon", group=group, colour=lvA1, fill=lvA1)
		+ theme_bw()
		+ theme(plot.background = element_blank(),
   	 			panel.grid.major = element_blank(),
   			 	panel.grid.minor = element_blank(),
   			 	panel.border = element_blank(),
				axis.line = element_blank(),
				axis.ticks = element_blank(), 
				axis.text.y = element_blank(),
				axis.text.x = element_blank(),
				axis.title.y= element_text(size=18),
				axis.title.x=element_blank(),
				legend.position = "none")
		+ scale_fill_manual(values = cols)
		+ scale_colour_manual(values = bdr)
		+ labs(y=hh[[2]])
		)
		
		pA2<-(qplot(long, lat, data=frame, geom="polygon", group=group, colour=lvA2, fill=lvA2)
		+ theme_bw()
		+ theme(plot.background = element_blank(),
   	 			panel.grid.major = element_blank(),
   			 	panel.grid.minor = element_blank(),
   			 	panel.border = element_blank(),
				axis.line = element_blank(),
				axis.ticks = element_blank(), 
				axis.text.y = element_blank(),
				axis.text.x = element_blank(),
				axis.title.y=element_blank(),
				axis.title.x=element_blank(),
				legend.position = "none")
		+ scale_fill_manual(values = cols)
		+ scale_colour_manual(values = bdr)
		)
	
		pA3<-(qplot(long, lat, data=frame, geom="polygon", group=group, colour=lvA3, fill=lvA3)
		+ theme_bw()
		+ theme(plot.background = element_blank(),
   	 			panel.grid.major = element_blank(),
   			 	panel.grid.minor = element_blank(),
   			 	panel.border = element_blank(),
				axis.line = element_blank(),
				axis.ticks = element_blank(), 
				axis.text.y = element_blank(),
				axis.text.x = element_blank(),
				axis.title.y=element_blank(),
				axis.title.x=element_blank(),
				legend.position = "none")
		+ scale_fill_manual(values = cols)
		+ scale_colour_manual(values = bdr)
		)
		
		#grid.arrange(pA1,pA2,pA3,ncol=3,main=textGrob(hh[[2]],gp=gpar(fontsize=20,font=2)))
		grid.arrange(pA1,pA2,pA3,ncol=3)
		
    })
	
    output$row2_Plot <- renderPlot({
		hh = dataR()
		frame = hh[[1]]
		minfin <- input$fin[1]
		maxfin <- input$fin[2]
		
		pB1<-(qplot(long, lat, data=frame, geom="polygon", group=group, colour=lvB1, fill=lvB1)
		+ theme_bw()
		+ theme(plot.background = element_blank(),
   	 			panel.grid.major = element_blank(),
   			 	panel.grid.minor = element_blank(),
   			 	panel.border = element_blank(),
				axis.line = element_blank(),
				axis.ticks = element_blank(), 
				axis.text.y = element_blank(),
				axis.text.x = element_blank(),
				axis.title.y= element_text(size=18),
				legend.position = "none")
		+ scale_fill_manual(values = cols)
		+ scale_colour_manual(values = bdr)
		+ labs(x=paste(fdmin,"-",minfin,"% Food Insecurity"))
		+ labs(y=hh[[3]])
		)
	
		pB2<-(qplot(long, lat, data=frame, geom="polygon", group=group, colour=lvB2, fill=lvB2)
		+ theme_bw()
		+ theme(plot.background = element_blank(),
   	 			panel.grid.major = element_blank(),
   			 	panel.grid.minor = element_blank(),
   			 	panel.border = element_blank(),
				axis.line = element_blank(),
				axis.ticks = element_blank(), 
				axis.text.y = element_blank(),
				axis.text.x = element_blank(),
				axis.title.y=element_blank(),
				legend.position = "none")
		+ scale_fill_manual(values = cols)
		+ scale_colour_manual(values = bdr)
		+ labs(x=paste(minfin,"-",maxfin,"% Food Insecurity"))
		)
	
		pB3<-(qplot(long, lat, data=frame, geom="polygon", group=group, colour=lvB3, fill=lvB3)
		+ theme_bw()
		+ theme(plot.background = element_blank(),
   	 			panel.grid.major = element_blank(),
   			 	panel.grid.minor = element_blank(),
   			 	panel.border = element_blank(),
				axis.line = element_blank(),
				axis.ticks = element_blank(), 
				axis.text.y = element_blank(),
				axis.text.x = element_blank(),
				axis.title.y=element_blank(),
				legend.position = "none")
		+ scale_fill_manual(values = cols)
		+ scale_colour_manual(values = bdr)
		+ labs(x=paste(maxfin,"-",fdmax,"% Food Insecurity"))
		)
		
		#grid.arrange(pB1,pB2,pB3,ncol=3,main=textGrob(hh[[3]],gp=gpar(fontsize=20,font=2)))
		grid.arrange(pB1,pB2,pB3,ncol=3)
    })
    
  }	
)