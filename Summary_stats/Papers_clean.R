# 23/12/2019
# Manipulate NBER working paper data 
library(tidyverse)
library(data.table)
library(RColorBrewer)

# Load the raw working papers data
Papers.data <- fread('../Data/NBER_data/Papers_data/Working_papers_data_new.csv')
Papers.data <- Papers.data %>% filter(title != 'Paper Not Found', !is.na(date), date != '') # FIlter empty entries 

# SHow count per year
Papers.data %>%
  mutate(date = as.Date(date),
         year = as.integer(format(date, format = '%Y'))) %>%
  group_by(year) %>%
  summarise(count = n()) %>%
  ggplot(aes(x = year, y = count)) +
  geom_point() +
  geom_smooth(span = 5, se = F) +
  theme_bw() +
  scale_x_continuous(name = 'Year', breaks = seq(1975, 2015, by = 5)) +
  scale_y_continuous(name = 'Count of Working Papers')

# SHow count per year, for each area
Papers_subjects.data <- Papers.data %>% transmute(
  aging = stri_detect_fixed(nber_area, 'Program on the Economics of Aging'),
  assets = stri_detect_fixed(nber_area, 'Asset Pricing Program'),
  corporate_finance = stri_detect_fixed(nber_area, 'Corporate Finance Program'),
  children = stri_detect_fixed(nber_area, 'Program on Children'),
  american_history = stri_detect_fixed(nber_area, 'Program on the Development of the American Economy'),
  development = stri_detect_fixed(nber_area, 'Development Economics Progra'),
  education = stri_detect_fixed(nber_area, 'Economics of Education Program'),
  energy = stri_detect_fixed(nber_area, 'Environment and Energy Program'),
  growth = stri_detect_fixed(nber_area, 'Economic Fluctuations and Growth Program'),
  care = stri_detect_fixed(nber_area, 'Health Care Program'),
  health = stri_detect_fixed(nber_area, 'Health Economics Program'),
  finance_macro = stri_detect_fixed(nber_area, 'International Finance and Macroeconomics Program'),
  indust_org = stri_detect_fixed(nber_area, 'Industrial Organization Program'),
  trade_invest = stri_detect_fixed(nber_area, 'International Trade and Investment Program'),
  law = stri_detect_fixed(nber_area, 'Law and Economics Program'),
  labour = stri_detect_fixed(nber_area, 'Labor Studies Program'),
  monetary = stri_detect_fixed(nber_area, 'Monetary Economics Program'),
  public = stri_detect_fixed(nber_area, 'Public Economics Program'),
  poli_econ = stri_detect_fixed(nber_area, 'Political Economy Program'),
  productivity = stri_detect_fixed(nber_area, 'Productivity, Innovation, and Entrepreneurship Program'),
  date = as.Date(date),
  year = as.integer(format(date, format = '%Y'))) %>%
  group_by(year) %>%
  summarise(count = n(),
            aging = sum(aging),
            assets = sum(assets),
            corporate_finance = sum(corporate_finance),
            children = sum(children),
            american_history = sum(american_history),
            development = sum(development),
            education = sum(education),
            energy = sum(energy),
            growth = sum(growth),
            care = sum(care),
            health = sum(health),
            finance_macro = sum(finance_macro),
            indust_org = sum(indust_org),
            trade_invest = sum(trade_invest),
            law = sum(law),
            labour = sum(labour),
            monetary = sum(monetary),
            public = sum(public),
            poli_econ = sum(poli_econ),
            productivity = sum(productivity)) %>%
  reshape(timevar = 'nber_area',
          times = c('aging', 'assets', 'corporate_finance', 'children', 'american_history', 'development', 'education',
                    'energy', 'growth', 'care', 'health', 'finance_macro', 'indust_org', 'trade_invest', 'law', 'labour', 
                    'monetary', 'public', 'poli_econ', 'productivity'),
          varying = c('aging', 'assets', 'corporate_finance', 'children', 'american_history', 'development', 'education',
                      'energy', 'growth', 'care', 'health', 'finance_macro', 'indust_org', 'trade_invest', 'law', 'labour', 
                      'monetary', 'public', 'poli_econ', 'productivity'),
          v.names = 'count', direction = 'long', new.row.names = 1:1000) %>% group_by(year)

