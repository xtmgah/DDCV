## Function to check whether package is installed

is.installed <- function(mypkg) {
  tmp <- is.element(mypkg,installed.packages()[,1])
  if(!tmp){ install.packages(mypkg)}
}


## check if package is installed 
is.installed("shiny")
is.installed("ggplot2")
is.installed("gplots")
is.installed("reshape2")
is.installed("lattice")
is.installed("plyr")
is.installed("scatterplot3d")

## Run shiny 

library(shiny)
runApp("../DDCV")

