## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----loading anyLib------------------------------------------------------
library(anyLib)

## ----dummy folder--------------------------------------------------------
lib <- normalizePath(tempdir(), "/")
f1 <- paste(lib, "folder1", sep = "/")
dir.create(f1)
.libPaths(f1)

## ----save packages, include=FALSE----------------------------------------
foo <- .packages()

## ----installation of the dependencies------------------------------------
utils::chooseCRANmirror(graphics = FALSE, 1)
install.packages("devtools")
source("https://bioconductor.org/biocLite.R")
biocLite()

## ----install and load a simple CRAN package------------------------------
anyLib("apercu")

## ----install and load a simple Bioconductor package----------------------
anyLib("limma")

## ----install and load a simple github package----------------------------
anyLib("achateigner/dummyPackage")

## ----only load a github package------------------------------------------
anyLib("dummyPackage")

## ----reload, include=FALSE-----------------------------------------------
bar <- .packages()
foobar <- setdiff(bar, foo)
toRemove <- paste0("package:", foobar)
for(i in seq_along(foobar)) {           
    detach(toRemove[i], character.only=TRUE)    
}

## ----install and load from various places--------------------------------
f2 <- paste(lib, "folder2", sep = "/")
dir.create(f2)
anyLib(list("apercu", "limma", "achateigner/dummyPackage"), lib = f2,
       loadLib = f2)

## ----reload2, include=FALSE----------------------------------------------
bar <- .packages()
foobar <- setdiff(bar, foo)
toRemove <- paste0("package:", foobar)
for(i in seq_along(foobar)) {           
    detach(toRemove[i], character.only=TRUE)    
}

## ----install and load from list------------------------------------------
f3 <- paste(lib, "folder3", sep = "/")
dir.create(f3)
packagesNeeded <- list("apercu", "limma", "achateigner/dummyPackage")
anyLib(packagesNeeded, lib = f3, loadLib = f3)

## ----reload3, include=FALSE----------------------------------------------
bar <- .packages()
foobar <- setdiff(bar, foo)
toRemove <- paste0("package:", foobar)
for(i in seq_along(foobar)) {           
    detach(toRemove[i], character.only=TRUE)    
}

## ----advanced options----------------------------------------------------
f4 <- paste(lib, "folder4", sep = "/")
dir.create(f4)
anyLib(packagesNeeded,
       force = TRUE,
       autoUpdate = FALSE,
       lib = f4,
       loadLib = c(f1, f4))


