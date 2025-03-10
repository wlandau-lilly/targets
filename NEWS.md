# targets 0.12.0.9000



# targets 0.12.0

## Bug fixes

* Fix `tar_mermaid()` graph ordering.
* Hash the node names and quote the label names of `tar_mermaid()` graphs to avoid JavaScript keywords.
* Remove superfluous line breaks in the node labels of graph visuals.
* Fix metadata migration to version >= 0.10.0 (#812, @tjmahr).
* `data.table::fread()` with encoding equal to `getOption("encoding")` if available (#814, @svraka). Only works with UTF-8 and latin1 because that is what `data.table` supports.
* Force add files in GitHub Actions workflow job (#815, @tarensanders).

## New features

* `use_targets()` now writes a `_targets.R` file tailored to the project in the current working directory (#639, @noamross).
* Move the old `use_targets()` to `use_targets_rmd()`.

## Enhancements

* Load packages when loading data for downstream targets in the pipeline (#713).
* Handle edge case when `getOption("OutDec")` is not `"."` to prevent time stamps from being corrupted (#433, @jarauh).
* Added helper function `tar_load_everything()` to quickly load all targets (#823, @malcolmbarrett)

# targets 0.11.0

## Bug fixes

* Print out the relevant target names if targets have conflicting names.
* Catch all the target warnings instead of just reporting the last one.
* Allow 200 group URL status codes instead of just 200 (#797, @petrbouchal).

## New features

* Add Google Cloud Storage via `tar_target(..., repository = "gcp")` (#720, @markedmondson1234). Special thanks to @markedmondson1234 for the cloud storage utilities in `R/utils_gcp.R`
* `mermaid.js` static graphs with `tar_mermaid()` (#775, @yonicd).
* Implement `tar_target(..., error = "null")`to allow errored targets to return `NULL` and continue (#807, @zoews). Errors are still registered, those targets are not up to date, and downstream targets have an easier time continuing on.
* Implement `tar_assert_finite()`.
* `tar_destroy()`, `tar_delete()`, and `tar_prune()` now attempt to delete cloud data for the appropriate targets (#799). In addition, `tar_exist_objects()` and `tar_objects()` now report about target data in the cloud when applicable. Add a new `cloud` argument to each function to optionally suppress this new behavior.
* Add a `zoom_speed` argument to `tar_visnetwork()` and `tar_glimpse()` (#749, @dipterix).
* Report the total runtime of the pipeline in the `"verbose"`, `"verbose_positives"`, `"timestamp"`, and `"timesamp_positives"` reporters.

## Enhancements

* Allow target name character strings to have attributes (#758, @psanker).
* Sort metadata rows when the pipeline finishes so that version-controlling the metadata is easier (#766, @jameelalsalam).

## Deprecations

* Deprecate the `"aws_*"` storage format values in favor of a new `repository` argument (#803). In other words, `tar_target(..., format = "aws_qs")` is now `tar_target(..., format = "qs", repository = "aws")`. And internally, storage classes with multiple inheritance are created dynamically as opposed to having hard-coded source files. All this paves the way to add new cloud storage platforms without combinatorial chaos.

# targets 0.10.0

## Bug fixes

* Add class `"tar_nonexportable"` to `format = "aws_keras"` and `format = "aws_torch"` stores.
* Export S3 methods of generic `tar_make_interactive_load_target()`.

## New features

* Allow entirely custom storage formats through `tar_target(format = tar_format(...))` (#736).
* Add a new function `tar_call()` to return the `targets` function currently running (from `_targets.R` or a target).
* Add a new function `tar_active()` to tell whether the pipeline is currently running. Detects if it is called from `tar_make()` or similar function.

## Enhancements

* Add `Sys.getenv("TAR_PROJECT")` to the output of `tar_envvars()`.
* Set the `store` field of `tar_runtime` prior to sourcing `_targets.R` so `tar_store()` works in target scripts.
* Explicitly export all the environment variables from `tar_envvars()` to targets run on parallel workers.
* Allow `format = "file"` targets to return `character(0)` (#728, @programLyrique).
* Automatically remove non-targets from the target list and improve target list error messages (#731, @billdenney).
* Link to resources on deploying to RStudio Connect (#745, @ian-flores).

# targets 0.9.1

* Mask pointers in function dependencies (#721, @matthiaskaeding)

# targets 0.9.0

## Highlights

* Track the version ID of AWS S3-backed targets if the bucket is version-enabled (#711). If you put your targets in AWS and the metadata and code under version control, you can `git checkout` a different branch of your code and all you targets will stay up to date.
* Refactor the AWS path format internally. It now consists of arbitrarily extensible key-value pairs so more AWS S3 functionality may be added more seamlessly going forward (#711).
* Switch the AWS S3 backend to `paws` (#711).

## New features

* Add a `region` argument to `tar_resources_aws()` to allow the user to explicitly declare a region for each AWS S3 buckets (@caewok, #681). Different buckets can now have different regions. This feature required modifying the metadata path for AWS storage formats. Before, the first element of the path was simply the bucket name. Now, it is internally formatted like `"bucket=BUCKET:region=REGION"`, where `BUCKET` is the user-supplied bucket name and `REGION` is the user-supplied region name. The new `targets` is back-compatible with the old metadata format, but if you run the pipeline with `targets` >= 0.8.1.9000 and then downgrade to `targets` <= 0.8.1, any AWS targets will break.
* Add new reporters `timestamp_positives"` and `"verbose_positives"` that omit messages for skipped targets (@psanker, #683).
* Implement `tar_assert_file()`.
* Implement `tar_reprex()` for creating easier reproducible examples of pipelines.
* Implement `tar_store()` to get the path to the store of the currently running pipeline (#714, @MilesMcBain).
* Automatically write a `_targets/user/` folder to encourage `gittargets` users to put custom files there for data version control.

## Bug fixes

* Make sure `tar_path()` uses the current store path of the currently running pipeline instead of `tar_config_get("store")` (#714, @MilesMcBain).

## Enhancements

* Refactor the automatic `.gitignore` file inside the data store to allow the metadata to be committed to version control more easily (#685, #711).
* Document target name requirements in `tar_target()` and `tar_target_raw()` (@tjmahr, #679).
* Catch and relay any the error if a target cannot be checked in `target_should_run.tar_builder()`. These kinds of errors sometimes come up with AWS storage.
* Fix the documentation of the reporters.
* Only write `_targets/.gitignore` for new data stores so the user can delete the `.gitignore` file without it mysteriously reappearing (#685).

# targets 0.8.1

## New features

* Add arguments `strict` and `silent` to allow `tar_load()` and `tar_load_raw()` to bypass targets that cannot be loaded.

## Enhancements

* Improve `tidyselect` docs in `tar_make()` (#640, @dewoller).
* Use namespaced call to `tar_dir()` in `tar_test()` (#642, @billdenney).
* Improve `tar_assert_target_list()` error message (@kkami1115, #654).
* Throw an informative error if a target name starts with a dot (@dipterix, #662).
* Improve help files of `tar_destroy()` and related cleanup functions (@billdenney, #675).

# targets 0.8.0

## Bug fixes

* Hash the correct files in `tar_target(target_name, ..., format = "aws_file")`. Previously, `_targets/objects/target_name` was also hashed if it existed.

## New features

* Implement a new `tar_config_unset()` function to delete one or more configuration settings from the YAML configuration file.
* Implement the `TAR_CONFIG` environment variable to set the default file path of the YAML configuration file with project settings (#622, @yyzeng, @atusy, @nsheff, @wdkrnls). If `TAR_CONFIG` is not set, the file path is still `_targets.yaml`.
* Restructure the YAML configuration file format to handle configuration information for multiple projects (using the `config` package) and support the `TAR_PROJECT` environment variable to select the current active project for a given R session. The old single-project format is gracefully deprecated (#622, @yyzeng, @atusy, @nsheff, @wdkrnls).
* Implement `retrieval = "none"` and `storage = "none"` to anticipate loading/saving targets from other languages, e.g. Julia (@MilesMcBain).
* Add a new `tar_definition()` function to get the target definition object of the current target while that target is running in a pipeline.
* If called inside an AWS target, `tar_path()` now returns the path to the staging file instead of `_targets/objects/target_name`. This ensures you can still write to `tar_path()` in `storage = "none"` targets and the package will automatically hash the right file and upload it to the cloud. (This behavior does not apply to formats `"file"` and `"aws_file"`, where it is never necessary to set `storage = "none"`.)

## Enhancements

* Use `eval(parse(text = ...), envir = tar_option_set("envir")` instead of `source()` in the `_targets.R` file for Target Markdown.
* Allow feather and parquet formats to accept objects of class `RecordBatch` and `Table` (@MilesMcBain).
* Let `knitr` load the Target Markdown engine (#469, @nviets, @yihui). Minimum `knitr` version is now `1.34`.
* In the `tar_resources_future()` help file, encourage the use of `plan` to specify resources.

# targets 0.7.0

## Bug fixes

* Ensure `error = "continue"` does not cause errored targets to have `NULL` values.
* Relay output and messages in Target Markdown interactive mode (using the R/default `knitr` engine).

## New features

* Expose the `poll_connection`, `stdout`, and `stderr` arguments of `callr::r_bg()` in `tar_watch()` (@mpadge).
* Add new helper functions to list targets in each progress category: `tar_started()`, `tar_skipped()`, `tar_built()`, `tar_canceled()`, and `tar_errored()`.
* Add new helper functions `tar_interactive()`, `tar_noninteractive()`, and `tar_toggle()` to differentially suppress code in non-interactive and interactive mode in Target Markdown (#607, @33Vito).

## Enhancements

* Handle `future` errors within targets (#570, @stuvet).
* Handle storage errors within targets (#571, @stuvet).
* In Target Markdown in non-interactive mode, suppress messages if the `message` `knitr` chunk option is `FALSE` (#574, @jmbuhr).
* In Target Markdown, if `tar_interactive` is not set, choose interactive vs non-interactive mode based on `isTRUE(getOption("knitr.in.progress"))` instead of `interactive()`.
* Convert errors loading dependencies into errors running targets (@stuvet).

# targets 0.6.0

## Bug fixes

* Allow `tar_poll()` to lose and then regain connection to the progress file.
* Make sure changes to the `tar_group` column of `iteration = "group"` data frames do not invalidate slices (#507, @lindsayplatt).

## New features

* In Target Markdown, add a new `tar_interactive` global option to select interactive mode or non-interactive mode (#469).
* Highlight a graph neighborhood when the user clicks a node. Control the neighborhood degree with new arguments `degree_from` and `degree_to` of `tar_visnetwork()` and `tar_glimpse()` (#474, @rgayler).
* Make the target script path configurable in `tar_config_set()` (#476).
* Add a `tar_script` chunk option in Target Markdown to control where the `{targets}` language engine writes the target script and helper scripts (#478).
* Add new arguments `script` and `store` to choose custom paths to the target script file and data store for individual function calls (#477).
* Allow users to set an alternative path to the YAML configuration file for the current R session (#477). Most users have no reason to set this path, it is only for niche applications like Shiny apps with `targets` backends. Unavoidably, the path gets reset to `_targets.yaml` when the session restarts.
* Add new `_targets.yaml` config options `reporter_make`, `reporter_outdated`, and `workers` to control function argument defaults shared across multiple functions called outside `_targets.R` (#498, @ianeveperry).
* Add `tar_load_globals()` for debugging, testing, prototyping, and teaching (#496, @malcolmbarrett).
* Add structure to the `resources` argument of `tar_target()` to avoid conflicts among formats and HPC backends (#489). Includes user-side helper functions like `tar_resources()` and `tar_resources_aws()` to build the required data structures.
* Log skipped targets in `_targets/meta/progress` and display then in `tar_progress()`, `tar_poll()`, `tar_watch()`, `tar_progress_branches()`, `tar_progress_summary()`, and `tar_visnetwork()` (#514). Instead of writing each skip line separately to `_targets/meta/progress`, accumulate skip lines in a queue and then write them all out in bulk when something interesting happens. This avoids a lot of overhead in certain cases.
* Add a `shortcut` argument to `tar_make()`, `tar_make_clustermq()`, `tar_make_future()`, `tar_outdated()`, and `tar_sitrep()` to more efficiently skip parts of the pipeline (#522, #523, @jennysjaarda, @MilesMcBain, @kendonB).
* Support `names` and `shortcut` in graph data frames and graph visuals (#529).
* Move `allow` and `exclude` to the network behind the graph visuals rather than the visuals themselves (#529).
* Add a new "progress" display to the `tar_watch()` app to show verbose progress info and metadata.
* Add a new `workspace_on_error` argument of `tar_option_set()` to supersede `error = "workspace"`. Helps control workspace behavior independently of the `error` argument of `tar_target()` (#405, #533, #534, @mattwarkentin, @xinstein).
* Implement `error = "abridge"` in `tar_target()` and related functions. If a target errors out with this option, the target itself stops, any currently running targets keeps, and no new targets launch after that (#533, #534, @xinstein).
* Add a menu prompt to `tar_destroy()` which can be suppressed with `TAR_ASK = "false"` (#542, @gofford).
* Support functions `tar_older()` and `tar_newer()` to help users identify and invalidate targets at regular times or intervals.

## Deprecations

* In Target Markdown, deprecate the `targets` chunk option in favor of `tar_globals` (#469).
* Deprecate `error = "workspace"` in `tar_target()` and related functions. Use `tar_option_set(workspace_on_error = TRUE)` instead (#405, #533, @mattwarkentin, @xinstein).

## Performance

* Reset the backoff upper bound when concluding a target or shutting down a `clustermq` worker (@rich-payne).
* Set more aggressive default backoff bound of 0.1 seconds (previous: 5 seconds) and set a more aggressive minimum of 0.001 seconds (previous: 0.01 seconds) (@rich-payne).
* Speed up the summary and forecast reporters by only printing to the console every quarter second.
* Avoid superfluous calls to `store_sync_file_meta.default()` on small files.
* In `tar_watch()`, take several measures to avoid long computation times rendering the graph:
    * Expose arguments `display` and `displays` to `tar_watch()` so the user can select which display shows first.
    * Make `"summary"` the default display instead of `"graph"`.
    * Set `outdated` to `FALSE` by default.

## Enhancements

* Simplify the Target Markdown example.
* Warn about unnamed chunks in Target Markdown.
* Redesign option system to be more object-oriented and rigorous. Also export most options to HPC workers (#475).
* Simplify config system to let API function arguments take control (#483).
* In `tar_read()` for targets with `format = "aws_file"`, download the file back to the path the user originally saved it when the target ran.
* Replace the `TAR_MAKE_REPORTER` environment variable with `targets::tar_config_get("reporter_make")`.
* Use `eval(parse(text = readLines("_targets.R")), envir = some_envir)` and related techniques instead of the less controllable `source()`. Expose an `envir` argument to many functions for further control over evaluation if `callr_function` is `NULL`.
* Drop `out.attrs` when hashing groups of data frames to extend #507 to `expand.grid()` (#508).
* Increase the number of characters in errors and warnings up to 2048.
* Refactor assertions to automatically generate better messages.
* Export assertions, conditions, and language utilities in packages that build on top of `targets`.
* Change `GITHUBPAT` to `GITHUB_TOKEN` in the `tar_github_actions()` YAML file (#554, @eveyp).
* Support the `eval` chunk option in Target Markdown (#552, @fkohrt).
* Record time stamps in the metadata `time` column for all builder targets, regardless of storage format.

# targets 0.5.0

## Bug fixes

* Export in-memory config settings from `_targets.yaml` to parallel workers.

## New features

* Add a limited-scope `exclude` argument to `tar_watch()` and `tar_watch_server()` (#458, @gorkang).
* Write a `.gitignore` file to ignore everything in `_targets/meta/` except `.gitignore` and `_targets/meta/meta`.
* Target Markdown: add `knitr` engines for pipeline construction and prototyping from within literate programming documents (#469, @cderv, @nviets, @emilyriederer, @ijlyttle, @GShotwell, @gadenbuie, @tomsing1). Huge thanks to @cderv on this one for answering my deluge of questions, helping me figure out what was and was not possible in `knitr`, and ultimately circling me back to a successful approach.
* Add an RStudio R Markdown template for Target Markdown (#469).
* Implement `use_targets()`, which writes the Target Markdown template to the project root (#469).
* Implement `tar_unscript()` to clean up scripts written by Target Markdown.

## Enhancements

* Enable priorities in `tar_make()` and `tar_manifest()`.
* Show the priority in the print method of stem and pattern targets.
* Throw informative errors if the secondary arguments to `pattern = slice()` or `pattern = sample()` are invalid.
* In `tar_target_raw()`, assert that commands have length 1 when converted to expressions.
* Handle errors and post failure artifacts in the Github Actions YAML file.
* Rewrite the documentation on invalidation rules in `tar_cue()` (@maelle).
* Drop `dplyr` groups and `"grouped_df"` class in `tar_group()` (`tarchetypes` discussion #53, @kendonB).
* Assign branch names to dynamic branching return values produced by `tar_read()` and `tar_read_raw()`.

# targets 0.4.2

## Bug fixes

* Do not use time stamps to monitor the config file (e.g. `_targets.yaml`). Fixes CRAN check errors from version 0.4.1.

# targets 0.4.1

* Fix CRAN test error on Windows R-devel.
* Do not inherit `roxygen2` docstrings from `shiny`.
* Handle more missing `Suggests:` packages.
* Unset the config lock before reading `targets.yaml` in the `callr` process.

# targets 0.4.0

## Bug fixes

* Avoid `file.rename()` errors when migrating staged temporary files (#410).
* Return correct error messages from feather and parquet formats (#388). Now calling `assert_df()` from `store_assert_format()` instead of `store_cast_object()`. And now those last two functions are not called at all if the target throws an error.
* Retry writing lines to database files so Windows machines can run `tar_poll()` at the same time as the pipeline (#393).
* Rename file written by `tar_renv()` to `_targets_packages.R` (#397).
* Ensure metadata is loaded to compute labels properly when `outdated = FALSE` in `tar_visnetwork()`.

## New features

* Implement `tar_timestamp()` and `tar_timestamp_raw()` to get the last modified timestamp of a target's data (#378).
* Implement `tar_progress_summary()` to compactly summarize all pipeline progress (#380).
* Add a `characters` argument of `tar_traceback()` to cap the traceback line lengths (#383).
* Add new "summary" and "about" views to `tar_watch()` (#382).
* Implement `tar_poll()` to repeatedly poll runtime progress in the R console (#381). `tar_poll()` is a lightweight alternative to `tar_watch()`.
* Change the color of the "dormant" status in the graph.
* Add a `tar_envvar()` function to list values of special environment variables supported in `targets`. The help file explains each environment variable in detail.
* Support extra project-level configuration settings with `_targets.yaml` (#297). New functions `tar_config_get()` and `tar_config_set()` interact with the `_targets.yaml` file. Currently only supports the `store` field to set the data store path to something other than `_targets/`.

## Performance

* Shut down superfluous persistent workers earlier in dynamic branching and when all remaining targets have `deployment = "main"` (#398, #399, #404, @pat-s).

## Enhancements

* Attempt to print only the useful part of the traceback in `tar_traceback()` (#383).
* Add a line break at the end of the "summary" reporter so warnings do not mangle the output.
* In `tar_watch()`, use `shinybusy` instead of `shinycssloaders` and keep current output on display while new output is rendering (#386, @rcorty).
* Right-align the headers and counts in the "summary" and "forecast" reporters.
* Add a timestamp to the "summary" reporter.
* Make the reporters show when a target ends (#391, @mattwarkentin).
* Make the reporters show when a pattern ends if the pattern built at least one target and none of the targets errored or canceled.
* Use words "start" and "built" in reporters.
* Use the region of the AWS S3 bucket instead of the local `AWS_DEFAULT_REGION` environment variable (`check_region = TRUE`; #400, @tomsing1).
* In `tar_meta()`, return `POSIXct` times in the time zone of the calling system (#131).
* Throw informative error messages when a target's name or command is missing (#413, @liutiming).
* Bring back ALTREP in `qs::qread()` now that `qs` 0.24.1 requires `stringfish` >= 1.5.0 (#147, @glep).
* Relax dynamic branching checks so `pattern = slice(...)` can take multiple indexes (#406, #419, @djbirke, @alexgphayes)

# targets 0.3.1

## Bug fixes

* `queue$enqueue()` is now `queue$prepend()` and always appends to the front of the queue (#371).

## Enhancements

* Throw a warning if `devtools::load_all()` or similar is detected inside `_targets.R` (#374).

## CRAN

* Skip `feather` and `parquet` tests on CRAN.

# targets 0.3.0

## Bug fixes

* Fix the "write target at cursor" RStudio addin and move cursor between the parentheses.

## New features

* Add a `backoff` option in `tar_option_set()` to set the maximum upper bound (seconds) for the polling interval (#333).
* Add a new `tar_github_actions()` function to write a GitHub Actions workflow file for continuous deployment of data analysis pipelines (#339, @jaredlander).
* Add a new `TAR_MAKE_REPORTER` environment variable to globally set the reporter of the `tar_make*()` functions (#345, @alexpghayes).
* Support new storage formats "feather", "parquet", "aws_feather", and "aws_parquet" (#355, @riazarbi).

## Performance

* Implement an exponential backoff algorithm for polling the priority queue in `tar_make_clustermq()` and `tar_make_future()` (#333). 
* In `tar_make_future()`, try to submit a target every time a worker is polled.
* In `tar_make_future()`, poll workers in order of target priority.
* Avoid the time delay in exiting on error (from https://github.com/r-lib/callr/issues/185).
* Clone target objects for the pipeline and scrape more `targets` internal objects out of the environment in order to avoid accidental massive data transfers to workers.

## Enhancements

* Use `rlang::check_installed()` inside `assert_package()` (#331, @malcolmbarrett).
* Allow `tar_destroy(destroy = "process")`.
* In `tar_watch()`, increase default `seconds` to 15 (previously 5).
* In `tar_watch()`, debounce instead of throttle inputs.
* In `tar_watch()`, add an action button to refresh the outputs.
* Always deduplicate metadata after `tar_make()`. Will help compute a cache key on GitHub Actions and similar services.
* Deprecate `tar_deduplicate()` due to the item above.
* Reorder information in timestamped messages.
* Document RNG seed generation in `tar_target_raw()`, `tar_meta()`, and `tar_seed()` (#357, @alexpghayes).
* Switch meaning of `%||%` and `%|||%` to conform to historical precedent.
* Only show a command line spinner if `reporter = "silent"` (#364, @matthiasgomolka).
* Target and pipeline objects no longer have an `envir` element.

# targets 0.2.0

## Bug fixes

* In `tar_load()`, subset metadata to avoid accidental attempts to load global objects in `tidyselect` calls.
* Do not register a pattern as running unless an actual branch is about to start (#304).
* Use a name spec in `vctrs::vec_c()` (#320, @joelnitta).

## New features

* Add a new `names` argument to `tar_objects()` and `tar_workspaces()` with `tidyselect` functionality.
* Record info on the main process (PID, R version, `targets` version) in `_targets/meta/process` and write new functions `tar_process()` and `tar_pid()` to retrieve the data (#291, #292).
* Add a new `targets_only` argument to `tar_meta()`.
* Add new functions `tar_helper()` and `tar_helper_raw()` to write general-purpose R scripts, using tidy evaluation for as a template mechanism (#290, #291, #292, #306).
* Export functions to check the existence of various pieces of local storage: `tar_exist_meta()`, `tar_exist_objects()`, `tar_exist_progress()`, `tar_exist_progress()`, `tar_exist_script()` (#310).
* Add a new `supervise` argument to `tar_watch()`.
* Add a new `complete_only` argument to `tar_meta()` to optionally return only complete rows (no `NA` values).
* Catch `callr` errors and refer users to the debugging chapter of the manual.

## Enhancements

* Improve error messages of invalid arguments (#298, @brunocarlin). Removes partial argument matching in most cases.
* By default, locally enable `crayon` if an only if the calling process is interactive (#302, @ginolhac). Can still be disabled with `options(crayon.enabled = FALSE)` in `_targets.R`.
* Improve error handling and message for `format = "url"` when the HTTP response status code is not 200 (#303, @petrbouchal).
* Add more `extras` packages to `tar_renv()` (to support `tar_watch()`).
* Show informative message instead of error in `tar_watch()` if `_targets.R` does not exist.
* Clear up the documentation of the `names` argument of `tar_load()` (#314, @jameelalsalam).
* Do not override `nobody` in custom `curl` handles (#315, @riazarbi).
* Rename "running" to "started" in the progress metadata. This avoids the implicit claim that `targets` is somehow actively monitoring each job, e.g. through a connection or heartbeat (#318).
* Set `errormode = "warn"` in `getVDigest()` for files to work around https://github.com/eddelbuettel/digest/issues/49 for network drives on Windows. `targets` already runs those file checks anyway. (#316, @boshek).
* If a package fails to load, print the library paths `targets` tried to load from.

# targets 0.1.0

## Bug fixes

* `tar_test()` now skips all tests on Solaris in order to fix the problems shown on the CRAN check page.
* Enable `allow` and `exclude` to work on imports in `tar_visnetwork()` and `tar_glimpse()`.
* Put `visNetwork` legends on right to avoid crowding the graph.

## Performance

* Call `force()` on subpipeline objects to eliminate high-memory promises in target objects. Allows targets to be deployed to workers much faster when `retreival` is `"main"` (#279).

## New features

* Add a new box to the `tar_watch()` app to tabulate progress on dynamic branches (#273, @mattwarkentin).
* Store `type`, `parent`, and `branches` in progress data for `tar_watch()` (#273, @mattwarkentin).
* Add a `fields` argument in `tar_progress()` and default to `"progress"` for back compatibility (#273, @mattwarkentin).
* Add a new `tar_progress_branches()` function to tabulate branch progress (#273, @mattwarkentin).
* Add new "refresh" switch to `tar_watch()` to toggle automatic refreshing and force a refresh.

## Enhancements

* Exclude `.Random.seed` by default in `tar_visnetwork()`.
* Spelling: "cancelled" changed to "canceled".
* Enhance controls and use of space in the `tar_watch()` app.
* Centralize internal path management utilities.

## Configuration

* Skip `clustermq` tests on Solaris.

# targets 0.0.2

## CRAN response

* Avoid starting the description with the package name.
* Remove `if(FALSE)` blocks from help files to fix "unexecutable code" warnings (`tar_glimpse()`, `tar_visnetwork()`, and `tar_watch()`).
* Remove commented code in the examples (`tar_edit()`, `tar_watch_ui()`, and `tar_watch_server()`).
* Ensure that all examples, tests, and vignettes do not write to the user's home file space. (Fixed an example of `tar_workspace()`.)

## Enhancements

* Use JOSS paper in `CITATION`.

# targets 0.0.1

## Enhancements

* Accept lists of target objects at the end of `_targets.R` (#253).
* Deprecate `tar_pipeline()` and `tar_bind()` because of the above (#253).
* Always show a special message when the pipeline finishes (#258, @petrbouchal).
* Disable `visNetwork` stabilization (#264, @mattwarkentin).
* Use default `visNetwork` font size.
* Relay errors as condition messages if `error` is `"continue"` (#267, @liutiming).

# targets 0.0.0.9003

## Bug fixes

* Ensure pattern-only pipelines can be defined so they can be combined again later with `tar_bind()` (#245, @yonicd).
* Implement safeguards around `igraph` topological sort.

## Enhancements

* Topologically sort the rows of `tar_manifest()` (#263, @sctyner).

## Breaking changes

* Make patterns composable (#212, @glep, @djbirke).
* Allow workspaces to load nonexportable objects (#214).
* Make workspace files super light by saving only a reference to the required dependencies (#214).
* Add a new `workspaces` argument to `tar_option_set()` to specify which targets will save their workspace files during `tar_make()` (#214).
* Change `error = "save"` to `error = "workspace"` to so it is clearer that saving workspaces no longer duplicates data (#214).
* Rename `what` to `destroy` in `tar_destroy()`.
* Remove `tar_undebug()` because is redundant with `tar_destroy(destroy = "workspaces")`.

## New features

* Make patterns composable (#212).
* Add new dynamic branching patterns `head()`, `tail()`, and `sample()` to provide functionality equivalent to `drake`'s `max_expand` (#56).
* Add a new `tar_pattern()` function to emulate dynamic branching outside a pipeline.
* Add a new `level_separation` argument to `tar_visnetwork()` and `tar_glimpse()` to control the aspect ratio (#226).
* Track functions from multiple packages with the `imports` argument to `tar_option_set()` (#239).
* Add color for "built" progress if `outdated` is `FALSE` in `tar_visnetwork()`.
* Tweak colors in `tar_visnetwork()` to try to account for color blindness.

## Enhancements

* Return full patterns from `tar_manifest()`.
* Record package load errors in progress and metadata (#228, @psychelzh).
* `tar_renv()` now invokes `_targets.R` through a background process just like `tar_outdated()` etc. so it can account for more hidden packages (#224, @mattwarkentin).
* Set `deployment` equal to `"main"` for all targets in `tar_make()`. This ensures `tar_make()` does not waste time waiting for nonexistent files to ship over a nonexistent network file system (NFS). `tar_make_clustermq()` or `tar_make_future()` could use NFS, so they still leave `deployment` alone.

# targets 0.0.0.9002

## Breaking changes

* Add a new `size` field to the metadata to allow `targets` to make better judgments about when to rehash files (#180). We now compare hashes to check file size differences instead of doing messy floating point comparisons with ad hoc tolerances. It breaks back compatibility with old projects, but the error message is informative, and this is all still before the first official release.
* Change "local" to "main" and "remote" to "worker" in the `storage`, `retrieval`, and `deployment` settings (#183, @mattwarkentin).
* Ensure function dependencies are sorted before computing the function hash (GitHub commit f15face7d72c15c2d1098da959492bdbfcddb425).
* Move `garbage_collection` to a target-level setting, i.e. argument to `tar_target()` and `tar_option_set()` (#194). Previously was an argument to the `tar_make*()` functions.
* Allow `tar_name()` and `tar_path()` to run outside the pipeline with debugging-friendly default return values.

## Bug fixes

* Stop sending target return values over the network when `storage` is `"remote"` (#182, @mattwarkentin).
* Shorten lengths of warnings and error messages to 128 characters (#186, @gorkang).
* Restrict in-memory metadata to avoid incorrectly recycling deleted targets (#191).
* Marshal nonexportable dependencies before sending them to workers. Transport data through `target$subpipeline` rather than `target$cache` to make that happen (#209, @mattwarkentin).

## New features

* Add a new function `tar_bind()` to combine pipeline objects.
* Add `tar_seed()` to get the random number generator seed of the target currently running.

## Enhancements

* Allow target-specific `future::plan()`s through the `resources` argument of `tar_target()` (#198, @mattwarkentin).
* Use `library()` instead of `require()` in `command_load_packages()`.
* Evaluate commands directly in `targets$cache$targets$envir` to improve convenience in interactive debugging (`ls()` just works now.) This is reasonably safe now that the cache is populated at the last minute and cleared as soon as possible (#209, #210).

# targets 0.0.0.9000

* First version.
