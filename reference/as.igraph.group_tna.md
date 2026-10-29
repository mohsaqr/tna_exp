# Coerce a Specific Group from a `group_tna` Object into an `igraph` Object.

Coerce a Specific Group from a `group_tna` Object into an `igraph`
Object.

## Usage

``` r
# S3 method for class 'group_tna'
as.igraph(x, which, ...)
```

## Arguments

- x:

  The object to convert.

- which:

  The number or name of the group.

- ...:

  Additional arguments. None currently.

## Value

An `igraph` object.

## See also

Helper functions
[`as.igraph.matrix()`](https://sonsoles.me/tna/reference/as.igraph.matrix.md),
[`as.igraph.tna()`](https://sonsoles.me/tna/reference/as.igraph.tna.md)

## Examples

``` r
model <- group_model(engagement_mmm)
as.igraph(model, which = 1)
#> IGRAPH 81f88ad DNW- 3 9 -- 
#> + attr: name (v/c), weight (e/n)
#> + edges from 81f88ad (vertex names):
#> [1] Disengaged->Disengaged Disengaged->Engaged    Disengaged->Moderate  
#> [4] Engaged   ->Disengaged Engaged   ->Engaged    Engaged   ->Moderate  
#> [7] Moderate  ->Disengaged Moderate  ->Engaged    Moderate  ->Moderate  
```
