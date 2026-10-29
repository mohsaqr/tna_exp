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
#> 15                                      discuss->cohesion        64       33
#> 16                                     discuss->consensus       405      191
#> 17                                     emotion->consensus       268      188
#> 18                                          plan->emotion       265      188
#> 19                                             plan->plan       484      706
#> 20                                       synthesis->adapt        19       59
#> 21                                     discuss->synthesis       119      175
#> 23                                     consensus->monitor        67      102
#> 24                                       monitor->discuss       111      157
#> 25                                      cohesion->discuss        11       30
#> 26                                       discuss->discuss       155      212
#> 27                                    emotion->coregulate        11       29
#> 28                                   cohesion->coregulate        37       68
#> 29                                        synthesis->plan        19        5
#> 30                                      cohesion->emotion        63       36
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
#> 58                                              synthesis       174      209
#> 60                                    coregulate->discuss       104      150
#> 61                                       discuss->monitor        12       27
#> 62                                       emotion->discuss        91       60
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
#>         prop_High     prop_Low  effect_size     p_value
#> 1    0.0105537083 0.0302506482 12.234801918 0.008991009
#> 2    0.2700592743 0.2264477096 10.923946548 0.008991009
#> 3    0.0680931039 0.0858542207  5.268630856 0.008991009
#> 4    0.1231747868 0.1002592913  6.395272392 0.008991009
#> 5    0.2246638716 0.2571305099  4.681888617 0.008991009
#> 6    0.0484314009 0.0600691443  3.843049072 0.017982018
#> 7    0.0735868151 0.0597810429  4.094260450 0.035964036
#> 8    0.0021817048 0.0086929525  6.935236054 0.077922078
#> 9    0.0054542621 0.0139708165  6.828691104 0.077922078
#> 10   0.0416082281 0.0280968643  5.867666376 0.077922078
#> 11   0.0062334424 0.0015523129  5.726699525 0.077922078
#> 12   0.0665419978 0.0316671841 12.769091669 0.077922078
#> 13   0.0215053763 0.0138155852  4.518578841 0.077922078
#> 14   0.0034283933 0.0194039118 12.817223307 0.077922078
#> 15   0.0099735079 0.0051226327  4.135479564 0.077922078
#> 16   0.0631136045 0.0296491773 13.805042190 0.077922078
#> 17   0.0417640642 0.0291834834  4.961905668 0.077922078
#> 18   0.0412965560 0.0291834834  5.161837478 0.077922078
#> 19   0.0754246533 0.1095932940  6.735166330 0.077922078
#> 20   0.0029608851 0.0091586464  5.831105492 0.077922078
#> 21   0.0185444912 0.0271654766  4.200583578 0.155844156
#> 23   0.0104410161 0.0158335921  3.389684348 0.233766234
#> 24   0.0172978027 0.0243713133  3.714758286 0.233766234
#> 25   0.0017141967 0.0046569388  3.731193533 0.311688312
#> 26   0.0241545894 0.0329090345  3.169474880 0.311688312
#> 27   0.0017141967 0.0045017075  3.549552349 0.311688312
#> 28   0.0057659342 0.0105557280  3.403459045 0.389610390
#> 29   0.0029608851 0.0007761565  3.321224233 0.389610390
#> 30   0.0098176718 0.0055883266  3.268748279 0.467532468
#> 31   0.0073242948 0.0130394287  3.971226280 0.467532468
#> 32   0.0013520365 0.0047122181  4.181598597 0.515484515
#> 33   0.0013520365 0.0060585661  5.662965110 0.515484515
#> 34   0.0125063377 0.0037024571  8.129292878 0.515484515
#> 36   0.0055771506 0.0018512285  4.425015688 0.515484515
#> 37   0.0263647118 0.0080780882 10.415118453 0.515484515
#> 38   0.0087882373 0.0031975766  5.155173072 0.515484515
#> 40   0.0013520365 0.0043756311  4.001577053 0.515484515
#> 41   0.0015210411 0.0053853921  4.535585240 0.515484515
#> 43   0.0020280548 0.0090878492  7.042751938 0.515484515
#> 44   0.0059151597 0.0018512285  4.737176332 0.515484515
#> 45   0.0163934426 0.0035341636  9.148955398 0.515484515
#> 46   0.0234916343 0.0144732413  5.149866320 0.515484515
#> 48   0.0023660639 0.0079097947  5.319727695 0.515484515
#> 50   0.0057461551 0.0008414675  6.143203103 0.515484515
#> 51   0.0050701369 0.0018512285  3.900400058 0.515484515
#> 53   0.0060841643 0.0018512285  4.723069083 0.515484515
#> 54   0.0236606388 0.0467855941  6.285192774 0.515484515
#> 58   0.0251554142 0.0301065975  1.750128298 0.647352647
#> 60   0.0162069503 0.0232846942  3.266396828 0.701298701
#> 61   0.0018700327 0.0041912450  2.919493831 0.779220779
#> 62   0.0141810815 0.0093138777  2.927396761 0.779220779
#> 63   0.1562816250 0.1501008355  0.291189291 1.000000000
#> 64   0.0015583606 0.0034150885  2.170748795 1.000000000
#> 68   0.0014025245 0.0026389320  1.233668809 1.000000000
#> 69   0.0095059997 0.0079167960  0.261989621 1.000000000
#> 71   0.0009350164 0.0017075442  0.671266635 1.000000000
#> 72   0.0250896057 0.0192486805  2.354827927 1.000000000
#> 73   0.0423874084 0.0462589258  0.498052096 1.000000000
#> 74   0.0964625214 0.0960881714 -1.162449869 1.000000000
#> 75   0.0023375409 0.0018627755 -0.314316924 1.000000000
#> 76   0.0015583606 0.0009313878  0.357750793 1.000000000
#> 77   0.0024933770 0.0027941633 -0.814714799 1.000000000
#> 78   0.0009350164 0.0031046259  3.006916140 1.000000000
#> 79   0.0146485897 0.0141260478 -0.889400241 1.000000000
#> 80   0.0067009506 0.0065197144 -1.121000783 1.000000000
#> 81   0.0174536388 0.0195591431  0.130368393 1.000000000
#> 82   0.0009350164 0.0013970817 -0.063382122 1.000000000
#> 83   0.0127785570 0.0139708165 -0.403474756 1.000000000
#> 84   0.0185444912 0.0159888233  0.722174939 1.000000000
#> 85   0.0028050491 0.0015523129  1.262450614 1.000000000
#> 87   0.0394265233 0.0327538032  2.119764823 1.000000000
#> 88   0.0067009506 0.0080720273  0.049355727 1.000000000
#> 89   0.0042075736 0.0040360137 -1.093206364 1.000000000
#> 90   0.0123110488 0.0121080410 -1.120079791 1.000000000
#> 93   0.0023375409 0.0027941633 -0.487130376 1.000000000
#> 94   0.0093501636 0.0097795716 -0.905235095 1.000000000
#> 95   0.0024933770 0.0041912450  1.401556384 1.000000000
#> 96   0.0048309179 0.0052778640 -0.705580350 1.000000000
#> 97   0.0010908524 0.0009313878 -0.866042135 1.000000000
#> 98   0.0102851800 0.0128841975  0.980528781 1.000000000
#> 101  0.0071684588 0.0058987892  0.198442783 1.000000000
#> 102  0.0657628175 0.0712511642  0.822964888 1.000000000
#> 103  0.0065451145 0.0035703198  2.631199104 1.000000000
#> 104  0.0141810815 0.0189382179  2.386446122 1.000000000
#> 105  0.0149602618 0.0178515989  0.936375541 1.000000000
#> 108  0.0152719339 0.0121080410  1.326725416 1.000000000
#> 110  0.0014025245 0.0021732381  0.270446291 1.000000000
#> 121  0.0015210411 0.0035341636  2.160692456 1.000000000
#> 122  0.0016900456 0.0013463480 -0.610756733 1.000000000
#> 160  0.0045631232 0.0023561091  2.057506493 1.000000000
#> 161  0.0052391415 0.0060585661 -0.291184352 1.000000000
#> 162  0.0040561095 0.0016829350  2.767292771 1.000000000
#> 164  0.0141963833 0.0124537193  0.072989093 1.000000000
#> 169  0.0015210411 0.0026926961  0.907261172 1.000000000
#> 170  0.0015210411 0.0023561091  0.406330133 1.000000000
#> 172  0.0016900456 0.0021878156 -0.334452469 1.000000000
#> 182  0.0028730776 0.0023561091 -0.435571239 1.000000000
#> 183  0.0035490958 0.0011780545  3.031424626 1.000000000
#> 193  0.0010140274 0.0011780545 -0.918931718 1.000000000
#> 197  0.0028730776 0.0025244026 -0.692696113 1.000000000
#> 202  0.0028730776 0.0031975766 -0.835289689 1.000000000
#> 216  0.0028730776 0.0013463480  1.591504850 1.000000000
#> 217  0.0032110867 0.0037024571 -0.569878790 1.000000000
#> 218  0.0018590502 0.0015146415 -0.553590287 1.000000000
#> 219  0.0020280548 0.0008414675  1.478101756 1.000000000
#> 220  0.0081122190 0.0097610232  0.286821535 1.000000000
#> 223  0.0013520365 0.0013463480 -1.420846995 1.000000000
#> 224  0.0040561095 0.0072366207  2.570948438 1.000000000
#> 225  0.0010140274 0.0023561091  1.495530141 1.000000000
#> 226  0.0106472875 0.0131268933  0.731690511 1.000000000
#> 227  0.0094642555 0.0077415012  0.301140712 1.000000000
#> 228  0.0042251141 0.0033658701 -0.080267080 1.000000000
#> 229  0.0106472875 0.0102659037 -1.026292546 1.000000000
#> 231  0.0018590502 0.0042073376  2.665226586 1.000000000
#> 232  0.0030420821 0.0008414675  3.340721849 1.000000000
#> 233  0.0052391415 0.0025244026  2.650844465 1.000000000
#> 234  0.0114923103 0.0063951531  3.499925995 1.000000000
#> 237  0.0082812236 0.0062268596  0.811688710 1.000000000
#> 239  0.0052391415 0.0042073376  0.005406381 1.000000000
#> 240  0.0076052053 0.0037024571  3.245678866 1.000000000
#> 242  0.0025350684 0.0021878156 -0.662762207 1.000000000
#> 243  0.0016900456 0.0010097610  0.341926454 1.000000000
#> 245  0.0018590502 0.0015146415 -0.564444354 1.000000000
#> 249  0.0011830319 0.0025244026  1.389831238 1.000000000
#> 251  0.0037181004 0.0075732077  3.653175999 1.000000000
#> 252  0.0013520365 0.0010097610 -0.364718331 1.000000000
#> 254  0.0027040730 0.0025244026 -1.018434348 1.000000000
#> 257  0.0033800913 0.0011780545  2.977702940 1.000000000
#> 258  0.0302518168 0.0269269606  0.486123215 1.000000000
#> 259  0.0028730776 0.0018512285  0.631082988 1.000000000
#> 260  0.0055771506 0.0074049142  0.678952259 1.000000000
#> 261  0.0167314517 0.0116122518  2.481858019 1.000000000
#> 262  0.0052391415 0.0074049142  1.210803229 1.000000000
#> 263  0.0331248944 0.0407270279  2.593566226 1.000000000
#> 276  0.0011830319 0.0015146415 -0.524951611 1.000000000
#> 281  0.0008450228 0.0013463480  0.007428494 1.000000000
#> 282  0.0013520365 0.0026926961  1.434514332 1.000000000
#> 283  0.0015210411 0.0018512285 -0.555139447 1.000000000
#> 286  0.0025350684 0.0058902726  3.328862496 1.000000000
#> 295  0.0077742099 0.0038707506  3.177096685 1.000000000
#> 296  0.0016900456 0.0021878156 -0.373390724 1.000000000
#> 297  0.0016900456 0.0016829350 -1.352030184 1.000000000
#> 300  0.0059151597 0.0045439246  0.348020596 1.000000000
#> 301  0.0033800913 0.0030292831 -0.753148238 1.000000000
#> 303  0.0023660639 0.0018512285 -0.275913562 1.000000000
#> 304  0.0008450228 0.0010097610 -0.857248511 1.000000000
#> 306  0.0015210411 0.0023561091  0.382634536 1.000000000
#> 310  0.0011830319 0.0010097610 -0.895984914 1.000000000
#> 312  0.0025350684 0.0020195220 -0.336348342 1.000000000
#> 315  0.0021970593 0.0013463480  0.468237790 1.000000000
#> 319  0.0042251141 0.0055536856  0.390135300 1.000000000
#> 321  0.0011830319 0.0013463480 -0.925710780 1.000000000
#> 322  0.0033800913 0.0023561091  0.441277894 1.000000000
#> 323  0.0010140274 0.0013463480 -0.407303530 1.000000000
#> 324  0.0064221734 0.0089195557  1.301984424 1.000000000
#> 331  0.0008450228 0.0021878156  1.932430518 1.000000000
#> 343  0.0057461551 0.0023561091  3.491221599 1.000000000
#> 344  0.0091262464 0.0052170986  2.979759856 1.000000000
#> 345  0.0047321278 0.0018512285  3.473166556 1.000000000
#> 346  0.0018590502 0.0018512285 -1.308666938 1.000000000
#> 349  0.0013520365 0.0015146415 -0.950320752 1.000000000
#> 350  0.0032110867 0.0047122181  0.647537261 1.000000000
#> 351  0.0023660639 0.0015146415  0.357394075 1.000000000
#> 352  0.0010140274 0.0016829350  0.426913650 1.000000000
#> 353  0.0028730776 0.0031975766 -0.827906054 1.000000000
#> 355  0.0011830319 0.0011780545 -1.305576502 1.000000000
#> 356  0.0103092784 0.0069000337  1.957389065 1.000000000
#> 357  0.0015210411 0.0023561091  0.455222477 1.000000000
#> 358  0.0035490958 0.0075732077  3.333794801 1.000000000
#> 359  0.0027040730 0.0043756311  1.057212972 1.000000000
#> 362  0.0032110867 0.0048805116  1.109321066 1.000000000
#> 363  0.0050701369 0.0053853921 -0.900390376 1.000000000
#> 364  0.0067601825 0.0053853921  0.336756726 1.000000000
#> 366  0.0020280548 0.0016829350 -0.572019460 1.000000000
#> 369  0.0030420821 0.0010097610  2.612534183 1.000000000
#> 375  0.0008450228 0.0021878156  1.901541254 1.000000000
#> 385  0.0116613149 0.0109390778 -0.696797846 1.000000000
#> 389  0.0021970593 0.0008414675  1.750591883 1.000000000
#> 392  0.0212945750 0.0164927634  2.097053327 1.000000000
#> 393  0.0037181004 0.0062268596  1.733703305 1.000000000
#> 394  0.0011830319 0.0021878156  0.914133456 1.000000000
#> 395  0.0057461551 0.0026926961  3.172161523 1.000000000
#> 397  0.0057461551 0.0037024571  1.334247184 1.000000000
#> 401  0.0043941186 0.0028609896  1.064284901 1.000000000
#> 402  0.0065911780 0.0065634467 -1.316965385 1.000000000
#> 403  0.0103092784 0.0047122181  4.472476827 1.000000000
#> 404  0.0033800913 0.0015146415  1.980206547 1.000000000
#> 405  0.0015210411 0.0026926961  0.996541564 1.000000000
#> 406  0.0138583742 0.0109390778  1.060116070 1.000000000
#> 418  0.0008450228 0.0010097610 -0.907285116 1.000000000
#> 419  0.0023660639 0.0026926961 -0.799211867 1.000000000
#> 420  0.0020280548 0.0010097610  0.880735857 1.000000000
#> 423  0.0018590502 0.0018512285 -1.296696211 1.000000000
#> 424  0.0030420821 0.0028609896 -1.034566346 1.000000000
#> 425  0.0023660639 0.0023561091 -1.307015538 1.000000000
#> 434  0.0011830319 0.0016829350 -0.150659873 1.000000000
#> 439  0.0035490958 0.0031975766 -0.803124701 1.000000000
#> 442  0.0020280548 0.0015146415 -0.256479306 1.000000000
#> 444  0.0040561095 0.0050488051  0.041415805 1.000000000
#> 452  0.0013520365 0.0015146415 -1.007728182 1.000000000
#> 459  0.0016900456 0.0015146415 -0.961824422 1.000000000
#> 460  0.0030420821 0.0015146415  1.557301776 1.000000000
#> 463  0.0035490958 0.0037024571 -1.075998801 1.000000000
#> 469  0.0008450228 0.0010097610 -0.860101598 1.000000000
#> 474  0.0023660639 0.0010097610  1.762521125 1.000000000
#> 475  0.0070981917 0.0045439246  1.840726469 1.000000000
#> 476  0.0011830319 0.0028609896  1.948845027 1.000000000
#> 477  0.0021970593 0.0058902726  3.920109125 1.000000000
#> 478  0.0013520365 0.0030292831  1.985277045 1.000000000
#> 481  0.0018590502 0.0045439246  3.261435463 1.000000000
#> 482  0.0008450228 0.0010097610 -0.857501482 1.000000000
#> 483  0.0025350684 0.0023561091 -1.028228988 1.000000000
#> 494  0.0027040730 0.0042073376  0.804218717 1.000000000
#> 497  0.0021970593 0.0015146415  0.178461593 1.000000000
#> 499  0.0050701369 0.0047122181 -0.877838417 1.000000000
#> 514  0.0059151597 0.0048805116 -0.087985539 1.000000000
#> 515  0.0121683285 0.0153147089  1.141610327 1.000000000
#> 516  0.0143653879 0.0095927297  2.645653701 1.000000000
#> 517  0.0049011323 0.0053853921 -0.732609326 1.000000000
#> 518  0.0037181004 0.0063951531  2.164058148 1.000000000
#> 519  0.0236606388 0.0277684281  0.895652783 1.000000000
#> 526  0.0021970593 0.0011780545  0.976723594 1.000000000
#> 529  0.0047321278 0.0037024571  0.050539214 1.000000000
#> 530  0.0018590502 0.0021878156 -0.647805553 1.000000000
#> 531  0.0025350684 0.0040390441  1.103845725 1.000000000
#> 532  0.0011830319 0.0018512285  0.242987697 1.000000000
#> 535  0.0020280548 0.0028609896  0.278456121 1.000000000
#> 537  0.0135203650 0.0087512622  2.766703375 1.000000000
#> 538  0.0133513605 0.0090878492  2.386756495 1.000000000
#> 540  0.0021970593 0.0028609896 -0.132460654 1.000000000
#> 542  0.0040561095 0.0037024571 -0.760655199 1.000000000
#> 545  0.0038871050 0.0033658701 -0.542368344 1.000000000
#> 547  0.0054081460 0.0063951531 -0.095737760 1.000000000
#> 548  0.0013520365 0.0011780545 -0.941059314 1.000000000
#> 550  0.0023660639 0.0053853921  3.253606549 1.000000000
#> 553  0.0020280548 0.0037024571  1.330488380 1.000000000
#> 554  0.0223086023 0.0309660047  3.767771128 1.000000000
#> 555  0.0020280548 0.0011780545  0.663254093 1.000000000
#> 556  0.0052391415 0.0075732077  1.381716551 1.000000000
#> 557  0.0140273787 0.0114439583  0.827215546 1.000000000
#> 558  0.0064221734 0.0058902726 -0.683443971 1.000000000
#> 562  0.0016900456 0.0038707506  2.388170616 1.000000000
#> 573  0.0008450228 0.0010097610 -0.948590806 1.000000000
#> 574  0.0021970593 0.0018512285 -0.613919980 1.000000000
#> 575  0.0037181004 0.0026926961  0.269825240 1.000000000
#> 578  0.0060841643 0.0047122181  0.372180325 1.000000000
#> 720  0.0016550202 0.0012813472 -0.484353999 1.000000000
#> 725  0.0018389114 0.0021965953 -0.622212030 1.000000000
#> 728  0.0011033468 0.0012813472 -0.940245278 1.000000000
#> 731  0.0051489518 0.0016474465  3.908447671 1.000000000
#> 733  0.0020228025 0.0009152480  1.334487617 1.000000000
#> 748  0.0051489518 0.0032948929  1.267119762 1.000000000
#> 749  0.0009194557 0.0010982976 -0.899173816 1.000000000
#> 750  0.0022066936 0.0021965953 -1.298525355 1.000000000
#> 752  0.0055167341 0.0049423394 -0.651312676 1.000000000
#> 805  0.0011033468 0.0014643969 -0.417528950 1.000000000
#> 858  0.0014711291 0.0010982976 -0.361851234 1.000000000
#> 922  0.0009194557 0.0010982976 -0.889593415 1.000000000
#> 925  0.0011033468 0.0009152480 -0.877047683 1.000000000
#> 943  0.0038617139 0.0034779425 -0.782440530 1.000000000
#> 948  0.0022066936 0.0032948929  0.395608063 1.000000000
#> 962  0.0009194557 0.0014643969  0.058300247 1.000000000
#> 965  0.0014711291 0.0021965953  0.073504522 1.000000000
#> 974  0.0055167341 0.0027457441  2.338291365 1.000000000
#> 977  0.0011033468 0.0010982976 -1.308986932 1.000000000
#> 980  0.0012872380 0.0025626945  1.155203018 1.000000000
#> 981  0.0038617139 0.0018304961  2.013320702 1.000000000
#> 982  0.0020228025 0.0023796449 -0.658149580 1.000000000
#> 984  0.0014711291 0.0009152480  0.099317986 1.000000000
#> 987  0.0011033468 0.0012813472 -0.919267313 1.000000000
#> 990  0.0009194557 0.0009152480 -1.298455741 1.000000000
#> 998  0.0023905848 0.0025626945 -1.031161046 1.000000000
#> 1001 0.0022066936 0.0016474465 -0.248419784 1.000000000
#> 1003 0.0033100405 0.0047592898  0.720932655 1.000000000
#> 1007 0.0011033468 0.0027457441  1.930847480 1.000000000
#> 1019 0.0036778227 0.0010982976  3.416401738 1.000000000
#> 1020 0.0060684075 0.0009152480  5.841874856 1.000000000
#> 1023 0.0097462302 0.0042101409  4.527890852 1.000000000
#> 1026 0.0012872380 0.0010982976 -0.901657103 1.000000000
#> 1032 0.0031261493 0.0010982976  2.582989805 1.000000000
#> 1034 0.0023905848 0.0016474465  0.156615969 1.000000000
#> 1035 0.0016550202 0.0009152480  0.495104017 1.000000000
#> 1038 0.0018389114 0.0009152480  0.864844042 1.000000000
#> 1039 0.0020228025 0.0010982976  0.549223557 1.000000000
#> 1040 0.0036778227 0.0009152480  3.644331963 1.000000000
#> 1057 0.0057006252 0.0025626945  2.577494340 1.000000000
#> 1064 0.0034939316 0.0018304961  1.457523755 1.000000000
#> 1071 0.0022066936 0.0010982976  1.069864136 1.000000000
#> 1118 0.0012872380 0.0014643969 -0.895864142 1.000000000
#> 1151 0.0038617139 0.0021965953  1.166187063 1.000000000
#> 1152 0.0062522986 0.0053084386 -0.220754040 1.000000000
#> 1153 0.0060684075 0.0045762402  0.446432788 1.000000000
#> 1154 0.0023905848 0.0020135457 -0.650975040 1.000000000
#> 1155 0.0022066936 0.0018304961 -0.592418513 1.000000000
#> 1156 0.0093784480 0.0098846787 -0.921575674 1.000000000
#> 1167 0.0022066936 0.0016474465 -0.348540748 1.000000000
#> 1169 0.0012872380 0.0020135457  0.244713257 1.000000000
#> 1174 0.0066200809 0.0040270913  1.712449751 1.000000000
#> 1175 0.0057006252 0.0036609921  1.243942722 1.000000000
#> 1180 0.0011033468 0.0012813472 -0.938224223 1.000000000
#> 1185 0.0022066936 0.0018304961 -0.583253207 1.000000000
#> 1188 0.0009194557 0.0032948929  3.250315527 1.000000000
#> 1189 0.0009194557 0.0016474465  0.323743791 1.000000000
#> 1190 0.0079073189 0.0120812740  2.345712642 1.000000000
#> 1192 0.0027583670 0.0025626945 -1.049444611 1.000000000
#> 1193 0.0058845164 0.0040270913  1.108762181 1.000000000
#> 1194 0.0033100405 0.0020135457  0.808314836 1.000000000
#> 1195 0.0104817948 0.0184880103  4.552549941 1.000000000
#> 1266 0.0009194557 0.0031118433  2.944994369 1.000000000
#> 1290 0.0012872380 0.0010982976 -0.913884404 1.000000000
#> 1294 0.0031261493 0.0010982976  2.583630763 1.000000000
#> 1302 0.0009194557 0.0014643969  0.050699022 1.000000000
#> 1322 0.0011033468 0.0032948929  2.530599362 1.000000000
#> 1327 0.0022066936 0.0029287937 -0.078564466 1.000000000
#> 1338 0.0016550202 0.0012813472 -0.511360807 1.000000000
#> 1377 0.0011033468 0.0009152480 -0.817116189 1.000000000
#> 1397 0.0009194557 0.0009152480 -1.300693811 1.000000000
#> 1401 0.0011033468 0.0020135457  0.767260414 1.000000000
#> 1423 0.0022066936 0.0027457441 -0.393929565 1.000000000
#> 1426 0.0016550202 0.0014643969 -0.944873825 1.000000000
#> 1428 0.0016550202 0.0029287937  1.054281688 1.000000000
#> 1505 0.0027583670 0.0012813472  1.470889437 1.000000000
#> 1511 0.0022066936 0.0016474465 -0.271148210 1.000000000
#> 1513 0.0022066936 0.0010982976  1.012043635 1.000000000
#> 1518 0.0031261493 0.0010982976  2.455289559 1.000000000
#> 1522 0.0018389114 0.0010982976  0.382440234 1.000000000
#> 1526 0.0009194557 0.0009152480 -1.261607438 1.000000000
#> 1539 0.0080912100 0.0034779425  4.216057583 1.000000000
#> 1541 0.0012872380 0.0010982976 -0.870097298 1.000000000
#> 1542 0.0044133873 0.0014643969  3.371289794 1.000000000
#> 1543 0.0016550202 0.0009152480  0.502734589 1.000000000
#> 1544 0.0068039720 0.0067728354 -1.220263730 1.000000000
#> 1561 0.0009194557 0.0010982976 -0.891031159 1.000000000
#> 1578 0.0014711291 0.0014643969 -1.267490473 1.000000000
#> 1596 0.0011033468 0.0009152480 -0.881614092 1.000000000
#> 1597 0.0031261493 0.0009152480  2.941972190 1.000000000
#> 1600 0.0044133873 0.0034779425  0.026909101 1.000000000
#> 1611 0.0014711291 0.0020135457 -0.174545370 1.000000000
#> 1618 0.0014711291 0.0016474465 -1.023089774 1.000000000
#> 1631 0.0014711291 0.0014643969 -1.339042843 1.000000000
#> 1637 0.0027583670 0.0027457441 -1.331465861 1.000000000
#> 1646 0.0009194557 0.0012813472 -0.334537484 1.000000000
#> 1650 0.0029422582 0.0016474465  1.102926887 1.000000000
#> 1703 0.0012872380 0.0036609921  2.741343728 1.000000000
#> 1715 0.0018389114 0.0018304961 -1.349118515 1.000000000
#> 1716 0.0027583670 0.0023796449 -0.694066969 1.000000000
#> 1719 0.0049650607 0.0038440417  0.122172669 1.000000000
#> 1750 0.0029422582 0.0018304961  0.608177432 1.000000000
#> 1751 0.0027583670 0.0034779425 -0.216747566 1.000000000
#> 1752 0.0062522986 0.0021965953  4.352367052 1.000000000
#> 1755 0.0069878632 0.0075050339 -0.801727578 1.000000000
#> 1759 0.0011033468 0.0012813472 -0.944865928 1.000000000
#> 1761 0.0011033468 0.0010982976 -1.261760169 1.000000000
#> 1789 0.0012872380 0.0018304961 -0.087626557 1.000000000
#> 1802 0.0009194557 0.0014643969  0.035293610 1.000000000
#> 1808 0.0020228025 0.0020135457 -1.324024199 1.000000000
#> 1809 0.0018389114 0.0010982976  0.286380253 1.000000000
#> 1811 0.0011033468 0.0016474465 -0.077819547 1.000000000
#> 1815 0.0011033468 0.0009152480 -0.836158335 1.000000000
#> 1819 0.0012872380 0.0010982976 -0.905268800 1.000000000
#> 1832 0.0034939316 0.0036609921 -1.058655611 1.000000000
#> 1835 0.0020228025 0.0023796449 -0.602494876 1.000000000
#> 1837 0.0051489518 0.0038440417  0.381500708 1.000000000
#> 1894 0.0018389114 0.0009152480  0.845302947 1.000000000
#> 1899 0.0014711291 0.0009152480  0.053615130 1.000000000
#> 1909 0.0011033468 0.0014643969 -0.414836511 1.000000000
#> 1976 0.0012872380 0.0009152480 -0.348065617 1.000000000
#> 1980 0.0009194557 0.0020135457  1.169598032 1.000000000
#> 2027 0.0018389114 0.0014643969 -0.516578742 1.000000000
#> 2073 0.0016550202 0.0009152480  0.458608192 1.000000000
#> 2076 0.0022066936 0.0023796449 -1.040620770 1.000000000
#> 2086 0.0014711291 0.0010982976 -0.379597814 1.000000000
#> 2163 0.0018389114 0.0012813472 -0.092810069 1.000000000
#> 2167 0.0016550202 0.0021965953 -0.250824466 1.000000000
#> 2189 0.0012872380 0.0009152480 -0.383072429 1.000000000
#> 2219 0.0014711291 0.0023796449  0.425433010 1.000000000
#> 2223 0.0014711291 0.0034779425  2.293550330 1.000000000
#> 2225 0.0025744759 0.0036609921  0.393568085 1.000000000
#> 2226 0.0031261493 0.0018304961  0.800973011 1.000000000
#> 2227 0.0011033468 0.0020135457  0.557141973 1.000000000
#> 2228 0.0033100405 0.0038440417 -0.592451035 1.000000000
#> 2232 0.0053328430 0.0020135457  3.137296782 1.000000000
#> 2234 0.0031261493 0.0021965953  0.287244665 1.000000000
#> 2235 0.0023905848 0.0012813472  0.940748727 1.000000000
#> 2238 0.0016550202 0.0016474465 -1.253050944 1.000000000
#> 2240 0.0011033468 0.0018304961  0.384189918 1.000000000
#> 2241 0.0012872380 0.0012813472 -1.352874838 1.000000000
#> 2250 0.0012872380 0.0032948929  2.298369132 1.000000000
#> 2253 0.0011033468 0.0010982976 -1.324957074 1.000000000
#> 2256 0.0053328430 0.0076880835  0.926041183 1.000000000
#> 2257 0.0011033468 0.0009152480 -0.858470049 1.000000000
#> 2258 0.0009194557 0.0020135457  1.093529416 1.000000000
#> 2259 0.0044133873 0.0027457441  0.956463283 1.000000000
#> 2260 0.0022066936 0.0025626945 -0.711953904 1.000000000
#> 2261 0.0088267745 0.0117151748  1.179536195 1.000000000
#> 2300 0.0018389114 0.0018304961 -1.287266955 1.000000000
#> 2334 0.0079073189 0.0045762402  2.495502938 1.000000000
#> 2339 0.0022066936 0.0012813472  0.529103990 1.000000000
#> 2342 0.0011033468 0.0010982976 -1.279299629 1.000000000
#> 2343 0.0022066936 0.0020135457 -1.014430592 1.000000000
#> 2344 0.0033100405 0.0018304961  1.329480384 1.000000000
#> 2347 0.0044133873 0.0031118433  0.507215418 1.000000000
#> 2361 0.0009194557 0.0010982976 -0.873702891 1.000000000
#> 2372 0.0012872380 0.0009152480 -0.301975795 1.000000000
#> 2377 0.0016550202 0.0012813472 -0.473838993 1.000000000
#> 2388 0.0011033468 0.0016474465 -0.095347590 1.000000000
#> 2396 0.0016550202 0.0009152480  0.542179845 1.000000000
#> 2398 0.0009194557 0.0020135457  1.112441422 1.000000000
#> 2415 0.0009194557 0.0018304961  0.847798134 1.000000000
#> 2418 0.0014711291 0.0012813472 -0.948662732 1.000000000
#> 2425 0.0011033468 0.0023796449  1.417964243 1.000000000
#> 2426 0.0029422582 0.0071389347  3.946952461 1.000000000
#> 2427 0.0051489518 0.0038440417  0.380915937 1.000000000
#> 2428 0.0014711291 0.0020135457 -0.217167668 1.000000000
#> 2429 0.0011033468 0.0032948929  2.724928924 1.000000000
#> 2430 0.0095623391 0.0122643236  0.925956384 1.000000000
#> 2440 0.0016550202 0.0016474465 -1.316833138 1.000000000
#> 2442 0.0009194557 0.0012813472 -0.392133345 1.000000000
#> 2447 0.0034939316 0.0020135457  1.082933582 1.000000000
#> 2448 0.0051489518 0.0036609921  0.608209936 1.000000000
#> 2450 0.0023905848 0.0010982976  1.530998085 1.000000000
#> 2451 0.0009194557 0.0018304961  0.776417276 1.000000000
#> 2453 0.0016550202 0.0018304961 -0.996569812 1.000000000
#> 2455 0.0016550202 0.0016474465 -1.296322902 1.000000000
#> 2457 0.0020228025 0.0018304961 -0.949706596 1.000000000
#> 2459 0.0011033468 0.0014643969 -0.447340085 1.000000000
#> 2463 0.0073556455 0.0126304228  3.428293090 1.000000000
#> 2465 0.0009194557 0.0040270913  4.443045500 1.000000000
#> 2466 0.0040456050 0.0045762402 -0.618670018 1.000000000
#> 2467 0.0016550202 0.0023796449  0.006677611 1.000000000
#> 2468 0.0084589923 0.0201354567  4.048296249 1.000000000
#> 2520 0.0016550202 0.0010982976 -0.048927835 1.000000000
#> 2536 0.0011033468 0.0012813472 -0.933263528 1.000000000
#> 2540 0.0033100405 0.0016474465  1.603096030 1.000000000
#> 2873 0.0021969243 0.0009956193  1.197398148 1.000000000
#> 2887 0.0013980427 0.0011947431 -0.931432136 1.000000000
#> 2889 0.0013980427 0.0009956193 -0.360968720 1.000000000
#> 2891 0.0019972039 0.0013938670 -0.144665206 1.000000000
#> 3227 0.0009986020 0.0015929908  0.036874104 1.000000000
#> 3246 0.0015977631 0.0015929908 -1.296521453 1.000000000
#> 3343 0.0009986020 0.0011947431 -0.883695558 1.000000000
#> 3347 0.0015977631 0.0011947431 -0.419733940 1.000000000
#> 3405 0.0009986020 0.0011947431 -0.862005400 1.000000000
#> 3426 0.0011983223 0.0013938670 -0.957125264 1.000000000
#> 3493 0.0025963651 0.0011947431  1.473800237 1.000000000
#> 3498 0.0033952467 0.0017921147  1.269380160 1.000000000
#> 3606 0.0025963651 0.0019912386 -0.270378048 1.000000000
#> 3623 0.0009986020 0.0011947431 -0.874104241 1.000000000
#> 3822 0.0015977631 0.0011947431 -0.433531978 1.000000000
#> 3826 0.0009986020 0.0009956193 -1.243890471 1.000000000
#> 3839 0.0023966447 0.0029868578 -0.510131526 1.000000000
#> 3844 0.0033952467 0.0041816010 -0.257586777 1.000000000
#> 3894 0.0043938486 0.0017921147  2.635725114 1.000000000
#> 3905 0.0013980427 0.0015929908 -0.912262282 1.000000000
#> 3964 0.0013980427 0.0011947431 -0.927557943 1.000000000
#> 3967 0.0035949670 0.0041816010 -0.619537778 1.000000000
#> 3983 0.0015977631 0.0011947431 -0.424571391 1.000000000
#> 3984 0.0015977631 0.0013938670 -0.914371158 1.000000000
#> 3998 0.0039944078 0.0045798487 -0.582091773 1.000000000
#> 4001 0.0017974835 0.0021903624 -0.636137778 1.000000000
#> 4003 0.0023966447 0.0071684588  4.474522323 1.000000000
#> 4239 0.0011983223 0.0017921147 -0.020677632 1.000000000
#> 4719 0.0021969243 0.0011947431  0.738483084 1.000000000
#> 4722 0.0019972039 0.0009956193  0.857221642 1.000000000
#> 4748 0.0009986020 0.0021903624  1.182847605 1.000000000
#> 4753 0.0027960855 0.0025886101 -1.017206779 1.000000000
#> 4885 0.0013980427 0.0013938670 -1.261031208 1.000000000
#> 4890 0.0011983223 0.0013938670 -0.912545163 1.000000000
#> 5143 0.0011983223 0.0009956193 -0.885234492 1.000000000
#> 5156 0.0011983223 0.0009956193 -0.905437268 1.000000000
#> 5160 0.0027960855 0.0011947431  1.723720009 1.000000000
#> 5218 0.0011983223 0.0009956193 -0.935851801 1.000000000
#> 5222 0.0015977631 0.0011947431 -0.446577515 1.000000000
#> 5243 0.0023966447 0.0021903624 -0.948467398 1.000000000
#> 5245 0.0011983223 0.0013938670 -0.874074161 1.000000000
#> 5247 0.0021969243 0.0027877340 -0.332767183 1.000000000
#> 5459 0.0009986020 0.0009956193 -1.271286646 1.000000000
#> 5487 0.0013980427 0.0019912386 -0.141257492 1.000000000
#> 6204 0.0009986020 0.0009956193 -1.294677649 1.000000000
#> 6225 0.0013980427 0.0021903624  0.210679820 1.000000000
#> 6238 0.0027960855 0.0009956193  1.911058452 1.000000000
#> 6261 0.0015977631 0.0009956193  0.058338969 1.000000000
#> 6325 0.0013980427 0.0031859817  1.600064302 1.000000000
#> 6340 0.0009986020 0.0013938670 -0.372144279 1.000000000
#> 6352 0.0019972039 0.0035842294  1.136103711 1.000000000
#> 6357 0.0027960855 0.0065710872  3.221039670 1.000000000
#> 6504 0.0021969243 0.0015929908 -0.195879335 1.000000000
#> 6561 0.0019972039 0.0009956193  0.871499340 1.000000000
#> 6747 0.0021969243 0.0009956193  1.226161793 1.000000000
#> 6748 0.0009986020 0.0009956193 -1.282065158 1.000000000
#> 6765 0.0017974835 0.0033851055  1.206167386 1.000000000
#> 6769 0.0009986020 0.0011947431 -0.922787123 1.000000000
#> 6770 0.0031955263 0.0051772202  1.252765725 1.000000000
#> 6791 0.0011983223 0.0011947431 -1.229346334 1.000000000
#> 6810 0.0011983223 0.0013938670 -0.915993223 1.000000000
#> 6821 0.0019972039 0.0013938670 -0.087503091 1.000000000
#> 6873 0.0011983223 0.0025886101  1.430582279 1.000000000
#> 6874 0.0015977631 0.0015929908 -1.308989836 1.000000000
#> 6877 0.0027960855 0.0059737157  2.642491844 1.000000000
#> 6893 0.0017974835 0.0013938670 -0.463039387 1.000000000
#> 6897 0.0011983223 0.0011947431 -1.297808881 1.000000000
#> 6905 0.0017974835 0.0063719634  4.842833030 1.000000000
#> 6908 0.0017974835 0.0017921147 -1.316955802 1.000000000
#> 6910 0.0041941282 0.0095579450  2.078790057 1.000000000
#> 7051 0.0015977631 0.0009956193  0.098976162 1.000000000
# }
```
