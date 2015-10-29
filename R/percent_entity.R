#' Named Percent Recognition
#'
#' A wrapper for \pkg{NLP},/\pkg{openNLP}'s named percent recognition annotation.
#'
#' @inheritParams named_entity
#' @return Returns a data.frame of named entities and frequencies.
#' @keywords percent
#' @export
#' @include utils.R named_entity.R
#' @family variable functions
#' @examples
#' \dontrun{
#' data(presidential_debates_2012)
#'
#' percents <- percent_entity(presidential_debates_2012$dialogue)
#' unlist(percents)
#'
#' library(dplyr)
#' presidential_debates_2012$percents <- percent_entity(presidential_debates_2012$dialogue)
#'
#' presidential_debates_2012 %>%
#'     {.[!sapply(.$percents, is.null), ]} %>%
#'     rowwise() %>%
#'     mutate(percents = paste(percents, collapse=", ")) %>%
#'     select(person, time, percents)
#'
#' library(tidyr)
#' presidential_debates_2012 %>%
#'     {.[!sapply(.$percents, is.null), ]} %>%
#'     unnest() %>%
#'     select(person, time, percents)
#' }
percent_entity <- hijack(named_entity,
    entity.annotator = 'percent_annotator'
)

