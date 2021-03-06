% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/commit.R
\name{commits}
\alias{commits}
\title{Commits}
\usage{
commits(
  repo = ".",
  topological = TRUE,
  time = TRUE,
  reverse = FALSE,
  n = NULL,
  ref = NULL,
  path = NULL
)
}
\arguments{
\item{repo}{a path to a repository or a \code{git_repository}
object. Default is '.'}

\item{topological}{Sort the commits in topological order (parents
before children); can be combined with time sorting. Default
is TRUE.}

\item{time}{Sort the commits by commit time; Can be combined with
topological sorting. Default is TRUE.}

\item{reverse}{Sort the commits in reverse order; can be combined
with topological and/or time sorting. Default is FALSE.}

\item{n}{The upper limit of the number of commits to output. The
default is NULL for unlimited number of commits.}

\item{ref}{The name of a reference to list commits from e.g. a tag
or a branch. The default is NULL for the current branch.}

\item{path}{The path to a file. If not NULL, only commits modifying
this file will be returned. Note that modifying commits that
occurred before the file was given its present name are not
returned; that is, the output of \code{git log} with
\code{--no-follow} is reproduced.}
}
\value{
list of commits in repository
}
\description{
Commits
}
\examples{
\dontrun{
## Initialize a repository
path <- tempfile(pattern="git2r-")
dir.create(path)
repo <- init(path)

## Config user
config(repo, user.name = "Alice", user.email = "alice@example.org")

## Write to a file and commit
lines <- "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do"
writeLines(lines, file.path(path, "example.txt"))
add(repo, "example.txt")
commit(repo, "First commit message")

## Change file and commit
lines <- c(
  "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do",
  "eiusmod tempor incididunt ut labore et dolore magna aliqua.")
writeLines(lines, file.path(path, "example.txt"))
add(repo, "example.txt")
commit(repo, "Second commit message")

## Create a tag
tag(repo, "Tagname", "Tag message")

## Change file again and commit
lines <- c(
  "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do",
  "eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad",
  "minim veniam, quis nostrud exercitation ullamco laboris nisi ut")
writeLines(lines, file.path(path, "example.txt"))
add(repo, "example.txt")
commit(repo, "Third commit message")

## Create a new file containing R code, and commit.
writeLines(c("x <- seq(1,100)",
             "print(mean(x))"),
           file.path(path, "mean.R"))
add(repo, "mean.R")
commit(repo, "Fourth commit message")

## List the commits in the repository
commits(repo)

## List the commits starting from the tag
commits(repo, ref = "Tagname")

## List the commits modifying example.txt and mean.R.
commits(repo, path = "example.txt")
commits(repo, path = "mean.R")

## Create and checkout 'dev' branch in the repo
checkout(repo, "dev", create = TRUE)

## Add changes to the 'dev' branch
lines <- c(
  "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do",
  "eiusmod tempor incididunt ut labore et dolore magna aliqua.")
writeLines(lines, file.path(path, "example.txt"))
add(repo, "example.txt")
commit(repo, "Commit message in dev branch")

## Checkout the 'master' branch again and list the commits
## starting from the 'dev' branch.
checkout(repo, "master")
commits(repo, ref = "dev")
}
}
