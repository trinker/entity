#' Named Person Recognition
#'
#' A wrapper for \pkg{NLP},/\pkg{openNLP}'s named person recognition annotation.
#'
#' @inheritParams named_entity
#' @return Returns a data.frame of named entities and frequencies.
#' @keywords person people
#' @export
#' @include utils.R named_entity.R
#' @family variable functions
#' @examples
#' \dontrun{
#' data(presidential_debates_2012)
#'
#' peoples <- person_entity(presidential_debates_2012$dialogue)
#' unlist(peoples)
#'
#' library(dplyr)
#' presidential_debates_2012$persons <- person_entity(presidential_debates_2012$dialogue)
#'
#' presidential_debates_2012 %>%
#'     {.[!sapply(.$persons, is.null), ]} %>%
#'     rowwise() %>%
#'     mutate(persons = paste(persons, collapse=", ")) %>%
#'     select(person, time, persons)
#'
#' library(tidyr)
#' presidential_debates_2012 %>%
#'     {.[!sapply(.$persons, is.null), ]} %>%
#'     unnest() %>%
#'     select(person, time, persons)
#' }
person_entity <- hijack(named_entity,
    entity.annotator = 'person_annotator'
)


