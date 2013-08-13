library(shiny)


shinyUI(pageWithSidebar(
  
  headerPanel("The Evaluation of DrugA-DrugB Combination Therapy Effect"),
  
  sidebarPanel(
    fileInput('file1','Please Choose CSV File',
              accept=c('text/csv','text/comma-separated-value,test/plain')),
    tags$hr(),
    radioButtons('fty','CSV File Format',c(Matrix='shapeA',Column3='shapeB'),'Column3'),
    
    br(),
    
    textInput('dname1','DrugA Name (no space):','DrugA'),
    textInput('dname2', 'DrugB Name (no space):','DrugB'),
    br(),
    checkboxInput('swap','Swap DrugA and DrugB',FALSE),
    br(),
    
    checkboxInput("normal1","Median Effect Plot: IC50 Normalization",TRUE),
    checkboxInput("normal2","Median Effect Plot II: IC50 Normalization",TRUE),
    checkboxInput("normal3","Isobologram: IC50 Normalization",FALSE),
    checkboxInput("normal4","Combination Index: IC50 Normalization",TRUE),
    checkboxInput("normal5","Curve-Shift: IC50 Normalization",TRUE),
    checkboxInput("normal6","Curve-Shift II: IC50 Normalization",TRUE),
    checkboxInput("normal7","Universal Surface Response: IC50 Normalization",FALSE),   
    
    br(),
    submitButton("Update View")

  ),
  
  
  
  mainPanel(
    h4("Single and Combination Drug IC50: "),
    tableOutput("view"),
    plotOutput("rmprofile"),
    plotOutput("meffect"),
    plotOutput("meffect2"),
    plotOutput("isob"),
    plotOutput("cindex"),
    plotOutput("cshift"),
    plotOutput("cshift2"),
    plotOutput("usresponse"),
    plotOutput("dcontour")
  )
  
))
