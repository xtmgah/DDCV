---
title: "DDCV Document"
output:
  html_document:
    theme: united
    toc: yes
---

<style type="text/css">
  
  /*  CSS chunck 1  */
  
  
th {
    padding:5px;}


td{
  padding:5px;}


</style>


DDCV Information
====

A Visualized Shiny App to Evaluate Drug-Drug Interaction

Project status: **Version 3.0**

<Author: [Tongwu Zhang](mailto:zhangt8@mail.nih.gov)>


Website: [http://xtmgah.shinyapps.io/DDCV/](http://xtmgah.shinyapps.io/DDCV/)

License: DDCV is freely available under a GNU Public License (Version 2)

Citation: Please cite the following article if you use DDCV in your research

<Tongwu Zhang *et al*. **Drug-Drug Combination Visualization (DDCV): Evaluation of Drug-Drug Interactions using Shiny by RStudio**. 2015.(In Prepare)>
**Tongwu Zhang *et al*. Drug-Drug Combination Visualization (DDCV): Evaluation of Drug-Drug Interactions using Shiny by RStudio. 2015**.




Description
-----------

Evaluation of synergy or antagonism of agents used in combination therapy is an integral part of cancer chemotherapy development. Simultaneous use of multiple methods enhances the donfidence of combination therapy. We developed a visualized R Shiny App to evaluated drug-drug synergy, additivity and antagonism using several published methodologies, including isobologram, combination index, curve-shift and universal surface response analysis. 


Dependencies
------------

* [R](http://www.r-project.org)

* R package: [ggplot2](http://ggplot2.org), [shiny](http://www.rstudio.com/shiny/), [reshape2](http://cran.r-project.org/web/packages/reshape2/index.html), [gplots](http://cran.r-project.org/web/packages/gplots/index.html), [plyr](http://plyr.had.co.nz), [lattice](http://cran.r-project.org/web/packages/lattice/index.html), [scatterplot3d](http://cran.r-project.org/web/packages/scatterplot3d/index.html), [d3heatmap](http://cran.r-project.org/web/packages/d3heatmap/index.html)



Downloading 
------------

>Both through "*git clone*" or directly download comparessed file are avaiable:

```bash
git clone "https://github.com/xtmgah/DDCV.git"
cd DDCV
```



Running
-------

>There are two methods runing with or without downloading software. 

**GitHub repository**:

```R
library(shiny)
options(download.file.method="wget",download.file.extra=" --no-check-certificate")
shiny::runGitHub('DDCV','xtmgah')
```
>or

```R
library(shiny)
options(download.file.method="wget",download.file.extra=" --no-check-certificate")
runUrl('https://github.com/xtmgah/DDCV/archive/master.zip')
```

**Local running**

```bash
cd DDCV
```

>then

```R
library(shiny)
runApp("../DDCV")
```

>or 

```R
library(shiny)
source("DDCV.R")
```

Input CSV foramt
----------------

**Matrix** file format:


|          DrugA/DrugB          |          5000           |          5000           |          4000           |          4000           |          3000           |          3000           |          2250           |          2250           |          1500           |          1500           |          1000           |          1000           |           500           |           500           |            0            |            0            |
|:-------------------------:|:-----------------------:|:-----------------------:|:-----------------------:|:-----------------------:|:-----------------------:|:-----------------------:|:-----------------------:|:-----------------------:|:-----------------------:|:-----------------------:|:-----------------------:|:-----------------------:|:-----------------------:|:-----------------------:|:-----------------------:|:-----------------------:|
|           0.25            |          1609           |          1073           |          1459           |          1597           |          4112           |          3195           |          3709           |          3929           |          4661           |          5253           |          5539           |          5805           |          10590          |          10184          |          10931          |          15020          |
|           0.25            |          1624           |          1898           |          2248           |          2937           |          3943           |          5139           |          3709           |          4340           |          4914           |          5614           |          6187           |          11652          |          9942           |          20365          |          9838           |          16601          |
|           0.20            |          2493           |          1498           |          2688           |          2091           |          5485           |          5324           |          4496           |          4492           |          5523           |          5174           |          8353           |          9833           |          19715          |          19214          |          12129          |          27393          |
|           0.20            |          2355           |          1950           |          2935           |          3383           |          5765           |          7162           |          4391           |          4391           |          4418           |          5265           |          8693           |          15340          |          15973          |          30613          |          11614          |          23119          |
|           0.16            |          3260           |          1390           |          2459           |          1755           |          5411           |          5889           |          3652           |          4210           |          4529           |          5162           |          8222           |          9413           |          18849          |          18455          |          16028          |          29547          |
|           0.16            |          3062           |          1921           |          2525           |          2055           |          6834           |          6323           |          3916           |          4283           |          4752           |          4956           |          10748          |          8628           |          15369          |          16258          |          15027          |          26021          |
|           0.13            |          3151           |          2039           |          2791           |          2601           |          6610           |          7918           |          4368           |          5078           |          5688           |          6760           |          12354          |          11062          |          18436          |          17563          |          15035          |          30379          |
|           0.13            |          3135           |          1575           |          3027           |          1653           |          5787           |          6293           |          4482           |          4529           |          4712           |          5195           |          11267          |          10588          |          16639          |          16787          |          15949          |          27543          |
|           0.10            |          3050           |          1965           |          2269           |          2729           |          6574           |          8452           |          4877           |          5601           |          6234           |          6105           |          14047          |          12401          |          20608          |          21756          |          23021          |          33000          |
|           0.10            |          3436           |          2140           |          3240           |          1989           |          5352           |          6795           |          4087           |          5096           |          5873           |          6760           |          13580          |          12332          |          18349          |          21378          |          23320          |          30949          |
|           0.07            |          4124           |          2640           |          3865           |          2718           |          8161           |          7999           |          5596           |          6374           |          6277           |          7373           |          17441          |          14634          |          25133          |          27359          |          30202          |          39171          |
|           0.07            |          3554           |          2293           |          3212           |          3261           |          7027           |          9090           |          5595           |          6192           |          6669           |          7505           |          18393          |          12325          |          22932          |          24509          |          27126          |          33748          |
|           0.05            |          5348           |          2820           |          6340           |          3404           |          10168          |          11130          |          7206           |          8805           |          8285           |          8729           |          18293          |          16843          |          28392          |          31007          |          34998          |          42773          |
|           0.05            |          4735           |          2577           |          5241           |          2038           |          10784          |          9490           |          5159           |          9057           |          8954           |          9138           |          18213          |          15769          |          27259          |          27927          |          35539          |          40335          |
|           0.00            |          11291          |          13751          |          17858          |          13083          |          35769          |          36605          |          36398          |          37620          |          35052          |          36365          |          33880          |          33576          |          42494          |          41642          |          46640          |          46467          |
|           0.00            |          7244           |          13013          |          12074          |          9639           |          32487          |          31180          |          32986          |          34580          |          32642          |          35208          |          32367          |          32937          |          39519          |          41412          |          45332          |          46843          |


.........

**Column3** file format:

|    DrugA   | DrugB | Intensity |
|:-------:|:---------:|:----------:|
| 5000.00 |   73.4    |    921     |
| 5000.00 |   73.4    |    1011    |
| 2500.00 |   73.4    |    995     |
| 2500.00 |   73.4    |    1020    |
| 1250.00 |   73.4    |    976     |
| 1250.00 |   73.4    |    982     |
| 625.00  |   73.4    |    994     |
| 625.00  |   73.4    |    993     |
| 312.50  |   73.4    |    1018    |
| 312.50  |   73.4    |    1087    |
| 156.25  |   73.4    |    967     |
| 156.25  |   73.4    |    1003    |
|  78.12  |   73.4    |    997     |
|  78.12  |   73.4    |    1026    |
|  39.06  |   73.4    |    1031    |
|  39.06  |   73.4    |    982     |
|  19.53  |   73.4    |    1036    |
|  19.53  |   73.4    |    1046    |
|  9.77   |   73.4    |    997     |
|  9.77   |   73.4    |    995     |
|  0.00   |   73.4    |    1013    |
|  0.00   |   73.4    |    995     |
|  0.00   |   73.4    |    1018    |
|  0.00   |   73.4    |    981     |
| 5000.00 |   73.4    |    1059    |
| 5000.00 |   73.4    |    982     |
| 2500.00 |   73.4    |    1038    |
| 2500.00 |   73.4    |    995     |
| 1250.00 |   73.4    |    961     |
| 1250.00 |   73.4    |    1041    |
| 625.00  |   73.4    |    997     |
| 625.00  |   73.4    |    1040    |
| 312.50  |   73.4    |    1031    |
| 312.50  |   73.4    |    986     |
| 156.25  |   73.4    |    1000    |
| 156.25  |   73.4    |    1030    |
|  78.12  |   73.4    |    1035    |
|  78.12  |   73.4    |    1002    |
|  39.06  |   73.4    |    968     |
|  39.06  |   73.4    |    1006    |
|  19.53  |   73.4    |    957     |
|  19.53  |   73.4    |    1009    |
|  9.77   |   73.4    |    1048    |
|  9.77   |   73.4    |    1014    |
|  0.00   |   73.4    |    936     |
|  0.00   |   73.4    |    971     |
|  0.00   |   73.4    |    973     |
|  0.00   |   73.4    |    1024    |
| 5000.00 |    8.4    |    1093    |
| 5000.00 |    8.4    |    1040    |


 
..............



Example
-------

**Parameter Panel**

<img src="https://raw.github.com/xtmgah/DDCV/master/doc/panel.png" width="433" height="801" />
**IC50 Prediction**

**Single and Combination Drug IC50:**

      | DrugA | DrugB | Combination (IC50 equivalent dose)  |
------| ------ | ------ |------ |
 IC50 |  2.01 | 6.24  | 0.64 |





**Response Matrix Profile**

<img src="https://raw.github.com/xtmgah/DDCV/master/doc/rmprofile.png" width="914" height="400" />

**Median Effect**

<img src="https://raw.github.com/xtmgah/DDCV/master/doc/meffect.png" width="914" height="400" />
<img src="https://raw.github.com/xtmgah/DDCV/master/doc/meffect2.png" width="914" height="400" />


**Isobologram**

>Isobologram analysis has been used to make a graphical presentation of the interaction of two drugs. 

<img src="https://raw.github.com/xtmgah/DDCV/master/doc/isob.png" width="914" height="400" />


**Combination Index**

>Combination index provides a quantitative measure of the extent of drug interaction at a given effect level.

<img src="https://raw.github.com/xtmgah/DDCV/master/doc/cindex.png" width="914" height="400" />
<img src="https://raw.github.com/xtmgah/DDCV/master/doc/cindex2.png" width="914" height="400" />


**Curve-shift**

>Curve-shift analysis allows simultaneous presentation of the studied concentration-effect curves of single-agent and combination treatments in a single plot. 

<img src="https://raw.github.com/xtmgah/DDCV/master/doc/cshift.png" width="914" height="400" />
<img src="https://raw.github.com/xtmgah/DDCV/master/doc/cshift2.png" width="914" height="400" />


**Universal Surface Response**

>Universal surface model approach provides a single value summarizing the nature of interaction for the totality of data on the combinations.

<img src="https://raw.github.com/xtmgah/DDCV/master/doc/usr.png" width="914" height="400" />
<img src="https://raw.github.com/xtmgah/DDCV/master/doc/usr2.png" width="914" height="400" />


**Contour Plots of Raw Data**

<img src="https://raw.github.com/xtmgah/DDCV/master/doc/contour.png" width="914" height="400" />




