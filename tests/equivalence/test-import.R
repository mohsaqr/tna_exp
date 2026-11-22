# import_data() and import_onehot(): reshapings, each written again in base R from its documentation.
#
# import_data(): zeros become missing (replace_zeros = TRUE); consecutive rows form windows of `window_size`
# rows; every observed value of `cols` is one event (`action` = the column, `value`); `order` numbers the events of
# a window and combination of `id_cols`, row by row; the table is sorted by the id columns, the window and `order`.
# The documentation does not say in which order the actions of one row come: import_data() sorts them by column
# name, the reference below takes the order of `cols`. With column names in alphabetical order the two orders are
# one and the comparison must agree; with other names the difference is recorded as known.
#
# import_onehot(): one output row per actor and session (per `interval` windows when given), columns
# W<window>_T<position>; a cell holds the name of the active column or nothing. Tumbling windows group
# `window_size` consecutive rows; a sliding window of width w at row t marks the columns active in rows t - w + 1
# .. t, and the first w - 1 rows are dropped (tna 1.5.4 NEWS); `aggregate = TRUE` keeps one mark per column and
# window. The cells are compared one by one (an empty cell is "-" on both sides).

#' import_data() written from its documentation
import_data_defined <- function(data, cols, id_cols, window_size = 1, replace_zeros = TRUE) {
  window <- ceiling(seq_len(nrow(data)) / window_size)
  events <- do.call(rbind, lapply(seq_len(nrow(data)), \(r) {
    values <- unlist(data[r, cols])
    keep <- !is.na(values) & !(replace_zeros & values == 0)
    data.frame(.row = rep(r, sum(keep)), .window = rep(window[[r]], sum(keep)), action = cols[keep],
               value = unname(values[keep]))
  }))
  ids <- data[events$.row, id_cols, drop = FALSE]
  unit <- do.call(paste, c(list(events$.window), ids, sep = "\r"))
  events$order <- stats::ave(seq_len(nrow(events)), unit, FUN = seq_along)
  extra <- setdiff(names(data), c(cols, id_cols))
  out <- data.frame(data[events$.row, extra, drop = FALSE], ids, events[c("action", "value", "order")],
                    row.names = NULL, check.names = FALSE)
  sorted <- do.call(order, c(unname(as.list(ids)), list(events$.window, events$order)))
  out <- out[sorted, , drop = FALSE]
  out$row <- seq_len(nrow(out))
  out
}

#' import_onehot() written from its documentation, as one row per output cell
onehot_defined <- function(data, cols, actor, session, window_size = 1L, window_type = "tumbling", interval = Inf,
                           aggregate = FALSE) {
  key <- paste(data[[actor]], data[[session]], sep = "\r")
  cells <- do.call(rbind, lapply(unique(key), \(unit) {
    active <- as.matrix(data[key == unit, cols]) == 1
    windows <- if (window_type == "sliding") {
      lapply(seq.int(window_size, nrow(active)), \(t) {
        matrix(colSums(active[seq.int(t - window_size + 1L, t), , drop = FALSE]) > 0, 1L)
      })
    } else {
      lapply(split(seq_len(nrow(active)), (seq_len(nrow(active)) - 1L) %/% window_size), \(rows) active[rows, , drop = FALSE])
    }
    if (aggregate) windows <- lapply(windows, \(w) matrix(colSums(w) > 0, 1L))
    do.call(rbind, Map(\(w, k) {
      marks <- as.vector(t(w))
      data.frame(unit = paste(unit, k %/% interval, sep = "\r"),
                 cell = sprintf("W%d_T%d", k %% interval, seq_along(marks)),
                 value = ifelse(marks, rep(cols, times = nrow(w)), "-"))
    }, windows, seq_along(windows) - 1L))
  }))
  cells$row <- match(cells$unit, unique(cells$unit))
  grid <- expand.grid(row = unique(cells$row), cell = unique(cells$cell), stringsAsFactors = FALSE)
  merged <- merge(grid, cells[c("row", "cell", "value")], by = c("row", "cell"), all.x = TRUE)
  merged$value[is.na(merged$value)] <- "-"
  merged
}

#' A wide output table as one row per cell
onehot_cells <- function(wide) {
  wide <- as.data.frame(wide)
  values <- unlist(lapply(wide, as.character), use.names = FALSE)
  data.frame(row = rep(seq_len(nrow(wide)), ncol(wide)), cell = rep(names(wide), each = nrow(wide)),
             value = ifelse(is.na(values), "-", values))
}

events <- data.frame(ID = c("A", "A", "B", "B", "A", "B", "A"), Time = c(1, 2, 1, 2, 3, 3, 4),
                     alpha = c(5, 8, 0, 12, 2, 1, 0), beta = c(2, 4, 6, 8, 0, 0, 3), gamma = c(10, 0, 15, 20, 1, 4, 7),
                     note = c("X", "Y", "Z", "W", "V", "U", "T"))
