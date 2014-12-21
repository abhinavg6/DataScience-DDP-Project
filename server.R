library(shiny)
data(mtcars)
mtcars$carmake <- rownames(mtcars)
mtcars$tmsn <- ifelse(mtcars$am == 0, "A", "M")

shinyServer(function(input, output) {
    
    # Create appropriate linear model based on the user selection
    modeldata <- reactive({
        model <- switch(input$model,
                        amcyl = lm(mpg ~ tmsn + cyl, mtcars),
                        amcylint = lm(mpg ~ tmsn + cyl + tmsn*cyl, mtcars),
                        amgear = lm(mpg ~ tmsn + gear, mtcars),
                        amgearint = lm(mpg ~ tmsn + gear + tmsn*gear, mtcars),
                        amcylgear = lm(mpg ~ tmsn + cyl + gear, mtcars),
                        lm(mpg ~ tmsn + cyl, mtcars))
        model
    })
    
    # Render a 2x1 plot for the chosen model 
    # 2 plots for Residuals vs Fit and Normal Q-Q
    output$plot <- renderPlot({
        par(mfrow = c(1,2))
        plot(modeldata(), which=1)
        plot(modeldata(), which=2)
    })
    
    # Predict the outcome for input values and render it on the UI
    output$prediction = renderPrint({
        intmsn <- ifelse(input$tmsn == "Automatic", "A", "M")
        newdatadf <- switch(input$model,
                       amcyl = data.frame(tmsn = intmsn, cyl = as.numeric(input$numcyl)),
                       amcylint = data.frame(tmsn = intmsn, cyl = as.numeric(input$numcyl)),
                       amgear = data.frame(tmsn = intmsn, gear = as.numeric(input$numgear)),
                       amgearint = data.frame(tmsn = intmsn, gear = as.numeric(input$numgear)),
                       amcylgear = data.frame(tmsn = intmsn, cyl = as.numeric(input$numcyl), 
                                              gear = as.numeric(input$numgear)),
                       data.frame(tmsn = intmsn, as.numeric(input$numcyl)))
        outcome <- predict(modeldata(), newdata=newdatadf)
        paste("The predicted outcome is: ", outcome)
    })
    
    # Render the summary for chosen model
    output$summary <- renderPrint({
        summary(modeldata())
    })
    
    # Render the mtcars data - only for columns in the chosen model
    output$mytable = renderDataTable({
        cols <- switch(input$model,
                       amcyl = c("carmake","mpg","am","tmsn","cyl"),
                       amcylint = c("carmake","mpg","am","tmsn","cyl"),
                       amgear = c("carmake","mpg","am","tmsn","gear"),
                       amgearint = c("carmake","mpg","am","tmsn","gear"),
                       amcylgear = c("carmake","mpg","am","tmsn","cyl","gear"),
                       c("carmake","mpg","am","tmsn","cyl"))
        mtcars[, cols, drop=FALSE]
    }, options = list(orderClasses = TRUE))
    
})