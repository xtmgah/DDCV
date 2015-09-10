#' Plot two drug combination isobologram
#' 
#' @param drMatrix input strandard model data
#' @param drug1Base first drug normalizated base
#' @param drug2Base second drug normalizated base
#' @param IC50base if normalization by IC50
#' @export


isobologram <- function (drMatrix,drug1Base=1, drug2Base=1, IC50base=FALSE,unit1="μM",unit2="μM") {
  
  require(ggplot2)
  
  if(IC50base){
    ic50 <- IC50(drMatrix)
    drug1Base <- as.numeric(ic50[1])
    drug2Base <- as.numeric(ic50[2])
  }
  
  dose1 <- drMatrix[,1]/drug1Base
  dose2 <- drMatrix[,2]/drug2Base
  fa    <- 1-drMatrix[,3]   ## fration of total cells or viability
  ##    Estimate the parameters in the median effect equation for single drug and their mixture at
  ##    the fixed ratio dose2/dose1=d2.d1
  fa1 <- fa
  fu <- 1-fa    ## death cell fraction
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
  lmcomb <- lm(resp[ind3]~logd[ind3])
  dmcomb <- exp(-summary(lmcomb)$coef[1,1]/summary(lmcomb)$coef[2,1])
  
  
  fa12 <-  fa1[ind3]
  d1 <- dose1[ind3]
  d2 <- dose2[ind3]
  Dx1o <- dm1*(fa12/(1-fa12))^(1/summary(lm1)$coef[2,1])
  Dx2o <- dm2*(fa12/(1-fa12))^(1/summary(lm2)$coef[2,1])
  
  temp=(Dx1o-d1)*Dx2o/(Dx1o*d2)
  dff<-data.frame(d1=d1,d2=d2,temp=temp)
  
  dff$syn<-rep(NA,length(dff$temp))
  dff$syn<-ifelse(dff$temp>1,"Antagonism","Synergy")
  dff$syn[dff$temp==1]<-"Additivity"

  
  dff$syn<-factor(dff$syn)
  levels(dff$syn)<-c("Synergy","Antagonism","Additivity")
  
  
#  colt<-temp
#  colt[temp=1]<-"black"
#  colt[temp>1]<-"green4"
#  colt[temp<1]<-"red"
  
p<- ggplot(dff,aes(x=factor(round(d1,2)),y=factor(round(d2,2)),col=factor(syn,levels=c("Synergy","Antagonism","Additivity"))))+
    geom_point(aes(size=log(abs(temp))),shape=19)+
#    guides(size=FALSE)+
    scale_color_manual("Drug-Drug interaction",breaks=c("Synergy","Antagonism","Additivity"),values=c("green","red","black"))+
  scale_size_continuous("Interaction Strength", range=c(1,10))+
    xlab(paste0("\n",colnames(drMatrix)[1]," concentration (",unit1,")"))+
    ylab(paste0(colnames(drMatrix)[2]," concentration (",unit2,")\n"))+
    ggtitle("Isobologram\n")+
    theme(
      panel.background = element_blank(),
      legend.text = element_text(size = 10),
      plot.title = element_text(face="bold",colour="black"),
 #     legend.key = element_blank(),
      legend.position = "bottom",
      panel.grid.major = element_line(linetype = "dotted", colour = "grey"),
      panel.grid.minor = element_line(linetype = "dotted", colour = "grey50")
      )
  
  return(p)

  
}