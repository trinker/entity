#' Named Date Recognition
#'
#' A wrapper for \pkg{NLP},/\pkg{openNLP}'s named date recognition annotation.
#'
#' @inheritParams named_entity
#' @return Returns a data.frame of named entities and frequencies.
#' @keywords date
#' @export
#' @include utils.R named_entity.R
#' @family variable functions
#' @examples
#' \dontrun{
#' data(presidential_debates_2012)
#'
#' dates <- date_entity(presidential_debates_2012$dialogue)
#' unlist(dates)
#'
#' library(dplyr)
#' presidential_debates_2012$dates <- date_entity(presidential_debates_2012$dialogue)
#'
#' presidential_debates_2012 %>%
#'     {.[!sapply(.$dates, is.null), ]} %>%
#'     rowwise() %>%
#'     mutate(dates = paste(dates, collapse=", ")) %>%
#'     select(person, time, dates)
#'
#' library(tidyr)
#' presidential_debates_2012 %>%
#'     {.[!sapply(.$dates, is.null), ]} %>%
#'     unnest() %>%
#'     select(person, time, dates)
#' }
date_entity <- hijack(named_entity,
    entity.annotator = 'date_annotator'
)

