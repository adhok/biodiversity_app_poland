

cssfile <- 'style.css'

ui <- fluidPage(
  shinyWidgets::setBackgroundColor("#fff5ee"),
  
  shiny::tags$head(tags$link(
    rel = "stylesheet", href = cssfile, type = "text/css"
  )),
  
  sidebarLayout(
    sidebarPanel(
      helpText(
        HTML(
          "<center><img src='img/poland.jpg' alt='Poland' width='150' height='150'></img></center>"
        )
      ),
      helpText(
        HTML(
          "<span><h4>Get Information about Animals/Fungi/Plantae in Poland.</h4></span> "
        )
      ),
      helpText(
        HTML(
          " <ul>
  <li>Select the Kingdom</li>
  <li>Select the VernaCular Name</li>
  <li>Select the Scientific Name</li>
  <li>Click the button to get your results!</li>

</ul> "
        )
      ),
      uiOutput('select_kingdom'),
      
      
      
      uiOutput('select_vern_name'),
      
      
      
      uiOutput('select_sci_name'),
      
      column(
        12,
        actionButton("refresh", "Click to get your results"),
        align = "center",
        style = "margin-top: -15px;"
      )
      
      #h5("This is a static text")
      
      
      
      
      
    ),
    
    mainPanel(
      #shiny::tableOutput('table'),
      
      useShinyjs(),
      inlineCSS(appCSS),
      shinyjs::extendShinyjs(text = "shinyjs.refresh = function() { location.reload(); }", functions = 'foo'),
      
      
      shinyjs::hidden(div(id = 'loading')),
      
      shinyjs::hidden(div(
        style = "width=100%",
        id = 'app-content',
        
        
        column(
          12,
          shiny::tabsetPanel(
            shiny::tabPanel("Contributers", plotly::plotlyOutput('rights_holders')),
            shiny::tabPanel(
              "Where were the animals photographed?",
              leafletOutput("mymap"),
              plotly::plotlyOutput('regions')
            ),
            shiny::tabPanel(
              "When were these photographs taken?",
              plotly::plotlyOutput('time_series')
            ),
            shiny::tabPanel('A photo of the animal', uiOutput("img"))
          ),
          align = "right"
        )
        
        
      ))
      
    )
  )
)
