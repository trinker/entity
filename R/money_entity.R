#' Named Money Recognition
#'
#' A wrapper for \pkg{NLP},/\pkg{openNLP}'s named money recognition annotation.
#'
#' @inheritParams named_entity
#' @return Returns a data.frame of named entities and frequencies.
#' @keywords money
#' @export
#' @include utils.R named_entity.R
#' @family variable functions
#' @examples
#' \dontrun{
#' data(presidential_debates_2012)
#'
#' monies <- money_entity(presidential_debates_2012$dialogue)
#' unlist(monies)
#'
#' library(dplyr)
#' presidential_debates_2012$monies <- money_entity(presidential_debates_2012$dialogue)
#'
#' presidential_debates_2012 %>%
#'     {.[!sapply(.$monies, is.null), ]} %>%
#'     rowwise() %>%
#'     mutate(monies = paste(monies, collapse=", ")) %>%
#'     select(person, time, monies)
#'
#' library(tidyr)
#' presidential_debates_2012 %>%
#'     {.[!sapply(.$monies, is.null), ]} %>%
#'     unnest() %>%
#'     select(person, time, monies)
#' }
money_entity <- hijack(named_entity,
    entity.annotator = 'money_annotator'
)

