# Pending as PR to fix an issue with multiple selections
# https://github.com/jdtrat/shinysurveys/pull/72

checkIndividual <- function(input = input, input_id) {
  vals <- input[[input_id]]

  if (!is.null(vals) && length(vals) > 0) {
    any(sapply(vals, function(x) as.character(x) != "" && !is.na(x)))
  } else {
    FALSE
  }
}

environment(checkIndividual) <- asNamespace("shinysurveys")
assignInNamespace("checkIndividual", checkIndividual, ns = "shinysurveys")
