#' Plot two drug curve shift 
#' 
#' @param drMatrix input strandard model data
#' @param drug1Base first drug normalizated base
#' @param drug2Base second drug normalizated base
#' @param IC50base if normalization by IC50
#' @return paramter results of drug1, drug2, and drug combination
#' @export


cShift2 <- function (drMatrix, drug1Base=1, drug2Base=1,IC50base=TRUE) {
  
  cols=c("#3366cc","#dc3912","#ff9900","#109618","#990099","#0099c6","#dd4477","#66aa00","#b82e2e","#316395","#994499","#22aa99","#aaaa11","#6633cc","#e67300","#8b0707","#651067","#329262","#5574a6","#3b3eac","#b77322","#16d620","#b91383","#f4359e","#9c5935","#a9c413","#2a778d","#668d1c","#bea413","#0c5922","#743411")
  
  #names(drMatrix)<-c("Drug1","Drug2","Fraction")
  var.name <- names(drMatrix)
  xlabn<-paste("\nLog(",var.name[1]," concentration)",sep="")
  if(IC50base){
    ic50 <- IC50(drMatrix)
    drug1Base <- as.numeric(ic50[1])
    drug2Base <- as.numeric(ic50[2])
    xlabn<-paste0("\nLog(",var.name[1]," IC50 equivalent Dose)")
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
  
  #dosem <- seq(0,max(totdose[ind3]),max(totdose[ind3])/100)
  dosem<-10^seq(-5,5,0.01)
  
  
  def.par <- par(no.readonly = TRUE)
  layout(cbind(1, 2), widths=c(6, 1)) 
  
  par(mar=c(5.1, 4.1, 4.1, 1))
  pchi<-c(16,1:15,17,18)
  plot(log(totdose[ind3]),fa[ind3],type='n',xlab=xlabn,ylab="Effect fraction", ylim=c(0,1),xlim=c(log(min(dose1[ind3])),log(max(totdose[ind3]))))
  
  for (i in 1:length(unique(dose2))) { 
    
    ind <- dose2==unique(dose2)[i] & dose1!=0    
    lm <- lm(resp[ind]~logd[ind])
    dm <- exp(-summary(lm)$coef[1,1]/summary(lm)$coef[2,1]) 
    fam <- 1/(1+(dm/dosem)^lm$coef[2])
    dfm<-data.frame(dose=dosem,fa=fam)
    lines(log(dosem),fam,lty=i,col=cols[i])
    points(log(totdose[ind]),fa[ind],pch=pchi[i],col=cols[i])
    
  }
  
  title("Curve-Shift by drugA" )
  
  lname <- paste0(var.name[2]," \nconcentration")
  if(IC50base){lname <- paste0(var.name[2]," IC50 equivalent\nconcentration")}
  
  par(mar=c(0,0,0,0))
  plot.new()
  legend("center",title=lname,legend=round(unique(dose2),2),cex=1,pch=pchi[1:length(unique(dose2))],lty=1:length(unique(dose2)),bty="n",col=cols[1:length(unique(dose2))])
  par(def.par)   
  
}
