#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(ElemStatLearn)
data(galaxy)

# for fitting cubic
galaxy$rp3 <- galaxy$radial.position^3

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    output$hoverinf <- renderText({
        if(!is.null(input$plot_hover)) {
            hover=input$plot_hover
            if(input$typeOfRepresentation==1) {
                rws <- nearPoints(galaxy,hover,xvar="east.west",yvar="north.south")
                paste("E-W:",round(rws$east.west,2),
                      " N-S:",round(rws$north.south,2),
                      "V: ",rws$velocity," km/sec")
            } else if (input$typeOfRepresentation==2) {
                rws <- nearPoints(galaxy,hover,xvar="radial.position",yvar="velocity")
                paste("Radial position: ",round(rws$radial.position,2),
                     " velocity:",rws$velocity," km/sec")
            } else {
                paste("Hover over a point to see its details")
            }
        } else {
            paste("If you want to see its details, hover over a point")
        }
    })

    glx <- reactive({
        if("all" %in% input$Angles)
            galaxy
        else
            subset(galaxy,angle %in% input$Angles)
    })
    
    fit <- reactive({
        glm(velocity~rp3,data=glx())
    })
    
    output$cubicFit <- renderPrint({
        summary(fit())
    })
    
    output$distPlot <- renderPlot({
        
        if (input$typeOfRepresentation == 1) {
            ggplot(data=glx(),mapping=aes(x=east.west,
                                           y=north.south,
                                           colour=velocity
                                           ))+
                geom_point()+
                xlab("East(-)               West(+)")+
                ylab("South(-)              North(+)")+
                labs(colour="Velocity (km/sec)")
        } else if (input$typeOfRepresentation == 2) {
            g <- ggplot(data=glx(),mapping=aes(x=radial.position,
                                           y=velocity,
                                           colour=angle
                                           ))+
                geom_point()+
                xlab("Distance from origin, negative if east.west negative")+
                ylab("Velocity (km/sec)")
            if (!("all" %in% input$Angles))
                g <- g+geom_line(aes(x=radial.position,y=fitted(fit())))
            g
        } else {
            df <- data.frame(x=0.5,y=0.5,ht="No data available")
            ggplot(data=df,mapping=aes(x=x,y=y))+geom_point()
        }
    })        
    
})
