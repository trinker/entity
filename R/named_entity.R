#' Named Entity Recognition
#'
#' A wrapper for \pkg{NLP},/\pkg{openNLP}'s named entity recognition annotation
#' tools.
#'
#' @param text.var The text string variable.
#' @param entity.annotator A character vector identifying an entity recognition
#' annotator (\code{c("person_annotator", "location_annotator", "date_annotator",
#' "money_annotator", "percent_annotator")}.  See \code{?annotators}.
#' @param word.annotator A word annotator.
#' @param element.chunks The number of elements to include in a chunk. Chunks are
#' passed through an \code{\link[base]{lapply}} and size is kept within a tolerance
#' because of memory allocation in the tagging process with \pkg{Java}.
#' @return Returns a data.frame of named entities and frequencies.
#' @keywords ner named entity
#' @export
#' @seealso \code{\link[openNLP]{Maxent_Entity_Annotator}}
#' @examples
#' \dontrun{
#' data(presidential_debates_2012)
#'
#' peoples <- named_entity(presidential_debates_2012$dialogue, 'person_annotator')
#' unlist(peoples)
#' plot(peoples)
#'
#' orgs <-named_entity(presidential_debates_2012$dialogue, 'organization_annotator')
#' unlist(orgs)
#'
#' dates <-named_entity(presidential_debates_2012$dialogue, 'date_annotator')
#' unlist(dates)
#'
#' library(dplyr)
#' presidential_debates_2012$organizations <- named_entity(
#'     presidential_debates_2012$dialogue,
#'     'organization_annotator'
#' )
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
named_entity <- function(text.var, entity.annotator, word.annotator = word_annotator(),
    element.chunks = floor(2000 * (23.5/mean(sapply(text.var, nchar), na.rm = TRUE)))){

    len <- length(text.var)

    ## locate empty or missing text elements
    nas <- sort(union(which(is.na(text.var)), grep("^\\s*$", text.var)))

    ## Get annotator
    entity.annotator <- switch(entity.annotator,
        person_annotator = person_annotator(),
        location_annotator = location_annotator(),
        organization_annotator = organization_annotator(),
        date_annotator = date_annotator(),
        money_annotator = money_annotator(),
        percent_annotator  = percent_annotator(),
        stop("`entity.annotator` does not appear to be an annotator.  See `?annotators`.")
    )


    ## replace empty text with a period
    if(length(nas) > 0){
       text.var[nas] <- "."
    }

    ## Chunking the text into memory sized chunks:
    ## caluclate the start/end indexes of the chunks
    ends <- c(utils::tail(seq(0, by = element.chunks,
        length.out = ceiling(len/element.chunks)), -1), len)
    starts <- c(1, utils::head(ends + 1 , -1))

    ## chunk the text
    text_list <- Map(function(s, e) {text.var[s:e]}, starts, ends)

    ## loop through the chunks and tag them
    out <- lapply(text_list, function(x){
        x <- entify(x, entity.annotator, word.annotator)
        gc()
        x
    })

    lens <- sapply(text_list, length)

    out <- unlist(lapply(seq_along(out), function(i){

        vectout <- vector(mode = "list", length = lens[i])
        if (is.null(out[[i]][["entities"]])) return(vectout)
        if (length(out[[i]][["entities"]]) == 1){
            splits <- out[[i]][["entities"]]
        } else {
            splits <- split(out[[i]][["entities"]], out[[i]][["locations"]])
        }
        vectout[unique(out[[i]][["locations"]])] <- splits
        vectout
    }), recursive = FALSE)

    class(out) <- c("entity", class(out))
    attributes(out)[["type"]] <- attributes(entity.annotator)[["type"]]
    out
}


entify <-  function(text.var, ANN, WTA, ...) {

    text.var <- gsub("^\\s+|\\s+$", "", text.var)
    s <- NLP::as.String(paste(text.var, collapse=""))

    ## Manually calculate the starts and ends via nchar
    lens <- sapply(text.var, nchar)
    ends <- cumsum(lens)
    starts <- c(1, utils::head(ends + 1, -1))

    a2 <- NLP::Annotation(seq_along(starts), rep("sentence", length(starts)), starts, ends)
    a2 <- NLP::annotate(s, WTA, a2)
    a3 <- NLP::annotate(s, ANN, a2)

    ## Determine the distribution of POS tags for word tokens.
    ents <- a3$type == "entity"
    if (all(!ents)) return(list(locations = NULL, entities = NULL))
    a3wb <- a3w <- a3[ents]

    a3s <- a3[a3$type == "sentence"]
    starts <- as.data.frame(a3s)[, "start"]
    ends <- as.data.frame(a3s)[, "end"]

    a3w$start <- sapply(as.data.frame(a3w)[, "start"], function(x) {
        max(starts[starts <= x])
    })
    a3w$end <- sapply(as.data.frame(a3w)[, "end"], function(x) {
        min(ends[ends >= x])
    })

    list(
        locations = match(a3w$start, starts),
        entities = s[a3wb]
    )
}

#' Prints a entity Object
#'
#' Prints a entity object
#'
#' @param x An \code{entity} object.
#' @param \ldots ignored.
#' @method print entity
#' @export
print.entity <- function(x, ...){
    class(x) <- "list"
    attributes(x) <- NULL
    print(x)
}

#' Plots a plot.entity Object
#'
#' Plots a plot.entity object
#'
#' @param x An \code{entity} object.
#' @param min Minimum frequency of included entities.
#' @param alphabetical logical.  Should rows be arranged alphabetically by entity
#' or by frequency.
#' @param \ldots ignored.
#' @method plot entity
#' @export
plot.entity <- function(x, min = 1, alphabetical = FALSE, ...){

    stopifnot(min > 0)

    entname <- attributes(x)[["type"]]
    substring(entname, 1, 1) <- toupper(substring(entname, 1, 1))

    x <- get_counts(x, alphabetical = alphabetical)

    x <- x[x[["frequency"]] >= min, ]

    ggplot2::ggplot(x, ggplot2::aes_string(x='entity', weight='frequency')) +
        ggplot2::geom_bar() +
        ggplot2::coord_flip() +
        ggplot2::ylab("Count") +
        ggplot2::xlab(entname) +
        ggplot2::scale_y_continuous(expand = c(0, 0), limits = c(0, 1.01 * max(x[["frequency"]]))) +
        ggplot2::theme_bw() +
        ggplot2::theme(
            panel.grid.major.y = ggplot2::element_blank(),
            legend.title = ggplot2::element_blank(),
            panel.border = ggplot2::element_blank(),
            axis.line = ggplot2::element_line(color="grey70")
        )
}



