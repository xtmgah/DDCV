#' Plot two drug response matrix profile
#' 
#' @param drMatrix input strandard model data
#' @param drug1 first drug name
#' @param drug2 second drug name
#' @export

require("reshape2")

rmheatmap <- function (drMatrix)  {
  
  names(drMatrix)<-c("Drug1","Drug2","Fraction")
#  drMatrix<-format(drMatrix,digits=2)
  drMatrix$Drug1<-round(drMatrix$Drug1,3)
  drMatrix$Drug2<-round(drMatrix$Drug2,3)
  drMatrix<-dcast(drMatrix,Drug2~Drug1,drop=FALSE)
  rownames(drMatrix)<-drMatrix[,1]
  drMatrix<-drMatrix[,-1]
  drMatrix[is.na(drMatrix)]<-1
  drMatrix <- drMatrix[ nrow(drMatrix):1, ]
  return(drMatrix)
}
