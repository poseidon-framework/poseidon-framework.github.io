[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
![GitHub R package version](https://img.shields.io/github/r-package/v/poseidon-framework/poseidonR)
[![Travis-CI Build Status](https://travis-ci.com/poseidon-framework/poseidonR.svg?branch=master)](https://travis-ci.com/poseidon-framework/poseidonR)
[![Coverage Status](https://img.shields.io/codecov/c/github/poseidon-framework/poseidonR/master.svg)](https://codecov.io/github/poseidon-framework/poseidonR?branch=master)

# poseidonR

poseidonR is an R package to simplify the interaction with Poseidon packages. So far it mostly focusses on `.janno` files and provides a dedicated R S3 class `janno` that inherits from `tibble` and allows to tidily read and manipulate the context information stored in them.

* [Installation](#installation)
* [Quickstart](#quickstart)
  + [Read janno files](#read-janno-files)
  + [Validate janno files](#validate-janno-files)
  + [Process age information in janno objects](#process-age-information-in-janno-objects)
  + [General helper functions](#general-helper-functions)
* [For developers](#for-developers)

## Installation

Install the poseidonR package from github with the following command in R:

```
if(!require('remotes')) install.packages('remotes')
remotes::install_github('poseidon-framework/poseidonR')
```

## Quickstart

### Read janno files

You can read `.janno` files with

```
my_janno_object <- poseidonR::read_janno(
  path = "path/to/my/janno_file.janno",
  to_janno = TRUE,
  validate = TRUE
)
```

The path argument takes one or multiple file paths or directory paths. `read_janno()` searches recursively for `.janno` files in the directory paths.

Before loading the `.janno` files are validated with `poseidonR::validate_janno()`. You can avoid this potentially time consuming step with `validate = FALSE`.

Usually the `.janno` files are loaded as normal `.tsv` files with every column type set to `character` and then the columns are transformed to the intended types. This transformation can be turned off with `to_janno = FALSE`.

`read_janno()` returns an object of class `janno`.

### Validate janno files

You can validate `.janno` files with

```
my_janno_issues <- poseidonR::validate_janno("path/to/my/janno_file.janno")
```

`validate_janno` returns a tibble with issues in the respective `.janno` files.

### Process age information in janno objects

`.janno` files contain age information in multiple different columns. The function `poseidonR::process_age()` works with this age information to calculate different derived columns, which are then added to the input `janno` object. 

You can run it with

```
poseidonR::process_age(
  my_janno_object,
  choices = c("Date_BC_AD_Prob", "Date_BC_AD_Median_Derived", "Date_BC_AD_Sample"),
  n = 100
)
```

The `choices` argument contains the list of columns that should be calculated and added. `n` is the number of samples that should be drawn for `Date_BC_AD_Sample`.

#### Output column `Date_BC_AD_Prob`

`Date_BC_AD_Prob` is a list column with a data.frame for each `janno` row ("samples"). This data.frame stores a density distribution (`sum_dens`) over a set of years (`age`) with the information of a given year is within two standard deviations (`two_sigma`) from the median age (`center`). 

| age   | sum_dens   | two_sigma | center |
|-------|------------|-----------|--------|
| -1506 | 0.00000456 | FALSE     | FALSE  |
| -1505 | 0.00000622 | FALSE     | FALSE  |
| -1504 | 0.00000907 | FALSE     | FALSE  |
| ...   | ...        | ...       | ...    |

The density distributions are either the result of (sum) calibration on radiocarbon dates or -- for samples that are only contextually dated -- a uniform distribution over the archaeologically determined age.

#### Output column `Date_BC_AD_Median_Derived`

`Date_BC_AD_Median_Derived` is a simple integer column with the median age (in years) as determined for `Date_BC_AD_Prob`.

#### Output column `Date_BC_AD_Sample`

`Date_BC_AD_Sample` is again a list column with a vector of `n` ages (in years) for each sample. These ages are drawn with `sample(prob = ...)` considering the probability distribution calculated for `Date_BC_AD_Prob`.

### General helper functions

When you're preparing a `.janno` file and want to determine the entries for the columns `Date_BC_AD_Median`, `Date_BC_AD_Start` and `Date_BC_AD_Stop` from radiocarbon dates, then `poseidonR::quickcalibrate()` might come in handy.

```
poseidonR::quickcalibrate(ages, sds)
```

`ages` takes a list of uncalibrated ages BP and `sds` a list of standard deviations. If multiple ages are provided for one sample, then the function automatically performs a sum calibration. 

`quickcalibrate(list(1000, c(2000, 2200)), list(20, c(30, 40)))` for example returns a data.frame like this: 

| Date_BC_AD_Median | Date_BC_AD_Start | Date_BC_AD_Stop |
|-------------------|------------------|-----------------|
| 1029              | 996              | 1144            |
| -88               | -364             | 98              |

This output can be copied to the new `.janno` file.

## For developers

- When pushing to this repository this [pre-commit hook shared by Robert M Flight](https://rmflight.github.io/post/package-version-increment-pre-and-post-commit-hooks) should be used to increment the R package version number in the DESCRIPTION on every commit automatically. Use `doIncrement=FALSE git commit -m "commit message"` to avoid this behaviour for individual commits.
- `tests/testthat/poseidonTestData` is a [git submodule](https://github.blog/2016-02-01-working-with-submodules/). It mirrors a certain state of [poseidon-framework/poseidonTestData](https://github.com/poseidon-framework/poseidonTestData) but has to be updated manually with `git pull`.


