# 21/08/2019
# Sentiment analysis of NBER abstracts 
library(tidyverse)
library(data.table)
library(dplyr)
library(stringr)
library(tidytext)
library(caret)

# Load the raw papers data
Papers.data <- fread('../Data/Master_data/Working_papers_data_new.csv')


# http://varianceexplained.org/r/trump-tweets/
# Analyse the workd usage of published vs non-published and put in an RMD, 
# link in econ applications


data(nrc_emotions)
nrc_emotions
