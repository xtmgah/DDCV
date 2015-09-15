library(shiny)
#library(shinyIncubator)

## Function to check whether package is installed

is.installed <- function(mypkg) {
  tmp <- is.element(mypkg,installed.packages()[,1])
  if(!tmp){ install.packages(mypkg)}
}


## check if package is installed 
is.installed("shiny")
is.installed("ggplot2")
is.installed("gplots")
is.installed("reshape2")
is.installed("lattice")
is.installed("plyr")
is.installed("scatterplot3d")
is.installed("shinythemes")
#is.installed("d3heatmap")
is.installed("DT")
is.installed("grid")

library("shiny")
library("ggplot2")
library("gplots")
library("reshape2")
library("lattice")
library("plyr")
library("scatterplot3d")
library("shinythemes")
library("d3heatmap")
library("DT")
library("dplyr")
library("markdown")
library ("grid")



### Add CI_range table ###
ci_range<-read.table("data/CI_range.txt",header=T,sep="\t")
#matrix_example<-read.csv("data/shapeAdata.csv",header=TRUE,stringsAsFactors=F,check.names=F)
#column3_example<-read.csv("data/shapeBdata.csv",header=TRUE,stringsAsFactors=F,check.names=F)


sfiles<-list.files(path="DDCV_function/",pattern=".R",full.names=TRUE)
for( fileA in sfiles) {source(fileA)}

dfpath<-'data/shapeAdata.csv'

