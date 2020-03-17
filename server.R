## Data Visual Final Project Group 5
## By: Gokturk Demir, Lei Hong, Jiewen Wu, Yiyan Wan


shinyServer(function(input, output,graphtype) {
  
  library(RCurl)
  x=getURL('https://raw.githubusercontent.com/amiao-h/Shinyloan/master/loan_visulization.csv')
  train_shiny = read.csv(text=x,sep = ',')
  head(train_shiny)
  sub_dat = train_shiny
  str(sub_dat)
  sub_dat['X1'] = substr(sub_dat$X1,
                         start = 1, 
                         stop= nchar(as.character(sub_dat$X1))-1) 
  sub_dat$X1 = as.numeric(sub_dat$X1)
  sub_dat$X4 = gsub('$', '', sub_dat$X4, fixed = TRUE)
  sub_dat$X4 = as.numeric(sub(",", "", sub_dat$X4))
    test = reactive({
  
            df <- data.frame(loan_amount = (input$X4),annual_income = (input$X13),state_of_residency = (input$X20),home_ownership = (input$X12))
          list(df=df) 
        
        
    })
    df_grade_interest = train_shiny[,c("X1", "X8")]
    
    output$pred <- renderPrint({
        
        if (input$X4 <= 50){
            return(NULL)
        }
        else if(input$X13 < 0) {
            return(NULL)
        }
        else{
            test.data = data.frame(input$X4, input$X13, input$X20, input$X12)
            colnames(test.data) = c("X4", "X13", "X20",'X12')
            ###########################################################
            ## load training data
            ###########################################################
            
            
            # perform Linear model
            lm.fit = lm(X1 ~ X4 + X13 + X20  +  X12, data = sub_dat)
            
            # make predictions
            lm.pred<-predict(lm.fit, test.data)
            
            paste("Based on your info, the estimated interest rate is ", round(lm.pred[1],2),'%',sep='')
            
        } })
    output$table = renderTable({
        test()$df
    })
    output$view0 = renderPlotly({
        df = num_loan_by_state
        
        # give state boundaries a white border
        l <- list(color = toRGB("white"), width = 2)
        # specify some map projection/options
        g <- list(
            scope = 'usa',
            projection = list(type = 'albers usa'),
            showlakes = TRUE,
            lakecolor = toRGB('white')
        )
        
        
        fig <- plot_geo(df, locationmode = 'USA-states')
        fig <- fig %>% add_trace(
            z = ~Count,locations = ~State,
            color = ~Count, colors = 'Blues'
        )
        fig <- fig %>% colorbar(title = "Number of Loan Requested")
        fig <- fig %>% layout(
            title = 'Amount of Loan Requested in Each State',
            geo = g
        )
          fig
    })
    
    output$view1 = renderPlot({
        value_count = as.data.frame(table(train_shiny$X17))
        value_count$Freq = value_count$Freq/dim(train_shiny)[1]
        a <-value_count[order(value_count$Freq),]
        frequencytable = tail(a,4)
        ggplot(frequencytable, aes(x="", y=Freq, fill=Var1)) + geom_bar(stat="identity", width=1) +
            coord_polar("y", start=0) + geom_text(aes(label = paste0(round(Freq*100), "%")), position = position_stack(vjust = 0.5)) +
            labs(x = NULL, y = NULL, fill = NULL, title = "Loan Category") + scale_fill_brewer(palette="PuBu")+
            theme_classic() + theme(axis.line = element_blank(), axis.text = element_blank(), axis.ticks = element_blank(),plot.title = element_text(hjust = 0.5, color = "#666666"))

                 })
    
     output$view2 = renderPlot({
         boxplot(
             X1 ~ X8,
             data = df_grade_interest,
             main = "Interest rate for each loan grade",
             xlab = "Loan Grade",
             ylab = "Interest rate",
             col = "grey",
             border = "blue")
     })
    output$view3 = renderPlotly({
        df_number_of_credit = as.data.frame(table(train_shiny$X27))
        df_2 = df_number_of_credit[order(df_number_of_credit$Freq),]
        g1 = ggplot(df_2, aes(x = Var1, y = Freq)) +
            geom_bar(stat = "identity", color = "blue", fill = "grey") +
            labs(title = "Frequency by Number of credit lines\n", x = "\nNumber of credit lines", y = "Frequency\n") +
            theme_classic() + geom_smooth(method = "normal") 
        ggplotly(g1)
    })
    
    output$view4 = renderPlot({
        ggplot(train_shiny, aes(x=X1, fill=X7)) + geom_density(alpha=.5)+
            labs(title = "Interest Rate by Number of Payments", x = "Interest Rate",y = "Density") +
            scale_fill_brewer(palette="PuBu")+theme_classic()+ guides(fill=guide_legend(title=NULL))        
        
    })
    output$view5 = renderPlot({
        home_owndership_grade=xtabs(X1~X11_new+X12,train_shiny)
        mosaicplot(home_owndership_grade,ylab='Home Ownership',xlab='Number of years employed ',
                   color=TRUE,border='blue',main=NULL,las=1)
    })
    output$view6 = renderPlot({
        par(mfrow=c(2,2), las=1, bty="n")
        #histogram of interest rate
        
        hist(train_shiny$X1,
             main='Histogram of interest rate',
             xlab='interest rate',
             color = "grey",
             border = "blue")
        
        ##histogram of log income
        
        hist(train_shiny$logX13,
             main='Histogram of annual income',
             xlab='annual income',
             color = "grey",
             border = "blue",
             col='grey')
        
        ## boxplot of year of work
        #not good
        boxplot(X1~X11_new,
                main='interest rate by working years',
                xlab='number of years employed ',
                ylab='interest rate',
                color = "grey",
                border = "blue",
                data=train_shiny)
        
        
        boxplot(logX13~X8,
                main='income by working years',
                xlab='loan grade',
                ylab='log income',
                color = "grey",
                border = "blue",
                data=train_shiny)
      
    
    })
    })
    