onehot <- rs_with_seed(51L, data.frame(actor = rep(c("p", "q", "r"), each = 8), session = rep(rep(1:2, each = 4), 3),
                                       read = stats::rbinom(24, 1, 0.5), discuss = stats::rbinom(24, 1, 0.4),
                                       plan = stats::rbinom(24, 1, 0.3)))
defined <- "independent: the reshaping written from the documentation in base R"

test_that("import_data() gives the events of each window in order", {
  covers <- "import_data()"
  lapply(c(1, 2, 3), \(size) {
    out <- as.data.frame(import_data(events, cols = c(alpha, beta, gamma), id_cols = "ID", window_size = size))
    out$row <- seq_len(nrow(out))
    expect_reference(out, import_data_defined(events, c("alpha", "beta", "gamma"), "ID", window_size = size),
                     reference = defined, covers = covers, quantity = sprintf("event table, window of %d rows", size),
                     tolerance = 0, key = "row")
  })
  kept <- as.data.frame(import_data(events, cols = alpha:gamma, id_cols = c("ID", "Time"), replace_zeros = FALSE))
  kept$row <- seq_len(nrow(kept))
  expect_reference(kept, import_data_defined(events, c("alpha", "beta", "gamma"), c("ID", "Time"), replace_zeros = FALSE),
                   reference = defined, covers = covers, quantity = "event table, zeros kept, two id columns",
                   tolerance = 0, key = "row")
})

test_that("import_data() orders the actions of a row by name, not by the order of cols", {
  renamed <- stats::setNames(events, c("ID", "Time", "zeta", "beta", "alpha", "note"))
  out <- as.data.frame(import_data(renamed, cols = c(zeta, beta, alpha), id_cols = "ID", window_size = 2))
  out$row <- seq_len(nrow(out))
  expect_known_difference(out, import_data_defined(renamed, c("zeta", "beta", "alpha"), "ID", window_size = 2),
                          reference = defined, covers = "import_data()",
                          quantity = "event table, columns not in alphabetical order", tolerance = 0, key = "row",
                          reason = paste("import_data() sorts the actions of one row by column name; the reference takes",
                                         "the order of `cols`. The documentation does not say which."),
                          agrees_with = "column names in alphabetical order")
})

test_that("import_onehot() places each active column in its window", {
  covers <- "import_onehot()"
  cols <- c("read", "discuss", "plan")
  settings <- list(
    list(label = "tumbling, width 1", args = list(), ref = list()),
    list(label = "tumbling, width 2", args = list(window_size = 2L), ref = list(window_size = 2L)),
    list(label = "tumbling, width 2, interval 1", args = list(window_size = 2L, interval = 1L),
         ref = list(window_size = 2L, interval = 1L)),
    list(label = "tumbling, width 2, aggregated", args = list(window_size = 2L, aggregate = TRUE),
         ref = list(window_size = 2L, aggregate = TRUE)),
    list(label = "sliding, width 2", args = list(window_size = 2L, window_type = "sliding"),
         ref = list(window_size = 2L, window_type = "sliding")),
    list(label = "sliding, width 3", args = list(window_size = 3L, window_type = "sliding"),
         ref = list(window_size = 3L, window_type = "sliding")))
  lapply(settings, \(setting) {
    out <- do.call(import_onehot, c(list(data = onehot, cols = quote(read:plan), actor = "actor", session = "session"),
                                    setting$args))
    expect_reference(onehot_cells(out), do.call(onehot_defined, c(list(onehot, cols, "actor", "session"), setting$ref)),
                     reference = defined, covers = covers, quantity = sprintf("cells, %s", setting$label),
                     tolerance = 0, key = c("row", "cell"))
  })
})

test_that("import_data() with one-row windows gives stats::reshape()'s long table of the observed values", {
  # stats::reshape() turns every value of `cols` into one row (action = the column); the zeros are dropped and the
  # rows ordered by the id column, the original row and the column, and `order` numbers the events of a row.
  cols <- c("alpha", "beta", "gamma")
  numbered <- data.frame(events, .row = seq_len(nrow(events)))
  long <- stats::reshape(numbered, direction = "long", varying = cols, v.names = "value", timevar = "action",
                         times = cols, idvar = ".row")
  long <- long[!is.na(long$value) & long$value != 0, ]
  long <- long[order(long$ID, long$.row, match(long$action, cols)), ]
  long$order <- stats::ave(long$.row, long$.row, FUN = seq_along)
  expected <- data.frame(Time = long$Time, note = long$note, ID = long$ID, action = long$action, value = long$value,
                         order = long$order, row = seq_len(nrow(long)))
  out <- as.data.frame(import_data(events, cols = c(alpha, beta, gamma), id_cols = "ID", window_size = 1))
  out$row <- seq_len(nrow(out))
  expect_reference(out, expected, reference = "stats", covers = "import_data()",
                   quantity = "event table, window of 1 row, reshaped by stats::reshape()", tolerance = 0, key = "row")
})
