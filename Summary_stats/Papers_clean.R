# 23/06/2019
# Manipulate NBER working paper data 
library(tidyverse)
library(data.table)

# Load the raw Master data
Papers.data <- fread('../Master_data/Working_papers_data.csv') 

# Transform in some way
Papers.data <- Papers.data %>%
  filter(title != 'Paper Not Found', !is.na(date)) %>% # FIlter empty entries
  mutate(published = published) # Make blank if the entry is blank

# SHow count per year
Papers.data %>%
  mutate(date = as.Date(date, format = '%d-%m-%y'),
         year = as.integer(format(date, format = '%Y'))) %>%
  group_by(year) %>%
  summarise(count = n())%>%
  ggplot(aes(x = year, y = count)) +
  geom_point() +
  geom_smooth(span = 5, se = F) +
  theme_bw() +
  scale_x_continuous(name = 'Year', breaks = seq(1975, 2015, by = 5)) +
  scale_y_continuous(name = 'Count of Working Papers')

# Show rate of publishing by year
Papers.data %>%
  transmute(publish_rate = (published != ''),
            date         = as.Date(date, format = '%d-%m-%y')) %>%
  mutate(year = as.integer(format(date, '%Y'))) %>%
  filter(year < 2011) %>%
  group_by(year) %>%
  summarise(publish_rate = mean(publish_rate)) %>%
  ggplot(aes(x = year, y = publish_rate)) +
  geom_point() +
  geom_smooth(span = 5) +
  theme_bw() +
  scale_x_continuous(name = 'Year', breaks = seq(1975, 2015, by = 5))+
  scale_y_continuous(name = 'Publish Rate (%)', breaks = seq(0, 1, by = 0.2), limits = c(0,1))


# Transform in some way
# Papers.data %>% fwrite('Transformed_data/Papers_cleaned.data')



# Part splitting up the words for (?) text analysis


# LOOK HERE FOR UP TO DATE RESEARCH ON THE SAME IDEA
# https://www.nber.org/papers/w25967

# WORK TO DO:
# 1. LOOk at Python code and edit/add to lines to get indicies of similar articles.  
#    Then run on entire sample
# 2. Read on the literature on economics papers/publishing
# ^ look for ideas about where to look specifically
# ^ look over the text data paper about ECon Job makret fora and sexist language.

# This data set is best for looking in to the economics
# publishing pipeline

# https://www.tidytextmining.com/tidytext.html

