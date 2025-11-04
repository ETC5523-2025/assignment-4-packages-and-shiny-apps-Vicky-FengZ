# inst/app/app.R
library(shiny)
library(bslib)
library(dplyr)
library(stringr)

ui <- page_fluid(
  theme = bs_theme(bootswatch = "flatly"),
  card(
    card_header("Explore the Assignment Corpus"),
    layout_columns(
      col_widths = c(4, 8),
      card(
        card_header("Filters"),
        selectInput("src", "Source document:",
                    choices = sort(unique(corpus_paragraphs$source)),
                    selected = sort(unique(corpus_paragraphs$source))[1]),
        sliderInput("range", "Word count range:", min = 0,
                    max = max(corpus_paragraphs$n_words, na.rm = TRUE),
                    value = c(0, 80)),
        textInput("kw", "Keyword (optional):", placeholder = "e.g. regression, credibility")
      ),
      card(
        card_header("Outputs"),
        plotOutput("hist_words"),
        tableOutput("peek"),
        p(em("How to interpret:"),
          " The histogram shows the distribution of paragraph word counts under current filters.",
          " Use the table to preview matched paragraphs; consider whether your summaries are concise/verbose.")
      )
    ),
    p(strong("Field descriptions:"),
      " see help(\"corpus_paragraphs\") and help(\"corpus_docs\").")
  )
)

server <- function(input, output, session) {
  filtered <- reactive({
    d <- corpus_paragraphs |>
      filter(source == input$src,
             n_words >= input$range[1],
             n_words <= input$range[2])
    if (nzchar(input$kw)) {
      re <- regex(input$kw, ignore_case = TRUE)
      d <- d |> filter(str_detect(paragraph, re))
    }
    d
  })

  output$hist_words <- renderPlot({
    hist(filtered()$n_words,
         main = paste("Word count -", input$src),
         xlab = "Words per paragraph")
  })

  output$peek <- renderTable({
    head(filtered() |> select(para_id, n_words, paragraph), 5)
  }, striped = TRUE, bordered = TRUE, width = "100%")
}

shinyApp(ui, server)
