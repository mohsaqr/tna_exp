sequences <- as.matrix(read.csv("../data/group_regulation.csv", na.strings = ""))
states <- sort(unique(na.omit(c(sequences))))
from <- factor(sequences[, -ncol(sequences)], levels = states)
to <- factor(sequences[, -1], levels = states)
counts <- table(from, to)
weights <- unclass(prop.table(counts, 1))
diag(weights) <- 0
n <- length(states)
# Diffusion: expected number of visits started from a state over walks of 1 to n steps.
powers <- Reduce(`%*%`, rep(list(weights), n), accumulate = TRUE)
diffusion <- rowSums(Reduce(`+`, powers))
# Clustering: sum over j, k of u[i, j] u[j, k] u[k, i], over
# (sum of u[i, ])^2 - sum of u[i, ]^2, with u the symmetrised weights.
u <- weights + t(weights)
triangles <- vapply(seq_len(n), function(i) sum(outer(u[i, ], u[, i]) * u), numeric(1))
result <- data.frame(
  state = states,
  Diffusion = (diffusion - min(diffusion)) / (max(diffusion) - min(diffusion)),
  Clustering = triangles / (rowSums(u)^2 - rowSums(u^2))
)
result
