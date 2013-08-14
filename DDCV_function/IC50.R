#' Get IC50 in durg combination data
#' 
#' @param drMatrix input strandard model data
#' @return IC50 value for drug1, drug2 and combiantion drug
#' @export


IC50 <- function (drMatrix) {
  
  dose1 <- drMatrix[,1]
  dose2 <- drMatrix[,2]
  fa    <-1- drMatrix[,3]   ## fration of total cells or viability
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
  
  totdose1 <- dose1/dm1 + dose2/dm2
  logd1 <- log(totdose1)
  
  lmcomb <- lm(resp[ind3]~logd1[ind3])
  dmcomb <- exp(-summary(lmcomb)$coef[1,1]/summary(lmcomb)$coef[2,1])
  
  dmall<-data.frame(dm1,dm2,dmcomb)
  names(dmall)<-c(names(drMatrix)[1:2],"Combiantion (IC50 equivalent dose)")
  row.names(dmall)<-"IC50"
  return(dmall)
}
