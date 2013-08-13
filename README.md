DDCV
====

A Visualized Shiny App to Evaluate Drug-Drug Interaction

Project status: **Version 1.0**

Author: [Tongwu Zhang](mailto:zhangt8@mail.nih.gov)

Website: [http://xtmgah.github.io/DDCV/](http://xtmgah.github.io/DDCV/)

cite:




Description
-----------

Evaluation of synergy or antagonism of agents used in combination therapy is an integral part of cancer chemotherapy development. Simultaneous use of multiple methods enhances the donfidence of combination therapy. We developed a visualized R Shiny App to evaluated drug-drug synergy, additivity and antagonism using several published methodologies, including isobologram, combination index, curve-shift and universal surface response analysis. 


Dependencies
------------

* [R](http://www.r-project.org)

* R package: [ggplot2](http://ggplot2.org), [shiny](http://www.rstudio.com/shiny/), [reshape2](http://cran.r-project.org/web/packages/reshape2/index.html), [gplots](http://cran.r-project.org/web/packages/gplots/index.html), [plyr](http://plyr.had.co.nz), [lattice](http://cran.r-project.org/web/packages/lattice/index.html), [scatterplot3d](http://cran.r-project.org/web/packages/scatterplot3d/index.html)



Downloading 
------------

Both through "*git clone*" or directly download comparessed file are avaiable:

```bash
git clone "https://github.com/xtmgah/DDCV.git"
cd DDCV
```



Running
-------

There are two methods runing with or without downloading software. 

**GitHub repository**:

```R
library(shiny)
options(download.file.method="wget",download.file.extra=" --no-check-certificate")
shiny::runGitHub('DDCV','xtmgah')
```
or

```R
library(shiny)
options(download.file.method="wget",download.file.extra=" --no-check-certificate")
runUrl('https://github.com/xtmgah/DDCV/archive/master.zip')
```

**Local running**

```bash
cd DDCV
```

then

```R
library(shiny)
runApp("../DDCV")
```

or 

```R
library(shiny)
source("DDCV.R")
```



Example
-------

**Parameter Panel**

![view](https://raw.github.com/xtmgah/DDCV/master/doc/panel2.png)

**IC50 Prediction**

![view](https://raw.github.com/xtmgah/DDCV/master/doc/ic502.png)

**Response Matrix Profile**

![view](https://raw.github.com/xtmgah/DDCV/master/doc/rmprofile.png)

**Median Effect**

![view](https://raw.github.com/xtmgah/DDCV/master/doc/meffect.png)

![view](https://raw.github.com/xtmgah/DDCV/master/doc/meffect2.png)

**Isobologram**

![view](https://raw.github.com/xtmgah/DDCV/master/doc/isob.png)

**Combination Index**

![view](https://raw.github.com/xtmgah/DDCV/master/doc/cindex.png)

**Curve-shift**

![view](https://raw.github.com/xtmgah/DDCV/master/doc/cshift.png)

![view](https://raw.github.com/xtmgah/DDCV/master/doc/cshift2.png)

**Universal Surface Response**

![view](https://raw.github.com/xtmgah/DDCV/master/doc/3d.png)

**Contour Plots of Raw Data**

![view](https://raw.github.com/xtmgah/DDCV/master/doc/contour.png)



