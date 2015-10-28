get_counts <- function(x, alphabetical = FALSE, ...){

    x <- sort(table(unlist(x)), TRUE)

    x <- data.frame(
        entity = names(x),
        frequency = c(unname(unlist(x)))
    )

    if (isTRUE(alphabetical)) {
        x <- x[order(x[["entity"]]), ]
    }

    x[["entity"]] <- factor(x[["entity"]], levels=rev(x[["entity"]]))

    dplyr::tbl_df(x)
}


