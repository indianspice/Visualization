library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)
library(scales)
library(DT)


dataS <- read.csv("https://raw.githubusercontent.com/indianspice/IS608/master/Final%20Project/Data/shinydata.csv",
                  stringsAsFactors = FALSE)
    
function(input, output, session) {
    
    
    
    output$plot2 <- renderPlot({
        
        filtered <- dataS %>%
            filter(TotalRecords >= input$records[1],
                   TotalRecords <= input$records[2],
                   TypeofBreach == input$breach,
                   TypeofOrganization == input$organzation
                   )
        
        ggplot(filtered, aes(x=Year, y=TotalRecords)) + 
            geom_jitter(size = 3, color = "red") + 
            ylab("Total Records") + 
            ggtitle("Type of Instution by Type of Breach") +
            scale_y_continuous(labels = comma) + 
            theme(panel.grid = element_blank(), plot.title = element_text(hjust = 0.5),
                  title=element_text(size=14,face="bold"))
    })
    
    #Tooltip 
    #Reference http://www.77dev.com/2016/03/custom-interactive-csshtml-tooltips.html
    
    output$hover_info <- renderUI({
        hover <- input$plot_hover
        point <- nearPoints(dataS, hover, threshold = 5, maxpoints = 1, 
                            addDist = TRUE)
        if (nrow(point) == 0) return(NULL)
        
        # calculate point position INSIDE the image as percent of total dimensions
        # from left (horizontal) and from top (vertical)
        left_pct <- (hover$x - hover$domain$left) / 
            (hover$domain$right - hover$domain$left)
        top_pct <- (hover$domain$top - hover$y) / 
            (hover$domain$top - hover$domain$bottom)
        
        
        # calculate distance from left and bottom side of the picture in pixels
        left_px <- hover$range$left + left_pct * (hover$range$right - hover$range$left)
        top_px <- hover$range$top + top_pct * (hover$range$bottom - hover$range$top)
        
        
        # create style property fot tooltip
        # background color is set so tooltip is a bit transparent
        # z-index is set so we are sure are tooltip will be on top
        style <- paste0("position:absolute; z-index:100;
                        font-size: 10px;
                        background-color: rgba(255,0,0,0.3); ",
                        "left:", left_px + 2, "px; top:", top_px + 2, "px;")
        # actual tooltip created as wellPanel
        wellPanel(
            style = style,
            p(HTML(paste0(#"<b> Total: </b>", rownames(point), "<br/>",
                          "<b> Total Records: </b>", point$TotalRecords, "<br/>",
                          "<b> Year: </b>", point$Year, "<br/>",
                          "<b> Organization Type: </b>", point$TypeofOrganization, "<br/>",
                          "<b> Type of Breach: </b>", point$TypeofBreach, "<br/>",
                          "<b> Company Name: </b>", point$Company, "<br/>")))    
                         #"<b> Type of Organization: </b>", left_px, "<b>, 
                         #from top: </b>", 
                          #top_px)))
        )
        
    })
 
    
    
    #Add column filters to the table
    output$tbl = DT::renderDataTable({
        datatable(dataS, filter="top", options = list(pageLenght = 6, autoWidth = TRUE))
        
        datatable(dataS) %>% formatStyle(
            'TotalRecords',
            backgroundColor = styleInterval(10000, c('gray', 'lightblue'))
        )
    }) 
  
    #Data table with graph
    output$names = DT:: renderDataTable({
        filteredma <- dataS %>%
            filter(TotalRecords >= input$records[1],
                   TotalRecords <= input$records[2],
                   TypeofBreach == input$breach,
                   TypeofOrganization == input$organzation
            )
        datatable(filteredma)
        
        keeps <- c("Company", "TypeofBreach", "TypeofOrganization", "TotalRecords")
        filteredma[keeps]
    })  
    
    #Summary stats of TotalRecordsBreach
    output$summary <- renderPrint({
        summary(dataS$TotalRecords)
    })
    
 
         
}


    