shinyServer(function(input, output,session){
  
  
  values <- reactiveValues(shouldShow=FALSE)
  
  observe({
    if(input$loading){
      
      updateRadioButtons(session = session,inputId = 'fty',label = 'CSV File Format',choices=list("Matrix (with header)"='shapeA',"Column3 (with header)"='shapeB'),selected='shapeA')
      session$sendCustomMessage(type = "resetFileInputHandler", "file1")
      values$shouldShow =TRUE
    }
  })
  
  observe({
    if(is.null(input$file1)) return()
    values$shouldShow =FALSE
  })
  
  
  output$fileUploaded <- reactive({
    return(is.null(input$file1) && !(input$loading))
  })
  outputOptions(output, 'fileUploaded',suspendWhenHidden=FALSE)
  
  inFile <- reactive({
    validate(
      need(!is.null(input$file1) || (input$loading), '')
      #<-- Please upload your drug-drug combination data or load example data on the left panel
    )
    if(values$shouldShow) return(dfpath)
    if(!is.null(input$file1)) return((input$file1)$datapath)
    return(NULL)
  })
  
  observe({
    
    if(input$fty == "shapeA" && !is.null(inFile())){
      tmp <- read.csv(inFile(),header = F, nrows=1)
      if(input$loading){
        updateTextInput(session,inputId = "dname1",value ="AZD7762")
        updateTextInput(session,inputId = "dname2",value ="TMZ")
      }else {
        updateTextInput(session,inputId = "dname1",value ="DrugA")
        updateTextInput(session,inputId = "dname2",value ="DrugB")
      }
    }
    
    if(input$fty == "shapeB" && !is.null(inFile())){
      tmp <- read.csv(inFile(),header = F, nrows=1)
      updateTextInput(session,inputId = "dname1",value =tmp$V1)
      updateTextInput(session,inputId = "dname2",value =tmp$V2)
    }
  })
  
  
  observe({
    input$swap
    
    isolate({
      if(!is.null(input$file1) || (input$loading)){
        tname1 <- input$dname1
        tname2 <- input$dname2
        updateTextInput(session,inputId = "dname1",value =tname2)
        updateTextInput(session,inputId = "dname2",value =tname1)
        
        tunit1 <- input$unit1
        tunit2 <- input$unit2
        updateTextInput(session,inputId = "unit1",value =tunit2)
        updateTextInput(session,inputId = "unit2",value =tunit1)
      }
    })
    
    
  })
  
  
  output$downloadMatrix<-downloadHandler(
    filename=function(){
      c("Matrix_example.csv")
    },
    content=function(file) {
      #        write.csv(matrix_example,file,row.names=FALSE)
      file.copy("data/shapeAdata.csv",file)
    }
  )
  
  
  output$downloadColumn3<-downloadHandler(
    filename=function(){
      c("column3_example.csv")
    },
    content=function(file) {
      #        write.csv(column3_example,file,row.names=FALSE)
      file.copy("data/shapeBdata.csv",file)
      
    }
  )
  
  
  
  datasetInput <- reactive({
    if (input$fty == "shapeA") {
      shapeA(inFile(),drug1=input$dname1,drug2=input$dname2,swap=input$swap)
    }else{
      shapeB(inFile(),drug1=input$dname1,drug2=input$dname2,swap=input$swap,threeColumn=1:3)
    }
    
  })
  
  
  
  output$format_data<-DT::renderDataTable({
    tmpdata<-datasetInput() 
    tmpdata[,3]=1-tmpdata[,3]
    colnames(tmpdata)[1]<-paste0(colnames(tmpdata)[1]," concentration"," (",input$unit1,")")
    colnames(tmpdata)[2]<-paste0(colnames(tmpdata)[2]," concentration"," (",input$unit2,")")
    colnames(tmpdata)[3] <- "Effect fraction"
    tmpdata[,1]<-as.character(tmpdata[,1])
    tmpdata[,2]<-as.character(tmpdata[,2])
    datatable(tmpdata,extensions = 'TableTools', rownames = FALSE,filter = list(position = 'top', clear = FALSE),options = list(dom = 'T<"clear">lfrtip',tableTools = list(sSwfPath = copySWF('www')))) %>% 
      formatRound(3,3) %>% 
      formatStyle('Effect fraction',
                  background = styleColorBar(tmpdata$`Effect fraction`, '#a8ce1b'),
                  backgroundSize = '100% 90%',
                  backgroundRepeat = 'no-repeat',
                  backgroundPosition = 'center')
  })
  
  
  output$view <- renderTable({  
    IC50(drMatrix=datasetInput())
  })
  
  output$rmprofile <- renderPlot({
    print(rmProfile(drMatrix=datasetInput(),drug1=input$dname1,drug2=input$dname2,unit1=input$unit1,unit2=input$unit2)
    )
  })
  
  #  output$heatmap <- renderD3heatmap({
  #    d3heatmap(rmheatmap(datasetInput()), colors = greenred(75),dendrogram = "none",cexRow=1,cexCol = 1)
  #  })
  
  #output$htleg <- renderText({paste0("X: ",input$dname1," dose | ","Y: ", input$dname2," dose")})
  
  output$meffect <- renderPlot({
    print(mEffect(drMatrix=datasetInput(),IC50base=input$normal1))  
  })
  
  output$meffect2 <- renderPlot({
    print(mEffect2(drMatrix=datasetInput(),IC50base=input$normal1))
  })
  
  output$meffect3 <- renderPlot({
    print(mEffect3(drMatrix=datasetInput(),IC50base=input$normal1))
  })
  
  output$isob <- renderPlot({
    print(isobologram(drMatrix=datasetInput(),IC50base=input$normal2,unit1=input$unit1,unit2=input$unit2))
  })
  
  output$ci_range<-renderTable({ ci_range })
  
  output$cindex <- renderPlot({
    print(cIndex(drMatrix=datasetInput(),IC50base=input$normal3))
  }) 
  
  
  output$cindex2 <- renderPlot({
    print( cIndex2(drMatrix=datasetInput(),IC50base=input$normal3,unit1=input$unit1,unit2=input$unit2) )
  })
  
  output$cshift <- renderPlot({
    print(cShift(drMatrix=datasetInput(),IC50base=input$normal4))
  })
  
  output$cshift2 <- renderPlot({
    print(cShift2(drMatrix=datasetInput(),IC50base=input$normal4))
    
  })
  output$cshift3 <- renderPlot({
    print(cShift3(drMatrix=datasetInput(),IC50base=input$normal4))
    
  })
  
  output$usresponse <- renderPlot({
    print(usReponse(drMatrix=datasetInput(),unit1=input$unit1,unit2=input$unit2))
  })
  
  
  output$usresponse2 <- renderPlot({
    print(usReponse2(drMatrix=datasetInput(),unit1=input$unit1,unit2=input$unit2))
  })
  
  
  output$dcontour <- renderPlot({
    print(dContour(drMatrix=datasetInput(),unit1=input$unit1,unit2=input$unit2))
  })
  
  output$downloadPlot<- downloadHandler(
    filename <- function() {
      paste('DDCV_result_', Sys.Date(),'.pdf',sep='')
    },
    content = function(file) {
      cairo_pdf(file,width = input$w,height = input$h,onefile = T)
      print(rmProfile(drMatrix=datasetInput(),drug1=input$dname1,drug2=input$dname2,unit1=input$unit1,unit2=input$unit2))
      mEffect(drMatrix=datasetInput(),IC50base=input$normal1)
      mEffect2(drMatrix=datasetInput(),IC50base=input$normal1)
      mEffect3(drMatrix=datasetInput(),IC50base=input$normal1)
      print(isobologram(drMatrix=datasetInput(),IC50base=input$normal2,unit1=input$unit1,unit2=input$unit2))
      cIndex(drMatrix=datasetInput(),IC50base=input$normal3)
      print(cIndex2(drMatrix=datasetInput(),IC50base=input$normal3,unit1=input$unit1,unit2=input$unit2)) 
      print(cShift(drMatrix=datasetInput(),IC50base=input$normal4))
      cShift2(drMatrix=datasetInput(),IC50base=input$normal4)
      cShift3(drMatrix=datasetInput(),IC50base=input$normal4)
      usReponse(drMatrix=datasetInput(),unit1=input$unit1,unit2=input$unit2)
      print(usReponse2(drMatrix=datasetInput(),unit1=input$unit1,unit2=input$unit2))
      dContour(drMatrix=datasetInput(),unit1=input$unit1,unit2=input$unit2)
      
      dev.off()
    }
  )
  
  
  output$downloadData <- downloadHandler(
    filename = function(){
      "Manuscript_Data.zip"
    },
    content = function(file) {
      file.copy("data/Manuscript_Data.zip",file)
    }
  )
  
  
})
