#' Plot two drug Combination index
#' 
#' @param drMatrix input strandard model data
#' @param drug1Base first drug normalizated base
#' @param drug2Base second drug normalizated base
#' @param IC50base if normalization by IC50
#' @return Combination index results of drug1, drug2, and drug combination
#' @export


cIndex <- function (drMatrix, drug1Base=1, drug2Base=1, IC50base=FALSE) {
  
  cols=c("blue","red","green4")  
  d2.d1=unique(drMatrix[,2])[2]/unique(drMatrix[,1])[2]
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
  
  keynames<-c(var.name[1], var.name[2], 'Combination')
  
  
  ##    Plot Combination Index (CI) vs fa; fax is the effect, Dx1, Dx2 are the doses of drug 1 and drug 2 eliciting
  ##    effect fax respectively; dx12 is the total amount of mixture of drug 1 and drug 2 eliciting
  ##    the effect fax, the corresponding drug 1 and drug 2 can be obtained by the ratio 
  ##    (dose of drug 2)/(dose of drug 1)=d2.d1. iix is the interaction index corresponding fax.
  
  if (sum(fa1==1) > 0) {fa1[fa1==1] <- NA; }  ##print("Reset fa1=1 to NA")
  fax <- seq(min(fa1,na.rm=T),max(fa1,na.rm=T), (max(fa1,na.rm=T) - min(fa1,na.rm=T))/100)
  Dx1 <- dm1*(fax/(1-fax))^(1/summary(lm1)$coef[2,1])
  Dx2 <- dm2*(fax/(1-fax))^(1/summary(lm2)$coef[2,1])
  dx12 <- dmcomb*(fax/(1-fax))^(1/summary(lmcomb)$coef[2,1])
  iix <- (dx12/(1+d2.d1))/Dx1+(dx12*d2.d1/(1+d2.d1))/Dx2
  
  
  ##   Extract the data with the fixed ratio (dose of drug 2)/(dose of drug 1)=d2.d1,
  ##   fa12 stores the effects at the fixed ratio d2.d1
  ##   d1, d2 are the doses at the combination elicting the effect fa12(observed)
  ##   Dx1o and Dx2o are the doses of drug 1 and drug 2 elicting effect fa12 respectively.
  ##   iixo stores the calculated combination indices of these observations at the fixed ratio d2.d1  
  fa12 <-  fa1[ind3]
  d1 <- dose1[ind3]
  d2 <- dose2[ind3]
  Dx1o <- dm1*(fa12/(1-fa12))^(1/summary(lm1)$coef[2,1])
  Dx2o <- dm2*(fa12/(1-fa12))^(1/summary(lm2)$coef[2,1])
  iixo <- d1/Dx1o+d2/Dx2o
  
  
  ##########
  
  
  ##   Calculate the standard error for the Interaction index at the observations
  coef1 <- summary(lm1)$coef
  coef2 <- summary(lm2)$coef
  cor1 <- summary(lm1, correlation=TRUE)$corr[2,1]
  cor2 <- summary(lm2, correlation=TRUE)$corr[2,1]
  temp <- log(fa12/(1-fa12))-coef1[1,1]
  sd1 <- coef1[1,2]^2/coef1[2,1]^2+2.0*temp*cor1*coef1[1,2]*coef1[2,2]/coef1[2,1]^3+coef1[2,2]^2*temp^2/coef1[2,1]^4
  temp <- log(fa12/(1-fa12))-coef2[1,1]
  sd2 <- coef2[1,2]^2/coef2[2,1]^2+2.0*temp*cor2*coef2[1,2]*coef2[2,2]/coef2[2,1]^3+coef2[2,2]^2*temp^2/coef2[2,1]^4
  sd3 <- 1/coef1[2,1]*d1/Dx1o+1/coef2[2,1]*d2/Dx2o
  temp3 <- (sum(lm1$res^2)+ sum(lm2$res^2))/(length(lm1$res)+length(lm2$res))
  stderr <- sqrt(d1^2*sd1/Dx1o^2+d2^2*sd2/Dx2o^2+sd3^2*temp3)
  sumtable2 <- matrix(data=NA,length(fa12),9)
  dimnames(sumtable2)[[2]] <- c('d1','d2','Viability','Dx1','Dx2','CI','s.e.', 'CIl', 'CIu')
  sumtable2[,1] <- d1
  sumtable2[,2] <- d2
  sumtable2[,3] <- fa12
  sumtable2[,4] <- Dx1o
  sumtable2[,5] <- Dx2o
  sumtable2[,6] <- iixo
  sumtable2[,7] <- stderr
  sumtable2[,8] <- iixo*exp(-1.96*stderr/iixo)
  sumtable2[,9] <- iixo*exp(1.96*stderr/iixo)
  ##     print(sumtable2)
  t.seg <- 0.005
  #plot(fax, iix, xlab="Proportion Surviving (E)", ylab="Interaction Index", type="l", ylim=c(0,min(20,max(iix)+0.5)),col=cols[1])
  plot(fax, iix, xlab="Effect", ylab="Combination Index", type="l", ylim=c(0,min(20,max(iixo*exp(1.96*stderr/iixo))+0.5)),col=cols[1])
  points(fa12, iixo, pch=16,col=cols[2])
  segments(fa12,iixo*exp(-1.96*stderr/iixo),fa12,iixo*exp(1.96*stderr/iixo),col=cols[3])
  segments(fa12-t.seg, iixo*exp(-1.96*stderr/iixo), fa12+t.seg, iixo*exp(-1.96*stderr/iixo),col=cols[3])
  segments(fa12-t.seg, iixo*exp(1.96*stderr/iixo), fa12+t.seg, iixo*exp(1.96*stderr/iixo),col=cols[3])
  abline(h=1, lty=4)
  title("Combination Index")
  
  return(sumtable2)
  
}
