# Print `group_tna` Bootstrap Results

Print `group_tna` Bootstrap Results

## Usage

``` r
# S3 method for class 'group_tna_bootstrap'
print(x, ...)
```

## Arguments

- x:

  A `group_tna_bootstrap` object.

- ...:

  Arguments passed to
  [`print.tna_bootstrap()`](https://sonsoles.me/tna/reference/print.tna_bootstrap.md).

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
[`print.group_tna_permutation()`](https://sonsoles.me/tna/reference/print.group_tna_permutation.md),
[`print.group_tna_stability()`](https://sonsoles.me/tna/reference/print.group_tna_stability.md),
[`print.summary.group_tna_bootstrap()`](https://sonsoles.me/tna/reference/print.summary.group_tna_bootstrap.md),
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
print(boot)
#> Cluster 1 :
#> Non-significant Edges
#> 
#>         from         to     weight    p_value   cr_lower   cr_upper   ci_lower
#> 1 Disengaged Disengaged 0.68079470 0.09090909 0.51059603 0.85099338 0.66020651
#> 2    Engaged Disengaged 0.02027027 0.27272727 0.01520270 0.02533784 0.01532573
#> 3   Moderate Disengaged 0.12065157 0.09090909 0.09048868 0.15081447 0.11748627
#> 4 Disengaged    Engaged 0.15827815 0.09090909 0.11870861 0.19784768 0.14344544
#> 5    Engaged    Engaged 0.66164241 0.09090909 0.49623181 0.82705301 0.64284364
#> 6   Moderate    Engaged 0.12424075 0.09090909 0.09318056 0.15530094 0.12113453
#> 7 Disengaged   Moderate 0.16092715 0.09090909 0.12069536 0.20115894 0.14180725
#> 8    Engaged   Moderate 0.31808732 0.09090909 0.23856549 0.39760915 0.30656722
#> 9   Moderate   Moderate 0.75510768 0.09090909 0.56633076 0.94388459 0.74610017
#>     ci_upper
#> 1 0.70284018
#> 2 0.02650789
#> 3 0.13047399
#> 4 0.18049502
#> 5 0.67593044
#> 6 0.12983839
#> 7 0.17345482
#> 8 0.33880334
#> 9 0.76066688
#> 
#> Cluster 2 :
#> Non-significant Edges
#> 
#>         from         to      weight    p_value     cr_lower    cr_upper
#> 1 Disengaged Disengaged 0.911206588 0.09090909 0.6834049409 1.139008235
#> 2    Engaged Disengaged 0.308310992 0.09090909 0.2312332440 0.385388740
#> 3   Moderate Disengaged 0.118299445 0.09090909 0.0887245841 0.147874307
#> 4 Disengaged    Engaged 0.087719298 0.09090909 0.0657894737 0.109649123
#> 5    Engaged    Engaged 0.671581769 0.09090909 0.5036863271 0.839477212
#> 6   Moderate    Engaged 0.053604436 0.27272727 0.0402033272 0.067005545
#> 7 Disengaged   Moderate 0.001074114 0.63636364 0.0008055854 0.001342642
#> 8    Engaged   Moderate 0.020107239 0.36363636 0.0150804290 0.025134048
#> 9   Moderate   Moderate 0.828096118 0.09090909 0.6210720887 1.035120148
#>       ci_lower    ci_upper
#> 1 0.8987572352 0.917005289
#> 2 0.2766215038 0.326041660
#> 3 0.1010387856 0.133679122
#> 4 0.0822827588 0.099798509
#> 5 0.6562147905 0.703515611
#> 6 0.0453342813 0.073187379
#> 7 0.0007094443 0.001455275
#> 8 0.0144219257 0.024646508
#> 9 0.8006729260 0.848086057
#> 
#> Cluster 3 :
#> Non-significant Edges
#> 
#>         from         to     weight    p_value   cr_lower   cr_upper   ci_lower
#> 1 Disengaged Disengaged 0.87538657 0.09090909 0.65653993 1.09423322 0.87318179
#> 2    Engaged Disengaged 0.06246451 0.09090909 0.04684838 0.07808064 0.05673563
#> 3   Moderate Disengaged 0.18153446 0.09090909 0.13615085 0.22691808 0.17073225
#> 4 Disengaged    Engaged 0.11115154 0.09090909 0.08336365 0.13893942 0.10268898
#> 5    Engaged    Engaged 0.66524702 0.09090909 0.49893526 0.83155877 0.64670375
#> 6   Moderate    Engaged 0.14980494 0.09090909 0.11235371 0.18725618 0.13682158
#> 7 Disengaged   Moderate 0.01346189 0.09090909 0.01009642 0.01682736 0.01217643
#> 8    Engaged   Moderate 0.27228847 0.09090909 0.20421635 0.34036059 0.26651568
#> 9   Moderate   Moderate 0.66866060 0.09090909 0.50149545 0.83582575 0.65034486
#>     ci_upper
#> 1 0.88349715
#> 2 0.06384711
#> 3 0.19194436
#> 4 0.11241399
#> 5 0.67189170
#> 6 0.16002882
#> 7 0.01516645
#> 8 0.29147816
#> 9 0.68200453
#> 
```
