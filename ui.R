library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Monthly fisheries catch for Timor-Leste"),
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput("site", label = "Location",
                         choices = c("Adara","Beloi","Biqueli","Vemasse","Adarai",
                                     "Uaroana","Com","Tutuala","Lore"), 
                         selected = c("Adara","Beloi","Biqueli","Vemasse","Adarai",
                                      "Uaroana","Com","Tutuala","Lore")),
      br(),
      checkboxGroupInput("hab", label = "Habitat",
                         choices = c("Reef", "FAD", "Deep", "Beach"),
                         selected = c("Reef", "FAD", "Deep", "Beach")),
      br(),
      checkboxGroupInput("gear", label = "Gear type",
                         choices = c("Net", "Hook & Line", "Spear"), 
                         selected = c("Net", "Hook & Line", "Spear")),
      br(),
      img(src = "logo.png", height = 72, width = 144), 
      br(),
      br(),
      br()
    ),

    mainPanel(
      plotOutput("plot1")
    )
    # mainPanel(
    #   tabsetPanel(
    #     tabPanel("Plot",
    #              fluidRow(
    #                column(8, plotOutput("plot1")),
    #                column(12, plotOutput("plot2"))
    #                #splitLayout(cellWidths = c("50%", "50%"), plotOutput("plotgraph1"), plotOutput("plotgraph2"))
    #                
    #                #column(6,plotOutput(outputId="plotgraph1", width="300px",height="300px")),  
    #                #column(6,plotOutput(outputId="plotgraph2", width="300px",height="300px"))
    #              )
    #     )
    #   )
    # )

    
  )
))
