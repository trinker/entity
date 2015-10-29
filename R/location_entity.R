#' Named Location Recognition
#'
#' A wrapper for \pkg{NLP},/\pkg{openNLP}'s named location recognition annotation.
#'
#' @inheritParams named_entity
#' @return Returns a data.frame of named entities and frequencies.
#' @keywords location
#' @export
#' @include utils.R named_entity.R
#' @family variable functions
#' @examples
#' \dontrun{
#' data(presidential_debates_2012)
#'
#' locales <- location_entity(presidential_debates_2012$dialogue)
#' unlist(locales)
#'
#' library(dplyr)
#' presidential_debates_2012$locations <- location_entity(presidential_debates_2012$dialogue)
#'
#' presidential_debates_2012 %>%
#'     {.[!sapply(.$locations, is.null), ]} %>%
#'     rowwise() %>%
#'     mutate(locations = paste(locations, collapse=", ")) %>%
#'     select(person, time, locations)
#'
#' library(tidyr)
#' presidential_debates_2012 %>%
#'     {.[!sapply(.$locations, is.null), ]} %>%
#'     unnest() %>%
#'     select(person, time, locations)
#' }
location_entity <- hijack(named_entity,
    entity.annotator = 'location_annotator'
)

