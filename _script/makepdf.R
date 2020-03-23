
# copy pdf manuals
shell("make latexpdf")
cat("copying pdfs\n\n")
f <- list.files("build/latex", patt='.pdf$', recursive=TRUE, full=TRUE)
h <- gsub("build/latex/", "build/html/pdf/", f)
dir.create(dirname(h), FALSE, TRUE)
y <- file.copy(f, h, overwrite=TRUE)
stopifnot(all(y))


