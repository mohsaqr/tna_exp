# Print Bootstrap Results

Print Bootstrap Results

## Usage

``` r
# S3 method for class 'tna_bootstrap'
print(x, digits = getOption("digits"), type = "both", ...)
```

## Arguments

- x:

  A `tna_bootstrap` object.

- digits:

  An `integer` giving the minimal number of *significant* digits to
  print.

- type:

  A `character` vector giving the type of edges to print. The default
  option `"both"` prints both statistically significant and
  non-significant edges, `"sig"` prints only significant edges, and
  `"nonsig"` prints only the non-significant edges.

- ...:

  Ignored.

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
[`print.summary.group_tna_bootstrap()`](https://sonsoles.me/tna/reference/print.summary.group_tna_bootstrap.md),
[`print.summary.tna_bootstrap()`](https://sonsoles.me/tna/reference/print.summary.tna_bootstrap.md),
[`print.summary.tna_markov_order()`](https://sonsoles.me/tna/reference/print.summary.tna_markov_order.md),
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
model <- tna(group_regulation)
# Small number of iterations for CRAN
boot <- bootstrap(model, iter = 10)
print(boot)
#> Non-significant Edges
#> 
#>          from         to       weight    p_value     cr_lower    cr_upper
#> 2    cohesion      adapt 0.0029498525 0.45454545 0.0022123894 0.003687316
#> 3   consensus      adapt 0.0047400853 0.27272727 0.0035550640 0.005925107
#> 4  coregulate      adapt 0.0162436548 0.09090909 0.0121827411 0.020304569
#> 5     discuss      adapt 0.0713743356 0.09090909 0.0535307517 0.089217920
#> 6     emotion      adapt 0.0024673951 0.63636364 0.0018505464 0.003084244
#> 7     monitor      adapt 0.0111653873 0.45454545 0.0083740405 0.013956734
#> 8        plan      adapt 0.0009745006 0.45454545 0.0007308754 0.001218126
#> 9   synthesis      adapt 0.2346625767 0.09090909 0.1759969325 0.293328221
#> 10      adapt   cohesion 0.2730844794 0.09090909 0.2048133595 0.341355599
#> 11   cohesion   cohesion 0.0271386431 0.27272727 0.0203539823 0.033923304
#> 12  consensus   cohesion 0.0148522673 0.09090909 0.0111392005 0.018565334
#> 13 coregulate   cohesion 0.0360406091 0.09090909 0.0270304569 0.045050761
#> 14    discuss   cohesion 0.0475828904 0.09090909 0.0356871678 0.059478613
#> 15    emotion   cohesion 0.3253436729 0.09090909 0.2440077547 0.406679591
#> 16    monitor   cohesion 0.0558269365 0.18181818 0.0418702024 0.069783671
#> 17       plan   cohesion 0.0251745980 0.09090909 0.0188809485 0.031468248
#> 18  synthesis   cohesion 0.0337423313 0.36363636 0.0253067485 0.042177914
#> 19      adapt  consensus 0.4774066798 0.09090909 0.3580550098 0.596758350
#> 20   cohesion  consensus 0.4979351032 0.09090909 0.3734513274 0.622418879
#> 21  consensus  consensus 0.0820034761 0.09090909 0.0615026070 0.102504345
#> 22 coregulate  consensus 0.1345177665 0.09090909 0.1008883249 0.168147208
#> 23    discuss  consensus 0.3211845103 0.09090909 0.2408883827 0.401480638
#> 24    emotion  consensus 0.3204088826 0.09090909 0.2403066620 0.400511103
#> 25    monitor  consensus 0.1591067690 0.09090909 0.1193300768 0.198883461
#> 26       plan  consensus 0.2904011694 0.09090909 0.2178008771 0.363001462
#> 27  synthesis  consensus 0.4662576687 0.09090909 0.3496932515 0.582822086
#> 28      adapt coregulate 0.0216110020 0.36363636 0.0162082515 0.027013752
#> 29   cohesion coregulate 0.1191740413 0.09090909 0.0893805310 0.148967552
#> 30  consensus coregulate 0.1877073787 0.09090909 0.1407805340 0.234634223
#> 31 coregulate coregulate 0.0233502538 0.36363636 0.0175126904 0.029187817
#> 32    discuss coregulate 0.0842824601 0.09090909 0.0632118451 0.105353075
#> 33    emotion coregulate 0.0341910469 0.09090909 0.0256432852 0.042738809
#> 34    monitor coregulate 0.0579204466 0.18181818 0.0434403350 0.072400558
#> 35       plan coregulate 0.0172161767 0.18181818 0.0129121325 0.021520221
#> 36  synthesis coregulate 0.0444785276 0.36363636 0.0333588957 0.055598160
#> 37      adapt    discuss 0.0589390963 0.09090909 0.0442043222 0.073673870
#> 38   cohesion    discuss 0.0595870206 0.09090909 0.0446902655 0.074483776
#> 39  consensus    discuss 0.1880233844 0.09090909 0.1410175383 0.235029231
#> 40 coregulate    discuss 0.2736040609 0.09090909 0.2052030457 0.342005076
#> 41    discuss    discuss 0.1948873703 0.09090909 0.1461655277 0.243609213
#> 42    emotion    discuss 0.1018681706 0.09090909 0.0764011280 0.127335213
#> 43    monitor    discuss 0.3754361479 0.09090909 0.2815771110 0.469295185
#> 44       plan    discuss 0.0678902063 0.09090909 0.0509176547 0.084862758
#> 45  synthesis    discuss 0.0628834356 0.18181818 0.0471625767 0.078604294
#> 46      adapt    emotion 0.1198428291 0.18181818 0.0898821218 0.149803536
#> 47   cohesion    emotion 0.1156342183 0.09090909 0.0867256637 0.144542773
#> 48  consensus    emotion 0.0726813083 0.09090909 0.0545109812 0.090851635
#> 49 coregulate    emotion 0.1720812183 0.09090909 0.1290609137 0.215101523
#> 50    discuss    emotion 0.1057960010 0.09090909 0.0793470008 0.132245001
#> 51    emotion    emotion 0.0768417342 0.09090909 0.0576313007 0.096052168
#> 52    monitor    emotion 0.0907187718 0.09090909 0.0680390789 0.113398465
#> 53       plan    emotion 0.1468247523 0.09090909 0.1101185642 0.183530940
#> 54  synthesis    emotion 0.0705521472 0.27272727 0.0529141104 0.088190184
#> 55      adapt    monitor 0.0333988212 0.09090909 0.0250491159 0.041748527
#> 56   cohesion    monitor 0.0330383481 0.09090909 0.0247787611 0.041297935
#> 57  consensus    monitor 0.0466108390 0.09090909 0.0349581292 0.058263549
#> 58 coregulate    monitor 0.0862944162 0.09090909 0.0647208122 0.107868020
#> 59    discuss    monitor 0.0222728423 0.09090909 0.0167046317 0.027841053
#> 60    emotion    monitor 0.0363059570 0.09090909 0.0272294677 0.045382446
#> 61    monitor    monitor 0.0181437544 0.36363636 0.0136078158 0.022679693
#> 62       plan    monitor 0.0755237941 0.09090909 0.0566428455 0.094404743
#> 63  synthesis    monitor 0.0122699387 0.54545455 0.0092024540 0.015337423
#> 64      adapt       plan 0.0157170923 0.72727273 0.0117878193 0.019646365
#> 65   cohesion       plan 0.1410029499 0.09090909 0.1057522124 0.176253687
#> 66  consensus       plan 0.3957971243 0.09090909 0.2968478433 0.494746405
#> 67 coregulate       plan 0.2390862944 0.09090909 0.1793147208 0.298857868
#> 68    discuss       plan 0.0116426221 0.09090909 0.0087319666 0.014553278
#> 69    emotion       plan 0.0997532605 0.09090909 0.0748149454 0.124691576
#> 70    monitor       plan 0.2156315422 0.09090909 0.1617236567 0.269539428
#> 71       plan       plan 0.3742082183 0.09090909 0.2806561637 0.467760273
#> 72  synthesis       plan 0.0751533742 0.18181818 0.0563650307 0.093941718
#> 74   cohesion  synthesis 0.0035398230 0.81818182 0.0026548673 0.004424779
#> 75  consensus  synthesis 0.0075841365 0.18181818 0.0056881024 0.009480171
#> 76 coregulate  synthesis 0.0187817259 0.27272727 0.0140862944 0.023477157
#> 77    discuss  synthesis 0.1409769679 0.09090909 0.1057327259 0.176221210
#> 78    emotion  synthesis 0.0028198802 0.54545455 0.0021149101 0.003524850
#> 79    monitor  synthesis 0.0160502442 0.18181818 0.0120376832 0.020062805
#> 80       plan  synthesis 0.0017865844 0.36363636 0.0013399383 0.002233230
#>        ci_lower    ci_upper
#> 2  0.0007311500 0.003083226
#> 3  0.0031256679 0.005701928
#> 4  0.0156030536 0.018224805
#> 5  0.0664363927 0.080319943
#> 6  0.0012290138 0.004761140
#> 7  0.0054936687 0.017066255
#> 8  0.0008016162 0.001942880
#> 9  0.2043095829 0.252438786
#> 10 0.2543054802 0.295604533
#> 11 0.0179146261 0.029381226
#> 12 0.0118908304 0.016848268
#> 13 0.0325090779 0.043473374
#> 14 0.0440065661 0.055484874
#> 15 0.3049281219 0.333385863
#> 16 0.0472727185 0.069776773
#> 17 0.0219075212 0.027294398
#> 18 0.0221860284 0.042947114
#> 19 0.4506978344 0.495874751
#> 20 0.4958957541 0.521512329
#> 21 0.0780307592 0.089265187
#> 22 0.1209750137 0.141298380
#> 23 0.3184993214 0.328958974
#> 24 0.3111608651 0.337441292
#> 25 0.1483529959 0.174215604
#> 26 0.2805945945 0.293311910
#> 27 0.4448067633 0.503716861
#> 28 0.0140327110 0.023415842
#> 29 0.1102228355 0.123786163
#> 30 0.1857641462 0.197638360
#> 31 0.0181239927 0.030198233
#> 32 0.0786945112 0.091516114
#> 33 0.0315682510 0.039367612
#> 34 0.0452347642 0.067023957
#> 35 0.0136442527 0.018826480
#> 36 0.0299941176 0.054560984
#> 37 0.0481121518 0.068955532
#> 38 0.0507039524 0.067275781
#> 39 0.1784964026 0.193711134
#> 40 0.2621066681 0.280731639
#> 41 0.1797204538 0.202702931
#> 42 0.0909930584 0.109185391
#> 43 0.3482163700 0.392625790
#> 44 0.0641984842 0.076389532
#> 45 0.0451208679 0.073256780
#> 46 0.1032689465 0.150974695
#> 47 0.1059260033 0.126628403
#> 48 0.0688642169 0.077088790
#> 49 0.1643595885 0.183974273
#> 50 0.0977297947 0.112979333
#> 51 0.0687006334 0.078714476
#> 52 0.0878272709 0.097269345
#> 53 0.1430019401 0.152695483
#> 54 0.0638400369 0.090687800
#> 55 0.0257656044 0.035614807
#> 56 0.0259926379 0.037816581
#> 57 0.0438141848 0.049814016
#> 58 0.0805598394 0.089987340
#> 59 0.0191786931 0.026883244
#> 60 0.0331253865 0.041123210
#> 61 0.0134962701 0.025164255
#> 62 0.0711719742 0.081292800
#> 63 0.0069048459 0.021358740
#> 64 0.0099328907 0.031962696
#> 65 0.1277852763 0.146926628
#> 66 0.3874413493 0.404971094
#> 67 0.2220440464 0.245197216
#> 68 0.0099193558 0.013231432
#> 69 0.0909329893 0.111430671
#> 70 0.2031686178 0.226866349
#> 71 0.3641611346 0.389177936
#> 72 0.0552968335 0.081758798
#> 74 0.0003972925 0.005640768
#> 75 0.0063334082 0.009655972
#> 76 0.0128496791 0.023479706
#> 77 0.1334904913 0.146525787
#> 78 0.0008651970 0.003418952
#> 79 0.0117094919 0.019058612
#> 80 0.0013305526 0.002402612
```
