#' Named Organization Recognition
#'
#' A wrapper for \pkg{NLP},/\pkg{openNLP}'s named organization recognition annotation.
#'
#' @inheritParams named_entity
#' @return Returns a data.frame of named entities and frequencies.
#' @keywords organization
#' @export
#' @include utils.R named_entity.R
#' @family variable functions
#' @examples
#' \dontrun{
#' data(presidential_debates_2012)
#'
#' orgs <- organization_entity(presidential_debates_2012$dialogue)
#' unlist(orgs)
#'
#' library(dplyr)
#' presidential_debates_2012$organizations <- organization_entity(presidential_debates_2012$dialogue)
#'
#' presidential_debates_2012 %>%
#'     {.[!sapply(.$organizations, is.null), ]} %>%
#'     rowwise() %>%
#'     mutate(organizations = paste(organizations, collapse=", ")) %>%
#'     select(person, time, organizations)
#'
#' library(tidyr)
#' presidential_debates_2012 %>%
#'     {.[!sapply(.$organizations, is.null), ]} %>%
#'     unnest() %>%
#'     select(person, time, organizations)
#' }
organization_entity <- hijack(named_entity,
    entity.annotator = 'organization_annotator'
)

