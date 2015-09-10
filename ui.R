
library(shiny)
library(shinythemes)


messinfo <- actionButton(inputId = "blank",label ="To check the results, please upload your drug-drug combination data or load example data on the left panel.",class = "btn btn-warning")


shinyUI(fluidPage(theme=shinytheme("united"),
                  tags$head(
                    tags$style(HTML("
                                    .shiny-output-error-validation {
                                    color: #eaa228;
                                    font-size:120%;
                                    
                                    
                                    }

                                    "))
                    
                  ),
                  
                  titlePanel("The Evaluation of Drug-Drug Combination Therapy Effect"),
                  hr(),
                  
                  
                  
                  p("**If you have any question about this R shiny app, Please contact",a("Tongwu Zhang",href="mailto:xtmgah@gmail.com")),
                  p("Please cite our paper:",strong("\"Drug-Drug Combination Visualization (DDCV): Evaluation of Drug-Drug Interactions using Shiny by RStudio\""),"when pulishing results analyzed by this shiny app"),
                  p("DDCV version: 4.0"),
                  p("Note: This app is freely deployed and hosted on ", a("Shinyapps.io",href="http://www.shinyapps.io"),"website. If Something unexpected happened, Please refresh your browser or download this software from GitHub: ",a("https://github.com/xtmgah/DDCV",href="https://github.com/xtmgah/DDCV")),
                  
                  hr(),
                  
                  sidebarLayout(
                    sidebarPanel(width =3, 
                                 fileInput('file1','Please Choose CSV File:',
                                           accept=c('text/csv','text/comma-separated-value','test/plain')),
                                 p(strong('Or')),
                                 actionButton('loading',' Load example data',class='btn btn-primary',class = "fa fa-arrow-circle-up" ),
                                 tags$script('
        Shiny.addCustomMessageHandler("resetFileInputHandler", function(x) {   
          var el = $("#" + x);
          el.replaceWith(el = el.clone(true));
          var id = "#" + x + "_progress";     
          $(id).css("visibility", "hidden");
        });
      '),
                                 br(),
                                 
                                 downloadLink('downloadMatrix','Matrix example',class = "fa fa-arrow-circle-down"),
                                 br(),
                                 downloadLink('downloadColumn3',' Column3 example',class = "fa fa-arrow-circle-down"),
                                 hr(),
                                 radioButtons('fty','CSV File Format',choices=list("Matrix (with header)"='shapeA',"Column3 (with header)"='shapeB'),selected='shapeA'),
                                 
                                 br(),
                                 
                                 strong("DrugA Name and Unit:"),
                                 fluidRow(
                                   column(8,
                                          textInput('dname1','','DrugA')
                                   ),
                                   column(4,
                                          textInput('unit1','','µM')
                                   )
                                 ),
                                 
                                 strong("DrugB Name and Unit:"),
                                 fluidRow(
                                   column(8,
                                          textInput('dname2','','DrugB')
                                   ),
                                   column(4,
                                          textInput('unit2','','µM')
                                   )
                                 ),
                                 
                                 hr(),
                                 
                                 checkboxInput('swap',strong('Swap data'),FALSE),
                                # br(),
                                 
                                 strong("IC50 normalization for:"),
                                 checkboxInput("normal1","Median Effect plots",TRUE),
                                 checkboxInput("normal2","Isobologram plots",FALSE),
                                 checkboxInput("normal3","Combination Index plots",TRUE),
                                 checkboxInput("normal4","Curve-Shift plots",TRUE),
                                 #    checkboxInput("normal7","Universal Surface Response: IC50 Normalization",FALSE),   
                                 
                                 hr(),
                                 #     submitButton("Update View"),
                                 
                                 br(),
                                 p("After you update and check all the results, you can download all plots in pdf format:"),
                                 
                                 numericInput("w", label = "Width (inches):",value = 12,min = 3, max=20,width = 120),
                                 numericInput("h", label = "Height (inches):",value = 8,min = 3, max=20,width = 120),
                                 downloadButton('downloadPlot', 'Download All Plots (PDF)',class="btn btn-primary"),
                                 br(),
                                 br(),
                                 
                                 p("Written and designed by Tongwu Zhang, using ",a("Shiny",href="http://shiny.rstudio.com"),"from",a("RStudio",href="http://www.rstudio.com"),"(2015).")
                                 
                    ),
                    
                    ####################################################################                    
                    mainPanel(width = 9,
                              tabsetPanel(
                                
                                tabPanel("Description",
                                         br(),
                                         p("Evaluating drug-drug interactions is important to medicine, especially for cancer combination therapy. Drug-drug interactions, including synergistic, antagonistic, and additive, are usually determined using in vitro studies. Multiple computational approaches have been developed to analyze experimental data for evaluating drug-drug interactions, however, freely-available software implementations for drug combination analyses are lacking, and it remains difficult to visualize experimental results with commercial software. We developed Drug-Drug Combination Visualization (DDCV) software to evaluate drug-drug interactions. DDCV is implemented as an R Shiny App, which turns analysis into interactive web applications. DDCV can compare and visualize several published methodologies for evaluating the nature of drug-drug interactions, i.e., isobologram, combination index, curve-shift analysis and universal surface response analysis. In addition, DDCV can be used to check data quality as well as drug combination effects in drug combination experiments."),
                                         br(),
                                         p("Please choose each table to view drug-drug combination analysis results."),
                                         p(strong("Data:"),"Review your uploaded preprocessed data and predict both single drug and drug-drug combination IC50." ),
                                         p(strong("Profile:"),"Heatmap of drug-durg combination response matrix profile." ),
                                         p(strong("Effect:"),"Median effect analysis of both single drug and drug-drug combination" ),
                                         p(strong("Isobologram:"),"Isobologram analysis of drug-drug combination." ),
                                         p(strong("cIndex:"),"Combination index analysis of drug-drug combination." ),
                                         p(strong("cShift"),"Curve-shift analysis of drug-drug combination." ),
                                         p(strong("Response:"),"Universal Surface Response analysis of drug-drug combination." ),
                                         p(strong("Contour:"),"Loewe additivity contour plot of drug-drug combination." ),
                                         p(strong("Document:"),"Manual of this R shiny app." ),
                                         
                                         tags$hr(),
                                         h4("Drug-drug interaction prediction model"),
                                         br(),
                                         img(src="Theory.png",height=612, width=792),
                                         
                                         p("Chou and Talalay. Quantitative analysis of dose-effect relationships: the combined effects of multiple drugs or enzyme inhibitors, advances in Enzyme Regulation 1984,22:27-55")
                                         
                                ),
                                tabPanel("Data",
                                         br(),
                                         tags$u(strong("IC50 prediction for single drug and drug-drug combination: ")),
                                         br(),
                                         br(),
                                         conditionalPanel(
                                           condition = "output.fileUploaded",messinfo),
                                         
                                         tableOutput("view"),
                                         tags$hr(),
                                         tags$u(strong("Preprocessed data:")),
                                         br(),
                                         br(),
                                         conditionalPanel(
                                           condition = "output.fileUploaded",messinfo),
                                         DT::dataTableOutput("format_data")),
                                tabPanel("Profile",
                                         br(),
                                         tags$ul(tags$u(strong("Response matrix profile:")),
                                                 tags$li("Shows the effect of both single and combination drug doses. Each value is the effect fraction, with hight effects shown in green and low effects shown in red.")
                                         ),
                                         conditionalPanel(
                                           condition = "output.fileUploaded",messinfo),
                                         plotOutput("rmprofile",height = 500),
                                         br(),
                                         p(strong("References:")),
                                         p("Yadav, B. et al. Quantitative scoring of differential drug sensitivity for individually optimized anticancer therapies. Scientific Reports 4, (2014)."),
                                         p("Tan, X. et al. Systematic identification of synergistic drug pairs targeting HIV. Nature Biotechnology 30, 1125–1130 (2012).")),
                                
                                tabPanel("Effect",
                                         br(),
                                         tags$ul(tags$u(strong("Median effect plot:")),
                                                 tags$li("Identifies IC50 values for both single drugs and the drug-drug combination."),
                                                 tags$li("Allows for evaluation of how well the data points fit a linear model."),
                                                 tags$li("Illustartes slope/effect  changes between single drugs and combination.")
                                         ), 
                                         br(),
                                         conditionalPanel(
                                           condition = "output.fileUploaded",messinfo),
                                         plotOutput("meffect"),
                                         conditionalPanel(
                                           condition = "output.fileUploaded",messinfo),
                                         plotOutput("meffect2"),
                                         conditionalPanel(
                                           condition = "output.fileUploaded",messinfo),
                                         plotOutput("meffect3"),
                                         br(),
                                         p(strong("Equation used in this method:")),
                                         img(src="Equivalent.png",height=66,width=404),
                                         br(),
                                         p(strong("References:")),
                                         p("Zhao, L., Au, J. L.-S. & Wientjes, M. G. Comparison of methods for evaluating drug-drug interaction. Front Biosci (Elite Ed) 2, 241–249 (2010)."),
                                         p("Chou, T.-C. Drug combination studies and their synergy quantification using the Chou-Talalay method. Cancer Res 70, 440–446 (2010)."),
                                         p("Chou, T.-C. Theoretical basis, experimental design, and computerized simulation of synergism and antagonism in drug combination studies. Pharmacol. Rev. 58, 621–681 (2006).")
                                ),
                                
                                tabPanel("Isobologram",
                                         br(),
                                         tags$ul(tags$u(strong("Isobologram plot:")),
                                                 tags$li("Shows the drug-drug synergy or antagonism and interaction strength of each drug cobmination dose.")), 
                                         conditionalPanel(
                                           condition = "output.fileUploaded",messinfo),
                                         plotOutput("isob",height = 500),
                                         
                                         p(strong("Schematic diagram:")),
                                         
                                         img(src="Additivity.png",height=330,width=561),
                                         br(),
                                         br(),
                                         p(strong("References:")),
                                         p("Zhao, L., Au, J. L.-S. & Wientjes, M. G. Comparison of methods for evaluating drug-drug interaction. Front Biosci (Elite Ed) 2, 241–249 (2010)."),
                                         p("Chou, T.-C. Drug combination studies and their synergy quantification using the Chou-Talalay method. Cancer Res 70, 440–446 (2010)."),
                                         
                                         p("Tallarida, R. J. An overview of drug combination analysis with isobolograms. J Pharmacol Exp Ther 319, 1–7 (2006).")
                                         
                                ),
                                tabPanel("cIndex",
                                         br(),
                                         tags$ul(tags$u(strong("Combination Index (CI) plot:")),
                                                 tags$li("Describes the degree of synergism and antagonism by a semi-quantitative method."),
                                                 tags$li("Calculates CI value in all drug combiantion concentration."),
                                                 tags$li("Calculates 96% confidence interval (error bar) based on predicted model."),
                                                 tags$li("Predicts CI values at any combination effect by the combinaiton index curve.")
                                         ),
                                         
                                         br(),
                                         
                                         conditionalPanel(
                                           condition = "output.fileUploaded",messinfo),
                                         plotOutput("cindex"),
                                         
                                         conditionalPanel(
                                           condition = "output.fileUploaded",messinfo),
                                         plotOutput("cindex2",height = 500),
                                         
                                         br(),
                                         br(),
                                         p(strong("Schematic diagram:")),
                                         img(src="CI2.png",height=260,width=435),
                                         br(),
                                         br(),
                                         p(strong("Equation used in this method:")),
                                         
                                         img(src="CI.png",height=72,width=144),
                                         br(),
                                         br(),
                                         
                                         p(strong("How much synergy is synergism?")),
                                         p("Chou and co-workers proposed semi-quantitative methods for describing the degrees of synergism or antagonism."),
                                         tableOutput("ci_range"),
                                         br(),
                                         
                                         p(strong("References:")),
                                         
                                         p("Bijnsdorp, I. V., Giovannetti, E. & Peters, G. J. in Cancer Cell Culture 731, 421–434 (Humana Press, 2011)."),
                                         p("Chou, T.-C. Drug combination studies and their synergy quantification using the Chou-Talalay method. Cancer Res 70, 440–446 (2010)."),
                                         p("Tan, X. et al. Systematic identification of synergistic drug pairs targeting HIV. Nature Biotechnology 30, 1125–1130 (2012)."),
                                         p("Chou, T.-C. Theoretical basis, experimental design, and computerized simulation of synergism and antagonism in drug combination studies. Pharmacol. Rev. 58, 621–681 (2006).")       
                                ),
                                tabPanel("cShift",
                                         br(),
                                         
                                         tags$ul(tags$u(strong("Curve Shift plot:")),
                                                 tags$li("Allows simultaneous presentation of the studied concentration effect curves of single agent and combination treatments in a single plot.")),
                                         
                                         br(),
                                         
                                         conditionalPanel(
                                           condition = "output.fileUploaded",messinfo),
                                         plotOutput("cshift"),
                                         br(),
                                         
                                         conditionalPanel(
                                           condition = "output.fileUploaded",messinfo),
                                         plotOutput("cshift2"),
                                         
                                         conditionalPanel(
                                           condition = "output.fileUploaded",messinfo),
                                         plotOutput("cshift3"),
                                         
                                         br(),
                                         p(strong("Schematic diagram:")),
                                         img(src="cshift.png",height=285,width=442),
                                         
                                         br(),
                                         br(),
                                         p(strong("References:")),
                                         p("Zhao, L., Au, J. L.-S. & Wientjes, M. G. Comparison of methods for evaluating drug-drug interaction. Front Biosci (Elite Ed) 2, 241–249 (2010)."),
                                         p("Zhao, L., Wientjes, M. G. & Au, J. L.-S. Evaluation of Combination Chemotherapy Integration of Nonlinear Regression, Curve Shift, Isobologram, and Combination Index Analyses. Clin Cancer Res 10, 7994–8004 (2004)."),
                                         p("Brents, L. K., Zimmerman, S. M., Saffell, A. R., Prather, P. L. & Fantegrossi, W. E. Differential Drug-Drug Interactions of the Synthetic Cannabinoids JWH-018 and JWH-073: Implications for Drug Abuse Liability and Pain Therapy. J Pharmacol Exp Ther 346, 350–361 (2013)."),
                                         p("Chou, T.-C. Theoretical basis, experimental design, and computerized simulation of synergism and antagonism in drug combination studies. Pharmacol. Rev. 58, 621–681 (2006).")
                                ),
                                tabPanel("Response",
                                         br(),
                                         
                                         
                                         tags$ul(tags$u(strong("Universal Surface Response plot:")),
                                                 tags$li("Assumes that the concentration effect relationship for each drug separately follows the Hill equation and is designed to simultaneously fit all combination data to a single function.")),
                                         br(),
                                         conditionalPanel(
                                           condition = "output.fileUploaded",messinfo),
                                         plotOutput("usresponse",height = 500),
                                         
                                         conditionalPanel(
                                           condition = "output.fileUploaded",messinfo),
                                         plotOutput("usresponse2",height = 500),
                                         
                                         br(),
                                         p(strong("Equation used in this method:")),
                                         
                                         img(src="URS.png",height=92,width=620),
                                         p("Alpha (α)> 0 for synergy and Alpha (α) < 0 for Antagonism"),
                                         br(),
                                         br(),
                                         p(strong("References:")),
                                         p("Zhao, L., Au, J. L.-S. & Wientjes, M. G. Comparison of methods for evaluating drug-drug interaction. Front Biosci (Elite Ed) 2, 241–249 (2010)."),
                                         p("Chou, T.-C. Theoretical basis, experimental design, and computerized simulation of synergism and antagonism in drug combination studies. Pharmacol. Rev. 58, 621–681 (2006)."),
                                         p("Lee, S.-I. Drug interaction: focusing on response surface models. Korean Journal of Anesthesiology 58, 421–434 (2010).")
                                ),
                                
                                
                                tabPanel("Contour",
                                         br(),
                                         
                                         tags$ul(tags$u(strong("Contour plot:")),
                                                 tags$li("allows to visualize and predict effect fraction data")),
                                         br(),
                                         conditionalPanel(
                                           condition = "output.fileUploaded",messinfo),
                                         plotOutput("dcontour",height = 500),
                                         br(),
                                         p(strong("Schematic diagram:")),                                         img(src="contour.png",height=359,width=434),
                                         p(strong("References:")),
                                         p("Lee, S.-I. Drug interaction: focusing on response surface models. Korean Journal of Anesthesiology 58, 421–434 (2010).")              
                                ),
                                tabPanel("Document",
                                         includeMarkdown("README.md"))
                                #                  includeHTML("README.html"))
                                
                                
                              )
                    )
                  )))
