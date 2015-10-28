#' Annotators
#'
#' A wrapper for \code{\link[openNLP]{Maxent_Entity_Annotator}} and
#' \code{\link[openNLP]{Maxent_Word_Token_Annotator}}.
#'
#' @return Returns an annotator for entities or words.
#' @seealso \code{\link[openNLP]{Maxent_Entity_Annotator}},
#' \code{\link[openNLP]{Maxent_Word_Token_Annotator}}
#' @rdname annotators
#' @export
word_annotator <- function(){
    check_models_package()
    openNLP::Maxent_Word_Token_Annotator()
}

#' @rdname annotators
#' @export
person_annotator <- function(){
    check_models_package()
    .PERSON <- openNLP::Maxent_Entity_Annotator(kind = "person")
    attributes(.PERSON)[["type"]] <- "person"
    .PERSON
}

#' @rdname annotators
#' @export
location_annotator <- function(){
    check_models_package()
    .LOCATION <- openNLP::Maxent_Entity_Annotator(kind = "location")
    attributes(.LOCATION)[["type"]] <- "location"
    .LOCATION
}

#' @rdname annotators
#' @export
organization_annotator <- function(){
    check_models_package()
    .ORGANIZATION <- openNLP::Maxent_Entity_Annotator(kind = "organization")
    attributes(.ORGANIZATION)[["type"]] <- "organization"
    .ORGANIZATION
}

#' @rdname annotators
#' @export
date_annotator <- function(){
    check_models_package()
    .DATE <- openNLP::Maxent_Entity_Annotator(kind = "date")
    attributes(.DATE)[["type"]] <- "date"
    .DATE
}

#' @rdname annotators
#' @export
money_annotator <- function(){
    check_models_package()
    .MONEY <- openNLP::Maxent_Entity_Annotator(kind = "money")
    attributes(.MONEY)[["type"]] <- "money"
    .MONEY
}

#' @rdname annotators
#' @export
percent_annotator <- function(){
    check_models_package()
    .PERCENT <- openNLP::Maxent_Entity_Annotator(kind = "percent")
    attributes(.PERCENT)[["type"]] <- "percent"
    .PERCENT
}


check_models_package <- function(){
    outcome <- "openNLPmodels.en" %in% list.files(.libPaths())
    if (!outcome) {
        message(paste0("Well it appears `openNLPmodels.en` is not installed.\n",
            "This package is necessary in order to use the `entity` package.\n\nWould you like me to try and fetch it?"))
        ans <- utils::menu(c("Yes", "No"))
        if (ans == "2") {
            stop("Named entity extraction aborted.  Please install `openNLPmodels.en`")
        } else {
            message("Attempting to install `openNLPmodels.en`.")
            utils::install.packages(
                "http://datacube.wu.ac.at/src/contrib/openNLPmodels.en_1.5-1.tar.gz",
                repos=NULL,
                type="source"
            )
            outcome <- "openNLPmodels.en" %in% list.files(.libPaths())
            if (outcome) {
                return(TRUE)
            } else {
                stop("Failed to install `openNLPmodels.en`.  Please install `openNLPmodels.en` manually.")
            }
        }
    }
}
