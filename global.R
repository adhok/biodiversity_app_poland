library(shiny)
library(ggplot2)
library(readr)
library(leaflet)
library(shinyjs)
library(V8)
library(lazyeval)
library(data.table)

appCSS <- "
#loading {
  position: fixed;
left: 50%;
top: 50%;
z-index: 1;
width: 150px;
height: 150px;
margin: -75px 0 0 -75px;
border: 16px solid #f3f3f3;
border-radius: 50%;
border-top: 16px solid #3498db;
width: 120px;
height: 120px;
-webkit-animation: spin 2s linear infinite;
animation: spin 2s linear infinite;
}
@-webkit-keyframes spin {
0% { -webkit-transform: rotate(0deg); }
100% { -webkit-transform: rotate(360deg); }
}
@keyframes spin {
0% { transform: rotate(0deg); }
100% { transform: rotate(360deg); }
}
"
plotTheme <- function(base_size = 12) {
  theme(
    text = element_text( color = "#D22630"),
    plot.title = element_text(size = 12,colour = "#D22630",hjust=0.5),
    plot.subtitle = element_text(face="italic"),
    plot.caption = element_text(hjust=0),
    axis.ticks = element_blank(),
    panel.background = element_rect(fill='#fff5ee'),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    strip.background = element_rect(fill = "black", color = "white"),
    strip.text = element_text(size=8),
    axis.title = element_text(size=10),
    axis.text = element_text(size=10),
    axis.title.x = element_text(hjust=1,size=10),
    axis.title.y = element_text(hjust=1,size=10),
    plot.background = element_rect(fill = '#fff5ee'),
    legend.background = element_blank(),
    legend.title = element_text(colour = "#D22630", face = "bold"),
    legend.text = element_text(colour = "#D22630", face = "bold"),
    axis.text.y = element_text(size=10),
    axis.text.x = element_text(vjust=-1,angle=90,size=10))
}



occurrence <- readRDS('data_sources/poland.rds')

data_new <- readRDS('data_sources/new_data.rds')

#occurrence <- readRDS(gzcon(url('https://raw.githubusercontent.com/adhok/data_sources_new/main/poland.rds')))

  
#data_new <- readRDS(gzcon(url('https://raw.githubusercontent.com/adhok/data_sources_new/main/new_data.RDS')))

occurrence %>%
  dplyr::mutate(eventDate=lubridate::ymd(eventDate)) -> occurrence