# Choose most popular areas :
popular_areas <- Papers_subjects.data %>% 
  group_by(nber_area) %>% summarise_all(sum) %>% 
  arrange(-count) %>% head(10) %>% pull(nber_area)

# Graph the cumulative count of the the most popular areas
Papers_subjects.data %>%
  filter(nber_area %in% popular_areas) %>% arrange(year) %>%
  group_by(nber_area) %>% mutate(cumul_count = cumsum(count)) %>%
  mutate(label = if_else(year == max(year), nber_area, NA_character_)) %>%
  ggplot(aes(x = year, y = cumul_count, 
             group = nber_area, colour = nber_area)) +
  geom_line(position = position_dodge(w = 2)) +
  scale_x_continuous(name = 'Year', breaks = seq(1975, 2020, by = 5)) +
  scale_y_continuous(name = 'Cumulative Count of Working Papers') + 
  theme_classic() + theme(legend.position = c(0.175, 0.60)) +
  scale_color_brewer(palette = 'Paired') + 
  geom_label_repel(aes(label = label), 
    nudge_x = 1, direction = 'y', hjust = -2, segment.alpha = 0, na.rm = T) + 
  scale_color_discrete(guide = F) + 
  scale_x_continuous(limits = c(1975,2022))


# Show rate of publishing by year
Papers.data %>%
  transmute(publish_rate = (published != ''),
            date         = as.Date(date)) %>%
  mutate(year = as.integer(format(date, '%Y'))) %>%
  filter(year < 2011) %>%
  group_by(year) %>%
  summarise(publish_rate = mean(publish_rate)) %>%
  ggplot(aes(x = year, y = publish_rate)) +
  geom_point() +
  geom_smooth(span = 5) +
  theme_bw() +
  scale_x_continuous(name = 'Year', breaks = seq(1975, 2015, by = 5)) +
  scale_y_continuous(name = 'Publish Rate (%)', 
                     breaks = seq(0, 1, by = 0.2), limits = c(0,1))
# Note sharp drop off 2015, work still yet to be published?

