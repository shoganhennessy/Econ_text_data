The Ideas.RePEc Listings of Articles in Economics
================
Senan Hogan-Hennesssy
13 Jan 2020

## WORK IN PROGRESS – to be finished this week

The NBER series is a great source of research in our profession, but it
isn’t the full picture of research in the field. It is, after all, a
listing of working papers which are by definition not yet publications –
though most do go on to be published, as I noted in the [last
post.](https://github.com/shoganhennessy/Econ_text_data/blob/master/Blog_post_exploration/1_NBER_working_papers.md)

``` r
# Load the data on Economists
Economists.data <- fread('../Data/RePEc_data/Economists_data/Economists_repec_data.csv')
# Load the data on published articles
Articles.data <- fread('../Data/RePEc_data/Papers_data/Journal_articles_repec.csv')
# Load data on Journals, collected 09/01/2020
# https://ideas.repec.org/top/top.journals.all.html
Journals.data <- fread('../Data/RePEc_data/Journals_data/Journal_info_repec.csv')
```

Forunately, [Research Papers in Economics (RePEc)’s
Ideas](https://ideas.repec.org/) provides a large listing of economics
research which I can use as a complement to the NBER listings as it
lists information on 57532 economists and 425459 published articles
papers – considering only those in English as of 31 December 2019.

> ‘’IDEAS is the largest bibliographic database dedicated to Economics
> and available freely on the Internet. Based on RePEc, it indexes over
> 3,000,000 items of research, including over 2,700,000 that can be
> downloaded in full text.’’
> 
> – What is IDEAS? [Ideas.RePEc.org/](https://ideas.repec.org/)

425459 is a huge number of articles to consider, and as far as I can
gather, it is the largest set yet analysed – Hamermesh
([2007](https://www.nber.org/papers/w6761),
[2012](https://www.nber.org/papers/w18635)) consider only subsamples of
the top three journals for example. Lucky for us, computing power and
open access to research have advanced enough to allow analysis of a more
complete view of research in economics.

``` r
# Get the top Journal
top_journal <- Journals.data %>% 
  arrange(rank) %>% head(1) %>% pull(journal_title)
# Get the bottom Journal
bottom_journal <- Journals.data %>% 
  arrange(rank) %>% tail(1) %>% pull(journal_title)
```

The set is certainly much larger than the NBER listings, but it is so
far unclear whether it is representative of the universe of economics
publications. Similarly the universe of economics publications may turn
out not to be the target of these data: a simple scan of the journals
included in these data show some *not so important* publications (also
seen at the bottom of [this
table](https://ideas.repec.org/top/top.journals.all.html)). Perhaps
economics articles published in *The Quarterly Journal of Economics* are
worth keeping, yet those in *Journal of Nonparametric Statistics* are
worth taking out of the sample.

### The Top 5

Quote book (name?) about survey for economists : an article in the top 5
makes a career?

SHow how many articles in the top 10.

    ## # A tibble: 10 x 3
    ##     rank journal_title                          n
    ##    <int> <chr>                              <int>
    ##  1     1 The Quarterly Journal of Economics  1727
    ##  2     2 American Economic Review            6769
    ##  3     3 Journal of Political Economy        2391
    ##  4     4 Econometrica                        2433
    ##  5     5 Journal of Economic Literature       637
    ##  6     6 Journal of Financial Economics      1421
    ##  7     7 Review of Economic Studies          1876
    ##  8     8 Journal of Finance                  1654
    ##  9     9 Journal of Economic Growth           284
    ## 10    10 Journal of Monetary Economics       2188

^ Test the correlation for an article in top 10 making a career.

^ Compare to people who make 6-10 : weak discontinuity, perhaps.

Draw maps of where they’re from and test a correlation: distance to
publication home institution and economist base. ^ Start of testing
locality or inclusion.

### Link to the NBER

opportunity link to NBER working paper and measure change from WP to
published article

<span style="font-weight:bold">Next up:</span> Looking at inclusion in
the *NBER family*.
