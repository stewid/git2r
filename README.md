git2r
=====

R bindings to libgit2. The package uses the source code and headers of libgit2 in src/libgit2 to compile and build as a R package. The libgit2 printf calls in cache.c and util.c have been modified to use the R printing routine Rprintf.

Aim
---

The aim of the package is to be able to run some basic git commands on a repository from R. Another aim is to extract and visualize descriptive statistics from a git repository.

Development
-----------

The package is in a very early development phase and is considered unstable with only a few features implemented.

Installation
------------

I'm developing the package on Linux, so it's very possible that other platforms currently fails to install the package. But feel free to look into that.

To install the development version of `git2r`, it's easiest to use the devtools package:

    # install.packages("devtools")
    library(devtools)
    install_github("git2r", "stewid")

Example
-------

    library(git2r)

    # Open an existing repository
    repo <- repository("path/to/git2r")

    # Check if repository is bare
    is.bare(repo)

    # Check if repository is empty
    is.empty(repo)

    # List all references in repository
    references(repo)

    # List all branches in repository
    references(repo)

    # Get HEAD of repository
    head(repo)

    # Check if HEAD is head
    is.head(head(repo))

    # Check if HEAD is local
    is.local(head(repo))

License
-------

GPL2
