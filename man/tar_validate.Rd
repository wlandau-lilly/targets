% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tar_validate.R
\name{tar_validate}
\alias{tar_validate}
\title{Validate a pipeline of targets.}
\usage{
tar_validate(
  callr_function = callr::r,
  callr_arguments = targets::callr_args_default(callr_function),
  envir = parent.frame(),
  script = targets::tar_config_get("script"),
  store = targets::tar_config_get("store")
)
}
\arguments{
\item{callr_function}{A function from \code{callr} to start a fresh clean R
process to do the work. Set to \code{NULL} to run in the current session
instead of an external process (but restart your R session just before
you do in order to clear debris out of the global environment).
\code{callr_function} needs to be \code{NULL} for interactive debugging,
e.g. \code{tar_option_set(debug = "your_target")}.
However, \code{callr_function} should not be \code{NULL} for serious
reproducible work.}

\item{callr_arguments}{A list of arguments to \code{callr_function}.}

\item{envir}{An environment, where to run the target R script
(default: \verb{_targets.R}) if \code{callr_function} is \code{NULL}.
Ignored if \code{callr_function} is anything other than \code{NULL}.
\code{callr_function} should only be \code{NULL} for debugging and
testing purposes, not for serious runs of a pipeline, etc.

The \code{envir} argument of \code{\link[=tar_make]{tar_make()}} and related
functions always overrides
the current value of \code{tar_option_get("envir")} in the current R session
just before running the target script file,
so whenever you need to set an alternative \code{envir}, you should always set
it with \code{tar_option_set()} from within the target script file.
In other words, if you call \code{tar_option_set(envir = envir1)} in an
interactive session and then
\code{tar_make(envir = envir2, callr_function = NULL)},
then \code{envir2} will be used.}

\item{script}{Character of length 1, path to the
target script file. Defaults to \code{tar_config_get("script")},
which in turn defaults to \verb{_targets.R}. When you set
this argument, the value of \code{tar_config_get("script")}
is temporarily changed for the current function call.
See \code{\link[=tar_script]{tar_script()}},
\code{\link[=tar_config_get]{tar_config_get()}}, and \code{\link[=tar_config_set]{tar_config_set()}} for details
about the target script file and how to set it
persistently for a project.}

\item{store}{Character of length 1, path to the
\code{targets} data store. Defaults to \code{tar_config_get("store")},
which in turn defaults to \verb{_targets/}.
When you set this argument, the value of \code{tar_config_get("store")}
is temporarily changed for the current function call.
See \code{\link[=tar_config_get]{tar_config_get()}} and \code{\link[=tar_config_set]{tar_config_set()}} for details
about how to set the data store path persistently
for a project.}
}
\value{
\code{NULL} except if \code{callr_function = callr::r_bg()}, in which case
a handle to the \code{callr} background process is returned. Either way,
the value is invisibly returned.
}
\description{
Inspect the pipeline for issues and throw an error or
warning if a problem is detected.
}
\examples{
if (identical(Sys.getenv("TAR_EXAMPLES"), "true")) {
tar_dir({ # tar_dir() runs code from a temporary directory.
tar_script(list(tar_target(x, 1 + 1)), ask = FALSE)
tar_validate()
})
}
}
\seealso{
Other inspect: 
\code{\link{tar_deps_raw}()},
\code{\link{tar_deps}()},
\code{\link{tar_manifest}()},
\code{\link{tar_network}()},
\code{\link{tar_outdated}()},
\code{\link{tar_sitrep}()}
}
\concept{inspect}
