#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(ElemStatLearn)
data(galaxy)

# Define UI for application that draws a histogram
shinyUI(
    navbarPage("NGC7531 Velocities Explorer",
        tabPanel("Radial Velocities",           
    # Sidebar with a slider input for number of bins 
    sidebarLayout(position="left",
        sidebarPanel(
            radioButtons("typeOfRepresentation",
                         "Choose the type of chart:",
                         choiceNames=c("velocity vs position",
                                       "velocity vs radial distance"),
                         choiceValues=c(1,2),
                         selected=1,
                         inline=FALSE),
            checkboxGroupInput("Angles","Choose observation angle",
                               choices=c("all",sort(unique(galaxy$angle))),
                               selected="all",
                               inline=TRUE),
            textOutput("hoverinf",inline=TRUE)
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
            tabsetPanel(
                tabPanel("chart",
                         plotOutput("distPlot",hover = hoverOpts(id ="plot_hover"))
                ),
                tabPanel("cubic fit",
                         verbatimTextOutput("cubicFit"))
            )
        )
    )
),
    tabPanel("About",
             mainPanel("",
                       includeHTML("About.html"))))
)