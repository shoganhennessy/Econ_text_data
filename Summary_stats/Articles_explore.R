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
# Load Economist-article individual links -- made externally in Python
Economists_articles.links <- fread('../Data/RePEc_data/Economists_data/Economists_articles_repec.csv')

## WHo have the most citations, in these data
Economists_articles.links %>% 
  left_join(select(Economists.data, url, name) %>% 
              rename(author_name = name, author_url = url), by = 'author_url') %>%
  left_join(rename(Articles.data, article_url = url), by = 'article_url') %>%
  select(author_name, title, publication_date, journal_title, citation_count) %>%
  filter(!is.na(citation_count)) %>%
  group_by(author_name) %>%
  summarise(total_citations = sum(citation_count, na.rm = T),
            mean_citations = mean(citation_count, na.rm = T),
            total_articules = n()) %>%
  arrange(-total_citations) %>% head(10) %>% as_tibble()



Articles.data %>%
  group_by(author) %>%
  summarise(citation_count = sum(citation_count)) %>%
  arrange(-citation_count) %>% head(10)

# Note: equally assigns citations to authors in spite of its inappropriateness (Sarsons 2017)




## Similarly, top author combinations
Articles.data %>% 
  group_by(author) %>%
  summarise(count = n()) %>%
  filter(grepl('; ', author)) %>%
  arrange(-count) %>% head(10)



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


## Event study testing
Top5_since.data %>% sample_frac(0.05) %>%
  filter(total_citations > 0) %>%
  lm(eventstudy_top5.formula, data = .) %>%
  broom::tidy(conf.int = T, conf.level = 0.95) %>%
  filter(str_detect(term, 'since_first_top5'))  %>%
  mutate(coefficient = as.numeric(str_extract(term, '[^)]+$'))) %>%
  filter(abs(coefficient) < 21)  %>%
  mutate(before = ifelse(coefficient < 0 , estimate, NA),
         after  = ifelse(0 <= coefficient, estimate, NA)) %>%
  ggplot(aes(x = coefficient)) +
  geom_point(aes(y = estimate)) +
  geom_smooth(aes(y = estimate), se = F, colour = 'blue', span = 0.5, alpha = 0.2) +
  geom_line(aes(y = conf.low), linetype = 'dashed') + 
  geom_line(aes(y = conf.high), linetype = 'dashed') + 
  geom_smooth(aes(y = before), method = 'lm', se = F, colour = 'red') +
  geom_smooth(aes(y = after ), method = 'lm', se = F, colour = 'red') +
  scale_x_continuous(name = 'Year to Publication', breaks = seq(-20, 20, by = 5)) +
  scale_y_continuous(name = 'Coefficient Estimate', limits = c(0.2,0.8), breaks = seq(0.2,0.8, by = 0.1)) +
  theme_bw() + ggtitle('Log Citations by year to author first\ntop 5 publication') +
  theme(plot.title = element_text(hjust = 0.5))


library(plm)
Top5_since.data %>%
  filter(total_citations > 0 & abs(since_first_top5) < 21) %>%
  ungroup() %>% pdata.frame() %>%
  plm(log(total_citations) ~ as.factor(since_first_top5), data = .,
      index = c('author_name', 'publication_date'), method = 'within', effect = 'twoways') %>%
  broom::tidy(conf.int = T, conf.level = 0.95) %>%
  filter(str_detect(term, 'since_first_top5'))  %>%
  mutate(coefficient = as.numeric(str_extract(term, '[^)]+$'))) %>%
  mutate(estimate_before  = ifelse(coefficient < 0 , estimate, NA),
         estimate_after   = ifelse(0 <= coefficient, estimate, NA),
         conf.low_before  = ifelse(coefficient < 0,  conf.low, NA),
         conf.low_after   = ifelse(0 < coefficient, conf.low, NA),
         conf.high_before = ifelse(coefficient < 0,  conf.high, NA),
         conf.high_after  = ifelse(0 < coefficient, conf.high, NA)) %>%
  ggplot(aes(x = coefficient)) +
  geom_point(aes(y = estimate)) +
  geom_smooth(aes(y = estimate), se = F, span = 0.5, alpha = 0.1) +
  geom_line(aes(y = conf.low_before), linetype = 'dashed') +
  geom_line(aes(y = conf.low_after), linetype = 'dashed') +
  geom_line(aes(y = conf.high_before), linetype = 'dashed') +
  geom_line(aes(y = conf.high_after), linetype = 'dashed') +
  geom_smooth(aes(y = estimate_before), method = 'lm', se = F, colour = 'red') +
  geom_smooth(aes(y = estimate_after), method = 'lm', se = F, colour = 'red') +
  scale_x_continuous(name = 'Year to Publication', breaks = seq(-20, 20, by = 5)) +
  scale_y_continuous(name = '', limits = c(-0.05,1), breaks = seq(0,1, by = 0.1)) + 
  theme_bw() + ggtitle('Log Citations by year to author first\ntop 5 publication') +
  theme(plot.title = element_text(hjust = 0.5))


