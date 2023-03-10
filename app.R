library(ggplot2)
library(shiny)

graduation <- read.csv('https://raw.githubusercontent.com/noahmedina/graduation/main/graduation.csv')
factor_list = names(graduation)[3:14]

calculate_R <- function(column) {
  c <- column
  n <- 55
  x <- 0
  y <- 0
  xx <- 0
  yy <- 0
  xy <- 0
  for (i in 1:n) {
    x = x + graduation[i,c]
    y <- y + graduation[i,2]
    xx <- xx + graduation[i,c]^2
    yy <- yy + graduation[i,2]^2
    xy <- xy + graduation[i,c] * graduation[i,2]
  }
  R <- (n*xy - x*y) / sqrt((n*xx - x^2) * (n*yy - y^2))
  return(R)
}

graph_graduation <- function(factor) {
  x_axis <- ""
  x_val <- graduation$Narcotics_Calls
  
  if (factor == factor_list[1]) {
    x_axis <- "Narcotics calls per 1,000 Residents"
    x_val <- graduation$Narcotics_Calls
  } else if (factor == factor_list[2]) {
    x_axis <- "Rate of Dirty Streets and Alleys Reports per 1,000 Residents"
    x_val <- graduation$Dirty_Streets
  } else if (factor == factor_list[3]) {
    x_axis <- "Households with No Internet at Home (%)"
    x_val <- graduation$Households_Without_Internet
  } else if (factor == factor_list[4]) {
    x_axis <- "Female-Headed Households with Children under 18 (%)"
    x_val <- graduation$Female_Headed_Households
  } else if (factor == factor_list[5]) {
    x_axis <- "Vacant and Abandoned Residential Properties (%)"
    x_val <- graduation$Vacant_Properties
  } else if (factor == factor_list[6]) {
    x_axis <- "Violent Crime Rate per 1,000 Residents"
    x_val <- graduation$Violent_Crime
  } else if (factor == factor_list[7]) {
    x_axis <- "Average Household Income ($)"
    x_val <- graduation$Household_Income
  } else if (factor == factor_list[8]) {
    x_axis <- "Families Living Below the Poverty Line (%)"
    x_val <- graduation$Poverty
  } else if (factor == factor_list[9]) {
    x_axis <- "Rent Affordability Index"
    x_val <- graduation$Rent_Affordability
  } else if (factor == factor_list[10]) {
    x_axis <- "Percent Population 16-64 Not in Labor Force"
    x_val <- graduation$Labor_Force_Participation
  } else if (factor == factor_list[11]) {
    x_axis <- "Percent of Residents - Black/African-American (Non-Hispanic)"
    x_val <- graduation$Percent_Black
  } else if (factor == factor_list[12]) {
    x_axis <- "Percent of Residents - White/Caucasian (Non-Hispanic)"
    x_val <- graduation$Percent_White
  }
  ggplot(data = graduation, aes(x = x_val, y = Completion_Rate)) + 
    geom_point(aes(color = Location, size = 1)) +
    geom_smooth(method = lm, se = FALSE) +
    labs(x = x_axis, y = "High School Completion Rate (%)", subtitle = paste("R = ", calculate_R(which(factor_list == factor) + 2))) +
    scale_color_manual(values = c("green", "black", "red")) +
    guides(size = 'none') +
    theme(text = element_text(size = 15))
}

shinyApp(
  ui <- fluidPage(
    # App title ----
    titlePanel("Factors That Influence High school Graduation"),
    
    # Sidebar layout with input and output definitions ----
    sidebarLayout(
      
      # Sidebar panel for inputs ----
      sidebarPanel(
        
        # Input: input for factors ----
        selectInput(inputId = "factor",
                    label = "Pick a Factor",
                    choices = factor_list
        )
      ),
      
      # Main panel for displaying outputs ----
      mainPanel(
        plotOutput("graph")
      )
    )
  ),
  
  server <- function(input, output) {
    output$graph <- renderPlot({ 
      graph_graduation(input$factor)
    })
  },
  options = list(height = 750, width = 1000)
)