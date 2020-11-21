##Loading packages
pacman::p_load(tidyverse, # General-purpose data wrangling
               rvest, # Parsing of HTML/XML files 
               stringr,# String manipulation
               rebus, # Verbose regular expressions
               lubridate, # Eases DateTime manipulation
               tidytext, # For transforming text
               wordcloud, # To make wordclouds
               RColorBrewer, # Colors to wordcloud and ggplot
               RSelenium,# In order to change infinite scroll
               httr,# In order to change infinite scroll
               gganimate, # To make a plot animation
               readr, #
               highcharter, # To make interactive charts
               htmltools, # Saving html
               dplyr) # General datawrangling

#Function scraping citizen proposals
infinite_scrape <- function(url, n_pages){
  page_list <- seq(1, n_pages)
  extr_content <- data.frame(0)
  
  for (i in seq_along(page_list)) {
    #print(paste("page number is", i, sep = " "))
    body_list <- list(
      filter = "",
      sortOrder= "", #NewestFirst
      searchQuery= "",
      pageNumber= i,
      pageSize = 24
    )
    posts <- POST(url = url, body = body_list, encode = "json")#, encode = "json"
    content <- httr::content(posts)
    for (k in seq_along(content$data)) {
      #print(paste("data number is", k, sep = " "))
      extr_content$title <- content$data[[k]]$title
      extr_content$votes <- content$data[[k]]$votes
      extr_content$date <- content$data[[k]]$date
      extr_content$status <- content$data[[k]]$status
      
      if(i == 1 & k ==1){
        #print("first page and row collected")
        citizen <- extr_content
      } else {
        citizen <- rbind(extr_content, citizen)
      }
    }  
  }
  return(citizen)
}

#keyword search 
keyword_search <- function(title_col, keyword_list){
  unique_title <- unique(as.character(title_col))
  
  for (k in 1:length(keyword_list)) {
    
    if(keyword_list[k] == "politi"){
      paste(".*",keyword_list[k],"(?!.*k)", sep = "")  
      
    }else{
      percent <- length(unique_title[unique_title %>% str_detect(paste(keyword_list[k],"{1}",sep = ""))])/length(unique_title)
    }
    
    topic <- data.frame(
      keyword = keyword_list[k],
      percent = (percent*100)
    )
    
    if(k == 1){
      topic_proportion <- topic
    }
    
    if(k != 1){
      topic_proportion <- rbind(topic_proportion, topic)
    }
  }
  return(topic_proportion)
}
