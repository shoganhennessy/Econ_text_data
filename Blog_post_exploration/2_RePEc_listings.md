The Ideas.RePEc Listings of Articles in Economics
================
Senan Hogan-Hennessy
21 Jan 2020

## WORK IN PROGRESS – to be finished this week

The NBER series is a great source of research in our profession, but it
isn’t the full picture of research in the field. It is, after all, a
listing of working papers which are by definition not yet publications –
though most do go on to be published, as I noted in the [last
post.](https://github.com/shoganhennessy/Econ_text_data/blob/master/Blog_post_exploration/1_NBER_working_papers.md)

Forunately, [Research Papers in Economics (RePEc)’s
Ideas](https://ideas.repec.org/) provides a large listing of economics
research which I can use as a complement to the NBER listings as it
lists information on 57532 economists and 423024 published articles
papers – considering only those in English as of 9 January 2020.

> ‘’IDEAS is the largest bibliographic database dedicated to Economics
> and available freely on the Internet. Based on RePEc, it indexes over
> 3,000,000 items of research, including over 2,700,000 that can be
> downloaded in full text.’’
> 
> – What is IDEAS? [Ideas.RePEc.org/](https://ideas.repec.org/)

423024 is a huge number of articles to consider, and comparable in size
to articles that use the near complete set of publcations.(\[^1\]:
[Angrist et al. 2015](https://www.nber.org/papers/w23698) link Econlit
and Web of Science for similar coverage, for example.) RePEc has certain
advantages: it is more open and it has a clear link to authors – and
importantly some of their characteristics – to working and published
papers, all within the field of ecoomics. It is however, a repository
only within the economics sphere: citations are only counted among other
papers in the database, and not among the universe of publications.

``` r
# The most prolific articles, within these data
Articles.data %>% 
  select(author, title, publication_date, journal_title, citation_count) %>%
  arrange(-citation_count) %>% head(10) %>%
  knitr::kable(format = 'markdown')
```

| author                                                                                                                                                                                 | title                                                                              | publication\_date | journal\_title                        | citation\_count |
| :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :--------------------------------------------------------------------------------- | :---------------- | :------------------------------------ | --------------: |
| John C. Harsanyi                                                                                                                                                                       | Cardinal Welfare, Individualistic Ethics, and Interpersonal Comparisons of Utility | 1955              | Journal of Political Economy          |             473 |
| Diebold, Francis X.; Inoue, Atsushi                                                                                                                                                    | Long memory and regime switching                                                   | 2001              | Journal of Econometrics               |             472 |
| Lucas, Robert E, Jr                                                                                                                                                                    | Supply-Side Economics: An Analytical Review                                        | 1990              | Oxford Economic Papers                |             472 |
| Ben S. Bernanke; Mark Gertler; Mark Watson                                                                                                                                             | Systematic Monetary Policy and the Effects of Oil Price Shocks                     | 1997              | Brookings Papers on Economic Activity |             471 |
| David Neumark                                                                                                                                                                          | Employers’ Discriminatory Behavior and the Estimation of Wage Discrimination       | 1988              | Journal of Human Resources            |             471 |
| Thomas A. Lubik; Frank Schorfheide                                                                                                                                                     | Testing for Indeterminacy: An Application to U.S. Monetary Policy                  | 2004              | American Economic Review              |             470 |
| David Hirshleifer                                                                                                                                                                      | Investor Psychology and Asset Pricing                                              | 2001              | Journal of Finance                    |             470 |
| Arrow, Kenneth; Bolin, Bert; Costanza, Robert; Dasgupta, Partha; Folke, Carl; Holling, C.S.; Jansson, Bengt-Owe; Levin, Simon; MÃ¤ler, Karl-GÃ¶ran; Perrings, Charles; Pimentel, David | Economic growth, carrying capacity, and the environment                            | 1996              | Environment and Development Economics |             470 |
| French, Kenneth R.; Roll, Richard                                                                                                                                                      | Stock return variances : The arrival of information and the reaction of traders    | 1986              | Journal of Financial Economics        |             470 |
| Gary S. Becker; Robert J. Barro                                                                                                                                                        | A Reformulation of the Economic Theory of Fertility                                | 1988              | The Quarterly Journal of Economics    |             470 |

### The Top 5

Quote book (name?) about survey for economists : an article in the top 5
makes a career?

SHow how many articles in the top
10.

| journal\_title                         | mean\_citations | citation\_count |
| :------------------------------------- | --------------: | --------------: |
| American Economic Review               |             102 |          301170 |
| Journal of Political Economy           |             112 |          142942 |
| The Quarterly Journal of Economics     |             137 |          129378 |
| Econometrica                           |             103 |          129028 |
| Journal of Finance                     |             112 |           97935 |
| The Review of Economics and Statistics |              84 |           97737 |
| Economic Journal                       |              83 |           93447 |
| Journal of Financial Economics         |             107 |           92602 |
| Journal of Econometrics                |              84 |           89413 |
| Journal of Public Economics            |              73 |           88089 |

^ Test the correlation for an article in top 10 making a career.

^ Compare to people who make 6-10 : weak discontinuity, perhaps.

Draw maps of where they’re from and test a correlation: distance to
publication home institution and economist base. ^ Start of testing
locality or inclusion.

### Link to the NBER

opportunity link to NBER working paper and measure change from WP to
published article

**Next up:** Looking at inclusion in the *NBER family*.