# Show rate of publishing by area
Papers_published.data <- Papers.data %>% 
  mutate(publish_rate = (published != '')) %>%
  transmute(
    aging = stri_detect_fixed(nber_area, 'Program on the Economics of Aging'),
    assets = stri_detect_fixed(nber_area, 'Asset Pricing Program'),
    corporate_finance = stri_detect_fixed(nber_area, 'Corporate Finance Program'),
    children = stri_detect_fixed(nber_area, 'Program on Children'),
    american_history = stri_detect_fixed(nber_area, 'Program on the Development of the American Economy'),
    development = stri_detect_fixed(nber_area, 'Development Economics Progra'),
    education = stri_detect_fixed(nber_area, 'Economics of Education Program'),
    energy = stri_detect_fixed(nber_area, 'Environment and Energy Program'),
    growth = stri_detect_fixed(nber_area, 'Economic Fluctuations and Growth Program'),
    care = stri_detect_fixed(nber_area, 'Health Care Program'),
    health = stri_detect_fixed(nber_area, 'Health Economics Program'),
    finance_macro = stri_detect_fixed(nber_area, 'International Finance and Macroeconomics Program'),
    indust_org = stri_detect_fixed(nber_area, 'Industrial Organization Program'),
    trade_invest = stri_detect_fixed(nber_area, 'International Trade and Investment Program'),
    law = stri_detect_fixed(nber_area, 'Law and Economics Program'),
    labour = stri_detect_fixed(nber_area, 'Labor Studies Program'),
    monetary = stri_detect_fixed(nber_area, 'Monetary Economics Program'),
    public = stri_detect_fixed(nber_area, 'Public Economics Program'),
    poli_econ = stri_detect_fixed(nber_area, 'Political Economy Program'),
    productivity = stri_detect_fixed(nber_area, 'Productivity, Innovation, and Entrepreneurship Program'),
    aging_publish = publish_rate * stri_detect_fixed(nber_area, 'Program on the Economics of Aging'),
    assets_publish = publish_rate * stri_detect_fixed(nber_area, 'Asset Pricing Program'),
    corporate_finance_publish = publish_rate * stri_detect_fixed(nber_area, 'Corporate Finance Program'),
    children_publish = publish_rate * stri_detect_fixed(nber_area, 'Program on Children'),
    american_history_publish = publish_rate * stri_detect_fixed(nber_area, 'Program on the Development of the American Economy'),
    development_publish = publish_rate * stri_detect_fixed(nber_area, 'Development Economics Progra'),
    education_publish = publish_rate * stri_detect_fixed(nber_area, 'Economics of Education Program'),
    energy_publish = publish_rate * stri_detect_fixed(nber_area, 'Environment and Energy Program'),
    growth_publish = publish_rate * stri_detect_fixed(nber_area, 'Economic Fluctuations and Growth Program'),
    care_publish = publish_rate * stri_detect_fixed(nber_area, 'Health Care Program'),
    health_publish = publish_rate * stri_detect_fixed(nber_area, 'Health Economics Program'),
    finance_macro_publish = publish_rate * stri_detect_fixed(nber_area, 'International Finance and Macroeconomics Program'),
    indust_org_publish = publish_rate * stri_detect_fixed(nber_area, 'Industrial Organization Program'),
    trade_invest_publish = publish_rate * stri_detect_fixed(nber_area, 'International Trade and Investment Program'),
    law_publish = publish_rate * stri_detect_fixed(nber_area, 'Law and Economics Program'),
    labour_publish = publish_rate * stri_detect_fixed(nber_area, 'Labor Studies Program'),
    monetary_publish = publish_rate * stri_detect_fixed(nber_area, 'Monetary Economics Program'),
    public_publish = publish_rate * stri_detect_fixed(nber_area, 'Public Economics Program'),
    poli_econ_publish = publish_rate * stri_detect_fixed(nber_area, 'Political Economy Program'),
    productivity_publish = publish_rate * stri_detect_fixed(nber_area, 'Productivity, Innovation, and Entrepreneurship Program'),
    year = as.integer(format(as.Date(date), format = '%Y'))) %>%
  group_by(year) %>%
  summarise_all(sum) %>%
  transmute()
  reshape(timevar = 'nber_area',
          times = c('aging', 'assets', 'corporate_finance', 'children', 'american_history', 'development', 'education',
                    'energy', 'growth', 'care', 'health', 'finance_macro', 'indust_org', 'trade_invest', 'law', 'labour', 
                    'monetary', 'public', 'poli_econ', 'productivity'),
          varying = c('aging', 'assets', 'corporate_finance', 'children', 'american_history', 'development', 'education',
                      'energy', 'growth', 'care', 'health', 'finance_macro', 'indust_org', 'trade_invest', 'law', 'labour', 
                      'monetary', 'public', 'poli_econ', 'productivity'),
          v.names = 'count', direction = 'long', new.row.names = 1:1000) %>% group_by(year)

# Show number of authors per paper
Papers.data %>%
  transmute(author_no = 1 + str_count(author, ';'),
            date      = as.Date(date)) %>%
  mutate(year = as.integer(format(date, '%Y'))) %>%
  group_by(year) %>%
  summarise(author_no = mean(author_no)) %>%
  ggplot(aes(x = year, y = author_no)) +
  geom_point() +
  geom_smooth(span = 5) +
  theme_bw() +
  scale_x_continuous(name = 'Year', breaks = seq(1970, 2020, by = 5)) +
  scale_y_continuous(name = 'No. Authors', 
                     breaks = seq(1, 3, by = 0.2), limits = c(1,3))


# Transform in some way
# Papers.data %>% fwrite('Transformed_data/Papers_cleaned.data')



# Part splitting up the words for (?) text analysis


# LOOK HERE FOR UP TO DATE RESEARCH ON THE SAME IDEA
# https://www.nber.org/papers/w25967

# WORK TO DO:
# 1. Read on the literature on economics papers/publishing
# ^ look for ideas about where to look specifically
# ^ look over the text data paper about ECon Job makret fora and sexist language.

# This data set is best for looking in to the economics
# publishing pipeline

# https://www.tidytextmining.com/tidytext.html

