library(tna)
model <- tna(group_regulation)
result <- centralities(model, measures = c("OutStrength", "InStrength", "ClosenessIn", "ClosenessOut",
                                           "Closeness", "Betweenness", "PageRank"))
as.data.frame(result)
