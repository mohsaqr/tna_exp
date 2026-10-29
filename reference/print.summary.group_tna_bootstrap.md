# Print a Bootstrap Summary for a Grouped Transition Network Model

Print a Bootstrap Summary for a Grouped Transition Network Model

## Usage

``` r
# S3 method for class 'summary.group_tna_bootstrap'
print(x, ...)
```

## Arguments

- x:

  A `summary.group_tna_bootstrap` object.

- ...:

  Arguments passed to the generic `print` method.

## Value

`x` (invisibly).

## See also

Validation functions
[`bootstrap()`](https://sonsoles.me/tna/reference/bootstrap.md),
[`deprune()`](https://sonsoles.me/tna/reference/deprune.md),
[`estimate_cs()`](https://sonsoles.me/tna/reference/estimate_centrality_stability.md),
[`markov_order()`](https://sonsoles.me/tna/reference/markov_order.md),
[`permutation_test()`](https://sonsoles.me/tna/reference/permutation_test.md),
[`permutation_test.group_tna()`](https://sonsoles.me/tna/reference/permutation_test.group_tna.md),
[`plot.group_tna_bootstrap()`](https://sonsoles.me/tna/reference/plot.group_tna_bootstrap.md),
[`plot.group_tna_permutation()`](https://sonsoles.me/tna/reference/plot.group_tna_permutation.md),
[`plot.group_tna_stability()`](https://sonsoles.me/tna/reference/plot.group_tna_stability.md),
[`plot.tna_bootstrap()`](https://sonsoles.me/tna/reference/plot.tna_bootstrap.md),
[`plot.tna_markov_order()`](https://sonsoles.me/tna/reference/plot.tna_markov_order.md),
[`plot.tna_permutation()`](https://sonsoles.me/tna/reference/plot.tna_permutation.md),
[`plot.tna_reliability()`](https://sonsoles.me/tna/reference/plot.tna_reliability.md),
[`plot.tna_stability()`](https://sonsoles.me/tna/reference/plot.tna_stability.md),
[`print.group_tna_bootstrap()`](https://sonsoles.me/tna/reference/print.group_tna_bootstrap.md),
[`print.group_tna_permutation()`](https://sonsoles.me/tna/reference/print.group_tna_permutation.md),
[`print.group_tna_stability()`](https://sonsoles.me/tna/reference/print.group_tna_stability.md),
[`print.summary.tna_bootstrap()`](https://sonsoles.me/tna/reference/print.summary.tna_bootstrap.md),
[`print.summary.tna_markov_order()`](https://sonsoles.me/tna/reference/print.summary.tna_markov_order.md),
[`print.tna_bootstrap()`](https://sonsoles.me/tna/reference/print.tna_bootstrap.md),
[`print.tna_clustering()`](https://sonsoles.me/tna/reference/print.tna_clustering.md),
[`print.tna_markov_order()`](https://sonsoles.me/tna/reference/print.tna_markov_order.md),
[`print.tna_permutation()`](https://sonsoles.me/tna/reference/print.tna_permutation.md),
[`print.tna_reliability()`](https://sonsoles.me/tna/reference/print.tna_reliability.md),
[`print.tna_stability()`](https://sonsoles.me/tna/reference/print.tna_stability.md),
[`prune()`](https://sonsoles.me/tna/reference/prune.md),
[`pruning_details()`](https://sonsoles.me/tna/reference/pruning_details.md),
[`reliability()`](https://sonsoles.me/tna/reference/reliability.md),
[`reprune()`](https://sonsoles.me/tna/reference/reprune.md),
[`summary.group_tna_bootstrap()`](https://sonsoles.me/tna/reference/summary.group_tna_bootstrap.md),
[`summary.tna_bootstrap()`](https://sonsoles.me/tna/reference/summary.tna_bootstrap.md),
[`summary.tna_markov_order()`](https://sonsoles.me/tna/reference/summary.tna_markov_order.md),
[`summary.tna_permutation()`](https://sonsoles.me/tna/reference/summary.tna_permutation.md),
[`summary.tna_stability()`](https://sonsoles.me/tna/reference/summary.tna_stability.md)

## Examples

``` r
model <- group_model(engagement_mmm)
# Low number of iteration for CRAN
boot <- bootstrap(model, iter = 10)
print(summary(boot))
#>        group       from         to      weight    p_value   sig     cr_lower
#> 1  Cluster 1 Disengaged Disengaged 0.680794702 0.09090909 FALSE 0.5105960265
#> 2  Cluster 1    Engaged Disengaged 0.020270270 0.18181818 FALSE 0.0152027027
#> 3  Cluster 1   Moderate Disengaged 0.120651574 0.09090909 FALSE 0.0904886803
#> 4  Cluster 1 Disengaged    Engaged 0.158278146 0.09090909 FALSE 0.1187086093
#> 5  Cluster 1    Engaged    Engaged 0.661642412 0.09090909 FALSE 0.4962318087
#> 6  Cluster 1   Moderate    Engaged 0.124240751 0.09090909 FALSE 0.0931805632
#> 7  Cluster 1 Disengaged   Moderate 0.160927152 0.09090909 FALSE 0.1206953642
#> 8  Cluster 1    Engaged   Moderate 0.318087318 0.09090909 FALSE 0.2385654886
#> 9  Cluster 1   Moderate   Moderate 0.755107675 0.09090909 FALSE 0.5663307565
#> 10 Cluster 2 Disengaged Disengaged 0.911206588 0.09090909 FALSE 0.6834049409
#> 11 Cluster 2    Engaged Disengaged 0.308310992 0.09090909 FALSE 0.2312332440
#> 12 Cluster 2   Moderate Disengaged 0.118299445 0.09090909 FALSE 0.0887245841
#> 13 Cluster 2 Disengaged    Engaged 0.087719298 0.09090909 FALSE 0.0657894737
#> 14 Cluster 2    Engaged    Engaged 0.671581769 0.09090909 FALSE 0.5036863271
#> 15 Cluster 2   Moderate    Engaged 0.053604436 0.27272727 FALSE 0.0402033272
#> 16 Cluster 2 Disengaged   Moderate 0.001074114 0.81818182 FALSE 0.0008055854
#> 17 Cluster 2    Engaged   Moderate 0.020107239 0.27272727 FALSE 0.0150804290
#> 18 Cluster 2   Moderate   Moderate 0.828096118 0.09090909 FALSE 0.6210720887
#> 19 Cluster 3 Disengaged Disengaged 0.875386574 0.09090909 FALSE 0.6565399309
#> 20 Cluster 3    Engaged Disengaged 0.062464509 0.09090909 FALSE 0.0468483816
#> 21 Cluster 3   Moderate Disengaged 0.181534460 0.09090909 FALSE 0.1361508453
#> 22 Cluster 3 Disengaged    Engaged 0.111151537 0.09090909 FALSE 0.0833636529
#> 23 Cluster 3    Engaged    Engaged 0.665247019 0.09090909 FALSE 0.4989352641
#> 24 Cluster 3   Moderate    Engaged 0.149804941 0.09090909 FALSE 0.1123537061
#> 25 Cluster 3 Disengaged   Moderate 0.013461888 0.09090909 FALSE 0.0100964162
#> 26 Cluster 3    Engaged   Moderate 0.272288472 0.09090909 FALSE 0.2042163543
#> 27 Cluster 3   Moderate   Moderate 0.668660598 0.09090909 FALSE 0.5014954486
#>       cr_upper     ci_lower    ci_upper
#> 1  0.850993377 0.6693699728 0.695218717
#> 2  0.025337838 0.0185972397 0.026370984
#> 3  0.150814467 0.1123557911 0.126206650
#> 4  0.197847682 0.1417159475 0.164447621
#> 5  0.827053015 0.6519410044 0.671140072
#> 6  0.155300939 0.1159768573 0.132138250
#> 7  0.201158940 0.1571498000 0.173884031
#> 8  0.397609148 0.3084454133 0.323201581
#> 9  0.943884594 0.7514798939 0.771467232
#> 10 1.139008235 0.8982174107 0.915887108
#> 11 0.385388740 0.2949721974 0.346540255
#> 12 0.147874307 0.1119902926 0.139083566
#> 13 0.109649123 0.0832246456 0.100260577
#> 14 0.839477212 0.6358707648 0.686519837
#> 15 0.067005545 0.0372805074 0.063698138
#> 16 0.001342642 0.0003489381 0.001770833
#> 17 0.025134048 0.0143952582 0.028427839
#> 18 1.035120148 0.7993477344 0.839117226
#> 19 1.094233218 0.8655773181 0.882641205
#> 20 0.078080636 0.0569835585 0.066727188
#> 21 0.226918075 0.1732606485 0.194750151
#> 22 0.138939422 0.1024966994 0.119885026
#> 23 0.831558773 0.6448556203 0.683091179
#> 24 0.187256177 0.1430896712 0.160337612
#> 25 0.016827360 0.0110686955 0.015189053
#> 26 0.340360591 0.2552398305 0.289469866
#> 27 0.835825748 0.6563396307 0.675963428
```
