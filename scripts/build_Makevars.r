## git2r, R bindings to the libgit2 library.
## Copyright (C) 2013-2014 The git2r contributors
##
## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License, version 2,
## as published by the Free Software Foundation.
##
## git2r is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License along
## with this program; if not, write to the Free Software Foundation, Inc.,
## 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

##' Generate object files in path
##'
##' @param path The path to directory to generate object files from
##' @param exclude Files to exclude
##' @return Character vector with object files
o_files <- function(path, exclude = NULL) {
    files <- sub("c$", "o",
                 sub("src/", "",
                     list.files(path, pattern = "[.]c$", full.names = TRUE)))

    if (!is.null(exclude))
        files <- files[!(files %in% exclude)]
    files
}

##' Generate build objects
##'
##' @param files The object files
##' @param substitution Any substitutions to apply in OBJECTS
##' @param Makevars The Makevars file
##' @return invisible NULL
build_objects <- function(files, substitution, Makevars) {
    lapply(names(files), function(obj) {
        cat("OBJECTS.", obj, " =", sep="", file = Makevars)
        len <- length(files[[obj]])
        for (i in seq_len(len)) {
            prefix <- ifelse(all(i > 1, (i %% 3) == 1), "    ", " ")
            postfix <- ifelse(all(i > 1, i < len, (i %% 3) == 0), " \\\n", "")
            cat(prefix, files[[obj]][i], postfix, sep="", file = Makevars)
        }
        cat("\n\n", file = Makevars)
    })

    cat("OBJECTS =", file = Makevars)
    len <- length(names(files))
    for (i in seq_len(len)) {
        prefix <- ifelse(all(i > 1, (i %% 3) == 1), "    ", " ")
        postfix <- ifelse(all(i > 1, i < len, (i %% 3) == 0), " \\\n", "")
        cat(prefix, "$(OBJECTS.", names(files)[i], ")", postfix, sep="", file = Makevars)
    }

    if (!is.null(substitution))
        cat(substitution, file = Makevars)
    cat("\n", file = Makevars)

    invisible(NULL)
}

##' Build Makevars.in
##'
##' @return invisible NULL
build_Makevars.in <- function() {
    Makevars <- file("src/Makevars.in", "w")
    on.exit(close(Makevars))

    files <- list(libgit2            = o_files("src/libgit2"),
                  libgit2.hash       = o_files("src/libgit2/hash", "libgit2/hash/hash_win32.o"),
                  libgit2.transports = o_files("src/libgit2/transports"),
                  libgit2.unix       = o_files("src/libgit2/unix"),
                  libgit2.xdiff      = o_files("src/libgit2/xdiff"),
                  http_parser        = o_files("src/http-parser"),
                  root               = o_files("src"))

    cat("# Generated by scripts/build_Makevars.r: do not edit by hand\n", file=Makevars)
    cat("PKG_CPPFLAGS = @CPPFLAGS@\n", file = Makevars)
    cat("PKG_LIBS = @LIBS@\n", file = Makevars)
    cat("\n", file = Makevars)

    build_objects(files, " @GIT2R_SRC_REGEX@", Makevars)

    invisible(NULL)
}

##' Build Makevars.in
##'
##' @return invisible NULL
build_Makevars.win <- function() {
    Makevars <- file("src/Makevars.win", "w")
    on.exit(close(Makevars))

    files <- list(libgit2            = o_files("src/libgit2"),
                  libgit2.hash       = o_files("src/libgit2/hash", "libgit2/hash/hash_win32.o"),
                  libgit2.transports = o_files("src/libgit2/transports"),
                  libgit2.xdiff      = o_files("src/libgit2/xdiff"),
                  libgit2.win32      = o_files("src/libgit2/win32"),
                  http_parser        = o_files("src/http-parser"),
                  regex              = o_files("src/regex", c("regex/regcomp.o", "regex/regexec.o", "regex/regex_internal.o")),
                  root               = o_files("src"))

    cat("# Generated by scripts/build_Makevars.r: do not edit by hand\n", file=Makevars)
    cat("ifeq \"$(WIN)\" \"64\"\n", file=Makevars)
    cat("PKG_LIBS = -L./winhttp $(ZLIB_LIBS) -lws2_32 -lwinhttp-x64 -lrpcrt4 -lole32 -lcrypt32\n", file = Makevars)
    cat("else\n", file = Makevars)
    cat("PKG_LIBS = -L./winhttp $(ZLIB_LIBS) -lws2_32 -lwinhttp -lrpcrt4 -lole32 -lcrypt32\n", file = Makevars)
    cat("endif\n", file = Makevars)
    cat("PKG_CFLAGS = -I. -Ilibgit2 -Ilibgit2/include -Ihttp-parser -Iwin32 -Iregex \\\n", file=Makevars)
    cat("    -DWIN32 -D_WIN32_WINNT=0x0501 -D__USE_MINGW_ANSI_STDIO=1 -DGIT_WINHTTP\n", file=Makevars)
    cat("\n", file = Makevars)

    build_objects(files, NULL, Makevars)

    invisible(NULL)
}

## Generate Makevars
build_Makevars.in()
build_Makevars.win()
