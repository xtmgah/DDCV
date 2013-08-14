#' Universal surface response analysis of two drug combination
#' 
#' @param drMatrix input strandard model data
#' @return IC50 value for drug1, drug2 and combiantion drug
#' @export


usReponse2 <- function (drMatrix) {
  
  require(ggplot2)
  var.name <- names(drMatrix)
  dose1 <- drMatrix[,1]
  dose2 <- drMatrix[,2]
  fa    <- 1-drMatrix[,3]   ## Drug Effect
  
  fa1 <- fa 
  fu <- 1-fa    ## Drug unEffect
  resp <- rep(NA, length(fa))
  resp[!(fa==0 | fa==1)] <- log(fa[!(fa==0 | fa==1)]/fu[!(fa==0 | fa==1)])  ## resp=log(fa/fu)
  totdose <- dose1 + dose2
  logd <- log(totdose)
  
  ind1 <- dose2==0 & dose1!=0
  ind2 <-dose1==0 & dose2!=0
  ind3<-dose1!=0 & dose2!=0
  
  ##     Estimate the parameters using median-effect plot for two single drugs and 
  ##     their combination at the fixed ratio (dose of drug 2)/(dose of drug 1)=d2.d1.
  lm1 <- lm(resp[ind1]~logd[ind1])
  dm1 <- exp(-summary(lm1)$coef[1,1]/summary(lm1)$coef[2,1])
  lm2 <- lm(resp[ind2]~logd[ind2])
  dm2 <- exp(-summary(lm2)$coef[1,1]/summary(lm2)$coef[2,1])
  #lmcomb <- lm(resp[ind3]~logd[ind3])
  #dmcomb <- exp(-summary(lmcomb)$coef[1,1]/summary(lmcomb)$coef[2,1])
  
  
  tdose1<-dose1[ind3]
  tdose2<-dose2[ind3]
  tfa<-fa[ind3]
  
  
  tA1<-(tfa/(1-tfa))^(1/(summary(lm1)$coef[1,1]))
  A1<-tdose1/(tA1*(dm1))
  
  tA2<-(tfa/(1-tfa))^(1/(summary(lm2)$coef[1,1]))
  A2<-tdose2/(tA2*(dm2))
  
  tA3<-(tfa/(1-tfa))^(0.5/(summary(lm1)$coef[1,1])+0.5/(summary(lm2)$coef[1,1]))
  A3<-(tdose1*tdose2)/(tA3*(dm1)*(dm2))
  
  alpha<-(1-A1-A2)/-A3
  
  sumtable3 <- matrix(data=NA,length(tfa),4)
  dimnames(sumtable3)[[2]] <-c('d1','d2','Effect','Alpha')
  sumtable3[,1]<-tdose1
  sumtable3[,2]<-tdose2
  sumtable3[,3]<-tfa
  sumtable3[,4]<-alpha

  newdata<-data.frame(sumtable3[,c(1,2,4)])
  names(newdata)<-c("Drug1","Drug2","Alpha")  


  theme_blank_ztw<-theme(panel.background = element_blank())+
    theme(panel.grid.minor=element_blank()) +
    theme(axis.ticks = element_blank()) +
    theme(panel.grid.major=element_blank()) +
    #theme(legend.position = "none")+
    theme(axis.ticks = element_line())+
    theme(plot.title = element_text(face="bold"))
  drug1<-names(drMatrix)[1]
  drug2<-names(drMatrix)[2]
  p<-ggplot(newdata,aes(x=factor(round(Drug1,2)),y=factor(round(Drug2,2)),label=sprintf("%1.1f",Alpha),size=10))+
    geom_tile(aes(fill=Alpha))+geom_text(aes(size=12))+
    guides(size=FALSE)+
    scale_fill_gradient(low="red",high="green")+
    #    scale_fill_manual(values=rainbow(5),breaks=c(0.5,1,1.5), labels=c('+++','+','-'))+
    xlab(paste0("\n",drug1," dose"))+
    ylab(paste0(drug2," dose\n"))+
    theme_blank_ztw+
    ggtitle("Universal Surface Response II")
  print(p)
  
}