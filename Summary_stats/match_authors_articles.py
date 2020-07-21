#
# Senan Hogan-H. 22/01/2020
#

# Python script that puts together articles and authors : 
# splitting among the authors if multiple authors

###### Packages to use
import pandas as pd
import numpy as np
import random
random.seed(47)


########################################
### Create a list of individual authors and link to articles they have written
## Takes data of form 
# AUthor | article title
# author1; author2 | name of article 1

## Puts to
# AUThor | article title | no_authors
# author1 | name of article 1 | 2
# author2 | name of article 1 | 2

# Load data on economists
Economists_data = pd.read_csv('Data/RePEc_data/Economists_data/Economists_repec_data.csv', low_memory=False)


# Reshape to a key with individual entries for author_id and article_id
url_listing = Economists_data['url'].tolist()
articles_list = Economists_data['article_links'].tolist()
url_articles_dict = {url_listing[i] : articles_list[i].split('; ')
	for i in range(0,len(url_listing))
	if not isinstance(articles_list[i], float)}

Economists_papers = []
for author_url in list(url_articles_dict.keys()) :
	for article_url in url_articles_dict[author_url] :
		Economists_papers.append([author_url, article_url])

# Put to a data frame
Economists_papers_data = pd.DataFrame(Economists_papers, columns=['author_url', 'article_url'])


####################
## Save for post analysis.
Economists_papers_data.to_csv('Data/RePEc_data/Economists_data/Economists_articles_repec.csv', index = False)
