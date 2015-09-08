#' Plot two drug median effect2
#' 
#' @param drMatrix input strandard model data
#' @param drug1Base first drug normalizated base
#' @param drug2Base second drug normalizated base
#' @param IC50base if normalization by IC50
#' @export



mEffect3 <- function (drMatrix, drug1Base=1, drug2Base=1, IC50base=FALSE) {
  
  cols=c("#3366cc","#dc3912","#ff9900","#109618","#990099","#0099c6","#dd4477","#66aa00","#b82e2e","#316395","#994499","#22aa99","#aaaa11","#6633cc","#e67300","#8b0707","#651067","#329262","#5574a6","#3b3eac","#b77322","#16d620","#b91383","#f4359e","#9c5935","#a9c413","#2a778d","#668d1c","#bea413","#0c5922","#743411")
  #cols=c("blue","red","green4")  
  #names(drMatrix)<-c("Drug1","Drug2","Fraction")
  drMatrix<-drMatrix[,c(2,1,3)]
  var.name <- names(drMatrix)
  
  xlabn<-paste("Log(",var.name[1]," concentration)",sep="")
  if(IC50base){
    ic50 <- IC50(drMatrix)
    drug1Base <- as.numeric(ic50[1])
    drug2Base <- as.numeric(ic50[2])
    xlabn<-paste("Log(",var.name[1]," IC50 equivalent concentration)",sep="")
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
  totdose<-dose1
  
  if(IC50base){ totdose <- dose1 + dose2 }
  logd <- log(totdose)
  
  keynames<-c(var.name[1], var.name[2], 'Combination')
  
  ## plot 2: Median Effect Plots 
  ##    Median Effect Plot
  
  def.par <- par(no.readonly = TRUE)
  layout(cbind(1, 2), widths=c(6, 1)) 
  
  par(mar=c(5.1, 4.1, 4.1, 1))
  plot(logd,resp,type='n',xlab=xlabn,ylab='Log(fa/(1-fa))')
  abline(h=0,lty=2,col="gray90")
  
  pchi<-c(16,1:15,17,18)
    
  for (i in 1:length(unique(dose2))) { 
  
    ind <- dose2==unique(dose2)[i] & dose1!=0
    lm <- lm(resp[ind]~logd[ind])
    dm <- exp(-summary(lm)$coef[1,1]/summary(lm)$coef[2,1]) 
    points(logd[ind],resp[ind],pch=pchi[i],col=cols[i])
    abline(lm,lty=i,col=cols[i])
  }
  
  title("Median Effect by drugB" )
  
  par(mar=c(0,0,0,0))
  plot.new()
  lname <- paste0(var.name[2]," \nconcentration")
  if(IC50base){lname <- paste0(var.name[2]," IC50 equivalent\nconcentration")}
  legend("center",title=lname,legend=round(unique(dose2),2),cex=1,pch=pchi[1:length(unique(dose2))],lty=1:length(unique(dose2)),bty="n",col=cols[1:length(unique(dose2))])
 par(def.par) 
#  dev.off()
  
}
