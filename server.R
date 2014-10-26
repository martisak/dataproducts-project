require(shiny)
require(datasets)
require(maps)
require(ggplot2)
require(dplyr)
require(scales)
require(magrittr)
require(stringr)


# Tidy the data
all_states <- map_data("state") %>% select(-subregion)

data <- as.data.frame(state.x77) %>% mutate(region = tolower(rownames(state.x77)))
colnames(data) <- gsub(" ", "_", colnames(data))

all_states  <- merge(all_states, data, by = "region")
all_states<-all_states[order(all_states$order), ]

all_states$colorgroup = as.factor(cut(all_states[,"Income"], 3))

#cities <- us.cities %>%
#	filter(capital > 0) %>%
#	select(-capital, -country.etc, -pop) %>%
#	mutate(
#		state = str_sub(name,-2),
#		name = str_sub(name,1,-4)
#		) %>%
#	filter(state != "AK", state != "HI")

shinyServer(function(input, output) {

  datasetInput <- reactive({
   	gsub(" ", "_", input$obs)
  })

  cutsInput <- reactive({
  	as.factor(cut(all_states[,datasetInput()], input$cuts))
  })

  output$distPlot <- renderPlot({
  	all_states$colorgroup = cutsInput()

  	ggplot() +
	geom_polygon( data=all_states,
		aes_string(x="long", y="lat",
		group = "group",
		fill="colorgroup"),
		colour="white") +
	scale_x_continuous(breaks=pretty_breaks(n=10)) +
	scale_y_continuous(breaks=pretty_breaks(n=10)) +
#	geom_point(data=cities, aes(x=long, y=lat), color="white",size=2) + 
#	geom_text(data=cities, aes(x=long, y=lat, label=name), color="white", hjust=-0.2, vjust=-0.2, size=3) +
	xlab("Longitude") +
	ylab("Latitude") +
	scale_fill_discrete(name=input$obs)
  }, height=200)

  output$distPlot2 <- renderPlot({
  	
  	data<-data[order(data[,datasetInput()]), ]

  	data$region <- factor(data$region, data$region)
  	data <- tail(data,10)


  	ggplot() +
		geom_bar(data=data, aes_string(y=datasetInput(), x="region"),stat="identity", fill="orange", color="black") +
		theme(axis.text.x=element_text(angle=90)) +
		ylab(input$obs) +
		xlab('State') +
		coord_flip()

  }, height=200)
})