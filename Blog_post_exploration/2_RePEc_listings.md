The Ideas.RePEc Listings of Articles in Economics
================
Senan Hogan-Hennesssy
13 Jan 2020

## WORK IN PROGRESS – to be finished this week

The NBER series is a great source of research in our profession, but it
isn’t the full picture of research in the field. It is, after all, a
listing of working papers which are by definition not yet publications –
though most do go on to be published, as I noted in the [last
post.](http://htmlpreview.github.io/?https://github.com/shoganhennessy/Econ_text_data/blob/master/Blog_post_exploration/1_NBER_working_papers.html)

Forunately, [Research Papers in Economics (RePEc)’s
Ideas](https://ideas.repec.org/) provides a large listing of economics
research which I can use as a complement to the NBER listings.

> ‘’IDEAS is the largest bibliographic database dedicated to Economics
> and available freely on the Internet. Based on RePEc, it indexes over
> 3,000,000 items of research, including over 2,700,000 that can be
> downloaded in full text.’’
> 
> – What is IDEAS? [Ideas.RePEc.org/](https://ideas.repec.org/)

``` r
# Load the data on Economists
Economists.data <- fread('../Data/RePEc_data/Economists_data/Economists_repec_data.csv')
# Load the data on published articles
Articles.data <- fread('../Data/RePEc_data/Papers_data/Journal_articles_repec.csv')
# Load data on Journals, collected 09/01/2020
# https://ideas.repec.org/top/top.journals.all.html
Journals.data <- fread('../Data/RePEc_data/Journals_data/Journal_info_repec.csv')
```

RePEc lists information on 57532 economists and 425459 published
articles papers – considering only those in English as of 31 December
2019.

### Published Articles

425459 is a huge number of articles to consider, and as far as I can
gather, it is the largest set yet analysed – Hamermesh
([2007](https://www.nber.org/papers/w6761),
[2012](https://www.nber.org/papers/w18635)) consider only subsamples for
example. Lucky for us, computing power and open access to information on
published research have advanced enough to allow analyse of a more
complete set of the data.

``` r
# Get the top Journal
top_journal <- Journals.data %>% 
  arrange(rank) %>% head(1) %>% pull(journal_title)
# Get the bottom Journal
bottom_journal <- Journals.data %>% 
  arrange(rank) %>% tail(1) %>% pull(journal_title)

# SUbset to the top 200 journals
Journals.data <- Journals.data %>% head(200)
```

The set is certainly much larger than te NBER listings, but it is so far
unclear whether it is representative of the universe of economics
publications. Similarly the universe of economics publications may turn
out not to be the target of these data: a simple scan of the journals
included in these data show some *not so important* publications (also
seen at the bottom of [this
table](https://ideas.repec.org/top/top.journals.all.html)). Perhaps
economics articles published in *The Quarterly Journal of Economics* are
worth keeping, yet those in *Journal of Nonparametric Statistics* are
worth taking out of the sample. SO for convenience, I’m subsetting to
the top 200 journals.

So who are the most problific authors, by article count?

…

Most profilific publications? // Compared to the ranking listing.

…

### Economists

Describe set of data on economists, including PhD attendence. note: most
entries are empty, however.

opportunity link to NBER working paper and measure change from WP to
published article