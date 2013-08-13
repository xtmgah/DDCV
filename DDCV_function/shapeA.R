#' Convert an Table data into standard funciton input
#' 
#' @param inputFile path to input csv file
#' @param swap exchange between two columns
#' @param drug1 first drug name
#' @param drug2 second drug name
#' @return standard model input data
#' @export
shapeA <- function (inputFile, drug1="Drug1", drug2="Drug2",swap=FALSE) {
  #options(digits=2)
  require(reshape2)
  require(plyr)
  mydata<-read.csv(file=inputFile,header=TRUE,stringsAsFactors=F,check.names=F)
  colnames(mydata)[1]<-drug1
  mydata2<-melt(mydata,id=colnames(mydata)[1],value.name="Signal",variable.name=drug2)
  mydata2[,1]<-as.numeric(as.character(mydata2[,1]))
  mydata2[,2]<-as.numeric(as.character(mydata2[,2]))
  mydata2[,3]<-as.numeric(as.character(mydata2[,3]))
  mydata3<-ddply(mydata2,c(drug1,drug2),summarise,Fraction=mean(Signal))
  maxSignal=max(mydata3$Fraction)
  mydata3$Fraction<-mydata3$Fraction/maxSignal
  
  if(swap) { 
    mydata3<-mydata3[,c(2,1,3)]
  }
  
  colnames(mydata3)[1:2]<-c(drug1,drug2)
  
  ## sort by drug1 and then drug2 
  mydata3<-mydata3[with(mydata3,order(mydata3[,1],mydata3[,2])),]
  
  ## set 0 concentration maximum
  mydata3[1,3]<-1
  
  ## Remove outliner 
  tmp<-mydata3[,3]==1
  tmp[1]<-FALSE
  mydata3<-mydata3[!tmp,]
  
  
  ##return
  return(mydata3)
  
    
}


