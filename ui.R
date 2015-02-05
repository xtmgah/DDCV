library(shiny)
library(shinythemes)

shinyUI(fluidPage(theme=shinytheme("united"),
  
  titlePanel("The Evaluation of Drug-Drug Combination Therapy Effect"),
 # br(),
  p("**If you have any question about this R shiny app, Please contact",a("Tongwu Zhang",href="mailto:xtmgah@gmail.com")),
 p("Please cite our paper:",strong("\"DDCV: A Visualized R Shiny App to Evaluate Drug-Drug Interaction\""),"when pulishing results analyzed by this shiny app."),
 
 tags$hr(),
  
  
  sidebarLayout(
    sidebarPanel(
      fileInput('file1','Please Choose CSV File',
                accept=c('text/csv','text/comma-separated-value','test/plain')),
      tags$hr(),
      radioButtons('fty','CSV File Format',c(Matrix='shapeA',Column3='shapeB'),'Matrix'),
    
      br(),
    
      textInput('dname1','DrugA Name (no space):','TMZ'),
      textInput('dname2', 'DrugB Name (no space):','AZD7762'),
      br(),
      checkboxInput('swap','Swap DrugA and DrugB',TRUE),
      br(),
    
      checkboxInput("normal1","Median Effect Plot: IC50 Normalization",TRUE),
      checkboxInput("normal2","Median Effect Plot II: IC50 Normalization",TRUE),
      checkboxInput("normal3","Isobologram: IC50 Normalization",FALSE),
      checkboxInput("normal4","Combination Index: IC50 Normalization",TRUE),
      checkboxInput("normal5","Curve-Shift: IC50 Normalization",TRUE),
      checkboxInput("normal6","Curve-Shift II: IC50 Normalization",TRUE),
#    checkboxInput("normal7","Universal Surface Response: IC50 Normalization",FALSE),   
    
      br(),
      submitButton("Update View"),
      br(),
      p("Written and designed by Tongwu Zhang, using ",a("Shiny",href="http://shiny.rstudio.com"),"from",a("RStudio",href="http://www.rstudio.com"),"and Inc. (2015)")

  ),
  
  
    mainPanel(
      tabsetPanel(
        tabPanel("Description",
                 br(),
                 p("Evaluation of synergy or antagonism of agents used in combination therapy is an integral part of cancer chemotherapy development. Simultaneous use of multiple methods enhances the confidence of combination therapy. We developed a visualized R Shiny App to evaluated drug-drug synergy, additivity and antagonism using several published methodologies, including isobologram, combination index, curve-shift and universal surface response analysis."),
                 br(),
                 p("Please choose each table to view drug-drug combination analysis results."),
                 p(strong("Data:"),"Review your uploaded raw data as well as both single drug and drug-drug combination IC50. " ),
                 p(strong("Proile:"),"Heatmap of drug-durg combination response matrix profile. " ),
                 p(strong("Effect:"),"Median effects of single drug and drug-drug combination" ),
                 p(strong("Isobologram:"),"Isobologram analysis of drug-drug combination." ),
                 p(strong("cIndex:"),"Combination index analysis of drug-drug combination." ),
                 p(strong("cShift"),"Curve-shift analysis of drug-drug combination." ),
                p(strong("Response:"),"Universal Surface Response analysis of drug-drug combination." ),
                 p(strong("Contour:"),"Loewe additivity contour plot of drug-drug combination." ),
                 
                 tags$hr(),
                 h4("Drug-drug interaction prediction model"),
                 br(),
                 strong("Chou and Talalay"),
                 p("Quantitative analysis of dose-effect relationships: the combined effects of multiple drugs or enzyme inhibitors, advances in Enzyme Regulation 1984,22:27-55"),
                 
                 
                 img(src="Theory.pdf",height=612, width=792)
        
                 ),
        tabPanel("Data",
                 br(),
                 h4("IC50 prediction for single drug and drug-drug combination: "),
                 tableOutput("view"),
                 tags$hr(),
                 h4("Formated Data:"),
                 dataTableOutput("format_data")),
        tabPanel("Profile",
                 br(),
                 tags$ul(
                 tags$li("Show drug combination therapy effect of both single and combination drug dose. Each value is the effect fraction. Hight effect shown in green, and low effect shown in red."),
                 tags$li("Quickly evaluate experiment result. For example, predict IC50 range for both drugs, check outliner data, and pre-predict the drug-drug interaction by comparing drug combination data with single drug data.")
                 ),
                 br(),
                 plotOutput("rmprofile")),
        tabPanel("Effect",
                 br(),
                 tags$ul(
                   tags$li("Identify IC50 value for both single drug and combined drug."),
                   tags$li("How well the data points fitted the linear model."),
                   tags$li("Slope/effect  changes between single drug and combined drug.")
                 ), 
                 br(),
                 plotOutput("meffect"),
                 plotOutput("meffect2"),
                 br(),
                 br(),
                 img(src="Equivalent.pdf",height=66,width=404)
                 ),
        
        tabPanel("Isobologram",
                 br(),
                 p("Show the drug-drug synergy/antagonism and interaction strength of each drug combination dose. Compared to traditional isobologram, DDCV isobologram have a good visualization of all tested drug combination dose."),
                 img(src="Additivity.pdf",height=330,width=561),
                 plotOutput("isob")),
        tabPanel("cIndex",
                 br(),
                 h4("Combination index (CI)"),
                 img(src="CI2.pdf",height=260,width=435),
                 img(src="CI.pdf",height=72,width=144),
                 br(),
                 tags$ul(
                   tags$li("Calculate CI value in all drug combination dose."),
                   tags$li("shown error bar (96% confidence interval) based on predict model."),
                   tags$li("Combination index curve to predict CI value at any combination effect.")                     
                     ),                 
                 h4("How much synergy is synergism?"),
                 p("Chou and co-workers proposed semi-quantitative methods for describing the degrees of synergism or antagonism."),
                 tableOutput("ci_range"),
                 plotOutput("cindex"),
                 plotOutput("cindex2")
                 
                 ),
        tabPanel("cShift",
                 br(),
                 p("Curve shift analysis allows simultaneous presentation of the studied concentration-effect curves of singe-agent and combination treatments in a single plot."),
                 br(),
                 img(src="cshift.pdf",height=285,width=442),
                 tags$ul(
                   tags$li("Curve-shift based on two single drug and all drug combination.")),
                 plotOutput("cshift"),
                 br(),
                 tags$ul(
                 tags$li("Curve-shift based on different drugB dose.")),
                 plotOutput("cshift2")),
        tabPanel("Response",
                 br(),
                 p("This method assumes that the concentration-effect relationship for each drug separately follows the Hill equation and is designed to simultaneously fit all combination data to a single function."),
                 img(src="URS.pdf",height=92,width=620),
                 plotOutput("usresponse"),
                 plotOutput("usresponse2")),
        tabPanel("Contour",
                 br(),
                 p("The contour plot can be used to guide next drug combination experiment for specific effect."),
                 img(src="contour.pdf",height=359,width=434),
                 plotOutput("dcontour")),
        tabPanel("Documentation",
                 includeHTML("README.html"))
        
        
  )
    )
)))
