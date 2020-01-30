The Ideas.RePEc Listings of Articles in Economics
================
Senan Hogan-Hennessy,
30 Jan 2020

## WORK IN PROGRESS – to be finished soon.

The NBER series is a great source of research in our profession, but it
isn’t the full picture of research in the field. It is, after all, a
listing of working papers which are by definition not yet publications –
though most do go on to be published, as I noted in the [last
post.](https://github.com/shoganhennessy/Econ_text_data/blob/master/Blog_post_exploration/1_NBER_working_papers.md)

Forunately, [Research Papers in Economics (RePEc)’s
Ideas](https://ideas.repec.org/) provides a large listing of economics
research which I can use as a complement to the NBER listings as it
lists information on 57532 economists and 421348 published articles
papers – considering only those in English as of 9 January 2020.

> ‘’IDEAS is the largest bibliographic database dedicated to Economics
> and available freely on the Internet. Based on RePEc, it indexes over
> 3,000,000 items of research, including over 2,700,000 that can be
> downloaded in full text.’’
> 
> – What is IDEAS? [Ideas.RePEc.org/](https://ideas.repec.org/)

421348 is a huge number of articles to consider, and comparable in size
to articles that use the near complete set of
publcations.<sup id="a1">[1](#f1)</sup> RePEc has certain advantages: it
is more open and it has a clear link to authors – and importantly some
of their characteristics – to working and published papers, all within
the field of economics. It is however, a repository only within the
economics sphere: citations are only counted among other papers in the
database, and not among the universe of publications.

### Citations

For a sanity check, take a look at the most prolific authors in the
field by citation
count.<sup id="a1">[2](#f2)</sup>

| author\_name                  | total\_citations | mean\_citations | total\_articles |
| :---------------------------- | ---------------: | --------------: | --------------: |
| Andrei Shleifer               |            13816 |             150 |              92 |
| James J. Heckman              |            12845 |             130 |              99 |
| Daron Acemoglu                |            12007 |             111 |             108 |
| Jean Tirole                   |            11602 |             130 |              89 |
| Joseph E. Stiglitz            |            11070 |             101 |             110 |
| René M. Stulz (Rene M. Stulz) |             9884 |             145 |              68 |
| John List                     |             8559 |              93 |              92 |
| John Y. Campbell              |             8423 |             153 |              55 |
| David E. Card                 |             8159 |             138 |              59 |
| Asli Demirguc-Kunt            |             8150 |             143 |              57 |

There are some familiar faces among the names, which is to be expected\!
The process of assigning is, however, not perfect: citations are
assigned from each article to each author equally when there are
multiple authors. Yet [Sarsons
(2017)](https://www.aeaweb.org/articles?id=10.1257/aer.p20171126) shows
how innapropriate this accounting is by exhibiting the unequal citation
rate of return in among economists by gender – which actually inspired
me to work with economics publishing data in the first place\! Call it a
point of interest to rank economists by better measures as this project
progresses.

### Inequality in Publications

Draw a Gini coefficient for citations among articles.

``` r
# Gini coefficient for article citations.
Articles.data %>% 
  filter(!is.na(citation_count)) %>%
  pull(citation_count) %>% reldist::gini()
```

    ## [1] 0.3995052

Histogram of citations for different periods

``` r
# Gini coefficient for article citations.
Articles.data %>% 
  filter(!is.na(citation_count)) %>%
  ggplot(aes(x = citation_count)) + 
  geom_histogram(binwidth = 1)
```

<img src="2_RePEc_listings_files/figure-gfm/unnamed-chunk-4-1.png" style="display: block; margin: auto;" />

``` r
# Per year summarise 
Citation_count.data <- Articles.data %>% 
  filter(!is.na(citation_count) & !is.na(publication_date)) %>%
  group_by(publication_date) %>%
  summarise(total_citations = sum(citation_count, na.rm = T),
            mean_citations = round(mean(citation_count, na.rm = T)),
            total_articles = n(),
            gini_coefficient = reldist::gini(citation_count)) 

# Gini coefficient for article citations.
Citation_count.data %>%
  filter(total_articles > 100) %>%
  ggplot(aes(x = publication_date, y = gini_coefficient)) +
  geom_line() +
  scale_x_continuous(name = 'Year Published', breaks = seq(1975, 2020, by = 5)) +
  scale_y_continuous(name = 'Citations Gini Index (among articles)',
                     breaks = seq(0, 0.5, by = 0.1), limits = c(0,0.5))
```

<img src="2_RePEc_listings_files/figure-gfm/unnamed-chunk-4-2.png" style="display: block; margin: auto;" />

^ Draw a coefficient for the earlier period vs later period : larger
field, more economists, but is it more top loaded now than before?
Perhaps less so now?

Draw a Gini coefficient for citations among authors per year.

Note: if going with the Gini index, then perhaps this should be
collapsing a cumulative count of citations per year among authors – or
at least consider that idea as collecting ‘wealth’ of citations.

``` r
# Gini coefficient for authors.
Economists_articles.links %>% 
  left_join(select(Economists.data, url, name, 
                   institution, affiliation, degree,) %>% 
              rename(author_name = name, author_url = url), by = 'author_url') %>%
  left_join(rename(Articles.data, article_url = url), by = 'article_url') %>%
  select(author_name, institution, affiliation, degree, 
         title, publication_date, journal_title, citation_count) %>%
  filter(!is.na(citation_count)) %>%
  group_by(author_name, publication_date) %>%
  summarise(total_citations = sum(citation_count, na.rm = T)) %>%
  group_by(publication_date) %>%
  summarise(gini_coefficient = reldist::gini(total_citations)) %>%
  filter(publication_date > 1975) %>%
  ggplot(aes(x = publication_date, y = gini_coefficient)) +
  geom_line() +
  scale_x_continuous(name = 'Year Published', breaks = seq(1975, 2020, by = 5)) +
  scale_y_continuous(name = 'Citations Gini Index (among authors)',
                     breaks = seq(0, 0.5, by = 0.1), limits = c(0,0.5))
```

<img src="2_RePEc_listings_files/figure-gfm/unnamed-chunk-5-1.png" style="display: block; margin: auto;" />

Think about whether sharing of publications/work over the internet leads
to more or less inequality -\> perhaps a better question for the
upcoming network analyses.

### The Top 5

Economists aim for the top 5

\-\> measure citations from making a top 5, and follow on. ^Note that
the graph or statistics on that LOOK like some causal identification of
the effect, which is not what is to be visualised.

Quote book (name?) about survey for economists : an article in the top 5
makes a career and/or tenure.

SHow how many articles in the top
10.

| journal\_title                         | mean\_citations | citation\_count |
| :------------------------------------- | --------------: | --------------: |
| The Quarterly Journal of Economics     |             137 |          129378 |
| Journal of Political Economy           |             112 |          142477 |
| Journal of Finance                     |             112 |           97687 |
| Journal of Financial Economics         |             107 |           92602 |
| Econometrica                           |             103 |          129028 |
| American Economic Review               |             102 |          301142 |
| The Review of Economics and Statistics |              84 |           97737 |
| Journal of Econometrics                |              84 |           89413 |
| Economic Journal                       |              83 |           93447 |
| Journal of Public Economics            |              73 |           88089 |

^ Test the correlation for an article in top 10 making a career.

^ Compare to people who make 6-10 : weakly comparable, perhaps, so note
the thoughts.

### Link to the NBER

Draw maps of where they’re from and test a correlation: distance to
publication home institution and economist base. ^ Start of testing
locality or inclusion.

Further opportunity link to NBER working paper and measure change from
WP to published article

**Next up:** Looking at inclusion in the *NBER family*.

-----

<b id="f1">1</b> [Angrist et al.
(2017)](https://www.nber.org/papers/w23698) link Econlit and Web of
Science for similar coverage, for example.[↩](#a1)

<b id="f2">2</b> Again, note that this citation count is not the same as
that in the universe of academic publications or Google Scholar, it is a
count of the citations within the RePEc listings so a measure of
citations within only this large coverage of the field.[↩](#a1)
