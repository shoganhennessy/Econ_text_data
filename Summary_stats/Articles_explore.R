## 09/01/2019
## Maniuplate and explore Articles and Economcists from RePEc data.
library(tidyverse)
library(data.table)
# https://github.com/dgrtwo/fuzzyjoin
library(fuzzyjoin)

# Load the data on Economists
Economists.data <- fread('../Data/RePEc_data/Economists_data/Economists_repec_data.csv')
# Load the data on published articles
Articles.data <- fread('../Data/RePEc_data/Papers_data/Journal_articles_repec.csv')
# Load data on Journals, collected 09/01/2020 : https://ideas.repec.org/top/top.journals.all.html
Journals.data <- fread('../Data/RePEc_data/Journals_data/Journal_info_repec.csv')


# The most prolific articles, within these data
Articles.data %>%
  arrange(-citation_count) %>% head(10)

## WHo have the most citations, in these data
Articles.data %>% 
  group_by(author) %>%
  summarise(citation_count = sum(citation_count)) %>% 
  arrange(-citation_count) %>% head(10)
# Note: equally assigns citations to authors in spite of its inappropriateness (Sarsons 2017)



### 
Journals_tomerge.data <- Journals.data %>%
  mutate(journal_id_publisher = paste(journal_title, publisher, sep = ', ')) %>%
  select(rank, journal_id_publisher)

Articles.data %>%
  mutate(journal_id_article = paste(journal_title, publisher, sep = ', ')) %>%
  stringdist_inner_join(Journals_tomerge.data,
                        by = c(journal_id_article = 'journal_id_publisher')) %>%
  filter(rank <= 5) %>% count(journal_id_article, journal_id_publisher, rank)
  


## Look at the distibution of PhDs for economists
Economists.data %>% count(degree) %>%
  summarise(count = n()) %>%
  arrange(-count)


#### INVESTIGATE: years since phd that the article is published, by journal


## Bygrams of words https://uc-r.github.io/word_relationships


