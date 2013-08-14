#' Plot two drug curve shift 
#' 
#' @param drMatrix input strandard model data
#' @param drug1Base first drug normalizated base
#' @param drug2Base second drug normalizated base
#' @param IC50base if normalization by IC50
#' @return paramter results of drug1, drug2, and drug combination
#' @export


cShift <- function (drMatrix, drug1Base=1, drug2Base=1,IC50base=TRUE) {
  require(ggplot2)
  cols=c("blue","red","green4")  
  #names(drMatrix)<-c("Drug1","Drug2","Fraction")
  var.name <- names(drMatrix)
  
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
  fa1 <- fa  ### affect cell fraction
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
  
  keynames<-c(var.name[1], var.name[2], 'Combination')
  
  df <- data.frame(dose1,dose2,dose=totdose,fa)
  df$drug<-rep(NA,length(dose1))
  df$drug[ind1] <-keynames[1] 
  df$drug[ind2] <-keynames[2]
  df$drug[ind3] <-keynames[3]
  df<-df[-1,]
  df$drug<-factor(df$drug,levels=keynames)
  
  dosem <- seq(0,max(totdose[ind3]),max(totdose[ind3])/20000)
 # dosem<-dosem[-1]
  fam <- 1/(1+(dmcomb/dosem)^lmcomb$coef[2])
#  dosem1 <- seq(0,max(totdose[ind1]),max(totdose[ind1])/100)
#  dosem1<-dosem1[-1]
  fam1 <- 1/(1+(dm1/dosem)^lm1$coef[2])
#  dosem2 <- seq(0,max(totdose[ind2]),max(totdose[ind2])/100)
#  dosem2<-dosem2[-1]
  fam2 <- 1/(1+(dm2/dosem)^lm2$coef[2])
  
  dfm<-data.frame(dose=dosem,fa=fam,drug=keynames[3])
  dfm1<-data.frame(dose=dosem,fa=fam1,drug=keynames[1])
  dfm2<-data.frame(dose=dosem,fa=fam2,drug=keynames[2])

p <-ggplot(df,aes(x=dose,y=fa,))+geom_point(data=df,aes(col=drug))+
    geom_line(data=dfm,aes(x=dose,y=fa),col="red",linetype=5)+
    geom_line(data=dfm1,aes(x=dose,y=fa),col="green",linetype=1)+
    geom_line(data=dfm2,aes(x=dose,y=fa),col="blue",linetype=3)+
    scale_x_log10()+
    xlab(paste0("\nLog10("," IC50 equivalent dose)"))+
    ylab("Effect\n")+
    ggtitle("Curve-shift\n")+
    scale_colour_manual("",values=c("green","blue","red"))+
    theme(legend.key = element_blank(),
          legend.text = element_text(size = 10),
          plot.title = element_text(face="bold",colour="black"),
          axis.text.x = element_text(colour = "black"),
          axis.text.y = element_text(colour = "black"),
 #         panel.background = element_blank(),
          panel.background = element_rect(colour = "black",fill="white"),
          panel.grid.major = element_line(linetype = "dotted", colour = "grey"),
        panel.grid.minor = element_line(linetype = "dotted", colour = "grey50")
  )
  
print(p)
  
}
