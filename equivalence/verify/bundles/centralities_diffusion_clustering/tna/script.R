library(tna)
model <- tna(group_regulation)
result <- centralities(model, measures = c("Diffusion", "Clustering"))
as.data.frame(result)
