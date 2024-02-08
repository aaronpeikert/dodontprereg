library(purrr)
library(shiny)
library(dplyr)
library(yaml)

# Define the UI
ui <- fluidPage(
  titlePanel("The Do's and Don'ts of Pre-Registration"),

  sidebarLayout(
    sidebarPanel(
      selectInput("tagInput", "Choose a tag to filter:",
                  choices = c("Good practice", "Literature review", "Deviations", "Neuroscience"),
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



# Define the server logic
server <- function(input, output) {

  # Read datasets
  content <- read_yaml("./import_data.yml")

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
}

# Run the application
shinyApp(ui = ui, server = server)
