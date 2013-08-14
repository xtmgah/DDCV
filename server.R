library(shiny)

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

sfiles<-list.files(path="DDCV_function/",pattern=".R",full.names=TRUE)
for( fileA in sfiles) {source(fileA)}

dfpath<-'./testdata/shapeAdata.csv'

shinyServer(function(input, output){
  
  datasetInput <- reactive({
    inFile <- input$file1
    filepath <- ifelse(is.null(inFile),dfpath,inFile$datapath)
#    ifelse (is.null(inFile)) {
#      return(NULL)
#    }
    if (input$fty == "shapeA") {
      shapeA(filepath,drug1=input$dname1,drug2=input$dname2,swap=input$swap)
    }else{
      shapeB(filepath,drug1=input$dname1,drug2=input$dname2,swap=input$swap,threeColumn=1:3)
    }
    
  })
  
  
  
  output$view <- renderTable({  
    IC50(drMatrix=datasetInput())
  })
  
  output$rmprofile <- renderPlot({
    rmProfile(drMatrix=datasetInput(),drug1=input$dname1,drug2=input$dname2)
  })
  
  output$meffect <- renderPlot({
    mEffect(drMatrix=datasetInput(),IC50base=input$normal1)
  })
  
  output$meffect2 <- renderPlot({
    mEffect2(drMatrix=datasetInput(),IC50base=input$normal2)
  })
  
  output$isob <- renderPlot({
    isobologram(drMatrix=datasetInput(),IC50base=input$normal3)
  })
  
  output$cindex <- renderPlot({
    cIndex(drMatrix=datasetInput(),IC50base=input$normal4) 
  })
  
  output$cshift <- renderPlot({
    cShift(drMatrix=datasetInput(),IC50base=input$normal5)
  })
  
  output$cshift2 <- renderPlot({
    cShift2(drMatrix=datasetInput(),IC50base=input$normal6)
  })
  
  output$usresponse <- renderPlot({
    usReponse(drMatrix=datasetInput()) 
  })
  
  output$dcontour <- renderPlot({
    dContour(drMatrix=datasetInput())
  })
})
