library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Timor-Leste Reported Monthly Fisheries Catch"),
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      
      dateRangeInput('dateRange',
                     label = "Date range",
                     start = as.Date("2016-09-01"), end = lubridate::floor_date(Sys.Date(), unit = "month"),
                     min = as.Date("2016-09-01"), max = lubridate::floor_date(Sys.Date(), unit = "month"),
                     separator = " - ", format = "dd-M-yyyy",
                     startview = "year", language = "en-AU"#, weekstart = 1
      ),
      
      checkboxGroupInput("site", label = "Location",
                         choices = c("Adara","Beloi","Biqueli","Vemasse","Adarai",
                                     "Uaroana","Com","Tutuala","Lore"), 
                         selected = c("Adara","Beloi","Biqueli","Vemasse","Adarai",
                                      "Uaroana","Com","Tutuala","Lore")),
      
      checkboxGroupInput("hab", label = "Habitat",
                         choices = c("Reef", "FAD", "Deep", "Beach"),
                         selected = c("Reef", "FAD", "Deep", "Beach")),
      
      checkboxGroupInput("gear", label = "Gear type",
                         choices = c("Net", "Hook & Line", "Spear"), 
                         selected = c("Net", "Hook & Line", "Spear")),
      
      downloadButton("downloadData", "Download (csv)"),
      br(),
      br(),
      img(src = "logo.png", height = 72, width = 144), 
      br(),
      br(),
      br()
    ),

    mainPanel(
      tabsetPanel(
        tabPanel("Plot", br(), plotOutput("plot1")),
        tabPanel("Summary", br(), tableOutput("table1"))
      )
      
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
