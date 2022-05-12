## Introduction
Hi here ! This is a simple shiny app to visualize Poland's biodiversity. This app makes use of the data that is available at https://www.gbif.org/occurrence/search?dataset_key=8a863029-f435-446a-821e-275f4f641165 . This data consists of photo URLs of flora & fauna, that are mapped to its photographer and type of species.


## App structure

* `server.R` - This is the file that contains the different backend functions that make the app work.
* `ui.R` - This is the file that contains basic UI features for the app such as Background color etc.
* `global.R`  - File that contains global variables such as data and the file used for library imports
* `data_pull.R` = R file that reads the large biodioversity data (~10GB) in chunks and creates two RDS files - new_data.RDS & poland.RDS.
* `data_sources/poland.RDS` - This contains the Poland data from `occurrence.csv`.
* `data_sources/new_data.RDS` - A joined data of `poland.RDS` & `multimedia.csv`
* `app.R` - File that imports `ui.R`, `server.R` & `global.R` and runs the shinyApp() function.
* `www` folder contains image and simple CSS files that are used in the app.


## App Layout & Usage

![App Layout](https://raw.githubusercontent.com/adhok/biodiversity_app_poland/main/Screenshot%202022-05-12%20at%2011.06.32%20AM.png)

* First select the kingdom, vernacular name and the scientific name in that order
* Then click the button `Click to get your results`
* A circular progress bar will appear that will last for ~2 seconds

As seen in the image, the app contains information on Contributors, Where the species were photographed , the photographs of the animals & when they were photographed.

## Future Work
The app can be found here https://pradeepadhokshaja.shinyapps.io/shiny_app/ . This app works better on Firefox. 

There are a couple of issues that lead to the app being slow

* Use of tidyverse::dplyr functions for data munging. **DT or data.table for manipulation that can speed up the process**
* Use of an RDS data file that leads to slower uptime when the app is loading . **Making using of AWS/Google Cloud/Azure can help with faster data streaming**.
* Using plotly wrapper for R can lead to longer rendering times for the graphs. **Using simpler JS visualization libraries can reduce the app load time**.
* This app is currently deployed on shiny.app.io **Using Cloud Machines that can optimize for memory** could help in faster rendering times.









