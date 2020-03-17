shinyUI(
    ui=fluidPage(
        headerPanel("Interest Rate Predictor"),
        tabsetPanel(
            tabPanel('Prediction',
                     sidebarPanel(
                         selectInput("X20", "Choose your state of residency:", 
                                     choices = c( "AK","AL","AR","AZ","CA","CO","CT","DC","DE","FL","GA","HI","IA","ID","IL","IN","KS","KY","LA","MA","MD",
                                                  "ME","MI","MN","MO","MS","MT","NC","NE","NH","NJ","NM","NV","NY","OH","OK","OR","PA","RI","SC","SD","TN","TX",
                                                  "UT","VA","VT","WA","WI","WV","WY")),
                         numericInput("X13", "Annual Income of borrower:", 1000, min = 1),
                         numericInput("X4", "Loan amount requested:", 1000, min = 100),
                         selectInput('X12','Home Ownership Status:',choices = c("MORTGAGE","NONE","OTHER","OWN","RENT")),
                         submitButton("Calculate")
                     ),
                     mainPanel(

                         tabPanel("Prediction", verbatimTextOutput("prediction"))# Regression output
                     )
            ),
            tabPanel("Visualization",
                     sidebarPanel(
                         selectInput("Graphtype", "Choose a plot:", 
                                     choices = c("Loan Category", "Interest rate for each loan grade", "Number of Loan Requests by Home Ownership * Working years",
                                                 "Frequency by Number of credit lines","Number of Loan Requests by State"
                                                 ,"plots of interest rate and income","Interest Rate by Number of Payments")),
                         submitButton("Let's plot it")
                     ),
                     mainPanel(
                         tabPanel("Visualization", plotOutput("Graphs"))
                         #plotOutput("pie"),plotOutput("scatter"),plotOutput("frequency_loan"),plotOutput("frequency_credit")) # Plot
                         
             
                     )
                    )
        )
    )
)

