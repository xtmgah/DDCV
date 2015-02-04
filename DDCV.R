## Function to check whether package is installed

is.installed <- function(mypkg) {
  tmp <- is.element(mypkg,installed.packages()[,1])
  if(!tmp){ install.packages(mypkg)}
}

is.installed.github <- function(mypkg,gsource) {
  tmp <- is.element(mypkg,installed.packages()[,1])
  if(!tmp){ devtools::install_github(mypkg,gsource)}
}


## check if package is installed 
is.installed("devtools")
is.installed("shiny")
is.installed("ggplot2")
is.installed("gplots")
is.installed("reshape2")
is.installed("lattice")
is.installed("plyr")
is.installed("scatterplot3d")
is.installed("shinythemes")
#is.installed.github("shiny-incubator", "rstudio")

## Run shiny 

library(shiny)
runApp("../DDCV_2.0/")

### if you get error with runGist, try the following command ###
#options(download.file.method="wget",download.file.extra=" --no-check-certificate")