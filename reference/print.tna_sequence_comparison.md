# Print a Comparison of Sequences

Print a Comparison of Sequences

## Usage

``` r
# S3 method for class 'tna_sequence_comparison'
print(x, ...)
```

## Arguments

- x:

  A `tna_sequence_comparison` object.

- ...:

  Arguments passed to the generic `print` method.

## Value

`x` (invisibly).

## See also

Model comparison functions
[`compare()`](https://sonsoles.me/tna/reference/compare.md),
[`compare.group_tna()`](https://sonsoles.me/tna/reference/compare.group_tna.md),
[`compare_sequences()`](https://sonsoles.me/tna/reference/compare_sequences.md),
[`plot.tna_comparison()`](https://sonsoles.me/tna/reference/plot.tna_comparison.md),
[`plot.tna_sequence_comparison()`](https://sonsoles.me/tna/reference/plot.tna_sequence_comparison.md),
[`plot_compare()`](https://sonsoles.me/tna/reference/plot_compare.md),
[`plot_compare.group_tna()`](https://sonsoles.me/tna/reference/plot_compare.group_tna.md),
[`print.tna_comparison()`](https://sonsoles.me/tna/reference/print.tna_comparison.md)

## Examples

``` r
# A small subset without the permutation test
idx <- c(1:100, 1001:1100)
group <- rep(c("High", "Low"), each = 100)
comp <- compare_sequences(group_regulation[idx, ], group, test = FALSE)
print(comp)
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
idx <- c(1:500, 1001:1500)
group <- c(rep("High", 500), rep("Low", 500))
comp <- compare_sequences(group_regulation[idx, ], group)
print(comp)
#>                                                   pattern freq_High freq_Low
#> 1                                                   adapt        73      210
#> 2                                               consensus      1868     1572
#> 3                                              coregulate       471      596
#> 4                                                 emotion       852      696
#> 5                                                    plan      1554     1785
#> 6                                                 monitor       335      417
#> 7                                                cohesion       509      415
#> 8                                         adapt->cohesion        14       56
#> 9                                        adapt->consensus        35       90
#> 10                                    cohesion->consensus       267      181
#> 11                                    consensus->cohesion        40       10
#> 12                                     consensus->discuss       427      204
#> 13                                     consensus->emotion       138       89
#> 14                                         discuss->adapt        22      125
#> 15                                     discuss->consensus       405      191
#> 16                                     discuss->synthesis       119      175
#> 17                                     emotion->consensus       268      188
#> 18                                          plan->emotion       265      188
#> 19                                             plan->plan       484      706
#> 20                                       synthesis->adapt        19       59
#> 21                                      discuss->cohesion        64       33
#> 22                                       monitor->discuss       111      157
#> 24                                      cohesion->discuss        11       30
#> 25                                       discuss->discuss       155      212
#> 26                                    emotion->coregulate        11       29
#> 27                                      cohesion->emotion        63       36
#> 28                                     consensus->monitor        67      102
#> 29                                        synthesis->plan        19        5
#> 31                                  coregulate->consensus        47       84
#> 32                             adapt->cohesion->consensus         8       28
#> 33                                 adapt->consensus->plan         8       36
#> 34                           cohesion->consensus->discuss        74       22
#> 36                          consensus->consensus->discuss        33       11
#> 37                          consensus->discuss->consensus       156       48
#> 38                            consensus->discuss->emotion        52       19
#> 40                           coregulate->discuss->discuss         8       26
#> 41                         coregulate->discuss->synthesis         9       32
#> 43                              discuss->adapt->consensus        12       54
#> 44                           discuss->cohesion->consensus        35       11
#> 45                            discuss->consensus->discuss        97       21
#> 46                               discuss->consensus->plan       139       86
#> 48                              discuss->synthesis->adapt        14       47
#> 50                            emotion->discuss->consensus        34        5
#> 51                              plan->cohesion->consensus        30       11
#> 53                                 plan->emotion->discuss        36       11
#> 54                                       plan->plan->plan       140      278
#> 56                                   cohesion->coregulate        37       68
#> 57                                              synthesis       174      209
#> 59                                       emotion->discuss        91       60
#> 61                                    coregulate->discuss       104      150
#> 62                                       discuss->monitor        12       27
#> 63                                                discuss      1081     1042
#> 64                                         adapt->emotion        10       22
#> 68                                      cohesion->monitor         9       17
#> 69                                         cohesion->plan        61       51
#> 71                                       consensus->adapt         6       11
#> 72                                   consensus->consensus       161      124
#> 73                                  consensus->coregulate       272      298
#> 74                                        consensus->plan       619      619
#> 75                                   consensus->synthesis        15       12
#> 76                                      coregulate->adapt        10        6
#> 77                                   coregulate->cohesion        16       18
#> 78                                 coregulate->coregulate         6       20
#> 79                                    coregulate->emotion        94       91
#> 80                                    coregulate->monitor        43       42
#> 81                                       coregulate->plan       112      126
#> 82                                  coregulate->synthesis         6        9
#> 83                                    discuss->coregulate        82       90
#> 84                                       discuss->emotion       119      103
#> 85                                          discuss->plan        18       10
#> 87                                      emotion->cohesion       253      211
#> 88                                       emotion->emotion        43       52
#> 89                                       emotion->monitor        27       26
#> 90                                          emotion->plan        79       78
#> 93                                      monitor->cohesion        15       18
#> 94                                     monitor->consensus        60       63
#> 95                                    monitor->coregulate        16       27
#> 96                                       monitor->emotion        31       34
#> 97                                       monitor->monitor         7        6
#> 98                                          monitor->plan        66       83
#> 101                                        plan->cohesion        46       38
#> 102                                       plan->consensus       422      459
#> 103                                      plan->coregulate        42       23
#> 104                                         plan->discuss        91      122
#> 105                                         plan->monitor        96      115
#> 108                                  synthesis->consensus        98       78
#> 110                                    synthesis->emotion         9       14
#> 121                          adapt->consensus->coregulate         9       21
#> 122                             adapt->consensus->discuss        10        8
#> 160                        cohesion->consensus->consensus        27       14
#> 161                       cohesion->consensus->coregulate        31       36
#> 162                          cohesion->consensus->emotion        24       10
#> 164                             cohesion->consensus->plan        84       74
#> 169                         cohesion->coregulate->discuss         9       16
#> 170                         cohesion->coregulate->emotion         9       14
#> 172                            cohesion->coregulate->plan        10       13
#> 182                           cohesion->emotion->cohesion        17       14
#> 183                          cohesion->emotion->consensus        21        7
#> 193                            cohesion->monitor->discuss         6        7
#> 197                             cohesion->plan->consensus        17       15
#> 202                                  cohesion->plan->plan        17       19
#> 216                       consensus->consensus->consensus        17        8
#> 217                      consensus->consensus->coregulate        19       22
#> 218                         consensus->consensus->emotion        11        9
#> 219                         consensus->consensus->monitor        12        5
#> 220                            consensus->consensus->plan        48       58
#> 223                       consensus->coregulate->cohesion         8        8
#> 224                      consensus->coregulate->consensus        24       43
#> 225                     consensus->coregulate->coregulate         6       14
#> 226                        consensus->coregulate->discuss        63       78
#> 227                        consensus->coregulate->emotion        56       46
#> 228                        consensus->coregulate->monitor        25       20
#> 229                           consensus->coregulate->plan        63       61
#> 231                             consensus->discuss->adapt        11       25
#> 232                          consensus->discuss->cohesion        18        5
#> 233                        consensus->discuss->coregulate        31       15
#> 234                           consensus->discuss->discuss        68       38
#> 237                         consensus->discuss->synthesis        49       37
#> 239                          consensus->emotion->cohesion        31       25
#> 240                         consensus->emotion->consensus        45       22
#> 242                           consensus->emotion->discuss        15       13
#> 243                           consensus->emotion->emotion        10        6
#> 245                              consensus->emotion->plan        11        9
#> 249                         consensus->monitor->consensus         7       15
#> 251                           consensus->monitor->discuss        22       45
#> 252                           consensus->monitor->emotion         8        6
#> 254                              consensus->monitor->plan        16       15
#> 257                             consensus->plan->cohesion        20        7
#> 258                            consensus->plan->consensus       179      160
#> 259                           consensus->plan->coregulate        17       11
#> 260                              consensus->plan->discuss        33       44
#> 261                              consensus->plan->emotion        99       69
#> 262                              consensus->plan->monitor        31       44
#> 263                                 consensus->plan->plan       196      242
#> 276                       coregulate->cohesion->consensus         7        9
#> 281                      coregulate->consensus->consensus         5        8
#> 282                     coregulate->consensus->coregulate         8       16
#> 283                        coregulate->consensus->discuss         9       11
#> 286                           coregulate->consensus->plan        15       35
#> 295                        coregulate->discuss->consensus        46       23
#> 296                       coregulate->discuss->coregulate        10       13
#> 297                          coregulate->discuss->emotion        10       10
#> 300                         coregulate->emotion->cohesion        35       27
#> 301                        coregulate->emotion->consensus        20       18
#> 303                          coregulate->emotion->discuss        14       11
#> 304                          coregulate->emotion->emotion         5        6
#> 306                             coregulate->emotion->plan         9       14
#> 310                        coregulate->monitor->consensus         7        6
#> 312                          coregulate->monitor->discuss        15       12
#> 315                             coregulate->monitor->plan        13        8
#> 319                           coregulate->plan->consensus        25       33
#> 321                             coregulate->plan->discuss         7        8
#> 322                             coregulate->plan->emotion        20       14
#> 323                             coregulate->plan->monitor         6        8
#> 324                                coregulate->plan->plan        38       53
#> 331                               discuss->adapt->emotion         5       13
#> 343                         discuss->consensus->consensus        34       14
#> 344                        discuss->consensus->coregulate        54       31
#> 345                           discuss->consensus->emotion        28       11
#> 346                           discuss->consensus->monitor        11       11
#> 349                        discuss->coregulate->consensus         8        9
#> 350                          discuss->coregulate->discuss        19       28
#> 351                          discuss->coregulate->emotion        14        9
#> 352                          discuss->coregulate->monitor         6       10
#> 353                             discuss->coregulate->plan        17       19
#> 355                            discuss->discuss->cohesion         7        7
#> 356                           discuss->discuss->consensus        61       41
#> 357                          discuss->discuss->coregulate         9       14
#> 358                             discuss->discuss->discuss        21       45
#> 359                             discuss->discuss->emotion        16       26
#> 362                           discuss->discuss->synthesis        19       29
#> 363                            discuss->emotion->cohesion        30       32
#> 364                           discuss->emotion->consensus        40       32
#> 366                             discuss->emotion->discuss        12       10
#> 369                                discuss->emotion->plan        18        6
#> 375                             discuss->monitor->discuss         5       13
#> 385                         discuss->synthesis->consensus        69       65
#> 389                              discuss->synthesis->plan        13        5
#> 392                          emotion->cohesion->consensus       126       98
#> 393                         emotion->cohesion->coregulate        22       37
#> 394                            emotion->cohesion->discuss         7       13
#> 395                            emotion->cohesion->emotion        34       16
#> 397                               emotion->cohesion->plan        34       22
#> 401                         emotion->consensus->consensus        26       17
#> 402                        emotion->consensus->coregulate        39       39
#> 403                           emotion->consensus->discuss        61       28
#> 404                           emotion->consensus->emotion        20        9
#> 405                           emotion->consensus->monitor         9       16
#> 406                              emotion->consensus->plan        82       65
#> 418                          emotion->discuss->coregulate         5        6
#> 419                             emotion->discuss->discuss        14       16
#> 420                             emotion->discuss->emotion        12        6
#> 423                           emotion->discuss->synthesis        11       11
#> 424                            emotion->emotion->cohesion        18       17
#> 425                           emotion->emotion->consensus        14       14
#> 434                             emotion->monitor->discuss         7       10
#> 439                              emotion->plan->consensus        21       19
#> 442                                emotion->plan->emotion        12        9
#> 444                                   emotion->plan->plan        24       30
#> 452                          monitor->cohesion->consensus         8        9
#> 459                        monitor->consensus->coregulate        10        9
#> 460                           monitor->consensus->discuss        18        9
#> 463                              monitor->consensus->plan        21       22
#> 469                          monitor->coregulate->discuss         5        6
#> 474                            monitor->discuss->cohesion        14        6
#> 475                           monitor->discuss->consensus        42       27
#> 476                          monitor->discuss->coregulate         7       17
#> 477                             monitor->discuss->discuss        13       35
#> 478                             monitor->discuss->emotion         8       18
#> 481                           monitor->discuss->synthesis        11       27
#> 482                            monitor->emotion->cohesion         5        6
#> 483                           monitor->emotion->consensus        15       14
#> 494                              monitor->plan->consensus        16       25
#> 497                                monitor->plan->emotion        13        9
#> 499                                   monitor->plan->plan        30       28
#> 514                            plan->consensus->consensus        35       29
#> 515                           plan->consensus->coregulate        72       91
#> 516                              plan->consensus->discuss        85       57
#> 517                              plan->consensus->emotion        29       32
#> 518                              plan->consensus->monitor        22       38
#> 519                                 plan->consensus->plan       140      165
#> 526                                plan->coregulate->plan        13        7
#> 529                              plan->discuss->consensus        28       22
#> 530                             plan->discuss->coregulate        11       13
#> 531                                plan->discuss->discuss        15       24
#> 532                                plan->discuss->emotion         7       11
#> 535                              plan->discuss->synthesis        12       17
#> 537                               plan->emotion->cohesion        80       52
#> 538                              plan->emotion->consensus        79       54
#> 540                                plan->emotion->emotion        13       17
#> 542                                   plan->emotion->plan        24       22
#> 545                              plan->monitor->consensus        23       20
#> 547                                plan->monitor->discuss        32       38
#> 548                                plan->monitor->emotion         8        7
#> 550                                   plan->monitor->plan        14       32
#> 553                                  plan->plan->cohesion        12       22
#> 554                                 plan->plan->consensus       132      184
#> 555                                plan->plan->coregulate        12        7
#> 556                                   plan->plan->discuss        31       45
#> 557                                   plan->plan->emotion        83       68
#> 558                                   plan->plan->monitor        38       35
#> 562                           synthesis->adapt->consensus        10       23
#> 573                       synthesis->consensus->consensus         5        6
#> 574                      synthesis->consensus->coregulate        13       11
#> 575                         synthesis->consensus->discuss        22       16
#> 578                            synthesis->consensus->plan        36       28
#> 720                  cohesion->consensus->consensus->plan         9        7
#> 725              cohesion->consensus->coregulate->discuss        10       12
#> 728                 cohesion->consensus->coregulate->plan         6        7
#> 731               cohesion->consensus->discuss->consensus        28        9
#> 733                 cohesion->consensus->discuss->discuss        11        5
#> 748                  cohesion->consensus->plan->consensus        28       18
#> 749                    cohesion->consensus->plan->discuss         5        6
#> 750                    cohesion->consensus->plan->emotion        12       12
#> 752                       cohesion->consensus->plan->plan        30       27
#> 805                cohesion->emotion->cohesion->consensus         6        8
#> 858                       cohesion->plan->consensus->plan         8        6
#> 922             consensus->consensus->coregulate->discuss         5        6
#> 925                consensus->consensus->coregulate->plan         6        5
#> 943                 consensus->consensus->plan->consensus        21       19
#> 948                      consensus->consensus->plan->plan        12       18
#> 962             consensus->coregulate->consensus->discuss         5        8
#> 965                consensus->coregulate->consensus->plan         8       12
#> 974             consensus->coregulate->discuss->consensus        30       15
#> 977               consensus->coregulate->discuss->emotion         6        6
#> 980             consensus->coregulate->discuss->synthesis         7       14
#> 981              consensus->coregulate->emotion->cohesion        21       10
#> 982             consensus->coregulate->emotion->consensus        11       13
#> 984               consensus->coregulate->emotion->discuss         8        5
#> 987                  consensus->coregulate->emotion->plan         6        7
#> 990             consensus->coregulate->monitor->consensus         5        5
#> 998                consensus->coregulate->plan->consensus        13       14
#> 1001                 consensus->coregulate->plan->emotion        12        9
#> 1003                    consensus->coregulate->plan->plan        18       26
#> 1007                 consensus->discuss->adapt->consensus         6       15
#> 1019            consensus->discuss->consensus->coregulate        20        6
#> 1020               consensus->discuss->consensus->discuss        33        5
#> 1023                  consensus->discuss->consensus->plan        53       23
#> 1026              consensus->discuss->coregulate->discuss         7        6
#> 1032               consensus->discuss->discuss->consensus        17        6
#> 1034                 consensus->discuss->discuss->discuss        13        9
#> 1035                 consensus->discuss->discuss->emotion         9        5
#> 1038               consensus->discuss->discuss->synthesis        10        5
#> 1039                consensus->discuss->emotion->cohesion        11        6
#> 1040               consensus->discuss->emotion->consensus        20        5
#> 1057             consensus->discuss->synthesis->consensus        31       14
#> 1064              consensus->emotion->cohesion->consensus        19       10
#> 1071            consensus->emotion->consensus->coregulate        12        6
#> 1118               consensus->monitor->discuss->consensus         7        8
#> 1151                consensus->plan->consensus->consensus        21       12
#> 1152               consensus->plan->consensus->coregulate        34       29
#> 1153                  consensus->plan->consensus->discuss        33       25
#> 1154                  consensus->plan->consensus->emotion        13       11
#> 1155                  consensus->plan->consensus->monitor        12       10
#> 1156                     consensus->plan->consensus->plan        51       54
#> 1167                  consensus->plan->discuss->consensus        12        9
#> 1169                    consensus->plan->discuss->discuss         7       11
#> 1174                   consensus->plan->emotion->cohesion        36       22
#> 1175                  consensus->plan->emotion->consensus        31       20
#> 1180                       consensus->plan->emotion->plan         6        7
#> 1185                    consensus->plan->monitor->discuss        12       10
#> 1188                       consensus->plan->monitor->plan         5       18
#> 1189                      consensus->plan->plan->cohesion         5        9
#> 1190                     consensus->plan->plan->consensus        43       66
#> 1192                       consensus->plan->plan->discuss        15       14
#> 1193                       consensus->plan->plan->emotion        32       22
#> 1194                       consensus->plan->plan->monitor        18       11
#> 1195                          consensus->plan->plan->plan        57      101
#> 1266                    coregulate->consensus->plan->plan         5       17
#> 1290           coregulate->discuss->consensus->coregulate         7        6
#> 1294                 coregulate->discuss->consensus->plan        17        6
#> 1302              coregulate->discuss->discuss->consensus         5        8
#> 1322            coregulate->discuss->synthesis->consensus         6       18
#> 1327             coregulate->emotion->cohesion->consensus        12       16
#> 1338                 coregulate->emotion->consensus->plan         9        7
#> 1377              coregulate->monitor->discuss->consensus         6        5
#> 1397              coregulate->plan->consensus->coregulate         5        5
#> 1401                    coregulate->plan->consensus->plan         6       11
#> 1423                    coregulate->plan->plan->consensus        12       15
#> 1426                      coregulate->plan->plan->emotion         9        8
#> 1428                         coregulate->plan->plan->plan         9       16
#> 1505                  discuss->consensus->consensus->plan        15        7
#> 1511              discuss->consensus->coregulate->emotion        12        9
#> 1513                 discuss->consensus->coregulate->plan        12        6
#> 1518                 discuss->consensus->discuss->discuss        17        6
#> 1522               discuss->consensus->discuss->synthesis        10        6
#> 1526                 discuss->consensus->emotion->discuss         5        5
#> 1539                  discuss->consensus->plan->consensus        44       19
#> 1541                    discuss->consensus->plan->discuss         7        6
#> 1542                    discuss->consensus->plan->emotion        24        8
#> 1543                    discuss->consensus->plan->monitor         9        5
#> 1544                       discuss->consensus->plan->plan        37       37
#> 1561               discuss->coregulate->emotion->cohesion         5        6
#> 1578                      discuss->coregulate->plan->plan         8        8
#> 1596              discuss->discuss->consensus->coregulate         6        5
#> 1597                 discuss->discuss->consensus->discuss        17        5
#> 1600                    discuss->discuss->consensus->plan        24       19
#> 1611                 discuss->discuss->discuss->consensus         8       11
#> 1618                 discuss->discuss->emotion->consensus         8        9
#> 1631               discuss->discuss->synthesis->consensus         8        8
#> 1637                discuss->emotion->cohesion->consensus        15       15
#> 1646              discuss->emotion->consensus->coregulate         5        7
#> 1650                    discuss->emotion->consensus->plan        16        9
#> 1703                 discuss->synthesis->adapt->consensus         7       20
#> 1715            discuss->synthesis->consensus->coregulate        10       10
#> 1716               discuss->synthesis->consensus->discuss        15       13
#> 1719                  discuss->synthesis->consensus->plan        27       21
#> 1750              emotion->cohesion->consensus->consensus        16       10
#> 1751             emotion->cohesion->consensus->coregulate        15       19
#> 1752                emotion->cohesion->consensus->discuss        34       12
#> 1755                   emotion->cohesion->consensus->plan        38       41
#> 1759               emotion->cohesion->coregulate->emotion         6        7
#> 1761                  emotion->cohesion->coregulate->plan         6        6
#> 1789                        emotion->cohesion->plan->plan         7       10
#> 1802                  emotion->consensus->consensus->plan         5        8
#> 1808              emotion->consensus->coregulate->discuss        11       11
#> 1809              emotion->consensus->coregulate->emotion        10        6
#> 1811                 emotion->consensus->coregulate->plan         6        9
#> 1815              emotion->consensus->discuss->coregulate         6        5
#> 1819               emotion->consensus->discuss->synthesis         7        6
#> 1832                  emotion->consensus->plan->consensus        19       20
#> 1835                    emotion->consensus->plan->emotion        11       13
#> 1837                       emotion->consensus->plan->plan        28       21
#> 1894               emotion->discuss->synthesis->consensus        10        5
#> 1899                emotion->emotion->cohesion->consensus         8        5
#> 1909                    emotion->emotion->consensus->plan         6        8
#> 1976                       emotion->plan->plan->consensus         7        5
#> 1980                            emotion->plan->plan->plan         5       11
#> 2027                  monitor->consensus->plan->consensus        10        8
#> 2073                 monitor->discuss->consensus->discuss         9        5
#> 2076                    monitor->discuss->consensus->plan        12       13
#> 2086                 monitor->discuss->discuss->consensus         8        6
#> 2163                       monitor->plan->plan->consensus        10        7
#> 2167                            monitor->plan->plan->plan         9       12
#> 2189                      plan->cohesion->consensus->plan         7        5
#> 2219                     plan->consensus->consensus->plan         8       13
#> 2223               plan->consensus->coregulate->consensus         8       19
#> 2225                 plan->consensus->coregulate->discuss        14       20
#> 2226                 plan->consensus->coregulate->emotion        17       10
#> 2227                 plan->consensus->coregulate->monitor         6       11
#> 2228                    plan->consensus->coregulate->plan        18       21
#> 2232                  plan->consensus->discuss->consensus        29       11
#> 2234                    plan->consensus->discuss->discuss        17       12
#> 2235                    plan->consensus->discuss->emotion        13        7
#> 2238                  plan->consensus->discuss->synthesis         9        9
#> 2240                   plan->consensus->emotion->cohesion         6       10
#> 2241                  plan->consensus->emotion->consensus         7        7
#> 2250                    plan->consensus->monitor->discuss         7       18
#> 2253                       plan->consensus->monitor->plan         6        6
#> 2256                     plan->consensus->plan->consensus        29       42
#> 2257                    plan->consensus->plan->coregulate         6        5
#> 2258                       plan->consensus->plan->discuss         5       11
#> 2259                       plan->consensus->plan->emotion        24       15
#> 2260                       plan->consensus->plan->monitor        12       14
#> 2261                          plan->consensus->plan->plan        48       64
#> 2300                       plan->discuss->consensus->plan        10       10
#> 2334                   plan->emotion->cohesion->consensus        43       25
#> 2339                        plan->emotion->cohesion->plan        12        7
#> 2342                  plan->emotion->consensus->consensus         6        6
#> 2343                 plan->emotion->consensus->coregulate        12       11
#> 2344                    plan->emotion->consensus->discuss        18       10
#> 2347                       plan->emotion->consensus->plan        24       17
#> 2361                     plan->emotion->emotion->cohesion         5        6
#> 2372                       plan->emotion->plan->consensus         7        5
#> 2377                            plan->emotion->plan->plan         9        7
#> 2388                       plan->monitor->consensus->plan         6        9
#> 2396                    plan->monitor->discuss->consensus         9        5
#> 2398                      plan->monitor->discuss->discuss         5       11
#> 2415                            plan->monitor->plan->plan         5       10
#> 2418                      plan->plan->cohesion->consensus         8        7
#> 2425                     plan->plan->consensus->consensus         6       13
#> 2426                    plan->plan->consensus->coregulate        16       39
#> 2427                       plan->plan->consensus->discuss        28       21
#> 2428                       plan->plan->consensus->emotion         8       11
#> 2429                       plan->plan->consensus->monitor         6       18
#> 2430                          plan->plan->consensus->plan        52       67
#> 2440                       plan->plan->discuss->consensus         9        9
#> 2442                         plan->plan->discuss->discuss         5        7
#> 2447                        plan->plan->emotion->cohesion        19       11
#> 2448                       plan->plan->emotion->consensus        28       20
#> 2450                         plan->plan->emotion->discuss        13        6
#> 2451                         plan->plan->emotion->emotion         5       10
#> 2453                            plan->plan->emotion->plan         9       10
#> 2455                       plan->plan->monitor->consensus         9        9
#> 2457                         plan->plan->monitor->discuss        11       10
#> 2459                            plan->plan->monitor->plan         6        8
#> 2463                          plan->plan->plan->consensus        40       69
#> 2465                            plan->plan->plan->discuss         5       22
#> 2466                            plan->plan->plan->emotion        22       25
#> 2467                            plan->plan->plan->monitor         9       13
#> 2468                               plan->plan->plan->plan        46      110
#> 2520             synthesis->consensus->discuss->consensus         9        6
#> 2536                synthesis->consensus->plan->consensus         6        7
#> 2540                     synthesis->consensus->plan->plan        18        9
#> 2873           cohesion->consensus->plan->consensus->plan        11        5
#> 2887           cohesion->consensus->plan->plan->consensus         7        6
#> 2889             cohesion->consensus->plan->plan->emotion         7        5
#> 2891                cohesion->consensus->plan->plan->plan        10        7
#> 3227          consensus->consensus->plan->consensus->plan         5        8
#> 3246          consensus->consensus->plan->plan->consensus         8        8
#> 3343 consensus->coregulate->discuss->synthesis->consensus         5        6
#> 3347  consensus->coregulate->emotion->cohesion->consensus         8        6
#> 3405         consensus->coregulate->plan->consensus->plan         5        6
#> 3426         consensus->coregulate->plan->plan->consensus         6        7
#> 3493       consensus->discuss->consensus->plan->consensus        13        6
#> 3498            consensus->discuss->consensus->plan->plan        17        9
#> 3606       consensus->discuss->synthesis->consensus->plan        13       10
#> 3623        consensus->emotion->cohesion->consensus->plan         5        6
#> 3822         consensus->plan->consensus->discuss->discuss         8        6
#> 3826       consensus->plan->consensus->discuss->synthesis         5        5
#> 3839          consensus->plan->consensus->plan->consensus        12       15
#> 3844               consensus->plan->consensus->plan->plan        17       21
#> 3894        consensus->plan->emotion->cohesion->consensus        22        9
#> 3905            consensus->plan->emotion->consensus->plan         7        8
#> 3964            consensus->plan->plan->consensus->discuss         7        6
#> 3967               consensus->plan->plan->consensus->plan        18       21
#> 3983             consensus->plan->plan->emotion->cohesion         8        6
#> 3984            consensus->plan->plan->emotion->consensus         8        7
#> 3998               consensus->plan->plan->plan->consensus        20       23
#> 4001                 consensus->plan->plan->plan->emotion         9       11
#> 4003                    consensus->plan->plan->plan->plan        12       36
#> 4239       coregulate->emotion->cohesion->consensus->plan         6        9
#> 4719         discuss->consensus->plan->consensus->discuss        11        6
#> 4722            discuss->consensus->plan->consensus->plan        10        5
#> 4748            discuss->consensus->plan->plan->consensus         5       11
#> 4753                 discuss->consensus->plan->plan->plan        14       13
#> 4885         discuss->discuss->consensus->plan->consensus         7        7
#> 4890              discuss->discuss->consensus->plan->plan         6        7
#> 5143    discuss->synthesis->consensus->discuss->consensus         6        5
#> 5156       discuss->synthesis->consensus->plan->consensus         6        5
#> 5160            discuss->synthesis->consensus->plan->plan        14        6
#> 5218        emotion->cohesion->consensus->consensus->plan         6        5
#> 5222    emotion->cohesion->consensus->coregulate->discuss         8        6
#> 5243        emotion->cohesion->consensus->plan->consensus        12       11
#> 5245          emotion->cohesion->consensus->plan->emotion         6        7
#> 5247             emotion->cohesion->consensus->plan->plan        11       14
#> 5459      emotion->consensus->plan->consensus->coregulate         5        5
#> 5487                 emotion->consensus->plan->plan->plan         7       10
#> 6204      plan->consensus->coregulate->discuss->consensus         5        5
#> 6225              plan->consensus->coregulate->plan->plan         7       11
#> 6238            plan->consensus->discuss->consensus->plan        14        5
#> 6261       plan->consensus->discuss->synthesis->consensus         8        5
#> 6325               plan->consensus->plan->consensus->plan         7       16
#> 6340            plan->consensus->plan->emotion->consensus         5        7
#> 6352               plan->consensus->plan->plan->consensus        10       18
#> 6357                    plan->consensus->plan->plan->plan        14       33
#> 6504             plan->emotion->cohesion->consensus->plan        11        8
#> 6561                 plan->emotion->consensus->plan->plan        10        5
#> 6747            plan->plan->consensus->discuss->consensus        11        5
#> 6748              plan->plan->consensus->discuss->discuss         5        5
#> 6765               plan->plan->consensus->plan->consensus         9       17
#> 6769                 plan->plan->consensus->plan->monitor         5        6
#> 6770                    plan->plan->consensus->plan->plan        16       26
#> 6791                 plan->plan->discuss->consensus->plan         6        6
#> 6810             plan->plan->emotion->cohesion->consensus         6        7
#> 6821                 plan->plan->emotion->consensus->plan        10        7
#> 6873              plan->plan->plan->consensus->coregulate         6       13
#> 6874                 plan->plan->plan->consensus->discuss         8        8
#> 6877                    plan->plan->plan->consensus->plan        14       30
#> 6893                 plan->plan->plan->emotion->consensus         9        7
#> 6897                      plan->plan->plan->emotion->plan         6        6
#> 6905                    plan->plan->plan->plan->consensus         9       32
#> 6908                      plan->plan->plan->plan->emotion         9        9
#> 6910                         plan->plan->plan->plan->plan        21       48
#> 7051               synthesis->consensus->plan->plan->plan         8        5
#>         prop_High     prop_Low effect_size     p_value
#> 1    0.0105537083 0.0302506482 12.17246182 0.008991009
#> 2    0.2700592743 0.2264477096 10.71148221 0.008991009
#> 3    0.0680931039 0.0858542207  5.37154029 0.008991009
#> 4    0.1231747868 0.1002592913  6.46278423 0.008991009
#> 5    0.2246638716 0.2571305099  4.59659102 0.017982018
#> 6    0.0484314009 0.0600691443  3.69917760 0.026973027
#> 7    0.0735868151 0.0597810429  4.11665881 0.044955045
#> 8    0.0021817048 0.0086929525  7.06550745 0.077922078
#> 9    0.0054542621 0.0139708165  6.83355793 0.077922078
#> 10   0.0416082281 0.0280968643  5.92389151 0.077922078
#> 11   0.0062334424 0.0015523129  5.78564491 0.077922078
#> 12   0.0665419978 0.0316671841 12.58812708 0.077922078
#> 13   0.0215053763 0.0138155852  4.47388084 0.077922078
#> 14   0.0034283933 0.0194039118 12.94960981 0.077922078
#> 15   0.0631136045 0.0296491773 13.67093757 0.077922078
#> 16   0.0185444912 0.0271654766  4.30495480 0.077922078
#> 17   0.0417640642 0.0291834834  4.96067445 0.077922078
#> 18   0.0412965560 0.0291834834  5.21563659 0.077922078
#> 19   0.0754246533 0.1095932940  6.67808130 0.077922078
#> 20   0.0029608851 0.0091586464  5.79236183 0.077922078
#> 21   0.0099735079 0.0051226327  3.99213304 0.155844156
#> 22   0.0172978027 0.0243713133  3.74304310 0.155844156
#> 24   0.0017141967 0.0046569388  3.76848657 0.311688312
#> 25   0.0241545894 0.0329090345  3.16235015 0.311688312
#> 26   0.0017141967 0.0045017075  3.49214639 0.311688312
#> 27   0.0098176718 0.0055883266  3.27187168 0.389610390
#> 28   0.0104410161 0.0158335921  3.37059017 0.389610390
#> 29   0.0029608851 0.0007761565  3.35313233 0.389610390
#> 31   0.0073242948 0.0130394287  3.97214572 0.467532468
#> 32   0.0013520365 0.0047122181  4.20765817 0.515484515
#> 33   0.0013520365 0.0060585661  5.85201987 0.515484515
#> 34   0.0125063377 0.0037024571  8.19686242 0.515484515
#> 36   0.0055771506 0.0018512285  4.36868540 0.515484515
#> 37   0.0263647118 0.0080780882 10.59312874 0.515484515
#> 38   0.0087882373 0.0031975766  5.04386910 0.515484515
#> 40   0.0013520365 0.0043756311  4.10563853 0.515484515
#> 41   0.0015210411 0.0053853921  4.56011163 0.515484515
#> 43   0.0020280548 0.0090878492  6.98027662 0.515484515
#> 44   0.0059151597 0.0018512285  4.73196023 0.515484515
#> 45   0.0163934426 0.0035341636  9.01341444 0.515484515
#> 46   0.0234916343 0.0144732413  5.16197185 0.515484515
#> 48   0.0023660639 0.0079097947  5.31195966 0.515484515
#> 50   0.0057461551 0.0008414675  6.17897993 0.515484515
#> 51   0.0050701369 0.0018512285  3.83369377 0.515484515
#> 53   0.0060841643 0.0018512285  4.68551551 0.515484515
#> 54   0.0236606388 0.0467855941  6.19409423 0.515484515
#> 56   0.0057659342 0.0105557280  3.34247987 0.545454545
#> 57   0.0251554142 0.0301065975  1.80833383 0.620379620
#> 59   0.0141810815 0.0093138777  2.96891697 0.623376623
#> 61   0.0162069503 0.0232846942  3.25100270 0.857142857
#> 62   0.0018700327 0.0041912450  2.89709870 0.857142857
#> 63   0.1562816250 0.1501008355  0.26599791 1.000000000
#> 64   0.0015583606 0.0034150885  2.22104065 1.000000000
#> 68   0.0014025245 0.0026389320  1.20129690 1.000000000
#> 69   0.0095059997 0.0079167960  0.25349151 1.000000000
#> 71   0.0009350164 0.0017075442  0.70850713 1.000000000
#> 72   0.0250896057 0.0192486805  2.36894994 1.000000000
#> 73   0.0423874084 0.0462589258  0.52740308 1.000000000
#> 74   0.0964625214 0.0960881714 -1.15725826 1.000000000
#> 75   0.0023375409 0.0018627755 -0.31315606 1.000000000
#> 76   0.0015583606 0.0009313878  0.32173602 1.000000000
#> 77   0.0024933770 0.0027941633 -0.78984140 1.000000000
#> 78   0.0009350164 0.0031046259  3.00672530 1.000000000
#> 79   0.0146485897 0.0141260478 -0.91017693 1.000000000
#> 80   0.0067009506 0.0065197144 -1.10395696 1.000000000
#> 81   0.0174536388 0.0195591431  0.13625880 1.000000000
#> 82   0.0009350164 0.0013970817 -0.05629551 1.000000000
#> 83   0.0127785570 0.0139708165 -0.39308462 1.000000000
#> 84   0.0185444912 0.0159888233  0.74351811 1.000000000
#> 85   0.0028050491 0.0015523129  1.29190666 1.000000000
#> 87   0.0394265233 0.0327538032  2.10710128 1.000000000
#> 88   0.0067009506 0.0080720273  0.06297300 1.000000000
#> 89   0.0042075736 0.0040360137 -1.07071624 1.000000000
#> 90   0.0123110488 0.0121080410 -1.13299438 1.000000000
#> 93   0.0023375409 0.0027941633 -0.47576260 1.000000000
#> 94   0.0093501636 0.0097795716 -0.89971996 1.000000000
#> 95   0.0024933770 0.0041912450  1.34709989 1.000000000
#> 96   0.0048309179 0.0052778640 -0.69929605 1.000000000
#> 97   0.0010908524 0.0009313878 -0.87427731 1.000000000
#> 98   0.0102851800 0.0128841975  0.94926027 1.000000000
#> 101  0.0071684588 0.0058987892  0.17907354 1.000000000
#> 102  0.0657628175 0.0712511642  0.80297988 1.000000000
#> 103  0.0065451145 0.0035703198  2.55968101 1.000000000
#> 104  0.0141810815 0.0189382179  2.35074283 1.000000000
#> 105  0.0149602618 0.0178515989  0.87827911 1.000000000
#> 108  0.0152719339 0.0121080410  1.30514319 1.000000000
#> 110  0.0014025245 0.0021732381  0.27233350 1.000000000
#> 121  0.0015210411 0.0035341636  2.18602947 1.000000000
#> 122  0.0016900456 0.0013463480 -0.57868345 1.000000000
#> 160  0.0045631232 0.0023561091  2.07373097 1.000000000
#> 161  0.0052391415 0.0060585661 -0.28245984 1.000000000
#> 162  0.0040561095 0.0016829350  2.78893550 1.000000000
#> 164  0.0141963833 0.0124537193  0.06807050 1.000000000
#> 169  0.0015210411 0.0026926961  0.86083325 1.000000000
#> 170  0.0015210411 0.0023561091  0.41062053 1.000000000
#> 172  0.0016900456 0.0021878156 -0.32372389 1.000000000
#> 182  0.0028730776 0.0023561091 -0.43707589 1.000000000
#> 183  0.0035490958 0.0011780545  3.14299516 1.000000000
#> 193  0.0010140274 0.0011780545 -0.93095006 1.000000000
#> 197  0.0028730776 0.0025244026 -0.69303971 1.000000000
#> 202  0.0028730776 0.0031975766 -0.81905911 1.000000000
#> 216  0.0028730776 0.0013463480  1.66750435 1.000000000
#> 217  0.0032110867 0.0037024571 -0.54833527 1.000000000
#> 218  0.0018590502 0.0015146415 -0.54286166 1.000000000
#> 219  0.0020280548 0.0008414675  1.46732491 1.000000000
#> 220  0.0081122190 0.0097610232  0.26481385 1.000000000
#> 223  0.0013520365 0.0013463480 -1.39845545 1.000000000
#> 224  0.0040561095 0.0072366207  2.51225301 1.000000000
#> 225  0.0010140274 0.0023561091  1.50326749 1.000000000
#> 226  0.0106472875 0.0131268933  0.72250762 1.000000000
#> 227  0.0094642555 0.0077415012  0.29607901 1.000000000
#> 228  0.0042251141 0.0033658701 -0.06353777 1.000000000
#> 229  0.0106472875 0.0102659037 -1.03585771 1.000000000
#> 231  0.0018590502 0.0042073376  2.66888426 1.000000000
#> 232  0.0030420821 0.0008414675  3.32130229 1.000000000
#> 233  0.0052391415 0.0025244026  2.58178156 1.000000000
#> 234  0.0114923103 0.0063951531  3.40791050 1.000000000
#> 237  0.0082812236 0.0062268596  0.86958939 1.000000000
#> 239  0.0052391415 0.0042073376 -0.01635119 1.000000000
#> 240  0.0076052053 0.0037024571  3.23041070 1.000000000
#> 242  0.0025350684 0.0021878156 -0.65562098 1.000000000
#> 243  0.0016900456 0.0010097610  0.34122126 1.000000000
#> 245  0.0018590502 0.0015146415 -0.56271425 1.000000000
#> 249  0.0011830319 0.0025244026  1.44536814 1.000000000
#> 251  0.0037181004 0.0075732077  3.60095394 1.000000000
#> 252  0.0013520365 0.0010097610 -0.39338437 1.000000000
#> 254  0.0027040730 0.0025244026 -1.01065675 1.000000000
#> 257  0.0033800913 0.0011780545  2.93150799 1.000000000
#> 258  0.0302518168 0.0269269606  0.48903128 1.000000000
#> 259  0.0028730776 0.0018512285  0.62324245 1.000000000
#> 260  0.0055771506 0.0074049142  0.68711065 1.000000000
#> 261  0.0167314517 0.0116122518  2.49507397 1.000000000
#> 262  0.0052391415 0.0074049142  1.19299982 1.000000000
#> 263  0.0331248944 0.0407270279  2.56142018 1.000000000
#> 276  0.0011830319 0.0015146415 -0.52659065 1.000000000
#> 281  0.0008450228 0.0013463480  0.03643499 1.000000000
#> 282  0.0013520365 0.0026926961  1.40689863 1.000000000
#> 283  0.0015210411 0.0018512285 -0.54775036 1.000000000
#> 286  0.0025350684 0.0058902726  3.37484696 1.000000000
#> 295  0.0077742099 0.0038707506  3.20613724 1.000000000
#> 296  0.0016900456 0.0021878156 -0.37213938 1.000000000
#> 297  0.0016900456 0.0016829350 -1.33607641 1.000000000
#> 300  0.0059151597 0.0045439246  0.35639903 1.000000000
#> 301  0.0033800913 0.0030292831 -0.73468281 1.000000000
#> 303  0.0023660639 0.0018512285 -0.30894551 1.000000000
#> 304  0.0008450228 0.0010097610 -0.86342090 1.000000000
#> 306  0.0015210411 0.0023561091  0.37454761 1.000000000
#> 310  0.0011830319 0.0010097610 -0.91389970 1.000000000
#> 312  0.0025350684 0.0020195220 -0.33410783 1.000000000
#> 315  0.0021970593 0.0013463480  0.45639562 1.000000000
#> 319  0.0042251141 0.0055536856  0.35558339 1.000000000
#> 321  0.0011830319 0.0013463480 -0.93664541 1.000000000
#> 322  0.0033800913 0.0023561091  0.45557529 1.000000000
#> 323  0.0010140274 0.0013463480 -0.42488202 1.000000000
#> 324  0.0064221734 0.0089195557  1.28040471 1.000000000
#> 331  0.0008450228 0.0021878156  1.89494678 1.000000000
#> 343  0.0057461551 0.0023561091  3.46855900 1.000000000
#> 344  0.0091262464 0.0052170986  2.99495221 1.000000000
#> 345  0.0047321278 0.0018512285  3.46910099 1.000000000
#> 346  0.0018590502 0.0018512285 -1.30609057 1.000000000
#> 349  0.0013520365 0.0015146415 -0.95637455 1.000000000
#> 350  0.0032110867 0.0047122181  0.64449449 1.000000000
#> 351  0.0023660639 0.0015146415  0.39614380 1.000000000
#> 352  0.0010140274 0.0016829350  0.39278076 1.000000000
#> 353  0.0028730776 0.0031975766 -0.84718917 1.000000000
#> 355  0.0011830319 0.0011780545 -1.30963649 1.000000000
#> 356  0.0103092784 0.0069000337  1.96184327 1.000000000
#> 357  0.0015210411 0.0023561091  0.45963436 1.000000000
#> 358  0.0035490958 0.0075732077  3.31232139 1.000000000
#> 359  0.0027040730 0.0043756311  1.01485979 1.000000000
#> 362  0.0032110867 0.0048805116  1.08692981 1.000000000
#> 363  0.0050701369 0.0053853921 -0.89542483 1.000000000
#> 364  0.0067601825 0.0053853921  0.32422519 1.000000000
#> 366  0.0020280548 0.0016829350 -0.55502940 1.000000000
#> 369  0.0030420821 0.0010097610  2.67458070 1.000000000
#> 375  0.0008450228 0.0021878156  1.85386672 1.000000000
#> 385  0.0116613149 0.0109390778 -0.68708534 1.000000000
#> 389  0.0021970593 0.0008414675  1.77593698 1.000000000
#> 392  0.0212945750 0.0164927634  2.07584257 1.000000000
#> 393  0.0037181004 0.0062268596  1.70116656 1.000000000
#> 394  0.0011830319 0.0021878156  0.91840523 1.000000000
#> 395  0.0057461551 0.0026926961  3.07403770 1.000000000
#> 397  0.0057461551 0.0037024571  1.32529402 1.000000000
#> 401  0.0043941186 0.0028609896  1.06310279 1.000000000
#> 402  0.0065911780 0.0065634467 -1.30552629 1.000000000
#> 403  0.0103092784 0.0047122181  4.55011456 1.000000000
#> 404  0.0033800913 0.0015146415  1.99155994 1.000000000
#> 405  0.0015210411 0.0026926961  1.02933601 1.000000000
#> 406  0.0138583742 0.0109390778  1.05461123 1.000000000
#> 418  0.0008450228 0.0010097610 -0.90017914 1.000000000
#> 419  0.0023660639 0.0026926961 -0.78561007 1.000000000
#> 420  0.0020280548 0.0010097610  0.86749395 1.000000000
#> 423  0.0018590502 0.0018512285 -1.30709721 1.000000000
#> 424  0.0030420821 0.0028609896 -1.04071334 1.000000000
#> 425  0.0023660639 0.0023561091 -1.31133093 1.000000000
#> 434  0.0011830319 0.0016829350 -0.15828343 1.000000000
#> 439  0.0035490958 0.0031975766 -0.77909293 1.000000000
#> 442  0.0020280548 0.0015146415 -0.24726117 1.000000000
#> 444  0.0040561095 0.0050488051  0.03154079 1.000000000
#> 452  0.0013520365 0.0015146415 -0.99007297 1.000000000
#> 459  0.0016900456 0.0015146415 -0.95845773 1.000000000
#> 460  0.0030420821 0.0015146415  1.55884204 1.000000000
#> 463  0.0035490958 0.0037024571 -1.07859984 1.000000000
#> 469  0.0008450228 0.0010097610 -0.86233590 1.000000000
#> 474  0.0023660639 0.0010097610  1.69030096 1.000000000
#> 475  0.0070981917 0.0045439246  1.80191022 1.000000000
#> 476  0.0011830319 0.0028609896  1.97419127 1.000000000
#> 477  0.0021970593 0.0058902726  3.92303482 1.000000000
#> 478  0.0013520365 0.0030292831  2.02004356 1.000000000
#> 481  0.0018590502 0.0045439246  3.31058899 1.000000000
#> 482  0.0008450228 0.0010097610 -0.85495771 1.000000000
#> 483  0.0025350684 0.0023561091 -1.01595659 1.000000000
#> 494  0.0027040730 0.0042073376  0.79565605 1.000000000
#> 497  0.0021970593 0.0015146415  0.15844528 1.000000000
#> 499  0.0050701369 0.0047122181 -0.88772489 1.000000000
#> 514  0.0059151597 0.0048805116 -0.08925816 1.000000000
#> 515  0.0121683285 0.0153147089  1.18169931 1.000000000
#> 516  0.0143653879 0.0095927297  2.63834750 1.000000000
#> 517  0.0049011323 0.0053853921 -0.72183318 1.000000000
#> 518  0.0037181004 0.0063951531  2.15368711 1.000000000
#> 519  0.0236606388 0.0277684281  0.93086958 1.000000000
#> 526  0.0021970593 0.0011780545  0.98581678 1.000000000
#> 529  0.0047321278 0.0037024571  0.03402068 1.000000000
#> 530  0.0018590502 0.0021878156 -0.65156087 1.000000000
#> 531  0.0025350684 0.0040390441  1.12965539 1.000000000
#> 532  0.0011830319 0.0018512285  0.23673091 1.000000000
#> 535  0.0020280548 0.0028609896  0.25915766 1.000000000
#> 537  0.0135203650 0.0087512622  2.83419441 1.000000000
#> 538  0.0133513605 0.0090878492  2.39289636 1.000000000
#> 540  0.0021970593 0.0028609896 -0.12862021 1.000000000
#> 542  0.0040561095 0.0037024571 -0.75982811 1.000000000
#> 545  0.0038871050 0.0033658701 -0.54248262 1.000000000
#> 547  0.0054081460 0.0063951531 -0.12155131 1.000000000
#> 548  0.0013520365 0.0011780545 -0.94906109 1.000000000
#> 550  0.0023660639 0.0053853921  3.18196916 1.000000000
#> 553  0.0020280548 0.0037024571  1.28561945 1.000000000
#> 554  0.0223086023 0.0309660047  3.71000146 1.000000000
#> 555  0.0020280548 0.0011780545  0.66279270 1.000000000
#> 556  0.0052391415 0.0075732077  1.38661864 1.000000000
#> 557  0.0140273787 0.0114439583  0.78879422 1.000000000
#> 558  0.0064221734 0.0058902726 -0.69047411 1.000000000
#> 562  0.0016900456 0.0038707506  2.50987684 1.000000000
#> 573  0.0008450228 0.0010097610 -0.96142697 1.000000000
#> 574  0.0021970593 0.0018512285 -0.62071456 1.000000000
#> 575  0.0037181004 0.0026926961  0.28967499 1.000000000
#> 578  0.0060841643 0.0047122181  0.36210643 1.000000000
#> 720  0.0016550202 0.0012813472 -0.47336493 1.000000000
#> 725  0.0018389114 0.0021965953 -0.64091038 1.000000000
#> 728  0.0011033468 0.0012813472 -0.91147565 1.000000000
#> 731  0.0051489518 0.0016474465  3.93022226 1.000000000
#> 733  0.0020228025 0.0009152480  1.33521786 1.000000000
#> 748  0.0051489518 0.0032948929  1.27409362 1.000000000
#> 749  0.0009194557 0.0010982976 -0.88652125 1.000000000
#> 750  0.0022066936 0.0021965953 -1.29621706 1.000000000
#> 752  0.0055167341 0.0049423394 -0.66521318 1.000000000
#> 805  0.0011033468 0.0014643969 -0.41682745 1.000000000
#> 858  0.0014711291 0.0010982976 -0.35721628 1.000000000
#> 922  0.0009194557 0.0010982976 -0.89175576 1.000000000
#> 925  0.0011033468 0.0009152480 -0.87306303 1.000000000
#> 943  0.0038617139 0.0034779425 -0.77166350 1.000000000
#> 948  0.0022066936 0.0032948929  0.38788926 1.000000000
#> 962  0.0009194557 0.0014643969  0.06771888 1.000000000
#> 965  0.0014711291 0.0021965953  0.07943523 1.000000000
#> 974  0.0055167341 0.0027457441  2.35089809 1.000000000
#> 977  0.0011033468 0.0010982976 -1.31633800 1.000000000
#> 980  0.0012872380 0.0025626945  1.16824433 1.000000000
#> 981  0.0038617139 0.0018304961  1.99237884 1.000000000
#> 982  0.0020228025 0.0023796449 -0.63700169 1.000000000
#> 984  0.0014711291 0.0009152480  0.06390084 1.000000000
#> 987  0.0011033468 0.0012813472 -0.93340794 1.000000000
#> 990  0.0009194557 0.0009152480 -1.27754162 1.000000000
#> 998  0.0023905848 0.0025626945 -1.04717849 1.000000000
#> 1001 0.0022066936 0.0016474465 -0.26042065 1.000000000
#> 1003 0.0033100405 0.0047592898  0.70530344 1.000000000
#> 1007 0.0011033468 0.0027457441  1.98997400 1.000000000
#> 1019 0.0036778227 0.0010982976  3.36105673 1.000000000
#> 1020 0.0060684075 0.0009152480  5.82825387 1.000000000
#> 1023 0.0097462302 0.0042101409  4.50831632 1.000000000
#> 1026 0.0012872380 0.0010982976 -0.89622001 1.000000000
#> 1032 0.0031261493 0.0010982976  2.58356118 1.000000000
#> 1034 0.0023905848 0.0016474465  0.13849267 1.000000000
#> 1035 0.0016550202 0.0009152480  0.45277452 1.000000000
#> 1038 0.0018389114 0.0009152480  0.82225821 1.000000000
#> 1039 0.0020228025 0.0010982976  0.53623587 1.000000000
#> 1040 0.0036778227 0.0009152480  3.54277086 1.000000000
#> 1057 0.0057006252 0.0025626945  2.59182419 1.000000000
#> 1064 0.0034939316 0.0018304961  1.42374966 1.000000000
#> 1071 0.0022066936 0.0010982976  1.04594290 1.000000000
#> 1118 0.0012872380 0.0014643969 -0.90906821 1.000000000
#> 1151 0.0038617139 0.0021965953  1.09811850 1.000000000
#> 1152 0.0062522986 0.0053084386 -0.21022268 1.000000000
#> 1153 0.0060684075 0.0045762402  0.43932081 1.000000000
#> 1154 0.0023905848 0.0020135457 -0.65315577 1.000000000
#> 1155 0.0022066936 0.0018304961 -0.59133695 1.000000000
#> 1156 0.0093784480 0.0098846787 -0.92502233 1.000000000
#> 1167 0.0022066936 0.0016474465 -0.34238801 1.000000000
#> 1169 0.0012872380 0.0020135457  0.27071496 1.000000000
#> 1174 0.0066200809 0.0040270913  1.77982700 1.000000000
#> 1175 0.0057006252 0.0036609921  1.25490209 1.000000000
#> 1180 0.0011033468 0.0012813472 -0.93094421 1.000000000
#> 1185 0.0022066936 0.0018304961 -0.57985414 1.000000000
#> 1188 0.0009194557 0.0032948929  3.18187832 1.000000000
#> 1189 0.0009194557 0.0016474465  0.32193159 1.000000000
#> 1190 0.0079073189 0.0120812740  2.26868051 1.000000000
#> 1192 0.0027583670 0.0025626945 -1.03858660 1.000000000
#> 1193 0.0058845164 0.0040270913  1.07836022 1.000000000
#> 1194 0.0033100405 0.0020135457  0.82575326 1.000000000
#> 1195 0.0104817948 0.0184880103  4.59220001 1.000000000
#> 1266 0.0009194557 0.0031118433  2.92676760 1.000000000
#> 1290 0.0012872380 0.0010982976 -0.91099892 1.000000000
#> 1294 0.0031261493 0.0010982976  2.66356281 1.000000000
#> 1302 0.0009194557 0.0014643969  0.07336530 1.000000000
#> 1322 0.0011033468 0.0032948929  2.55927139 1.000000000
#> 1327 0.0022066936 0.0029287937 -0.05773642 1.000000000
#> 1338 0.0016550202 0.0012813472 -0.52131426 1.000000000
#> 1377 0.0011033468 0.0009152480 -0.81459896 1.000000000
#> 1397 0.0009194557 0.0009152480 -1.32275463 1.000000000
#> 1401 0.0011033468 0.0020135457  0.71725027 1.000000000
#> 1423 0.0022066936 0.0027457441 -0.37403238 1.000000000
#> 1426 0.0016550202 0.0014643969 -0.94150506 1.000000000
#> 1428 0.0016550202 0.0029287937  1.01532734 1.000000000
#> 1505 0.0027583670 0.0012813472  1.47083171 1.000000000
#> 1511 0.0022066936 0.0016474465 -0.26193506 1.000000000
#> 1513 0.0022066936 0.0010982976  0.98012704 1.000000000
#> 1518 0.0031261493 0.0010982976  2.42482694 1.000000000
#> 1522 0.0018389114 0.0010982976  0.36758783 1.000000000
#> 1526 0.0009194557 0.0009152480 -1.27247810 1.000000000
#> 1539 0.0080912100 0.0034779425  4.22471184 1.000000000
#> 1541 0.0012872380 0.0010982976 -0.86025729 1.000000000
#> 1542 0.0044133873 0.0014643969  3.46528381 1.000000000
#> 1543 0.0016550202 0.0009152480  0.51885520 1.000000000
#> 1544 0.0068039720 0.0067728354 -1.25508374 1.000000000
#> 1561 0.0009194557 0.0010982976 -0.87166297 1.000000000
#> 1578 0.0014711291 0.0014643969 -1.25565123 1.000000000
#> 1596 0.0011033468 0.0009152480 -0.86842803 1.000000000
#> 1597 0.0031261493 0.0009152480  2.92668804 1.000000000
#> 1600 0.0044133873 0.0034779425  0.02394886 1.000000000
#> 1611 0.0014711291 0.0020135457 -0.18040264 1.000000000
#> 1618 0.0014711291 0.0016474465 -1.00402700 1.000000000
#> 1631 0.0014711291 0.0014643969 -1.36441231 1.000000000
#> 1637 0.0027583670 0.0027457441 -1.32086004 1.000000000
#> 1646 0.0009194557 0.0012813472 -0.33785711 1.000000000
#> 1650 0.0029422582 0.0016474465  1.10061167 1.000000000
#> 1703 0.0012872380 0.0036609921  2.84877067 1.000000000
#> 1715 0.0018389114 0.0018304961 -1.29992906 1.000000000
#> 1716 0.0027583670 0.0023796449 -0.68257108 1.000000000
#> 1719 0.0049650607 0.0038440417  0.14142972 1.000000000
#> 1750 0.0029422582 0.0018304961  0.60397074 1.000000000
#> 1751 0.0027583670 0.0034779425 -0.21529618 1.000000000
#> 1752 0.0062522986 0.0021965953  4.42588016 1.000000000
#> 1755 0.0069878632 0.0075050339 -0.80967794 1.000000000
#> 1759 0.0011033468 0.0012813472 -0.95341020 1.000000000
#> 1761 0.0011033468 0.0010982976 -1.25353922 1.000000000
#> 1789 0.0012872380 0.0018304961 -0.08529078 1.000000000
#> 1802 0.0009194557 0.0014643969  0.03205146 1.000000000
#> 1808 0.0020228025 0.0020135457 -1.32464734 1.000000000
#> 1809 0.0018389114 0.0010982976  0.29117319 1.000000000
#> 1811 0.0011033468 0.0016474465 -0.08787190 1.000000000
#> 1815 0.0011033468 0.0009152480 -0.81545766 1.000000000
#> 1819 0.0012872380 0.0010982976 -0.92819706 1.000000000
#> 1832 0.0034939316 0.0036609921 -1.08209421 1.000000000
#> 1835 0.0020228025 0.0023796449 -0.58526840 1.000000000
#> 1837 0.0051489518 0.0038440417  0.37958505 1.000000000
#> 1894 0.0018389114 0.0009152480  0.88631966 1.000000000
#> 1899 0.0014711291 0.0009152480  0.07319052 1.000000000
#> 1909 0.0011033468 0.0014643969 -0.44223485 1.000000000
#> 1976 0.0012872380 0.0009152480 -0.36711022 1.000000000
#> 1980 0.0009194557 0.0020135457  1.22732910 1.000000000
#> 2027 0.0018389114 0.0014643969 -0.51763698 1.000000000
#> 2073 0.0016550202 0.0009152480  0.47187325 1.000000000
#> 2076 0.0022066936 0.0023796449 -1.04835943 1.000000000
#> 2086 0.0014711291 0.0010982976 -0.38113860 1.000000000
#> 2163 0.0018389114 0.0012813472 -0.12636074 1.000000000
#> 2167 0.0016550202 0.0021965953 -0.26514234 1.000000000
#> 2189 0.0012872380 0.0009152480 -0.38442207 1.000000000
#> 2219 0.0014711291 0.0023796449  0.42324153 1.000000000
#> 2223 0.0014711291 0.0034779425  2.25876012 1.000000000
#> 2225 0.0025744759 0.0036609921  0.38758072 1.000000000
#> 2226 0.0031261493 0.0018304961  0.84479718 1.000000000
#> 2227 0.0011033468 0.0020135457  0.57882384 1.000000000
#> 2228 0.0033100405 0.0038440417 -0.60653746 1.000000000
#> 2232 0.0053328430 0.0020135457  3.20999334 1.000000000
#> 2234 0.0031261493 0.0021965953  0.26924251 1.000000000
#> 2235 0.0023905848 0.0012813472  0.96537732 1.000000000
#> 2238 0.0016550202 0.0016474465 -1.26940755 1.000000000
#> 2240 0.0011033468 0.0018304961  0.36538092 1.000000000
#> 2241 0.0012872380 0.0012813472 -1.37539904 1.000000000
#> 2250 0.0012872380 0.0032948929  2.31277243 1.000000000
#> 2253 0.0011033468 0.0010982976 -1.32296162 1.000000000
#> 2256 0.0053328430 0.0076880835  0.96668927 1.000000000
#> 2257 0.0011033468 0.0009152480 -0.85660046 1.000000000
#> 2258 0.0009194557 0.0020135457  1.13959103 1.000000000
#> 2259 0.0044133873 0.0027457441  0.98600990 1.000000000
#> 2260 0.0022066936 0.0025626945 -0.71473958 1.000000000
#> 2261 0.0088267745 0.0117151748  1.19418463 1.000000000
#> 2300 0.0018389114 0.0018304961 -1.28183660 1.000000000
#> 2334 0.0079073189 0.0045762402  2.56475730 1.000000000
#> 2339 0.0022066936 0.0012813472  0.51525198 1.000000000
#> 2342 0.0011033468 0.0010982976 -1.28061284 1.000000000
#> 2343 0.0022066936 0.0020135457 -1.00270101 1.000000000
#> 2344 0.0033100405 0.0018304961  1.35637119 1.000000000
#> 2347 0.0044133873 0.0031118433  0.50776107 1.000000000
#> 2361 0.0009194557 0.0010982976 -0.87502687 1.000000000
#> 2372 0.0012872380 0.0009152480 -0.29955936 1.000000000
#> 2377 0.0016550202 0.0012813472 -0.46928595 1.000000000
#> 2388 0.0011033468 0.0016474465 -0.08018434 1.000000000
#> 2396 0.0016550202 0.0009152480  0.52460101 1.000000000
#> 2398 0.0009194557 0.0020135457  1.10673839 1.000000000
#> 2415 0.0009194557 0.0018304961  0.81082168 1.000000000
#> 2418 0.0014711291 0.0012813472 -0.97692462 1.000000000
#> 2425 0.0011033468 0.0023796449  1.41774743 1.000000000
#> 2426 0.0029422582 0.0071389347  3.89195113 1.000000000
#> 2427 0.0051489518 0.0038440417  0.33954752 1.000000000
#> 2428 0.0014711291 0.0020135457 -0.22463828 1.000000000
#> 2429 0.0011033468 0.0032948929  2.71014391 1.000000000
#> 2430 0.0095623391 0.0122643236  0.91739418 1.000000000
#> 2440 0.0016550202 0.0016474465 -1.33657904 1.000000000
#> 2442 0.0009194557 0.0012813472 -0.35729178 1.000000000
#> 2447 0.0034939316 0.0020135457  1.05777691 1.000000000
#> 2448 0.0051489518 0.0036609921  0.59353077 1.000000000
#> 2450 0.0023905848 0.0010982976  1.51252417 1.000000000
#> 2451 0.0009194557 0.0018304961  0.77883021 1.000000000
#> 2453 0.0016550202 0.0018304961 -1.00070022 1.000000000
#> 2455 0.0016550202 0.0016474465 -1.32297922 1.000000000
#> 2457 0.0020228025 0.0018304961 -0.92688551 1.000000000
#> 2459 0.0011033468 0.0014643969 -0.43246434 1.000000000
#> 2463 0.0073556455 0.0126304228  3.27051577 1.000000000
#> 2465 0.0009194557 0.0040270913  4.41018106 1.000000000
#> 2466 0.0040456050 0.0045762402 -0.60296357 1.000000000
#> 2467 0.0016550202 0.0023796449  0.02496081 1.000000000
#> 2468 0.0084589923 0.0201354567  4.00640438 1.000000000
#> 2520 0.0016550202 0.0010982976 -0.05442110 1.000000000
#> 2536 0.0011033468 0.0012813472 -0.96448603 1.000000000
#> 2540 0.0033100405 0.0016474465  1.58861430 1.000000000
#> 2873 0.0021969243 0.0009956193  1.20373854 1.000000000
#> 2887 0.0013980427 0.0011947431 -0.93344670 1.000000000
#> 2889 0.0013980427 0.0009956193 -0.37205574 1.000000000
#> 2891 0.0019972039 0.0013938670 -0.15827615 1.000000000
#> 3227 0.0009986020 0.0015929908  0.06083703 1.000000000
#> 3246 0.0015977631 0.0015929908 -1.29109177 1.000000000
#> 3343 0.0009986020 0.0011947431 -0.91134275 1.000000000
#> 3347 0.0015977631 0.0011947431 -0.39429603 1.000000000
#> 3405 0.0009986020 0.0011947431 -0.86211749 1.000000000
#> 3426 0.0011983223 0.0013938670 -0.94918188 1.000000000
#> 3493 0.0025963651 0.0011947431  1.46552306 1.000000000
#> 3498 0.0033952467 0.0017921147  1.26382089 1.000000000
#> 3606 0.0025963651 0.0019912386 -0.25672710 1.000000000
#> 3623 0.0009986020 0.0011947431 -0.87943210 1.000000000
#> 3822 0.0015977631 0.0011947431 -0.42259421 1.000000000
#> 3826 0.0009986020 0.0009956193 -1.27124331 1.000000000
#> 3839 0.0023966447 0.0029868578 -0.50836812 1.000000000
#> 3844 0.0033952467 0.0041816010 -0.25460288 1.000000000
#> 3894 0.0043938486 0.0017921147  2.62156541 1.000000000
#> 3905 0.0013980427 0.0015929908 -0.90483311 1.000000000
#> 3964 0.0013980427 0.0011947431 -0.92814354 1.000000000
#> 3967 0.0035949670 0.0041816010 -0.61742883 1.000000000
#> 3983 0.0015977631 0.0011947431 -0.42999997 1.000000000
#> 3984 0.0015977631 0.0013938670 -0.91019768 1.000000000
#> 3998 0.0039944078 0.0045798487 -0.55909119 1.000000000
#> 4001 0.0017974835 0.0021903624 -0.61499116 1.000000000
#> 4003 0.0023966447 0.0071684588  4.45736425 1.000000000
#> 4239 0.0011983223 0.0017921147 -0.01981470 1.000000000
#> 4719 0.0021969243 0.0011947431  0.71878975 1.000000000
#> 4722 0.0019972039 0.0009956193  0.85467357 1.000000000
#> 4748 0.0009986020 0.0021903624  1.23432175 1.000000000
#> 4753 0.0027960855 0.0025886101 -1.01499449 1.000000000
#> 4885 0.0013980427 0.0013938670 -1.26128715 1.000000000
#> 4890 0.0011983223 0.0013938670 -0.91057731 1.000000000
#> 5143 0.0011983223 0.0009956193 -0.89171412 1.000000000
#> 5156 0.0011983223 0.0009956193 -0.91611794 1.000000000
#> 5160 0.0027960855 0.0011947431  1.73326003 1.000000000
#> 5218 0.0011983223 0.0009956193 -0.92404702 1.000000000
#> 5222 0.0015977631 0.0011947431 -0.45761208 1.000000000
#> 5243 0.0023966447 0.0021903624 -0.96641334 1.000000000
#> 5245 0.0011983223 0.0013938670 -0.87688559 1.000000000
#> 5247 0.0021969243 0.0027877340 -0.33392946 1.000000000
#> 5459 0.0009986020 0.0009956193 -1.26274626 1.000000000
#> 5487 0.0013980427 0.0019912386 -0.14000621 1.000000000
#> 6204 0.0009986020 0.0009956193 -1.31037032 1.000000000
#> 6225 0.0013980427 0.0021903624  0.21559663 1.000000000
#> 6238 0.0027960855 0.0009956193  1.96461313 1.000000000
#> 6261 0.0015977631 0.0009956193  0.04691053 1.000000000
#> 6325 0.0013980427 0.0031859817  1.67004619 1.000000000
#> 6340 0.0009986020 0.0013938670 -0.34052466 1.000000000
#> 6352 0.0019972039 0.0035842294  1.09834016 1.000000000
#> 6357 0.0027960855 0.0065710872  3.21190311 1.000000000
#> 6504 0.0021969243 0.0015929908 -0.20305407 1.000000000
#> 6561 0.0019972039 0.0009956193  0.86447581 1.000000000
#> 6747 0.0021969243 0.0009956193  1.25462351 1.000000000
#> 6748 0.0009986020 0.0009956193 -1.28885398 1.000000000
#> 6765 0.0017974835 0.0033851055  1.25215806 1.000000000
#> 6769 0.0009986020 0.0011947431 -0.92258732 1.000000000
#> 6770 0.0031955263 0.0051772202  1.17658152 1.000000000
#> 6791 0.0011983223 0.0011947431 -1.24978930 1.000000000
#> 6810 0.0011983223 0.0013938670 -0.92494721 1.000000000
#> 6821 0.0019972039 0.0013938670 -0.11481170 1.000000000
#> 6873 0.0011983223 0.0025886101  1.38271818 1.000000000
#> 6874 0.0015977631 0.0015929908 -1.31868713 1.000000000
#> 6877 0.0027960855 0.0059737157  2.60115597 1.000000000
#> 6893 0.0017974835 0.0013938670 -0.46181660 1.000000000
#> 6897 0.0011983223 0.0011947431 -1.25602711 1.000000000
#> 6905 0.0017974835 0.0063719634  4.71214956 1.000000000
#> 6908 0.0017974835 0.0017921147 -1.32985495 1.000000000
#> 6910 0.0041941282 0.0095579450  2.05586826 1.000000000
#> 7051 0.0015977631 0.0009956193  0.09663614 1.000000000
# }
```
