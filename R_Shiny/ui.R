#require(devtools)
#install_github('adymimos/rWordCloud')#install_github('ramnathv/rCharts', force= TRUE)
library(shiny)
library(plotly)
library(shinythemes)
library(wordcloud)


dataS <- read.csv("https://raw.githubusercontent.com/indianspice/IS608/master/Final%20Project/Data/shinydata.csv",
                 stringsAsFactors = FALSE)


fluidPage(theme = shinytheme("cerulean"),
    
    navbarPage("Data Breaches in the United States"),
        column(4,
                   h4("Filter Data"),
                   sliderInput("records", "Number of records breached",
                               min = 10,
                               max = 1100000,
                               step = 500,
                               value=c(50000, 200000)),
               uiOutput("hover"),
               
                   selectInput("breach", "Type of breach",
                               c( 
                                 "Hacking or Malware", 
                                 "Unintended Disclosure", 
                                 "Insider", 
                                 "Portable Device", 
                                 "Stationary Device",
                                 "Unknown", 
                                 "Payment Card Fraud", 
                                 "Physical Loss")),
                 radioButtons("organzation", "Select type of organization",
                                      selected = "Educational Institutions",
                               choices = unique(dataS$TypeofOrganization))#,
                   
               ),
               
        #),
        mainPanel(
            
            tabsetPanel(
                tabPanel("Visualization",
                         div(
                             style = "position:relative",
                             plotOutput("plot2", 
                                        hover = hoverOpts("plot_hover",
                                                          delay = 100, 
                                                          delayType = "debounce"))),
                uiOutput("hover_info"),
               # width = 7,
               
                 wellPanel(
                    span("Company Names:",
                         dataTableOutput("names"), 
                         style = "font-size:60%")
                )
                ),
                
              
               #summary output
                tabPanel("Summary",
                         h4("Summary of total records breached"),
                    verbatimTextOutput("summary")
                ),
               
               #Data table output
                 tabPanel("Data", div(DT::dataTableOutput(outputId = "tbl"), 
                                     style = "font-size:60%")),
               #About
                tabPanel("About",
                 h1(
                     "CUNY- DATA608 Final Project"),
                 p(
                     "This Shiny app visualization of data breaches in the United States
                     between 2005 - 2017. The original database contained 7731 observations
                     as of October 2017. The dataset used for this Shiny contains 2382 records
                     the number of records breached was Unknown"
                 ),
                 p(
                     "Author: Sharon Morris"
                 ),
                 p( 
                     "Date:   December 17, 2017" 
                 ),
                 tags$a("Privacy Rights Clearinghouse Database",
                     href="https://www.privacyrights.org/data-breaches"
                 ),
                 p(tags$a("Github code", href="https://github.com/indianspice/IS608/tree/master/Final%20Project"))
                 )
                         
            
        )
        )

)


