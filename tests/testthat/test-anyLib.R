context("anyLib")

# Creation of tempdir
lib <- normalizePath(tempdir(), "/")
f1 <- paste(lib, "folder1", sep = "/")
dir.create(f1)
.libPaths(c(f1, .libPaths()))
f2 <- paste(lib, "folder2", sep = "/")
dir.create(f2)
foo <- .packages()

# Creation of objects
a <- TRUE
names(a) <- "apercu"
b <- TRUE
names(b) <- "limma"
d <- TRUE
names(d) <- "dummyPackage"

# test_that("works on CRAN, bioconductor and github, 1 pkg", {
#     testthat::skip_on_cran()
#     expect_equal(anyLib("apercu", lib = f1, loadLib = f1), a)
#     expect_equal(anyLib("limma", lib = f1, loadLib = f1), b)
#     expect_equal(anyLib("achateigner/apercu", lib = f1, loadLib = f1), a)
#     bar <- .packages()
#     foobar <- setdiff(bar, foo)
#     toRemove <- paste0("package:", foobar)
#     for (i in seq_along(foobar)) {
#         detach(toRemove[i], character.only = TRUE)
#     }
#     testthat::skip_on_cran()
#     expect_equal(anyLib(list("apercu", "limma", "achateigner/dummyPackage"),
#                         lib = f2,
#            loadLib = f2), c(a, b, d))
# })

test_that("works on 1 local package, only test on cran", {
    expect_equal(anyLib(system.file("dummyPackage_0.1.0.tar.gz",
                                    package = "anyLib"), source = TRUE,
                        lib = f1, loadLib = f1), d)
})
