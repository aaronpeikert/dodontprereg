library(shiny)
library(dplyr)
library(DT)
library(yaml)
library(shinysurveys)
library(tibble)
library(purrr)

library(shinysurveys)
source("fix_shinysurveys.R")


survey_questions <- read.csv("questions.csv")

all_tags <- function(questions){
  unlist(strsplit(pull(questions, tags_implied), ",")) %>%
    unique() %>%
    na.omit() %>%
    sort()
}

ui <- fluidPage(
  tabsetPanel(
    id = "hidden_tabs",
    # Hide the tab values.
    # Can only switch tabs by using `updateTabsetPanel()`
    type = "hidden",
    tabPanelBody(
      "panel1",
      uiOutput("survey")
    ),
    tabPanelBody("panel2",
                 sidebarLayout(
                   sidebarPanel(
                     selectizeInput("tagInput", "Choose a tag to filter:",
                                 choices = all_tags(survey_questions),
                                 multiple = TRUE)
                   ),

                   mainPanel(
                     tabsetPanel(
                       tabPanel("Statements", dataTableOutput("filteredStatements")),
                       tabPanel("Resources", dataTableOutput("filteredResources"))
                     )
                   )
                 )
    )
  )
)

extendInputType("checkbox", {
  shiny::checkboxGroupInput(
    inputId = surveyID(),
    label = surveyLabel(),
    choices = surveyOptions(),
  )
})

server <- function(input, output, session) {
  survey_questions <- reactiveVal(survey_questions)

  ui_rendered <- reactiveVal(FALSE)

  survey_step <- reactiveVal(1)
  survey_results <- reactiveVal(tibble())

  output$survey <- renderUI({

    req(survey_step())
    ui_rendered(TRUE)

    filtered_questions <- survey_questions() %>% filter(survey_id == survey_step())
    if(nrow(filtered_questions) > 0){
      surveyOutput(filtered_questions, "Welcome to the Do's and Don'ts of Pre-Registration",
                   "To help us identify the materials relevant to your current situation, please answer a couple of questions.")
    } else {
      NULL
    }
  })


  observeEvent(ui_rendered(), {
    if (ui_rendered()) {
      renderSurvey()
    }
    ui_rendered(FALSE)
  })

    # Read datasets
  content <- read_yaml("import_data.yml")

  statements <- content$statements %>% map(function(tb) {
    tb <- as_tibble(tb)
    if (!is.list(tb$tags)) {
      tb <- tb %>%
        mutate(tags = map(tags, list))
    }
    tb
  }) %>% bind_rows()

  resources <- content$resources %>% map(function(tb) {
    tb <- as_tibble(tb)
    if (!is.list(tb$tags)) {
      tb <- tb %>%
        mutate(tags = map(tags, list))
    }
    tb
  }) %>% bind_rows()


  # Reactive expression to filter statements based on selected tags
  filtered_statements <- reactive({
    if (length(input$tagInput) == 0) {
      return(statements)
    } else {
      sel <- c(input$tagInput, "Show always")
      statements %>%
        filter(sapply(tags, function(tag_list) any(sel %in% tag_list)))
    }
  })

  # Reactive expression to filter resources based on selected tags
  filtered_resources <- reactive({
    if (length(input$tagInput) == 0) {
      return(resources)
    } else {
      sel <- c(input$tagInput, "Show always")
      resources %>%
        filter(sapply(tags, function(tag_list) any(sel %in% tag_list)))
    }
  })

  # Output the filtered datasets
  output$filteredStatements <- DT::renderDT({
    filtered_statements() %>%
      select(id, title) %>%
      datatable(rownames = FALSE)
  })

  output$filteredResources <- DT::renderDT({
    filtered_resources() %>%
      select(id, title, doi) %>%
      mutate(doi = ifelse(is.na(doi), "", paste0('<a href="https://doi.org/', doi, '">', doi, '</a>'))) %>%
      datatable(rownames = FALSE, escape = FALSE)
  })

  observeEvent(input$submit, {
    finish <- FALSE

    new_results <- shinysurveys::getSurveyData() %>% tidyr::separate_longer_delim(response, delim = ",")



    if (survey_step() == 1) {
      if (length(setdiff(new_results$response, c("Report deviations after a pre-reg", "Convince someone / decide for myself whether to pre-register"))) == 0) {
        finish <- TRUE # Finish the survey
      } else if (!"Work on a pre-registration" %in% new_results$response) {
        survey_step(2) # Skip step 2
      }

    } else if (survey_step() == 2) {

    } else if (survey_step() == 3) {

      if(!new_results$response %in% c("Quantitative", "Mixed-methods")) {
        survey_questions(survey_questions() %>% filter(input_id != "q_methods_quant"))
      }

      if(new_results$response != "Literature review (incl. meta-analyses)") { #Should this be displayed for mixed methods? Would tend to no.
        survey_questions(survey_questions() %>% filter(input_id != "q_methods_lit"))
      }

      if (!new_results$response %in% c("Literature review (incl. meta-analyses)", "Quantitative")) { # Ideally this would filter for meta-analyses - but then we have ever more survey steps
        survey_questions(survey_questions() %>% filter(input_id != "q_approach"))
      }
    }

    survey_step(survey_step() + 1)
    survey_results(bind_rows(survey_results(), new_results))

    if (survey_step() > max(survey_questions()$survey_id) || finish) {
      final_results <- left_join(survey_results(), survey_questions(), join_by(question_id == input_id, response == option), copy = TRUE)
      tags <- all_tags(final_results)
      print(tags)
      updateSelectInput(session,
                        "tagInput",
                        selected = tags)
      updateTabsetPanel(session, "hidden_tabs", selected = "panel2")
    }

  })
}

shinyApp(ui, server)
