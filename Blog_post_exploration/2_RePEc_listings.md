The Ideas.RePEc Listings of Articles in Economics
================
Senan Hogan-Hennessy,
04 Feb 2020

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

### Inequality in Publication Citations

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

Economists aim for the top 5. READ OVER: Gibson, J, D L Anderson and J
Tressler (2017), “Citations or journal quality: Which is rewarded more
in the academic labor market?” Economic Inquiry 55(4): 1945–1965.
Hamermesh, D S (2018), “Citations in economics: Measurement, uses, and
impacts,” Journal of Economic Literature 56(1): 115–56.
<https://voxeu.org/article/publishing-and-promotion-economics-tyranny-top-five>
<https://www.nber.org/papers/w25093>

Top Five journals in economics: the American Economic Review,
Econometrica,the Journal of Political Economy,the Quarterly Journal of
Economics, and the Review of Economic Studies.

> Indeed, serious theoretical and empirical work should be conducted to
> understand this disease better and suggest possible treatments. The
> problem will probably require challenging techniques in applied
> mechanism design.
> 
> – [Top5itis, R Serrano (2018)](http://hdl.handle.net/10419/202594)

\-\> measure citations from making a top 5, and follow on. ^Note that
the graph or statistics on that LOOK like some causal identification of
the effect, which is not the case yet, so be careful to not use causal
language.

SHow how many articles in the top 10. The accepted top 5 is not the top
5 by total or mean citation count, documented previously in (Anauati et
al. 2018 NBER WP
25101).

| journal\_title                         | mean\_citations | total\_citations | total\_articles |
| :------------------------------------- | --------------: | ---------------: | --------------: |
| American Economic Review               |             102 |           301142 |            2954 |
| Journal of Political Economy           |             112 |           142477 |            1271 |
| The Quarterly Journal of Economics     |             137 |           129378 |             945 |
| Econometrica                           |             103 |           129028 |            1247 |
| The Review of Economics and Statistics |              84 |            97737 |            1169 |
| Journal of Finance                     |             112 |            97687 |             870 |
| Economic Journal                       |              83 |            93447 |            1132 |
| Journal of Financial Economics         |             107 |            92602 |             866 |
| Journal of Econometrics                |              84 |            89413 |            1068 |
| Journal of Public Economics            |              73 |            88089 |            1207 |

| rank | journal\_title                     | score | simple\_IF | recursive\_IF | discounted\_IF | recursive\_discounted\_IF | h\_index | Euclid |
| ---: | :--------------------------------- | ----: | ---------: | ------------: | -------------: | ------------------------: | -------: | -----: |
|    1 | The Quarterly Journal of Economics |  2.18 |          1 |             1 |              2 |                         1 |        3 |      4 |
|    2 | American Economic Review           |  2.99 |         10 |            14 |             12 |                        11 |        1 |      3 |
|    3 | Journal of Political Economy       |  3.04 |          3 |             2 |              6 |                         2 |        4 |      2 |
|    4 | Econometrica                       |  3.53 |          4 |             3 |              3 |                         3 |        2 |      1 |
|    5 | Journal of Economic Literature     |  5.92 |          2 |             5 |              1 |                         5 |       11 |     10 |
|    6 | Journal of Financial Economics     |  6.20 |          6 |             8 |              8 |                        14 |        6 |      7 |
|    7 | Review of Economic Studies         |  7.85 |          7 |             4 |              7 |                         7 |        7 |      6 |
|    8 | Journal of Finance                 |  9.65 |          9 |             7 |             14 |                        13 |        5 |      9 |
|    9 | Journal of Economic Growth         | 11.56 |          5 |             6 |              4 |                         8 |       45 |     33 |
|   10 | Journal of Monetary Economics      | 12.13 |         12 |            10 |             16 |                        20 |        8 |      8 |

Draw a line graph for author cumulative citations, years after first
publication. NOTE: attributing citations to year of publication and not
year in which a reader cites the previous work in a new publication
(which I will consider later in network effects).
<img src="2_RePEc_listings_files/figure-gfm/unnamed-chunk-7-1.png" style="display: block; margin: auto;" />

Draw a graph for author cumulative citations, years after first
publication in a top 5. Add a line for year after making a top 6-10
(weakly comparable).

NOTE: attributing citations to year of publication and not year in which
a reader cites the previous work in a new publication (which I will
consider later in network
effects).

#### Re-do as an event study :

<img src="2_RePEc_listings_files/figure-gfm/unnamed-chunk-8-1.png" style="display: block; margin: auto;" />\[1\]
3

### Conclusion:

Describe data set and opportunity to measure economics publication
*outcomes*.

**Next up:** Looking at inclusion in the *NBER family*.

-----

<b id="f1">1</b> [Angrist et al.
(2017)](https://www.nber.org/papers/w23698) link Econlit and Web of
Science for similar coverage, for example.[↩](#a1)

<b id="f2">2</b> Again, note that this citation count is not the same as
that in the universe of academic publications or Google Scholar, it is a
count of the citations within the RePEc listings so a measure of
citations within only this large coverage of the field.[↩](#a1)

-----

## References

1.  Angrist, Joshua, et al. Inside job or deep impact? Using extramural
    citations to assess economic scholarship. No. w23698. National
    Bureau of Economic Research, 2017.
2.  Serrano, Roberto. Top5itis. No. 2018-2. Working Paper, 2018.
