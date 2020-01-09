## 09/01/2019
## Maniuplate and explore Articles and Economcists from RePEc data.
library(tidyverse)
library(data.table)
library(stringi)
library(ggplot2)
library(RColorBrewer)
library(ggrepel)
library(tidytext)
library(scales)
theme_set(theme_bw())

# Load the data on Economists
Economists.data <- fread('../Data/RePEc_data/Economists_data/Economists_repec_data.csv')
# Load the data on published articles
Articles.data <- fread('../Data/RePEc_data/Papers_data/Journal_articles_repec.csv')
# Load data on Journals, collected 09/01/2020
# https://ideas.repec.org/top/top.journals.all.html
Journals.data <- fread('../Data/RePEc_data/Journals_data/Journal_info.tsv', sep = '\t', nrows = 11) %>%
  mutate(publisher = sub('^[^,]*', '', journal_title),
         journal_title = sub('\\,.*', '', journal_title) %>% str_replace(', ', ''))

## Look at the distibution of PhDs for economists
Economists.data %>% group_by(degree) %>%
  summarise(count = n()) %>%
  arrange(-count)




#### INVESTIGATE: years since phd that the article is published, by journal


## Bygrams of words https://uc-r.github.io/word_relationships


