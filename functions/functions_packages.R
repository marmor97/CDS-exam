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
               dplyr, # General datawrangling
               tm, # Text mining package
               reticulate) # Package for using Python in RStudio


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

# Creating function to scrape bills 
scraping <- function(pm){
  
  if (pm == "rasmussen_p1"){
    url <- html("https://www.folketingstidende.dk/da/dokumenttyper/lovforslag?govPriv=R&startDate=20180101&endDate=20190604&pageSize=200&pageNumber=1")
  }
  if (pm == "rasmussen_p2"){
    url <- html("https://www.folketingstidende.dk/da/dokumenttyper/lovforslag?govPriv=R&startDate=20180101&endDate=20190604&pageSize=200&pageNumber=2")
  } 
  if (pm == "frederiksen_p1"){
    url <- html("https://www.folketingstidende.dk/da/dokumenttyper/lovforslag?govPriv=R&startDate=20190605&endDate=20201121&pageSize=200&pageNumber=1")
  } 
  if (pm == "frederiksen_p2"){
    url <- html("https://www.folketingstidende.dk/da/dokumenttyper/lovforslag?govPriv=R&startDate=20190605&endDate=20201121&pageSize=200&pageNumber=2") 
  }
  
  #specifying list of paths to extract from (as specified by SelectorGadget)
  c_list <- c(".highlighted+ .column-documents .column-documents__icon-text", #title
              ".hidden-xs:nth-child(3) .column-documents__icon-text", #proposed by
              ".hidden-xs+ .hidden-xs .column-documents__icon-text", #status
              ".hidden-xs~ .hidden-xs+ .column-documents .column-documents__icon-text") #year
  
  #specifying column titles
  ctitles <- c("title", "proposed_by", "status", "year")  
  
  for (j in c_list){ #looping through all elements in the column_list
    
    #create df with data from each element in the column_list
    current_df <- as.data.frame(url %>% #go into the specified url
                                  html_nodes(paste(j)) %>% #what to extract from the url (specified by selectorgadget)
                                  html_text())   #return texts
    
    if (j == ".highlighted+ .column-documents .column-documents__icon-text"){ #add current information to new df
      df <- current_df
    }else{ #if 'df' exists, add current information as new column to df
      df <- cbind(df, current_df)
    }
    
  }
  colnames(df) <- ctitles
  
  return(df)  
}  


# Creating preprocessing-function that removes punctuation and stopwords and tokenizes the text
preprocessing <- function(lovforslag){
  filtered <- lovforslag
  
  #tokenizing title column
  filtered$title2 <- as.character(filtered$title)
  
  #removing stopwords
  text <- filtered$title2
  stopwords_regex <- paste(stopwords('da'), collapse = '\\b|\\b')
  stopwords_regex <- paste0('\\b', stopwords_regex, '\\b')
  filtered$title2 <-  stringr::str_replace_all(text, stopwords_regex, '')
  
  filtered <- filtered %>% unnest_tokens(word, title2)
  
  #removing punctuation
  filtered$word<- gsub('[[:punct:]]', '', filtered$word) 
  
  
  return(filtered)
  
}

# Creating function to put all the lemmatized words back into sentences
lemma_to_sentence <- function(df){
  
  #first, we make sure new df name does not alreadyexist in global environment
  if (exists("lemmatized_titles")){ 
    rm(lemmatized_titles)
  }
  
  #looping through all unique titles
  for (titl in unique(df$title)){ 
    
    #creating a subset of the df with lemmatized words for each unique title
    subset <- df %>% subset(title == titl) 
    
    #collapsing all lemmas in this subset into one row
    this_title <- paste0(subset$lemmas, collapse=NULL, sep="") #collapsing all lemmas into one vector
    this_title <- paste(this_title,collapse=" ") #removing quotes between lemmas
    this_title <- as.data.frame(this_title) #turning the vector into a dataframe
    
    #adding the row with the collapsed lemmas to a new df
    if (!exists("lemmatized_titles")){
      lemmatized_titles <- as.data.frame(this_title)
    }else{
      lemmatized_titles <- rbind(lemmatized_titles, this_title) 
    }
  }
  colnames(lemmatized_titles) <- "titles" #changing column name 
  
  return(lemmatized_titles)
}

# Creating document term matrix function
create_dtm <- function(lovforslag){
  #transform dataset to corpus and strip whitespace
  tm_corpus <- Corpus(VectorSource(lovforslag$title)) %>% tm_map(stripWhitespace) 
  #turn into document-term matrix
  dtm <- DocumentTermMatrix(tm_corpus) 
  
  return(dtm)
}

# Creating tf-idf function
create_dtm_tfidf <- function(lovforslag){
  #transform dataset to corpus and strip whitespace
  tm_corpus <- Corpus(VectorSource(lovforslag$title)) %>% tm_map(stripWhitespace) 
  #turn into document-term matrix
  dtm_tfidf <- DocumentTermMatrix(tm_corpus, control = list(weighting = weightTfIdf))
  
  return(dtm_tfidf)
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



