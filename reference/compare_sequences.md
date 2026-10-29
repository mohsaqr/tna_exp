# Compare Sequences Between Groups

Performs comprehensive sequence comparison analysis between groups. All
patterns of the sequences (subsequences of specific length) are
extracted from all sequences in each group. The pattern frequencies are
compared between the groups using a permutation test. The reported
effect size is the difference between the observed test statistic (sum
of squared differences between the observed and expected counts) and the
mean value over the permutation samples divided by their standard
deviation times square root of the number of observations.

## Usage

``` r
compare_sequences(x, ...)

# Default S3 method
compare_sequences(
  x,
  group,
  sub,
  min_freq = 5L,
  test = TRUE,
  iter = 1000L,
  adjust = "bonferroni",
  actor = NULL,
  ...
)

# S3 method for class 'group_tna'
compare_sequences(
  x,
  sub,
  min_freq = 5L,
  test = TRUE,
  iter = 1000L,
  adjust = "bonferroni",
  actor = NULL,
  ...
)
```

## Arguments

- x:

  A `group_tna` object or a `data.frame` containing sequence data in
  wide format. A `group_tna` object with scaled edge weights is not
  resampled (an error of class `tna_error_scaling`).

- ...:

  Not used. A misspelled or unknown argument is an error.

- group:

  A `vector` indicating the group assignment of each row of the
  data/sequence. Must have the same length as the number of
  rows/sequences of `x`. Alternatively, a single `character` string
  giving the column name of the data that defines the group when `x` is
  a wide format `data.frame` or a `tna_data` object.

- sub:

  An `integer` vector of pattern lengths to analyze. The default is
  `2:5`.

- min_freq:

  An `integer` giving the minimum number of times that a specific
  pattern has to be observed in each group to be included in the
  analysis. The default is `5`.

- test:

  A `logical` value indicating whether to test the differences of
  pattern counts between the groups using a permutation test. The
  default is `TRUE`.

- iter:

  An `integer` giving the number of iterations for the permutation test.
  The default is `1000`.

