require(shiny)

# Define UI for application that plots random distributions 
shinyUI(pageWithSidebar(

  # Application title
  headerPanel("Measurement on a map"),

  # Sidebar with a slider input for number of observations
  sidebarPanel(
    selectInput("obs", "Choose a measurement:", 
                choices = colnames(state.x77),
                selected='Income'),
    sliderInput("cuts", "Number of cuts", 2, 15, 3, step = 1, 
    ticks = TRUE, animate = FALSE),
  	hr(),
    helpText("Select a feature to compare")
  ),

  # Show a plot of the generated distribution
  mainPanel(
    plotOutput("distPlot",  width = "100%", height="200px"),
    plotOutput("distPlot2",  width = "60%", height="200px")
  )
))
