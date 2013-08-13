DDCV
====

A Visualized Shiny App to Evaluate Drug-Drug Interaction

Project status: **Version 1.0**

Author: [Tongwu Zhang](mailto:zhangt8@mail.nih.gov)

Website: [http://xtmgah.github.io/DDCV/](http://xtmgah.github.io/DDCV/)

License: DDCV is freely available under a GNU Public License (Version 2)

Citation: Please cite the following article if you use DDCV in your research

Tongwu Zhang *et al*. **DDCV: A visualized R Shiny App for Evaluationg Drug-Drug Interaction**. 2013.(In Prepare) 




Description
-----------

Evaluation of synergy or antagonism of agents used in combination therapy is an integral part of cancer chemotherapy development. Simultaneous use of multiple methods enhances the donfidence of combination therapy. We developed a visualized R Shiny App to evaluated drug-drug synergy, additivity and antagonism using several published methodologies, including isobologram, combination index, curve-shift and universal surface response analysis. 


Dependencies
------------

* [R](http://www.r-project.org)

* R package: [ggplot2](http://ggplot2.org), [shiny](http://www.rstudio.com/shiny/), [reshape2](http://cran.r-project.org/web/packages/reshape2/index.html), [gplots](http://cran.r-project.org/web/packages/gplots/index.html), [plyr](http://plyr.had.co.nz), [lattice](http://cran.r-project.org/web/packages/lattice/index.html), [scatterplot3d](http://cran.r-project.org/web/packages/scatterplot3d/index.html)



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

**Matrix**

|DrugB|10|10|8|8|6|6|4.5|4.5|3|3|2|2|1|1|0|0|
|-----|--|-|-|-|-|---|---|-|-|-|-|-|-|-|-|
|5|1609|1073|1459|1597|4112|3195|3709|3929|4661|5253|5539|5805|10590|10184|10931|15020|
|5|1624|1898|2248|2937|3943|5139|3709|4340|4914|5614|6187|11652|9942|20365|9838|16601|
|4|2493|1498|2688|2091|5485|5324|4496|4492|5523|5174|8353|9833|19715|19214|12129|27393|
|4|2355|1950|2935|3383|5765|7162|4391|4391|4418|5265|8693|15340|15973|30613|11614|23119|
|3.2|3260|1390|2459|1755|5411|5889|3652|4210|4529|5162|8222|9413|18849|18455|16028|29547|
|3.2|3062|1921|2525|2055|6834|6323|3916|4283|4752|4956|10748|8628|15369|16258|15027|26021|
|2.6|3151|2039|2791|2601|6610|7918|4368|5078|5688|6760|12354|11062|18436|17563|15035|30379|
|2.6|3135|1575|3027|1653|5787|6293|4482|4529|4712|5195|11267|10588|16639|16787|15949|27543|
|2|3050|1965|2269|2729|6574|8452|4877|5601|6234|6105|14047|12401|20608|21756|23021|33000|
|2|3436|2140|3240|1989|5352|6795|4087|5096|5873|6760|13580|12332|18349|21378|23320|30949|
|1.4|4124|2640|3865|2718|8161|7999|5596|6374|6277|7373|17441|14634|25133|27359|30202|39171|
|1.4|3554|2293|3212|3261|7027|9090|5595|6192|6669|7505|18393|12325|22932|24509|27126|33748|
|1|5348|2820|6340|3404|10168|11130|7206|8805|8285|8729|18293|16843|28392|31007|34998|42773|
|1|4735|2577|5241|2038|10784|9490|5159|9057|8954|9138|18213|15769|27259|27927|35539|40335|
|0|11291|13751|17858|13083|35769|36605|36398|37620|35052|36365|33880|33576|42494|41642|46640|46467|
|0|7244|13013|12074|9639|32487|31180|32986|34580|32642|35208|32367|32937|39519|41412|45332|46843|


**Column3**

|DrugA|DrugB|Fraction|
|-----|-----|--------|
|5000|73.4|921|
|5000|73.4|1011|
|2500|73.4|995|
|2500|73.4|1020|
|1250|73.4|976|
|1250|73.4|982|
|625|73.4|994|
|625|73.4|993|
|312.5|73.4|1018|
|312.5|73.4|1087|
|156.25|73.4|967|
|156.25|73.4|1003|
|78.125|73.4|997|
|78.125|73.4|1026|
|39.0625|73.4|1031|
|39.0625|73.4|982|
|19.53125|73.4|1036|
|19.53125|73.4|1046|
..............


Example
-------

**Parameter Panel**

![view](https://raw.github.com/xtmgah/DDCV/master/doc/panel2.png)

**IC50 Prediction**

**Single and Combination Drug IC50:**

      | DrugA | DrugB | Combination (IC50 equivalent dose)|
------| ----- |:-----:|-----------------------------------|
 IC50 |  2.01 | 6.24  |                               0.64|


![view](https://raw.github.com/xtmgah/DDCV/master/doc/ic502.png)

**Response Matrix Profile**

![view](https://raw.github.com/xtmgah/DDCV/master/doc/rmprofile.png)

**Median Effect**

![view](https://raw.github.com/xtmgah/DDCV/master/doc/meffect.png)

![view](https://raw.github.com/xtmgah/DDCV/master/doc/meffect2.png)

**Isobologram**

>Isobologram analysis has been used to make a graphical presentation of the interaction of two drugs. 

![view](https://raw.github.com/xtmgah/DDCV/master/doc/isob.png)

**Combination Index**

>Combination index provides a quantitative measure of the extent of drug interaction at a given effect level.

![view](https://raw.github.com/xtmgah/DDCV/master/doc/cindex.png)

**Curve-shift**

>Curve-shift analysis allows simultaneous presentation of the studied concentration-effect curves of single-agent and combination treatments in a single plot. 

![view](https://raw.github.com/xtmgah/DDCV/master/doc/cshift.png)

![view](https://raw.github.com/xtmgah/DDCV/master/doc/cshift2.png)

**Universal Surface Response**

>Universal surface model approach provides a single value summarizing the nature of interaction for the totality of data on the combinations.

![view](https://raw.github.com/xtmgah/DDCV/master/doc/3d.png)

**Contour Plots of Raw Data**

![view](https://raw.github.com/xtmgah/DDCV/master/doc/contour.png)