- adjust:

  A `character` string naming the multiple comparison correction method
  (default: `"bonferroni"`). Supports all
  [stats::p.adjust](https://rdrr.io/r/stats/p.adjust.html) methods:
  `"holm"`, `"hochberg"`, `"hommel"`, `"bonferroni"`, `"BH"`, `"BY"`,
  `"fdr"`, `"none"`. The adjustment is carried out within sequences of
  the same length.

- actor:

  An optional actor identifier for sequences nested in actors: a
  `character` string naming a non-sequence column of the data, or a
  vector with one identifier per row/sequence of `x` (of the data the
  grouped model was built from, for a `group_tna` object). When given,
  the permutation test reassigns whole actors between the groups, and
  shuffles the sequences of actors present in several groups within the
  actor (Good, 2005). The default `NULL` permutes single sequences.

## Value

A `tna_sequence_comparison` object, which is a `data.frame` with columns
giving the names of the patterns, pattern frequencies, pattern
proportions (within patterns of the same length), effect sizes, and
p-values of the tests.

## See also

Model comparison functions
[`compare()`](https://sonsoles.me/tna/reference/compare.md),
[`compare.group_tna()`](https://sonsoles.me/tna/reference/compare.group_tna.md),
[`plot.tna_comparison()`](https://sonsoles.me/tna/reference/plot.tna_comparison.md),
[`plot.tna_sequence_comparison()`](https://sonsoles.me/tna/reference/plot.tna_sequence_comparison.md),
[`plot_compare()`](https://sonsoles.me/tna/reference/plot_compare.md),
[`plot_compare.group_tna()`](https://sonsoles.me/tna/reference/plot_compare.group_tna.md),
[`print.tna_comparison()`](https://sonsoles.me/tna/reference/print.tna_comparison.md),
[`print.tna_sequence_comparison()`](https://sonsoles.me/tna/reference/print.tna_sequence_comparison.md)

## Examples

``` r
# A small subset without the permutation test
idx <- c(1:100, 1001:1100)
group <- rep(c("High", "Low"), each = 100)
compare_sequences(group_regulation[idx, ], group, test = FALSE)
#>                                     pattern freq_High freq_Low   prop_High
#> 1                                     adapt        21       47 0.015283843
#> 2                                  cohesion       107       79 0.077874818
#> 3                                 consensus       360      305 0.262008734
#> 4                                coregulate        86      116 0.062590975
#> 5                                   discuss       207      208 0.150655022
#> 6                                   emotion       164      134 0.119359534
#> 7                                   monitor        69       75 0.050218341
#> 8                                      plan       324      328 0.235807860
#> 9                                 synthesis        36       36 0.026200873
#> 10                          adapt->cohesion         5       10 0.003924647
#> 11                         adapt->consensus        10       21 0.007849294
#> 18                      cohesion->consensus        55       37 0.043171115
#> 19                     cohesion->coregulate         9       15 0.007064364
#> 21                        cohesion->emotion        10        7 0.007849294
#> 23                           cohesion->plan        15        7 0.011773940
#> 26                     consensus->consensus        23       26 0.018053375
#> 27                    consensus->coregulate        49       60 0.038461538
#> 28                       consensus->discuss        86       38 0.067503925
#> 29                       consensus->emotion        30       17 0.023547881
#> 30                       consensus->monitor         7       19 0.005494505
#> 31                          consensus->plan       131      118 0.102825746
#> 35                    coregulate->consensus         7       19 0.005494505
#> 37                      coregulate->discuss         8       29 0.006279435
#> 38                      coregulate->emotion        22       16 0.017268446
#> 39                      coregulate->monitor        11        8 0.008634223
#> 40                         coregulate->plan        23       20 0.018053375
#> 43                        discuss->cohesion        11        7 0.008634223
#> 44                       discuss->consensus        74       34 0.058084772
#> 45                      discuss->coregulate        15       14 0.011773940
#> 46                         discuss->discuss        35       50 0.027472527
#> 47                         discuss->emotion        21       22 0.016483516
#> 50                       discuss->synthesis        29       32 0.022762951
#> 52                        emotion->cohesion        51       40 0.040031397
#> 53                       emotion->consensus        55       34 0.043171115
#> 55                         emotion->discuss        19        5 0.014913658
#> 56                         emotion->emotion         6       13 0.004709576
#> 58                            emotion->plan        15       17 0.011773940
#> 61                       monitor->consensus        15       12 0.011773940
#> 63                         monitor->discuss        19       31 0.014913658
#> 64                         monitor->emotion         6        5 0.004709576
#> 66                            monitor->plan        15       17 0.011773940
#> 69                           plan->cohesion         8        8 0.006279435
#> 70                          plan->consensus        86       83 0.067503925
#> 72                            plan->discuss        21       24 0.016483516
#> 73                            plan->emotion        56       34 0.043956044
#> 74                            plan->monitor        26       21 0.020408163
#> 75                               plan->plan        92      128 0.072213501
#> 77                         synthesis->adapt         7       12 0.005494505
#> 78                     synthesis->consensus        20       10 0.015698587
#> 110          cohesion->consensus->consensus         5        5 0.004258944
#> 112            cohesion->consensus->discuss        16        5 0.013628620
#> 115               cohesion->consensus->plan        20       14 0.017035775
#> 151              consensus->consensus->plan         7        7 0.005962521
#> 156          consensus->coregulate->discuss         5       18 0.004258944
#> 157          consensus->coregulate->emotion        12        9 0.010221465
#> 158          consensus->coregulate->monitor         7        5 0.005962521
#> 159             consensus->coregulate->plan        14        9 0.011925043
#> 162           consensus->discuss->consensus        29       10 0.024701874
#> 164             consensus->discuss->discuss        15        7 0.012776831
#> 165             consensus->discuss->emotion        10        6 0.008517888
#> 168           consensus->discuss->synthesis        15        5 0.012776831
#> 171           consensus->emotion->consensus         9        6 0.007666099
#> 182              consensus->plan->consensus        34       30 0.028960818
#> 184                consensus->plan->discuss         7       11 0.005962521
#> 185                consensus->plan->emotion        23       15 0.019591141
#> 186                consensus->plan->monitor        10        8 0.008517888
#> 187                   consensus->plan->plan        42       43 0.035775128
#> 225             coregulate->plan->consensus         6        6 0.005110733
#> 251                discuss->consensus->plan        30       20 0.025553663
#> 260             discuss->discuss->consensus        13        7 0.011073254
#> 262               discuss->discuss->discuss         7       14 0.005962521
#> 267              discuss->emotion->cohesion         6        8 0.005110733
#> 281               discuss->synthesis->adapt         5       10 0.004258944
#> 282           discuss->synthesis->consensus        16        9 0.013628620
#> 289            emotion->cohesion->consensus        24       17 0.020442930
#> 297          emotion->consensus->coregulate        10        9 0.008517888
#> 301                emotion->consensus->plan        19       11 0.016183986
#> 324                     emotion->plan->plan         6       10 0.005110733
#> 339             monitor->discuss->consensus         7        5 0.005962521
#> 354                monitor->plan->consensus         5        5 0.004258944
#> 359                     monitor->plan->plan         6        7 0.005110733
#> 369             plan->consensus->coregulate        11       20 0.009369676
#> 370                plan->consensus->discuss        21       15 0.017887564
#> 371                plan->consensus->emotion         6        5 0.005110733
#> 373                   plan->consensus->plan        34       25 0.028960818
#> 388                 plan->emotion->cohesion        17       11 0.014480409
#> 389                plan->emotion->consensus        17       10 0.014480409
#> 394                     plan->emotion->plan         6        5 0.005110733
#> 402                     plan->monitor->plan         6        9 0.005110733
#> 405                   plan->plan->consensus        21       28 0.017887564
#> 407                     plan->plan->discuss         7       10 0.005962521
#> 408                     plan->plan->emotion        16       11 0.013628620
#> 409                     plan->plan->monitor         9        7 0.007666099
#> 410                        plan->plan->plan        20       52 0.017035775
#> 504         cohesion->consensus->plan->plan         8        6 0.007407407
#> 628     consensus->discuss->consensus->plan        13        8 0.012037037
#> 689  consensus->plan->consensus->coregulate         5        5 0.004629630
#> 690     consensus->plan->consensus->discuss         6        7 0.005555556
#> 693        consensus->plan->consensus->plan        12       10 0.011111111
#> 718        consensus->plan->plan->consensus         6        7 0.005555556
#> 723             consensus->plan->plan->plan         7       20 0.006481481
#> 869     discuss->consensus->plan->consensus         9        5 0.008333333
#> 874          discuss->consensus->plan->plan         8        9 0.007407407
#> 971      emotion->cohesion->consensus->plan         7        7 0.006481481
#> 1179       plan->consensus->plan->consensus         7        6 0.006481481
#> 1182         plan->consensus->plan->emotion         6        5 0.005555556
#> 1219     plan->emotion->cohesion->consensus        10        5 0.009259259
#> 1276            plan->plan->consensus->plan        11        7 0.010185185
#> 1303                 plan->plan->plan->plan         7       20 0.006481481
#>         prop_Low
#> 1    0.035391566
#> 2    0.059487952
#> 3    0.229668675
#> 4    0.087349398
#> 5    0.156626506
#> 6    0.100903614
#> 7    0.056475904
#> 8    0.246987952
#> 9    0.027108434
#> 10   0.008143322
#> 11   0.017100977
#> 18   0.030130293
#> 19   0.012214984
#> 21   0.005700326
#> 23   0.005700326
#> 26   0.021172638
#> 27   0.048859935
#> 28   0.030944625
#> 29   0.013843648
#> 30   0.015472313
#> 31   0.096091205
#> 35   0.015472313
#> 37   0.023615635
#> 38   0.013029316
#> 39   0.006514658
#> 40   0.016286645
#> 43   0.005700326
#> 44   0.027687296
#> 45   0.011400651
#> 46   0.040716612
#> 47   0.017915309
#> 50   0.026058632
#> 52   0.032573290
#> 53   0.027687296
#> 55   0.004071661
#> 56   0.010586319
#> 58   0.013843648
#> 61   0.009771987
#> 63   0.025244300
#> 64   0.004071661
#> 66   0.013843648
#> 69   0.006514658
#> 70   0.067589577
#> 72   0.019543974
#> 73   0.027687296
#> 74   0.017100977
#> 75   0.104234528
#> 77   0.009771987
#> 78   0.008143322
#> 110  0.004432624
#> 112  0.004432624
#> 115  0.012411348
#> 151  0.006205674
#> 156  0.015957447
#> 157  0.007978723
#> 158  0.004432624
#> 159  0.007978723
#> 162  0.008865248
#> 164  0.006205674
#> 165  0.005319149
#> 168  0.004432624
#> 171  0.005319149
#> 182  0.026595745
#> 184  0.009751773
#> 185  0.013297872
#> 186  0.007092199
#> 187  0.038120567
#> 225  0.005319149
#> 251  0.017730496
#> 260  0.006205674
#> 262  0.012411348
#> 267  0.007092199
#> 281  0.008865248
#> 282  0.007978723
#> 289  0.015070922
#> 297  0.007978723
#> 301  0.009751773
#> 324  0.008865248
#> 339  0.004432624
#> 354  0.004432624
#> 359  0.006205674
#> 369  0.017730496
#> 370  0.013297872
#> 371  0.004432624
#> 373  0.022163121
#> 388  0.009751773
#> 389  0.008865248
#> 394  0.004432624
#> 402  0.007978723
#> 405  0.024822695
#> 407  0.008865248
#> 408  0.009751773
#> 409  0.006205674
#> 410  0.046099291
#> 504  0.005808325
#> 628  0.007744434
#> 689  0.004840271
#> 690  0.006776379
#> 693  0.009680542
#> 718  0.006776379
#> 723  0.019361084
#> 869  0.004840271
#> 874  0.008712488
#> 971  0.006776379
#> 1179 0.005808325
#> 1182 0.004840271
#> 1219 0.004840271
#> 1276 0.006776379
#> 1303 0.019361084
# \donttest{
# Use a subset to keep the example fast.
idx <- c(1:500, 1001:1500)
group <- c(rep("High", 500), rep("Low", 500))
comp <- compare_sequences(group_regulation[idx, ], group)

# With permutation test (small number of iterations for CRAN)
comp_test <- compare_sequences(
  group_regulation[idx, ],
  group,
  test = TRUE,
  iter = 5
)
# }
```
