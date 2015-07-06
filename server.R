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
is.installed("d3heatmap")
is.installed("DT")

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



### Add CI_range table ###
ci_range<-read.table("data/CI_range.txt",header=T,sep="\t")
#matrix_example<-read.csv("data/shapeAdata.csv",header=TRUE,stringsAsFactors=F,check.names=F)
#column3_example<-read.csv("data/shapeBdata.csv",header=TRUE,stringsAsFactors=F,check.names=F)


sfiles<-list.files(path="DDCV_function/",pattern=".R",full.names=TRUE)
for( fileA in sfiles) {source(fileA)}

dfpath<-'data/shapeAdata.csv'

shinyServer(function(input, output,session){
  
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

  
  output$format_data<-DT::renderDataTable({
    tmpdata<-datasetInput() 
    datatable(tmpdata,extensions = 'TableTools', rownames = FALSE,options = list(dom = 'T<"clear">lfrtip',tableTools = list(sSwfPath = copySWF('www')))) %>% 
      formatRound(3,3) %>% 
                formatStyle('Fraction',
      background = styleColorBar(tmpdata$Fraction, '#a8ce1b'),
      backgroundSize = '100% 90%',
      backgroundRepeat = 'no-repeat',
      backgroundPosition = 'center')
    })

  
  output$view <- renderTable({  
    IC50(drMatrix=datasetInput())
  })
  

  plotrmprofile<-reactive({
    rmProfile(drMatrix=datasetInput(),drug1=input$dname1,drug2=input$dname2)
  })
  
  output$rmprofile <- renderPlot({
    print(plotrmprofile())
  })
  
  
  output$heatmap <- renderD3heatmap({
    d3heatmap(rmheatmap(datasetInput()), colors = greenred(75),dendrogram = "none",cexRow=1,cexCol = 1)
  })
  
  output$htleg <- renderText({paste0("X: ",input$dname1," dose | ","Y: ", input$dname2," dose")})

  
  plotmeffect<-reactive({
    mEffect(drMatrix=datasetInput(),IC50base=input$normal1)
  })
  output$meffect <- renderPlot({
    print(plotmeffect())  
  })

  plotmeffect2<-reactive({
    mEffect2(drMatrix=datasetInput(),IC50base=input$normal2)
  })
  output$meffect2 <- renderPlot({
   print(plotmeffect2())
  })
  
  plotisob<-reactive({
    isobologram(drMatrix=datasetInput(),IC50base=input$normal3)
  })
  output$isob <- renderPlot({
    print(plotisob())
  })
  
  output$ci_range<-renderTable({ ci_range })
  
  plotcindex<-reactive({
    cIndex(drMatrix=datasetInput(),IC50base=input$normal4)
  })
  output$cindex <- renderPlot({
     print(plotcindex())
  })
  
  plotcindex2<-reactive({
    cIndex2(drMatrix=datasetInput(),IC50base=input$normal4) 
  })
  output$cindex2 <- renderPlot({
    print(plotcindex2())
  })
  
  plotcshift<-reactive({
    cShift(drMatrix=datasetInput(),IC50base=input$normal5)
  })
  output$cshift <- renderPlot({
    print(plotcshift())
  })
  
  plotcshift2<-reactive({
    cShift2(drMatrix=datasetInput(),IC50base=input$normal6)
  })
  output$cshift2 <- renderPlot({
    print(plotcshift2())
    
  })
  
  plotusresponse<-reactive({
    usReponse(drMatrix=datasetInput()) 
  })
  output$usresponse <- renderPlot({
    print(plotusresponse())
  })
  
  plotusresponse2<-reactive({
    usReponse2(drMatrix=datasetInput()) 
  })
  output$usresponse2 <- renderPlot({
    print(plotusresponse2())
  })
  
  plotdcontour<-reactive({
    dContour(drMatrix=datasetInput())
  })
  output$dcontour <- renderPlot({
    print(plotdcontour())
  })

  output$downloadPlot<- downloadHandler(
    filename <- function() {
    paste('DDCV_result_', Sys.Date(),'.pdf',sep='')
  },
  content = function(file) {
    pdf(file,width = 12,height = 8,onefile = T)
    plotrmprofile()
    plotmeffect()
    plotmeffect2() 
    plotisob()
    plotcindex()
    plotcindex2()
    plotcshift()
    plotcshift2()
    plotusresponse()
    plotusresponse2()
    plotdcontour()
    dev.off()
  }
)

 

})
