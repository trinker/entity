#' Named Entity Extaction
#'
#' A wrapper for \pkg{NLP} and \pkg{openNLP} to facilitate named entity extraction.
#' @docType package
#' @name entity
#' @aliases entity package-entity
NULL


#' 2012 U.S. Presidential Debates
#'
#' A dataset containing a cleaned version of all three presidential debates for
#' the 2012 election.
#'
#' @details
#' \itemize{
#'   \item person. The speaker
#'   \item tot. Turn of talk
#'   \item dialogue. The words spoken
#'   \item time. Variable indicating which of the three debates the dialogue is from
#' }
#'
#' @docType data
#' @keywords datasets
#' @name presidential_debates_2012
#' @usage data(presidential_debates_2012)
#' @format A data frame with 2912 rows and 4 variables
NULL


#' Bell Labs Wikipedia Article
#'
#' A dataset containing a character vector of an excerpt from Wikipedia about
#' Bell Labs with an extra final sentence to include percent and money when
#' extracting entities.
#'
#' @docType data
#' @keywords datasets
#' @name wiki
#' @usage data(wiki)
#' @format A character vector with 7 elements
#' @references \url{https://en.wikipedia.org/wiki/Bell_Labs}
NULL
