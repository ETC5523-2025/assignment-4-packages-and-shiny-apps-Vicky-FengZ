# Dependencies
required <- c(
  "pdftools",
  "dplyr",
  "tidyr",
  "stringr",
  "tibble",
  "purrr"
)
to_install <- setdiff(required, rownames(installed.packages()))
if (length(to_install)) install.packages(to_install)

library(pdftools)
library(dplyr)
library(tidyr)
library(stringr)
library(tibble)
library(purrr)

# Input directory
ext_dir <- "inst/extdata"
stopifnot(dir.exists(ext_dir))

# List ONLY PDF files
pdf_files <- list.files(ext_dir, pattern = "\\.pdf$", full.names = TRUE)

# Fail early if no PDFs are found
if (length(pdf_files) == 0) {
  stop("No PDF files found in inst/extdata/. Please place your PDFs there and re-run.")
}


# Split a single PDF into paragraphs, keeping page numbers.
read_pdf_to_tibble <- function(path, source_id) {
  pages <- pdftools::pdf_text(path)

  # For each page, split into paragraphs and build a tibble with page index
  out <- purrr::imap(pages, function(txt, i_page) {
    paras <- unlist(str_split(txt, "\\n\\s*\\n+"))
    paras <- str_squish(paras)
    paras <- paras[paras != ""]

    if (length(paras) == 0) {
      # Return empty tibble for pages with no content
      return(tibble(source = character(), page = integer(), paragraph = character()))
    }

    tibble(
      source    = source_id,
      page      = rep.int(i_page, length(paras)),
      paragraph = paras
    )
  })

  # Bind all pages; add a running paragraph id within this source
  out <- bind_rows(out) |>
    mutate(para_id = row_number())

  out
}

# Safe word count (uses stringr word boundary)
count_words <- function(x) {
  ifelse(x == "" | is.na(x), 0L, str_count(x, boundary("word")))
}

# Parse all PDFs
pdf_tbls <- map(pdf_files, ~{
  fn  <- basename(.x)
  sid <- tools::file_path_sans_ext(fn)  # e.g., "Assignment_1"
  read_pdf_to_tibble(.x, sid)
})

# Combine all PDFs into one paragraph-level table
pdf_tbl <- bind_rows(pdf_tbls)

# Basic features
corpus_paragraphs <- pdf_tbl |>
  mutate(
    doc_id  = paste0(source, "_", para_id),
    n_chars = nchar(paragraph),
    n_words = count_words(paragraph)
  ) |>
  # Keep a tidy, minimal set of columns used by the Shiny app and docs
  select(doc_id, source, page, para_id, paragraph, n_chars, n_words)

# Document-level summary (1 row per source)
corpus_docs <- corpus_paragraphs |>
  group_by(source) |>
  summarise(
    n_paragraphs = n(),
    n_words      = sum(n_words, na.rm = TRUE),
    n_chars      = sum(n_chars, na.rm = TRUE),
    .groups = "drop"
  )

# Save to data
usethis::use_data(corpus_paragraphs, corpus_docs, overwrite = TRUE)

message("Built datasets: corpus_paragraphs (paragraph-level) and corpus_docs (document-level).")
message(paste0("Sources detected: ", paste(unique(corpus_paragraphs$source), collapse = ", ")))
message(paste0("Total paragraphs: ", nrow(corpus_paragraphs)))
