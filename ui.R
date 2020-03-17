
# Data Visualization Final Project
# By: Gokturk Demir,  Lei Hong, Jiewen Wu, Yiyan Wan
#

library(shiny)
library(shinydashboard)
library(ggplot2)
library(ggthemes)
library(party)
library(caret)
library(plotly)
library(curl)
library(RCurl)
library(devtools)
install_github("nik01010/dashboardthemes")
library(plotly)



shinyUI(
ui <- dashboardPage(
                    dashboardHeader(title = "QuickLoan Services"
                    ),
                    dashboardSidebar(
                        sidebarMenu(id = 'sidebarmenu',
                            menuItem("Interest Rate Calculator", tabName = "Prediction", icon = icon("dashboard")),
                            conditionalPanel("input.sidebarmenu =='Prediction'", selectInput("X20", "Choose your state of residency:", 
                                                                                             choices = c( "AK","AL","AR","AZ","CA","CO","CT","DC","DE","FL","GA","HI","IA","ID","IL","IN","KS","KY","LA","MA","MD",
                                                                                                          "ME","MI","MN","MO","MS","MT","NC","NE","NH","NJ","NM","NV","NY","OH","OK","OR","PA","RI","SC","SD","TN","TX",
                                                                                                          "UT","VA","VT","WA","WI","WV","WY")),
                                             numericInput("X13", "Annual Income of borrower:", 1000, min = 1),
                                             numericInput("X4", "Loan amount requested:", 1000, min = 100),
                                             selectInput('X12','Home Ownership Status:',choices = c("MORTGAGE","NONE","OTHER","OWN","RENT"))
                                             
                            ),

                            menuItem("Visualizations",icon = icon("th"),
                                     menuSubItem('Loan Overview Map',tabName = 'map'),
                                     menuSubItem("Loan Category", tabName = "pie"),
                                     menuSubItem("Interest for Loan Grade", tabName = "boxplot"),
                                     menuSubItem("Frequency by Num_Credit", tabName = "frequency_credit"),
                                     menuSubItem('Interest by Num_Payment',tabName = 'num_payment'),
                                     menuSubItem('Loan by Home*Work Year',tabName = 'home_ownership'),
                                     menuSubItem('Interest and Income',tabName = 'collection')
                    ))),
                    dashboardBody(
                        # Boxes need to be put in a row (or column)
                        dashboardthemes::shinyDashboardThemes(theme = 'purple_gradient'),
                       tabItems(
                           tabItem(tabName = "Prediction",
                                   h2("Interest Rate Calculator"),
                                    fluidRow(
                                       box(title = "Information you entered:",width = 10,
                                           status = "primary", solidHeader = TRUE, collapsible = TRUE,
                                           tableOutput("table")
                                       ),
                                       box(title = "Prediction:", width = 10, 
                                           status = "primary",  solidHeader = TRUE, collapsible = TRUE,
                                           verbatimTextOutput("pred")
                                   )
                           )
                        ),
                        tabItem(tabName = 'map',
                                h2('Map'),
                                fluidRow(
                                    box(title = 'Amount of Loan Requested in Each State',width = 20, status = 'primary',solidHeader = TRUE,collaspible = TRUE, plotlyOutput('view0'))
                                )),
                        
                            tabItem(tabName = "pie",
                                    h2("Loan Category"),
                                    fluidRow(
                                        box(title = "Loan Category",  width = 8,  background = "red",
                                            status = "primary", solidHeader = TRUE, collapsible = TRUE,
                                            plotOutput("view1")
                                        )
                                    )
                            ),
                            
                            tabItem(tabName = "boxplot",
                                    h2("Interest rate for each loan grade"),
                                    fluidRow(
                                        box(title = "Interest rate for each loan grade",  width = 11,  background = "red",
                                            status = "primary", solidHeader = TRUE, collapsible = TRUE,
                                            plotOutput("view2")
                                        )
                                       
                                    )
                            ),
                            
                            tabItem(tabName = "frequency_credit",
                                    h2("Frequency by Number of Credit Lines"),
                                    fluidRow(
                                        box(title = "Frequency by Number of Credit Lines",  width = 9,  background = "red",
                                            status = "primary", solidHeader = TRUE, collapsible = TRUE,
                                            plotlyOutput("view3")
                                        )
                                    )
                            ),
                        
                             tabItem(tabName = "num_payment",
                                h2("Interest Rate by Number of Payments"),
                                fluidRow(
                                    box(title = "Frequency by Number of Payment",  width = 9,  background = "red",
                                        status = "primary", solidHeader = TRUE, collapsible = TRUE,
                                        plotOutput("view4")
                                    )
                                )
                            ),
                             tabItem(tabName = "home_ownership",
                                h2("Number of Loan Requests by Home Ownership * Working years"),
                                fluidRow(
                                    box(title = "Number of Loan Requests by Home Ownership * Working years",  width = 9,  background = "red",
                                        status = "primary", solidHeader = TRUE, collapsible = TRUE,
                                        plotOutput("view5")
                                    )
                                )
                        ),
                        
                            tabItem(tabName = 'collection',
                                h2('Plots of interest rate and income'),
                                fluidRow(
                                    box(title = "Plots of interest rate and income",  width = 9,  background = "red",
                                        status = "primary", solidHeader = TRUE, collapsible = TRUE,
                                        plotOutput("view6")
                                    )
                                )
                                )
                        )
                        )
                    )
)