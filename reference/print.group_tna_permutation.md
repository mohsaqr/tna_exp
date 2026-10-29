# Print Permutation Test Results

Print Permutation Test Results

## Usage

``` r
# S3 method for class 'group_tna_permutation'
print(x, ...)
```

## Arguments

- x:

  A `group_tna_permutation` object.

- ...:

  Arguments passed to
  [`print.tna_permutation()`](https://sonsoles.me/tna/reference/print.tna_permutation.md).

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
# Small number of iterations for CRAN
perm <- permutation_test(model, iter = 20)
print(perm)
#> Cluster 1 vs. Cluster 2 :
#> # A tibble: 9 × 4
#>   edge_name                diff_true effect_size p_value
#>   <chr>                        <dbl>       <dbl>   <dbl>
#> 1 Disengaged -> Disengaged  -0.230       -14.9    0.0476
#> 2 Engaged -> Disengaged     -0.288       -16.9    0.0476
#> 3 Moderate -> Disengaged     0.00235       0.190  0.810 
#> 4 Disengaged -> Engaged      0.0706        7.42   0.0476
#> 5 Engaged -> Engaged        -0.00994      -0.725  0.524 
#> 6 Moderate -> Engaged        0.0706        7.37   0.0476
#> 7 Disengaged -> Moderate     0.160        17.8    0.0476
#> 8 Engaged -> Moderate        0.298        24.3    0.0476
#> 9 Moderate -> Moderate      -0.0730       -5.69   0.0476
#> 
#> Cluster 1 vs. Cluster 3 :
#> # A tibble: 9 × 4
#>   edge_name                diff_true effect_size p_value
#>   <chr>                        <dbl>       <dbl>   <dbl>
#> 1 Disengaged -> Disengaged  -0.195       -17.3    0.0476
#> 2 Engaged -> Disengaged     -0.0422       -5.89   0.0476
#> 3 Moderate -> Disengaged    -0.0609       -6.91   0.0476
#> 4 Disengaged -> Engaged      0.0471        5.43   0.0476
#> 5 Engaged -> Engaged        -0.00360      -0.246  0.810 
#> 6 Moderate -> Engaged       -0.0256       -3.55   0.0476
#> 7 Disengaged -> Moderate     0.147        24.2    0.0476
#> 8 Engaged -> Moderate        0.0458        3.72   0.0476
#> 9 Moderate -> Moderate       0.0864        8.20   0.0476
#> 
#> Cluster 2 vs. Cluster 3 :
#> # A tibble: 9 × 4
#>   edge_name                diff_true effect_size p_value
#>   <chr>                        <dbl>       <dbl>   <dbl>
#> 1 Disengaged -> Disengaged   0.0358        5.50   0.0476
#> 2 Engaged -> Disengaged      0.246        17.1    0.0476
#> 3 Moderate -> Disengaged    -0.0632       -5.75   0.0476
#> 4 Disengaged -> Engaged     -0.0234       -4.06   0.0476
#> 5 Engaged -> Engaged         0.00633       0.414  0.714 
#> 6 Moderate -> Engaged       -0.0962       -8.81   0.0476
#> 7 Disengaged -> Moderate    -0.0124       -5.04   0.0476
#> 8 Engaged -> Moderate       -0.252       -13.8    0.0476
#> 9 Moderate -> Moderate       0.159        11.4    0.0476
#> 
```
