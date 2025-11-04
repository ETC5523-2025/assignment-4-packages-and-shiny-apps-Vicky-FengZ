
<!-- README.md is generated from README.Rmd. Please edit that file -->

# VickyA4

<!-- badges: start -->

<!-- badges: end -->

**VickyA4** is a small R package that turns my Assignment 1–3
deliverables (PDFs and blog) into a **reproducible, structured corpus**
for teaching and exploration.  
It ships with:

- A **tidy document-level dataset** `course_dataset` built from the PDFs
  under `inst/extdata/` (no external downloads).
- A **Shiny app** (under `inst/app/`) to interactively explore word
  counts, pages, estimated reading time, etc.
- A **pkgdown site** with function documentation and a getting-started
  vignette.

> Why a package for PDFs? Because reproducibility beats screenshots. The
> `data-raw/` pipeline converts static PDFs into a consistent,
> analysis-ready table that can be versioned, documented, and reused
> across assignments.

## Installation

You can install the development version of **VickyA4** from GitHub with:

``` r
# install.packages("pak")
pak::pak("ETC5523-2025/assignment-4-packages-and-shiny-apps-Vicky-FengZ")
```

If you prefer `remotes`:

``` r
# install.packages("remotes")
remotes::install_github("ETC5523-2025/assignment-4-packages-and-shiny-apps-Vicky-FengZ")
```

## Example

Load the package and inspect the bundled dataset:

``` r
library(VickyA4)

# A quick peek at the document-level corpus
head(corpus_docs)
#>                 source n_paragraphs n_words n_chars
#> 1 A1_breaking_articles           36    1314    8022
#> 2  A2_summarising_tech          144    1879   13025
#> 3     A3_blog_snapshot            8     851    5032
```

Launch the Shiny app (this opens an interactive window; disabled while
knitting the README):

``` r
launch_app()
```

### What is inside `course_dataset`?

Each row is one PDF (one assignment). Columns include:

- `source`
- `n_paragraphs`, `n_words`, `n_chars`

You can compute simple summaries directly:

``` r
summary(corpus_docs[c("n_paragraphs", "n_words", "n_chars")])
#>   n_paragraphs       n_words        n_chars     
#>  Min.   :  8.00   Min.   : 851   Min.   : 5032  
#>  1st Qu.: 22.00   1st Qu.:1082   1st Qu.: 6527  
#>  Median : 36.00   Median :1314   Median : 8022  
#>  Mean   : 62.67   Mean   :1348   Mean   : 8693  
#>  3rd Qu.: 90.00   3rd Qu.:1596   3rd Qu.:10524  
#>  Max.   :144.00   Max.   :1879   Max.   :13025
```

## Data provenance & reproducibility

- Source PDFs live **inside the package** under `inst/extdata/`.
- The dataset is built by **`data-raw/course_dataset.R`** using
  `pdftools`.  
  Rebuild locally with:

``` r
# From the package root (development environment)
source("data-raw/build_corpus.R")
#> Using poppler version 23.08.0
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
#> ✔ Setting active project to "E:/Master/First year/S2/ETC5523 - Communicating
#>   with Data/Assignment/A4/VickyA4".
#> ✔ Saving "corpus_paragraphs" and "corpus_docs" to "data/corpus_paragraphs.rda"
#>   and "data/corpus_docs.rda".
#> ☐ Document your data (see <https://r-pkgs.org/data.html>).
#> Built datasets: corpus_paragraphs (paragraph-level) and corpus_docs (document-level).
#> Sources detected: A1_breaking_articles, A2_summarising_tech, A3_blog_snapshot
#> Total paragraphs: 188
```

This design avoids brittle links and ensures anyone can reproduce the
exact same dataset from the same PDFs.

## pkgdown

A pkgdown site will host function docs, the vignette, and examples.

- **Planned URL:** <https://YOUR-USERNAME.github.io/VickyA4/>
- After the first deployment, please update this README to link the live
  site.

## Limitations (and how to think critically)

- Text extracted from PDFs is not perfect: hyphenation, footers, or
  equations may affect counts.
- Sentence counts are approximate (punctuation-based). Treat
  `read_minutes_est` as a **guide**, not ground truth.
- If you need deeper NLP (topic modeling, readability indices), extend
  the `data-raw/` script and document the new fields.
