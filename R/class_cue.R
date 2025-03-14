cue_init <- function(
  mode = "thorough",
  command = TRUE,
  depend = TRUE,
  format = TRUE,
  repository = TRUE,
  iteration = TRUE,
  file = TRUE
) {
  cue_new(
    mode = mode,
    command = command,
    depend = depend,
    format = format,
    repository = repository,
    iteration = iteration,
    file = file
  )
}

cue_new <- function(
  mode = NULL,
  command = NULL,
  depend = NULL,
  format = NULL,
  repository = NULL,
  iteration = NULL,
  file = NULL
) {
  force(mode)
  force(command)
  force(depend)
  force(format)
  force(repository)
  force(file)
  force(iteration)
  enclass(environment(), "tar_cue")
}

cue_record <- function(cue, target, meta) {
  if (!meta$exists_record(target_get_name(target))) {
    return(TRUE)
  }
  record <- meta$get_record(target_get_name(target))
  if (record_has_error(record)) {
    # Not sure why covr does not catch this.
    # A test in tests/testthat/test-class_builder.R # nolint
    # definitely covers it (errored targets are always outdated).
    return(TRUE) # nocov
  }
  if (!identical(record$type, target_get_type(target))) {
    # Again, not sure why covr does not catch this.
    # A test in tests/testthat/test-class_cue.R # nolint
    # definitely covers it (conflicting import and target).
    return(TRUE) # nocov
  }
  FALSE
}

cue_always <- function(cue, target, meta) {
  identical(cue$mode, "always")
}

cue_never <- function(cue, target, meta) {
  identical(cue$mode, "never")
}

cue_command <- function(cue, target, meta) {
  if (!cue$command) {
    return(FALSE)
  }
  old <- meta$get_record(target_get_name(target))$command
  new <- target$command$hash
  !identical(old, new)
}

cue_depend <- function(cue, target, meta) {
  if (!cue$depend) {
    return(FALSE)
  }
  old <- meta$get_record(target_get_name(target))$depend
  new <- meta$get_depend(target_get_name(target))
  !identical(old, new)
}

cue_format <- function(cue, target, meta) {
  if (!cue$format) {
    return(FALSE)
  }
  old <- meta$get_record(target_get_name(target))$format
  new <- target$settings$format
  !identical(old, new)
}

cue_repository <- function(cue, target, meta) {
  if (!cue$repository) {
    return(FALSE)
  }
  old <- meta$get_record(target_get_name(target))$repository
  new <- target$settings$repository
  !identical(old, new)
}

cue_iteration <- function(cue, target, meta) {
  if (!cue$iteration) {
    return(FALSE)
  }
  old <- meta$get_record(target_get_name(target))$iteration
  new <- target$settings$iteration
  !identical(old, new)
}

cue_file <- function(cue, target, meta) {
  if (!cue$file) {
    return(FALSE)
  }
  record <- meta$get_record(target_get_name(target))
  file_current <- target$store$file
  file_recorded <- file_new(
    path = record$path,
    hash = record$data,
    time = record$time,
    size = record$size,
    bytes = record$bytes
  )
  on.exit(target$store$file <- file_current)
  target$store$file <- file_recorded
  !store_has_correct_hash(target$store)
}

cue_validate <- function(cue) {
  tar_assert_correct_fields(cue, cue_new)
  tar_assert_chr(cue$mode)
  tar_assert_in(cue$mode, c("thorough", "always", "never"))
  tar_assert_lgl(cue$command)
  tar_assert_lgl(cue$depend)
  tar_assert_lgl(cue$format)
  tar_assert_lgl(cue$repository)
  tar_assert_lgl(cue$iteration)
  tar_assert_scalar(cue$mode)
  tar_assert_scalar(cue$command)
  tar_assert_scalar(cue$depend)
  tar_assert_scalar(cue$format)
  tar_assert_scalar(cue$repository)
  tar_assert_scalar(cue$iteration)
}

#' @export
print.tar_cue <- function(x, ...) {
  cat("<tar_cue>\n ", paste0(paste_list(as.list(x)), collapse = "\n  "))
}
