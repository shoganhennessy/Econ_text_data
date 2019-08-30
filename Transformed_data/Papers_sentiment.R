# 21/08/2019
# Sentiment analysis of NBER abstracts 
library(tidyverse)
library(data.table)
library(dplyr)
library(stringr)
library(tidytext)

# Load the raw Master data
Papers.data <- fread('../Master_data/Working_papers_data.csv')


Papers.data %>%
  pull(nber_index, abstract) %>%
  unnest_tokens()


library(wordcloud)
