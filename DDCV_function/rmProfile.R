#' Plot two drug response matrix profile
#' 
#' @param drMatrix input strandard model data
#' @param drug1 first drug name
#' @param drug2 second drug name
#' @export

rmProfile <- function (drMatrix,drug1="Drug1",drug2="Drug2")  {
    require(ggplot2)
#    Ndigits=2  
    # New ggplot2 theme
    theme_blank_ztw<-theme(panel.background = element_blank())+
    theme(panel.grid.minor=element_blank()) +
    theme(axis.ticks = element_blank()) +
    theme(panel.grid.major=element_blank()) +
    theme(legend.position = "none")+
    theme(axis.ticks = element_line())+
    theme(plot.title = element_text(face="bold"))
    
    names(drMatrix)<-c("Drug1","Drug2","Fraction")  
  p<-ggplot(drMatrix,aes(x=factor(round(Drug1,2)),y=factor(round(Drug2,2)),label=sprintf("%1.1f",100*(1-Fraction)),size=10))+geom_tile(aes(fill=Fraction))+geom_text(aes(size=10))+scale_fill_gradient(low="green",high="red")+xlab(paste0("\n",drug1))+ylab(paste0(drug2,"\n"))+theme_blank_ztw+ggtitle("Response Matrix Profile")
  print(p)
    
}