library(shiny)
library(shinysurveys)

df <- read.csv("questions.csv")

ui <- fluidPage(
  tabsetPanel(
    id = "hidden_tabs",
    # Hide the tab values.
    # Can only switch tabs by using `updateTabsetPanel()`
    type = "hidden",
    tabPanelBody(
      "panel1",
      surveyOutput(
        df = df,
        survey_title = "Hello, World!",
        survey_description = "Welcome! This is a demo survey showing off the {shinysurveys} package."
      )
    ),
    tabPanelBody("panel2",
                 sidebarLayout(
                   sidebarPanel(
                     selectInput("tagInput", "Choose a tag to filter:",
                                 choices = c("Good practice", "Literature review", "Deviations", "Neuroscience", "Quantitative", "Qualitative", "Mixed-methods"),
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

server <- function(input, output, session) {
  renderSurvey()
  # Read datasets
  content <- read_yaml(here::here("shiny", "import_data.yml"))

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
  output$filteredStatements <- renderDataTable({
    filtered_statements()
  })

  output$filteredResources <- renderDataTable({
    filtered_resources()
  })
  observeEvent(input$submit, {
    updateTabsetPanel(session, "hidden_tabs", selected = "panel2")
    survey_results <- reactive(left_join(shinysurveys::getSurveyData(), df, join_by(question_id == input_id, response == option)))
    tags <- reactive(unlist(strsplit(pull(survey_results(), tags_implied), ",")))
    updateSelectInput(session,
                      "tagInput",
                      selected = tags()
    )
  })
}

shinyApp(ui, server)
