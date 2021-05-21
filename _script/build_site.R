
dopdf <- FALSE
args <- commandArgs(TRUE)
if (length(args) > 0) {
	cmd <- args[1]
	if (cmd == "clean") {
		unlink("build", recursive=TRUE)
	} else if (cmd == "pdf") {
		dopdf=TRUE
	}
}


if (!dopdf) {
	shell("make html")

	fff <- list.files("build/html", patt='\\.html$', recursive=TRUE, full=TRUE)
	for (f in fff) {
		d <- readLines(f, warn=FALSE)
		dd <- trimws(d)
		d <- d[dd != ""]
		if (basename(f) != "index.html") {
			d <- gsub("\\.rst\\.txt", ".R.txt", d)
		}
		writeLines(d, f)	
	}

	cat("copying source\n\n")
	f <- list.files("source", patt='\\.txt$', recursive=TRUE, full=TRUE)
	f <- grep("/txt/", f, value=TRUE)
	g <- gsub("txt/", "", f)
	g <- gsub("source/", "", g)
	h <- file.path("build/html/_sources", g)
	h <- gsub("\\.txt$", ".R.txt", h)
	y <- file.copy(f, h, overwrite=TRUE)

	#cat("copying images\n\n")
	#f <- list.files("source", patt='\\.png$', recursive=TRUE, full=TRUE)
	#g <- file.path("build/html/images", basename(f))
	#y <- file.copy(f, g, overwrite=TRUE)

	ff <- list.files("build/html", patt='\\.html$', recursive=TRUE, full=TRUE)

#	ignore_errors <- c("build/html/intr/2-basic-data-types.html", "build/html/intr/7-explore.html" ,"build/html/intr/8-functions.html", "build/html/intr/9-apply.html", "build/html/cases/3-speciesdistribution.html")


	ignore_errors <- c("Error in eval(expr, envir, enclos): object &#39;Yi", "Error in quantile.default(d$score2): missing value", "Error: &#39;\\p&#39; is an unrecognized escape in c",
    "Error in nrow(): argument &quot;x&quot; is missing", "Error in sumsquare(a = 1, d = 2): unused argument ",
"Error in sumsquare(1:5): argument &quot;b&quot; is", "Error in f1(x, ...): unused argument (z = 5)</span", "Error in aggregate.data.frame(d[, c(&quot;v1&quot;")

	for (f in ff) {
		x <- readLines(f, warn=FALSE)
		e <- grep("## Error", x, value=TRUE)
		e <- gsub("<span class=\"c1\">## ", "", e)
		e <- substr(e, 1, 50)
		e <- e[!(e %in% ignore_errors)]
		if (length(e) > 0) {
			print(f)
			print(e)
			cat("----\n\n")
		}
	}



} else { #if (dopdf) {
	print("dopdf")

# copy pdf manuals
	shell("make latexpdf")
	cat("copying pdfs\n\n")
	f <- list.files("build/latex", patt='.pdf$', recursive=TRUE, full=TRUE)
	h <- gsub("build/latex/", "build/html/pdf/", f)
	dir.create(dirname(h), FALSE, TRUE)
	y <- file.copy(f, h, overwrite=TRUE)
	stopifnot(all(y))
}

