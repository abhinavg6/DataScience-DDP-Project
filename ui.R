library(shiny)

shinyUI(pageWithSidebar(
    headerPanel('Motor Cars MPG Modeling/Prediction'),
    sidebarPanel(
        helpText('In this application, we will create a user-specified linear model for the 
                "mtcars" dataset, and use it to predict MPG (miles per gallon). The output
                 on all tabs will be refreshed as soon as a different model is chosen.'),
        radioButtons("model", "Choose a model:", 
                     list("MPG vs AM and CYL" = "amcyl",
                          "MPG vs AM, CYL and their interaction" = "amcylint",
                          "MPG vs AM and GEAR" = "amgear",
                          "MPG vs AM, GEAR and their interaction" = "amgearint",
                          "MPG vs AM, CYL and GEAR" = "amcylgear")),
        br(),
        helpText('Based on the chosen model, following prediction variables will appear.
                 Please select any values and go to the "Prediction" tab to see the 
                 predicted outcome for MPG (miles per gallon), based on current chosen model.'),
        conditionalPanel(
            condition = "1 == 1",
            selectInput("tmsn","Transmission",c("Automatic","Manual"),selected = c("Automatic"))
        ),
        conditionalPanel(
            condition = "(input.model == 'amcyl') || (input.model == 'amcylint') || (input.model == 'amcylgear')",
            selectInput("numcyl","No. of Cylinders",c(3,4,5,6,8,9,10,11,12,13,14),selected = c(4))
        ),
        conditionalPanel(
            condition = "(input.model == 'amgear') || (input.model == 'amgearint') || (input.model == 'amcylgear')",
            selectInput("numgear","No. of Gears",c(3,4,5,6,7,8),selected = c(4))
        ),
        br(),
        helpText('Summary for the chosen model will be available in the "Summary" tab,
                 and input mtcars data to create the model is available in "Data" tab.')
    ),
    mainPanel(
        tabsetPanel(
            tabPanel('Plots', plotOutput("plot")),
            tabPanel("Prediction", verbatimTextOutput("prediction")),
            tabPanel("Summary", verbatimTextOutput("summary")),
            tabPanel('Data',
                     dataTableOutput("mytable"))
        )
    )
))