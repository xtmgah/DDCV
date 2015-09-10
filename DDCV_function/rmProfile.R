#' Plot two drug response matrix profile
#' 
#' @param drMatrix input strandard model data
#' @param drug1 first drug name
#' @param drug2 second drug name
#' @export



rmProfile <- function (drMatrix,drug1="Drug1",drug2="Drug2",unit1="μM",unit2="μM")  {
#    mcols <- terrain.colors(30)

    mcols <- colorRampPalette(c("#ec4335","yellow","#35a853"),space="Lab")(30)

#      require(ggplot2)
  theme_blank_ztw<-theme(panel.background = element_blank())+
    theme(panel.grid.minor=element_blank()) +
    theme(axis.ticks = element_blank()) +
    theme(panel.grid.major=element_blank()) +
    theme(legend.position = "bottom")+
    theme(axis.ticks = element_line())+
    theme(legend.key.width=unit(5,"line"))+
    theme(plot.title = element_text(face="bold"))
  
  names(drMatrix)<-c("Drug1","Drug2","Fraction")  
  p<-ggplot(drMatrix,aes(x=factor(round(Drug1,2)),y=factor(round(Drug2,2)),label=sprintf("%1.3f",(1-Fraction))))+geom_tile(aes(fill=1-Fraction))+geom_text(size=4.5)+scale_fill_gradientn(name = "Effect fraction\n", colours = mcols)+xlab(paste0("\n",drug1," concentration (",unit1,")"))+ylab(paste0(drug2," concentration (",unit2,")\n"))+theme_blank_ztw+ggtitle("Response Matrix Profile\n")
  #scale_fill_gradient(name = "Effect fraction\n", low = "#ec4335",high = "#35a853")
  #scale_fill_gradientn(name = "Effect fraction\n", colours = mcols)
  return(p)
}