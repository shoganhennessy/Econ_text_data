#
# Senan Hogan-H. 13/07/2020
#

# Python script that to put together appointment data 
# and economists with citations in year made
###### Packages to use
import pandas as pd
import numpy as np
from gtabview import view
import random
random.seed(47)


########################################################################
## Load data sources
# Load NBER economists
Economists_nber_data = pd.read_csv('Data/NBER_data/Authors_data/Authors_data_new.csv')
# Load NBER appointment
Appointment_nber_data = pd.read_csv('Data/NBER_data/Appointment_data/Appointment_data.csv')
# Load economists in RePEc
Economists_repec_data = pd.read_csv('Data/RePEc_data/Economists_data/Economists_repec_data.csv', low_memory=False)
Economists_repec_data.rename(columns =
	{'name':'name_repec', 'url':'url_repec'}, inplace = True)
# Load articles in RePEc
Articles_repec_data = pd.read_csv('Data/RePEc_data/Papers_data/Journal_articles_repec.csv', low_memory=False)
# Load individual key for economists and their RePec articles
Economists_papers_data = pd.read_csv('Data/RePEc_data/Economists_data/Economists_articles_repec.csv')


#########################################################################
## Reshape citation info
# Count citations in year made
articleUrlList = Articles_repec_data['url'].tolist()
articleYearList = Articles_repec_data['publication_date'].tolist()
referenceList = Articles_repec_data['reference_indicies'].tolist()
articleRefDict = {articleUrlList[i] : 
	[articleYearList[i], referenceList[i].split('; ')]
	for i in range(0,len(articleUrlList))
	if not isinstance(referenceList[i], float)}
# form a 1 <->1 list
articleRefList = []
for articleUrl in list(articleRefDict.keys()) :
	for refUrl in articleRefDict[articleUrl][1] :
		articleRefList.append([articleUrl,
			articleRefDict[articleUrl][0], refUrl])
# Put to a data frame
articleRefData = pd.DataFrame(articleRefList, 
	columns=['article_url', 'ref_year', 'ref_url'])
# Summarise the years of references made
articleRefData['ref_count'] = 1
articleRefData = articleRefData.groupby(
	['ref_url','ref_year']).agg({'ref_count': 'sum'}).reset_index()
# Add to the economists' key
articleRefData = Economists_papers_data.merge(articleRefData,
	how = 'right', left_on = 'article_url', right_on = 'ref_url')
# Collapse to the years of citations made for each author
authorRefData = articleRefData.groupby(
	['author_url','ref_year']).agg({'ref_count' : 'sum'}).reset_index()


#########################################################################
## Merge appointment data to economists data
# collapse appointment to first date
Appointment_nber_data['name_nber'] = Appointment_nber_data['author_name']
Appointment_nber_data['appt_rank_nber'] = Appointment_nber_data['appt_rank']
Appointment_nber_data['appt_date_nber'] = pd.to_datetime(
	Appointment_nber_data['appt_date'])
Appointment_nber_data = Appointment_nber_data.groupby(
	['name_nber', 'appt_rank_nber', 'author_link']).agg(
		{'appt_date_nber' : 'min'}).reset_index()
# Add on repec provided link
Economists_nber_data['author_link'] = [url.replace(
	'https://www.nber.org','') for url in
	Economists_nber_data['url'].tolist()]
Economists_nber_data['index_repec'] = [url.replace('.htm', '').
	replace('http://econpapers.repec.org/RAS/', '')
	for url in Economists_nber_data['repec_link'].fillna('').tolist()]
Appointment_nber_data = Economists_nber_data[['author_link', 'index_repec']
	].merge(Appointment_nber_data, how = 'right', on = 'author_link')
# merge nber appointment to repec data
Economists_repec_data['index_repec'] = [url.replace('.html', '').
	replace('https://ideas.repec.org/', '').replace('f/', '').replace('e/', '')
	for url in Economists_repec_data['url_repec'].fillna('').tolist()]
Appointment_repec_data = Appointment_nber_data[
	['index_repec', 'appt_rank_nber', 'appt_date_nber']].merge(
	Economists_repec_data, how = 'right', on = 'index_repec')


#########################################################################
## Put together citations and appointment
authorRefData['index_repec'] = [url.replace('.html', '').
	replace('https://ideas.repec.org/', '').replace('f/', '').replace('e/', '')
	for url in authorRefData['author_url'].fillna('').tolist()]
Appointment_repec_data = Appointment_repec_data.merge(
	authorRefData, how = 'right', on = 'index_repec')
# subset to relevant columns
Appointment_repec_data = Appointment_repec_data[
	['index_repec', 'appt_rank_nber', 'appt_date_nber',
	'name_repec', 'degree', 'ref_year', 'ref_count']]

# Save file for post analysis.
Appointment_repec_data = Appointment_repec_data.sort_values(by = ['index_repec', 'ref_year'])
Appointment_repec_data.to_csv('Data/RePEc_data/Economists_data/Appointment_ref_repec.csv', index = False)


view(Appointment_repec_data[pd.notnull(Appointment_repec_data['appt_rank_nber'])])
