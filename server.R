server <- function(input, output) {
  output$select_kingdom <- renderUI({
    shinyjs::hide(id = 'app-content')
    selectInput(
      "select_kingdom",
      "Choose a Kingdom",
      choices = unique(occurrence$kingdom),
      multiple = FALSE,
      selected = "Animalia"
    )
    
  })
  
  kingdom_selected <- reactive({
    req(input$select_kingdom)
    input$select_kingdom
  })
  
  data_ <- reactive({
    req(kingdom_selected())
    
    
    kingdom_selected <- kingdom_selected()
    data_ <- occurrence  %>%
      dplyr::filter(kingdom == kingdom_selected)
    
    data_
  })
  
  output$select_vern_name <- renderUI({
    shinyjs::hide(id = 'app-content')
    
    req(data_())
    selectInput(
      "select_vern_name",
      "Choose a Vernacular Name",
      choices = unique(data_()$vernacularName),
      multiple = FALSE
    )
    
  })
  
  vern_selected <- reactive({
    req(input$select_vern_name)
    input$select_vern_name
  })
  
  data_1 <- reactive({
    req(data_())
    req(vern_selected())
    
    
    vern_selected <- vern_selected()
    
    
    data_ <- data_()  %>%
      dplyr::filter(vernacularName == vern_selected)
    
    data_
  })
  
  
  output$select_sci_name <- renderUI({
    shinyjs::hide(id = 'app-content')
    
    req(data_1())
    
    selectInput(
      "select_sci_name",
      "Choose a Scientific Name",
      choices = unique(data_1()$scientificName),
      multiple = FALSE
    )
    
  })
  
  sci_selected <- reactive({
    req(input$select_sci_name)
    input$select_sci_name
  })
  data_2 <- reactive({
    req(data_1())
    req(sci_selected())
    
    
    sci_selected <- sci_selected()
    
    
    data_ <- data_1() %>%
      dplyr::filter(scientificName == sci_selected)
    
    data_
  })
  
  output$regions <- plotly::renderPlotly({
    req(data_2())
    
    
    p <- data_2() %>%
      dplyr::group_by(locality) %>%
      dplyr::summarise(n = dplyr::n()) %>%
      dplyr::ungroup() %>%
      dplyr::arrange(desc(n))
    
    #
    #   ggplot(aes(x = reorder(locality, n), y = n)) + geom_bar(stat = 'identity', fill =
    #                                                             '#D22630') + ggplot2::labs(x = 'Locality', y = 'Number of Contributions') +
    #   ggplot2::coord_flip()
    
    
    plotly::plot_ly(
      x = reorder(p$locality,-p$n),
      y = p$n,
      name = '',
      type = 'bar',
      textposition = 'auto',
      marker = list(
        color = '#D22630',
        
        line = list(color = '#D22630', width = 1.5)
      )
    ) %>% plotly::layout(
      title = "",
      
      xaxis = list(title = "Locality"),
      
      yaxis = list(title = "Number of Photographs"),
      paper_bgcolor = '#fff5ee',
      
      plot_bgcolor = '#fff5ee'
    )
    
    
  })
  
  
  output$rights_holders <- plotly::renderPlotly({
    req(data_2())
    
    kingdom_selected <-
      data_2() %>% dplyr::select(kingdom) %>% unique() %>% dplyr::pull()
    
    sci_selected <-
      data_2()  %>% dplyr::select(scientificName) %>% unique() %>% dplyr::pull()
    
    vern_selected <-
      data_2() %>% dplyr::select(vernacularName) %>% unique() %>% dplyr::pull()
    
    p <- data_new  %>%
      dplyr::filter(
        kingdom == kingdom_selected,
        vernacularName == vern_selected,
        scientificName == sci_selected
      ) %>%
      dplyr::select(id, rightsHolder.y) %>%
      unique() %>%
      # na.omit() %>%
      dplyr::mutate(rightsHolder.y = ifelse(is.na(rightsHolder.y), 'Unassigned', rightsHolder.y)) %>%
      
      dplyr::group_by(rightsHolder.y) %>%
      dplyr::summarise(n = dplyr::n()) %>% dplyr::ungroup()
    
    
    # ggplot(aes(x = reorder(rightsHolder.y,n), y = n)) + geom_bar(stat =
    #                                                                 'identity', fill = '#D22630') + ggplot2::labs(x = 'Contributor Name', y =
    #                                                                                                                 'Number of Contributions') + ggplot2::coord_flip()
    
    plotly::plot_ly(
      x = reorder(p$rightsHolder.y,-p$n),
      y = p$n,
      name = '',
      type = 'bar',
      textposition = 'auto',
      marker = list(
        color = '#D22630',
        
        line = list(color = '#D22630', width = 1.5)
      )
    ) %>% plotly::layout(
      title = "",
      
      xaxis = list(title = "Photographers"),
      
      yaxis = list(title = "Number of Photographs")
    ) %>% plotly::layout(
      autosize = F,
      width = 1000,
      height = 800,
      paper_bgcolor = '#fff5ee',
      
      plot_bgcolor = '#fff5ee'
    )
    
    
  })
  
  
  
  output$mymap <- renderLeaflet({
    leaflet(data_2()) %>%
      addTiles() %>%
      addCircleMarkers(lng = ~ longitudeDecimal,
                       lat = ~ latitudeDecimal)
  })
  
  
  observeEvent(input$refresh, {
    shinyjs::show(
      id = "loading",
      anim = TRUE,
      animType = "fade",
      time = 0.5
    )
    Sys.sleep(2)
    
    shinyjs::hide(
      id = "loading",
      anim = TRUE,
      animType = "fade",
      time = 0.5
    )
    
    shinyjs::show(id = 'app-content')
    shinyjs::js$foo()
  })
  
  output$img <- renderUI({
    req(data_2())
    
    req(data_2())
    
    kingdom_selected <-
      data_2() %>% dplyr::select(kingdom) %>% unique() %>% dplyr::pull()
    
    sci_selected <-
      data_2() %>%  dplyr::select(scientificName) %>% unique() %>% dplyr::pull()
    
    vern_selected <-
      data_2()  %>% dplyr::select(vernacularName) %>% unique() %>% dplyr::pull()
    
    data_new %>%
      dplyr::filter(
        kingdom == kingdom_selected,
        vernacularName == vern_selected,
        scientificName == sci_selected,!is.na(accessURI)
      ) -> data_new
    
    url <-
      data_new %>% dplyr::sample_frac(1) %>% dplyr::slice(1) %>% dplyr::select(accessURI) %>% dplyr::pull()
    
    
    
    
    
    tags$img(
      src = url,
      height = "800",
      width = "1000",
      align = "center"
    )
  })
  
  output$time_series <- plotly::renderPlotly({
    req(data_2())
    
    p <- data_2()  %>%
      dplyr::arrange(eventDate) %>%
      dplyr::mutate(month_year = stringr::str_c(
        lubridate::month(eventDate, label = TRUE),
        '-',
        lubridate::year(eventDate)
      )) %>%
      dplyr::mutate(month_year = lubridate::my(month_year)) %>%
      dplyr::arrange(month_year) %>%
      dplyr::group_by(month_year) %>%
      dplyr::summarise(`Number of Discoveries by Date` = dplyr::n()) %>%
      dplyr::ungroup() %>%
      dplyr::rename(Date = month_year)
    #ggplot(aes(x = Date, y = `Number of Discoveries by Date`)) + geom_bar(stat='identity',fill = '#D22630')-> p
    
    #plotly::ggplotly(p + plotTheme()) %>% plotly::layout(autosize = F,
    #                                                     width = 1000,
    #                                                     height = 800)
    
    
    
    plotly::plot_ly(
      p,
      type = 'bar',
      mode = 'lines',
      marker = list(
        color = '#D22630',
        
        line = list(color = '#D22630', width = 1.5))
      ) %>%
        
        plotly::add_trace(
          x = ~ Date,
          y = ~ `Number of Discoveries by Date`
        ) %>%
        
        plotly::layout(showlegend = F) %>% plotly::layout(
          autosize = F,
          width = 1000,
          height = 800,
          
          paper_bgcolor = '#fff5ee',
          
          plot_bgcolor = '#fff5ee'
        )
      
      
      
      
      
      
      
      
      
      
      
  })
    
    
    
    
    
    
}