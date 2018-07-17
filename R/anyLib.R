#' @title Install and load any library
#'
#' @description Made to make your life simpler with packages/libraries,
#' by installing and loading a list of packages, whether they are on CRAN,
#' Bioconductor or github. For github, if you do not have the full path, with
#' the maintainer name in it (e.g. "achateigner/topReviGO"), it will not be able
#' to install it. However, once installed you only need the name of the package.
#' For more details see the help vignette:
#' \code{vignette("help", package = "anyLib")}
#' @param pkg The package name or the list containing the packages names.
#' @param force To force reinstallation of packages.
#' @param autoUpdate To select whether Bioconductor packages auto update or not.
#' @param lib Where to install the packages
#' @param loadLib From where the packages are loaded
#' @param source The package to install is a local source file, on the user disk.
#' @return A named vector of booleans showing if the package is loaded properly
#' @details The source option can be a single TRUE or FALSE, or a vector of TRUE
#' and FALSE corresponding to the vector/list of packages. E.g. if
#' source == c(TRUE, FALSE), the first package will be considered as a source
#' file. The file has to be a tar.gz source file, not a binary.
#' @examples
#' # Install and load 1 package from a local source file, which name is in an object:
#' lib <- normalizePath(tempdir(), "/")
#' listOfPackages <- system.file("dummyPackage_0.1.0.tar.gz", package="anyLib")
#' anyLib(listOfPackages, force = TRUE, autoUpdate = FALSE, lib = lib, source = TRUE)
#' @export
anyLib <- function(pkg, force = FALSE, autoUpdate = TRUE, lib = .libPaths()[1],
                   loadLib = .libPaths(), source = FALSE){
    opkg <- sub("_[0-9][.][0-9][.][0-9].tar.gz$", "",
                sapply(pkg, function(y) lapply(strsplit(y, "/"),
                                               function(x) x[length(x)])))
    if (inherits(pkg, "character")) {
        pkg <- as.list(pkg)
    } else if (!inherits(pkg, "list")) {
        stop("pkg has to be a package name or a list of packages names")
    }
    if (any(source) == TRUE) {
        lapply(pkg[source], function(p){
            utils::chooseCRANmirror(graphics = FALSE, 1)
            utils::install.packages(p, repos = NULL, type = "source",
                                    dependencies = TRUE, lib = lib)
        })
    }
    pkg <- pkg[!source]
    if (length(pkg) > 0) {
        # Starts by checking if the packages list contains github paths
        is.github <- sapply(pkg, function(p) !identical(grep("/", p), integer(0)))
        githubP <- pkg[is.github]
        notGithubP <- pkg[!is.github]
        # Check if github packages are installed, if force = FALSE
        is.installedGithubP <- sapply(githubP, function(p){
            mAndP <- strsplit(unlist(p), "/")[[1]]
            mAndP[2] %in% utils::installed.packages(lib.loc = loadLib)[, "Package"]
        })
        # Make a list of the packages that are not installed and install them
        new.pkg <- notGithubP[!(notGithubP %in%
                                    utils::installed.packages(
                                        lib.loc = loadLib)[, "Package"])]
        if (force == TRUE) new.pkg <- notGithubP
        if (length(new.pkg)) {
            for (p in new.pkg) {
                utils::chooseCRANmirror(graphics = FALSE, 1)
                base::suppressWarnings(utils::install.packages(
                    p, dependencies = TRUE, lib = lib))
            }
        }
        # if install fails, try bioconductor
        new.pkg <- notGithubP[!(notGithubP %in% utils::installed.packages(
            lib.loc = loadLib)[, "Package"])]
        if (force == TRUE) {
            new.pkg <- pkg[!sapply(notGithubP,
                                    function(p)
                                        length(grep(
                                            p, utils::available.packages()[,1])))]
        }
        if (length(new.pkg)) {
            try(BiocInstaller::biocLite(new.pkg, ask = FALSE,
                                        suppressAutoUpdate = !autoUpdate,
                                        lib = lib))
        }
        # Install github packages
        if (force == FALSE) {
            for (p in githubP[!is.installedGithubP])
                try(withr::with_libpaths(new = lib, devtools::install_github(p)))
        } else if (force == TRUE) {
            for (p in githubP)
                try(withr::with_libpaths(new = lib,
                                         devtools::install_github(p,
                                                                  force = force)))
        }
        # Change the list to remove the maintainer names
        if (!identical(githubP, list())) {
            pkg[is.github] <- sapply(strsplit(unlist(
                pkg[is.github]), "/"), function(x) x[[2]])
        }
    }
    sapply(opkg, require, character.only = TRUE, lib.loc = loadLib)
}
