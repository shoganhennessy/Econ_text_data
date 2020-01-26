The Ideas.RePEc Listings of Articles in Economics
================
Senan Hogan-Hennessy,
26 Jan 2020

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

For sanity, take a look at the most prolific authors in the field by
citation
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
(2017)](https://www.aeaweb.org/articles?id=10.1257/aer.p20171126) show
how innapropriate this accounting is by exhibiting the unequal citation
rate of return in among economists by gender – which actually inspired
me to work with economics publishing data in the first place\! Call it a
point of interest to rank economists by better measures, as this project
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
# Per year
# Gini coefficient for article citations.
Articles.data %>% 
  filter(!is.na(citation_count)) %>%
  group_by(publication_date) %>%
  summarise(total_citations = sum(citation_count, na.rm = T),
            mean_citations = round(mean(citation_count, na.rm = T)),
            total_articles = n(),
            gini_coefficient = reldist::gini(citation_count)) %>%
  knitr::kable(format = 'markdown')
```

| publication\_date | total\_citations | mean\_citations | total\_articles | gini\_coefficient |
| ----------------: | ---------------: | --------------: | --------------: | ----------------: |
|              1937 |              229 |             229 |               1 |         0.0000000 |
|              1939 |               45 |              45 |               1 |         0.0000000 |
|              1941 |              291 |             146 |               2 |         0.4106529 |
|              1942 |               49 |              49 |               1 |         0.0000000 |
|              1943 |               29 |              29 |               1 |         0.0000000 |
|              1945 |               29 |              29 |               1 |         0.0000000 |
|              1947 |               48 |              48 |               1 |         0.0000000 |
|              1949 |               31 |              31 |               1 |         0.0000000 |
|              1950 |              376 |              94 |               4 |         0.2473404 |
|              1951 |              296 |             296 |               1 |         0.0000000 |
|              1952 |              730 |             182 |               4 |         0.3856164 |
|              1953 |              315 |             105 |               3 |         0.3513228 |
|              1954 |              614 |             154 |               4 |         0.5089577 |
|              1955 |              714 |             143 |               5 |         0.5445378 |
|              1956 |              652 |             163 |               4 |         0.3796012 |
|              1957 |              105 |              35 |               3 |         0.0825397 |
|              1958 |              651 |              93 |               7 |         0.3585692 |
|              1959 |              255 |              64 |               4 |         0.2401961 |
|              1960 |              262 |              87 |               3 |         0.3587786 |
|              1961 |              320 |              64 |               5 |         0.2787500 |
|              1962 |             1312 |             131 |              10 |         0.4268293 |
|              1963 |              945 |              86 |              11 |         0.3717172 |
|              1964 |              282 |             141 |               2 |         0.1666667 |
|              1965 |              744 |              93 |               8 |         0.4401882 |
|              1966 |              357 |              51 |               7 |         0.3209284 |
|              1967 |             1335 |              83 |              16 |         0.4096910 |
|              1968 |             1579 |             113 |              14 |         0.5148376 |
|              1969 |             4267 |              95 |              45 |         0.4334245 |
|              1970 |             4544 |              78 |              58 |         0.3851384 |
|              1971 |             5533 |             101 |              55 |         0.4840708 |
|              1972 |             6785 |              81 |              84 |         0.4029880 |
|              1973 |             6648 |              78 |              85 |         0.4296524 |
|              1974 |            11981 |              98 |             122 |         0.4570303 |
|              1975 |             8634 |              82 |             105 |         0.4227605 |
|              1976 |            11517 |              84 |             137 |         0.3916445 |
|              1977 |            12149 |              93 |             130 |         0.4262592 |
|              1978 |            14954 |              90 |             167 |         0.4212743 |
|              1979 |            19015 |              87 |             219 |         0.4399334 |
|              1980 |            20615 |              84 |             246 |         0.4153068 |
|              1981 |            23224 |              98 |             238 |         0.4445611 |
|              1982 |            26234 |              90 |             292 |         0.4365549 |
|              1983 |            27162 |              87 |             311 |         0.4140488 |
|              1984 |            27906 |              82 |             341 |         0.4121383 |
|              1985 |            35836 |              87 |             411 |         0.4216884 |
|              1986 |            43838 |              98 |             447 |         0.4425449 |
|              1987 |            42841 |              85 |             504 |         0.4322151 |
|              1988 |            45952 |              83 |             556 |         0.4120794 |
|              1989 |            50599 |              89 |             569 |         0.4246348 |
|              1990 |            63864 |              92 |             691 |         0.4389281 |
|              1991 |            65399 |              89 |             737 |         0.4185786 |
|              1992 |            70368 |              91 |             772 |         0.4209525 |
|              1993 |            76640 |              86 |             889 |         0.4084598 |
|              1994 |            84377 |              90 |             939 |         0.4221472 |
|              1995 |            95793 |              91 |            1053 |         0.4375297 |
|              1996 |           109057 |              91 |            1198 |         0.4213415 |
|              1997 |           108091 |              82 |            1312 |         0.4142832 |
|              1998 |           115350 |              81 |            1427 |         0.4097947 |
|              1999 |           123831 |              80 |            1550 |         0.4024297 |
|              2000 |           135398 |              81 |            1670 |         0.4075189 |
|              2001 |           149518 |              80 |            1866 |         0.4228098 |
|              2002 |           163913 |              81 |            2030 |         0.4052854 |
|              2003 |           177205 |              78 |            2275 |         0.4104583 |
|              2004 |           183334 |              77 |            2387 |         0.4014621 |
|              2005 |           190642 |              75 |            2544 |         0.3959197 |
|              2006 |           187527 |              70 |            2682 |         0.3749441 |
|              2007 |           194632 |              71 |            2751 |         0.3822542 |
|              2008 |           200528 |              68 |            2942 |         0.3765613 |
|              2009 |           181445 |              66 |            2763 |         0.3614854 |
|              2010 |           172439 |              62 |            2785 |         0.3513305 |
|              2011 |           141404 |              62 |            2284 |         0.3539024 |
|              2012 |           132027 |              59 |            2230 |         0.3471395 |
|              2013 |           114863 |              56 |            2041 |         0.3313296 |
|              2014 |            83097 |              53 |            1556 |         0.3176567 |
|              2015 |            55073 |              50 |            1099 |         0.2919622 |
|              2016 |            33458 |              48 |             692 |         0.2691331 |
|              2017 |            16599 |              47 |             354 |         0.2744361 |
|              2018 |             8341 |              47 |             179 |         0.2790992 |
|              2019 |             3878 |              48 |              80 |         0.2949394 |
|                NA |             1303 |              57 |              23 |         0.3209984 |

^ Draw a coefficient for the earlier period vs later period : larger
field, more economists, but is it more top loaded now than before?

Draw a Gini coefficient for citations among authors.

``` r
# Gini coefficient for article citations.
Economists_articles.links %>% 
  left_join(select(Economists.data, url, name, degree) %>% 
              rename(author_name = name, author_url = url), by = 'author_url') %>%
  left_join(rename(Articles.data, article_url = url), by = 'article_url') %>%
  select(author_name, degree, title, publication_date, journal_title, citation_count) %>%
  filter(!is.na(citation_count)) %>%
  group_by(author_name) %>%
  summarise(total_citations = sum(citation_count, na.rm = T)) %>%
  pull(total_citations) %>% reldist::gini()
```

    ## [1] 0.6717785

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
