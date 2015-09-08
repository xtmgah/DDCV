#' Plot two drug median effect
#' 
#' @param drMatrix input strandard model data
#' @param drug1Base first drug normalizated base
#' @param drug2Base second drug normalizated base
#' @param IC50base if normalization by IC50
#' @return paramter results of drug1, drug2, and drug combination
#' @export



mEffect <- function (drMatrix, drug1Base=1, drug2Base=1, IC50base=TRUE) {
  
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
  fa1 <- fa
  fu <- 1-fa  	## death cell fraction
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
  sumtable1 <- matrix(data=NA,3,7)
  dimnames(sumtable1)[[2]] <- c('Intercept','s.e.','Slope','s.e.', 'corr.coef.','R-square','IC50')
  dimnames(sumtable1)[[1]] <- c(var.name[1], var.name[2], 'Combination')
  sumtable1[1,1:4] <- as.vector(t(summary(lm1)$coef[1:2,1:2]))
  sumtable1[1,5] <- summary(lm1, correlation=TRUE)$corr[2,1]
  sumtable1[1,6] <- summary(lm1)$r.sq
  sumtable1[1,7] <- dm1
  sumtable1[2,1:4] <- as.vector(t(summary(lm2)$coef[1:2,1:2]))
  sumtable1[2,5] <- summary(lm2,correlation=TRUE)$corr[2,1]
  sumtable1[2,6] <- summary(lm2)$r.sq
  sumtable1[2,7] <- dm2
  sumtable1[3,1:4] <- as.vector(t(summary(lmcomb)$coef[1:2,1:2]))
  sumtable1[3,5] <- summary(lmcomb, correlation=TRUE)$corr[2,1]
  sumtable1[3,6] <- summary(lmcomb)$r.sq
  sumtable1[3,7] <- dmcomb
  ##  print(sumtable1)
  
  keynames<-c(var.name[1], var.name[2], 'Combination')
  
  ## plot 2: Median Effect Plots 
  ##    Median Effect Plot
  def.par <- par(no.readonly = TRUE)
  layout(cbind(1, 2), widths=c(6, 1)) 
  
  par(mar=c(5.1, 4.1, 4.1, 1))
  
  lname <- c("Log(Drug concentration)")
  if(IC50base){lname <- c("Log(Drug IC50 equivalent concentration)")}
  
  plot(logd,resp,type='n',xlab=lname,ylab='Log(fa/(1-fa))')
  abline(h=0,lty=2,col="gray80")
  abline(lm1,lty=4,col=cols[1])
  points(logd[ind1],resp[ind1],pch=15,col=cols[1])
  abline(lm2,lty=2,col=cols[2])
  points(logd[ind2],resp[ind2],pch=16,col=cols[2])
  abline(lmcomb,lty=1,col=cols[3])
  points(logd[ind3],resp[ind3], pch=17,col=cols[3])
  
  title("Median Effect" )
  
  par(mar=c(0,0,0,0))
  plot.new()
  legend("center",keynames,pch=15:17,lty=c(4,2,1),col=cols,bty="n")
  par(def.par) 
  
  return(sumtable1)
  
}
  