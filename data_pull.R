library(readr)

chunk_size <- 1000000


col_names <- TRUE
line_num <- 0
poland_df <- data.frame()

column_names <- names(chunk <- data.table::fread(
  file = "biodiversity_data/occurence.csv",
  skip = 0,
  nrows = 100
))

counter <- 1

### Each chunks of 1M data points each

while (TRUE) {
  chunk <- data.table::fread(
    file = "biodiversity_data/occurence.csv",
    skip = line_num,
    nrows = chunk_size
  )
  
  # If the chunk has now rows, then reached end of file
  if (!nrow(chunk)) {
    break
  }
  
  # Do something with the chunk of data
  names(chunk) <- column_names
  
  chunk <- chunk %>% dplyr::filter(country=='Poland')
  
  if(nrow(chunk)>0){
    poland_df <- rbind(poland_df,chunk)
    
  }
  
  # Update `col_names` so that it is equal the actual column names

  # Move to the next chunk. Add 1 for the header.
  line_num <- line_num + chunk_size+1
  print('Done!...\n')
  print(counter)
  print('------------------')
  counter <- counter+1
  rm(chunk)
}

poland_df

saveRDS(poland_df,'data_sources/poland.rds')


new_data <- read.csv('biodiversity_data/multimedia.csv')

poland_df %>%
  dplyr::left_join(new_data,by = c('id'='CoreId')) %>% saveRDS('data_sources/new_data.RDS')
