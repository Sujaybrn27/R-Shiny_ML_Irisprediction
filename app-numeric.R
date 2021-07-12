library(shiny)
library(data.table)
library(randomForest)

model <- readRDS("model.rds")

ui <- pageWithSidebar(
    headerPanel("Iris Predictor"),
    sidebarPanel(
        HTML("<h3>Please enter your dimensions:</h3>"),
        numericInput("sl", label = "Sepal Length", value = 5.1),
        numericInput("sw", label = "Sepal Width", value = 3.6),
        numericInput("pl", label = "Petal Length", value = 4.0),
        numericInput("pw", label = "Petal Width", value = 4.5),
        actionButton("submitbutton", "Submit", 
                     class = "btn btn-primary")
    ),
    mainPanel(
        tags$label(h3('Status/output')),
        verbatimTextOutput('contents'),
        tableOutput('tabledata')
    )
)

server <- function(input, output, session){
    datasetinput <- reactive({
        df <- data.frame(
            Name = c("Sepal Length",
                     "Sepal Width",
                     "Petal Length",
                     "Petal Width"),
            value = as.character(c("input$sl",
                                   "input$sw",
                                   "input$pl",
                                   "input$pw")),
            stringsAsFactors = FALSE)
        Species <- 0
        df <- rbind(df, Species)
        input <- transpose(df)
        write.table(input,"input.csv", sep=",", quote = FALSE, row.names = FALSE, col.names = FALSE)
        
        test <- read.csv(paste("input", ".csv", sep=""), header = TRUE)
        
        Output <- data.frame(Prediction=predict(model,test), round(predict(model,test,type="prob"), 3))
        print(Output)
    })
    output$contents <- renderPrint({
        if(input$submitbutton>0){
            print("Calculation Completed")
        }else{
            print("Calculation in progress")
        }
    })
    output$tabledata <- renderTable({
        if(input$submitbutton>0){
            datasetinput()
        }
    })
}
shinyApp(ui = ui, server = server)





