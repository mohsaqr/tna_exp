# prepare_data(): an event log (actor, time, action) cut into sessions, one sequence per session, and the model
# built from it (build_model.tna_data()). The reference is the definition in base R: the events of an actor in
# time order, a new session wherever the gap to the previous event exceeds the threshold. The bundled
# group_regulation_long log, 27533 events of 2000 actors.
# Tolerances: the sequences are words (equal or not); a probability is a ratio of two whole counts (1e-12).

by_definition <- "independent: sessions cut in base R where the gap to the previous event exceeds the threshold"

#' Sessions of an event log, as the definition gives them
#'
#' @param log The event log.
#' @param threshold The largest gap, in seconds, within a session.
#' @return A data frame: session, position, action.
ref_sessions <- function(log, threshold) {
  ordered <- log[order(log$Actor, log$Time, seq_len(nrow(log))), ]
  gap <- c(Inf, diff(as.numeric(ordered$Time)))
  first <- c(TRUE, ordered$Actor[-1L] != ordered$Actor[-nrow(ordered)])
  starts <- first | gap > threshold
  number <- stats::ave(as.integer(starts), ordered$Actor, FUN = cumsum)
  session <- paste0(ordered$Actor, " s", number)
  position <- stats::ave(seq_len(nrow(ordered)), session, FUN = seq_along)
  data.frame(session = session, position = position, action = ordered$Action)
}

#' The cells of tna's sequence table, one row per observed time point
#'
#' @param sequences The wide sequence table.
#' @param sessions The session of each row.
#' @return A data frame: session, position, action.
ref_cells_of <- function(sequences, sessions) {
  cells <- as.matrix(sequences)
  observed <- which(!is.na(cells), arr.ind = TRUE)
  data.frame(session = sessions[observed[, "row"]], position = observed[, "col"], action = cells[observed])
}

test_that("sessions are cut where the gap exceeds the threshold", {
  log <- as.data.frame(group_regulation_long)
  prepared <- prepare_data(group_regulation_long, actor = "Actor", time = "Time", action = "Action",
                           time_threshold = 300)
  expected <- ref_sessions(log, threshold = 300)
  expect_reference(ref_cells_of(prepared$sequence_data, prepared$meta_data$.session_id), expected,
                   reference = by_definition, covers = "prepare_data()", quantity = "action, threshold 300 s",
                   tolerance = 0, key = c("session", "position"))
  default <- prepare_data(group_regulation_long, actor = "Actor", time = "Time", action = "Action")
  expect_reference(ref_cells_of(default$sequence_data, default$meta_data$.session_id),
                   ref_sessions(log, threshold = 900), reference = by_definition, covers = "prepare_data()",
                   quantity = "action, threshold 900 s", tolerance = 0, key = c("session", "position"))
})

test_that("the model of prepared data counts the transitions within sessions", {
  log <- as.data.frame(group_regulation_long)
  expected <- ref_sessions(log, threshold = 300)
  sessions <- split(expected$action, expected$session)
  from <- unlist(lapply(sessions, \(events) utils::head(events, -1L)))
  to <- unlist(lapply(sessions, \(events) utils::tail(events, -1L)))
  states <- sort(unique(expected$action), method = "radix")
  counts <- table(factor(from, states), factor(to, states))
  probabilities <- matrix(as.numeric(prop.table(counts, 1L)), length(states), dimnames = list(states, states))
  prepared <- prepare_data(group_regulation_long, actor = "Actor", time = "Time", action = "Action",
                           time_threshold = 300)
  expect_reference(tna(prepared)$weights, probabilities, reference = by_definition,
                   covers = c("build_model.tna_data()", "tna()", "prepare_data()"),
                   quantity = "transition probability within sessions", tolerance = 1e-12)
})

test_that("the model of prepared data equals TraMineR's rates of the sessions", {
  skip_without_reference("TraMineR")
  log <- as.data.frame(group_regulation_long)
  expected <- ref_sessions(log, threshold = 300)
  # the sessions, cut in base R, as a wide table for TraMineR
  sessions <- split(expected$action, expected$session)
  longest <- max(lengths(sessions))
  wide <- as.data.frame(do.call(rbind, lapply(sessions, \(events) c(events, rep(NA, longest - length(events))))))
  sequences <- suppressMessages(TraMineR::seqdef(wide))
  alphabet <- TraMineR::alphabet(sequences)
  rates <- `dimnames<-`(suppressMessages(TraMineR::seqtrate(sequences)), list(alphabet, alphabet))
  prepared <- prepare_data(group_regulation_long, actor = "Actor", time = "Time", action = "Action",
                           time_threshold = 300)
  expect_reference(tna(prepared)$weights, rates, reference = "TraMineR",
                   covers = c("build_model.tna_data()", "tna()", "prepare_data()"),
                   quantity = "transition probability within sessions", tolerance = 1e-12)
})

test_that("prepare_data() recovers the sequences of simulab's event logs", {
  # simulab::simulate_event_log() spaces an actor's events 60 to 600 seconds apart; with a threshold of 900 seconds
  # every actor is one session, which must be the actor's simulated sequence (simulab's "wide" table).
  lapply(1:3, \(seed) {
    simulated <- simulab::simulate_event_log(groups = 3, actors = 40, sequence_length = c(5L, 25L), seed = seed)
    log <- as.data.frame(simulated)
    truth <- as.data.frame(simulated, what = "wide")
    prepared <- prepare_data(log, actor = "id", time = "timestamp", action = "state", time_threshold = 900)
    found <- ref_cells_of(prepared$sequence_data, prepared$meta_data$id)
    steps <- grep("^S[0-9]+$", names(truth), value = TRUE)
    true_cells <- do.call(rbind, lapply(steps, \(step) {
      data.frame(session = truth$id, position = as.integer(substring(step, 2L)), action = truth[[step]])
    }))
    true_cells <- true_cells[!is.na(true_cells$action), ]
    expect_reference(found, true_cells,
                     reference = "independent: recovery of the sequences of simulab simulate_event_log()",
                     covers = "prepare_data()", quantity = sprintf("action of an actor's sequence, seed %d", seed),
                     tolerance = 0, key = c("session", "position"))
  })
})
