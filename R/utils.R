## Hijack a function
## see: http://stackoverflow.com/a/25366322/1000343
hijack <- function(FUN, ...){

    .FUN <- FUN

    args <- list(...)
    invisible(lapply(seq_along(args), function(i) {
        formals(.FUN)[[names(args)[i]]] <<- args[[i]]
    }))

    .FUN
}
