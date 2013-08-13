#' Convert an Table data into standard funciton input
#' 
#' @param inputFile path to input Table csv file
#' @param swap exchange between two columns
#' @param drug1 first drug name
#' @param drug2 second drug name
#' @return standard model input data
#' @export
shapeB <- function (inputFile, drug1="Drug1", drug2="Drug2", threeColumn=2:4, swap=FALSE) {
  #options(digits=2)
  require(reshape2)
  require(plyr)
  mydata<-read.csv(file=inputFile,header=TRUE,stringsAsFactors=F,check.names=F)
  mydata<-mydata[,threeColumn]
  
  if(swap) { 
    mydata<-mydata[,c(2,1,3)]
  }
  
  colnames(mydata)<-c(drug1,drug2,"Signal")

  mydata[,1]<-as.numeric(as.character(mydata[,1]))
  mydata[,2]<-as.numeric(as.character(mydata[,2]))
  mydata[,3]<-as.numeric(as.character(mydata[,3]))
  mydata2<-ddply(mydata,c(drug1,drug2),summarise,Fraction=mean(Signal))
  maxSignal=max(mydata2$Fraction)
  mydata2$Fraction<-mydata2$Fraction/maxSignal
  
  colnames(mydata2)[1:2]<-c(drug1,drug2)
  ## sort by drug1 and then drug2 
  mydata2<-mydata2[with(mydata2,order(mydata2[,1],mydata2[,2])),]
  mydata2[1,3]<-1
  
  
  ## remove outliners
  tmp<-mydata2[,3]==1
  tmp[1]<-FALSE
  mydata2<-mydata2[!tmp,]
  
  return(mydata2)
  
}