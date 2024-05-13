# Load necessary libraries
library(googlesheets4)
library(yaml)
library(dplyr)
library(tidyr)

# Specify the URL of the Google Spreadsheet
spreadsheet_url <- "https://docs.google.com/spreadsheets/d/1SSGMwThXidvQ_ACh4A4RltSF-JLbfRq3_qrLPi5Cee8/edit#gid=836920715"

gs4_deauth()

# Read the Google Spreadsheet without authentication
statements <- read_sheet(spreadsheet_url, sheet = "do's and don'ts-statements w/ tags")
resources <- read_sheet(spreadsheet_url, sheet = "resources", skip = 1)

# Reshape the data to long format to handle multiple tag columns
statements_long <- statements %>%
  pivot_longer(cols = starts_with("Tag"),
               names_to = "Tag",
               values_to = "Value",
               values_drop_na = TRUE) %>%
  select(-Tag) %>%
  group_by(Statement) %>%
  summarise(Do = c("don't", "do")[first(Do)+1],
            tags = list(Value),
            .groups = 'drop')

# Generate id numbers
statements_long <- statements_long %>%
  mutate(id = row_number())

# Rename columns to match YAML structure
statements_long <- statements_long %>%
  rename(title = Statement,
         please = Do) %>%
  select(id, title, please, tags)

resources_long <- resources %>%
  rename(Resource = `resource/template`) %>%
  pivot_longer(cols = starts_with("Tag"),
               names_to = "Tag",
               values_to = "Value",
               values_drop_na = TRUE) %>%
  select(-Tag) %>%
  group_by(Resource) %>%
  summarise(tags = list(Value),
            .groups = 'drop')

# Generate id numbers
resources_long <- resources_long %>%
  mutate(id = row_number())

# Rename columns to match YAML structure
resources_long <- resources_long %>%
  rename(title = Resource) %>%
  mutate(doi = stringr::str_extract(title, "10\\.\\S*")) %>%
  select(id, title, tags, doi)

# Convert to a list for YAML
list_data <- list(statements = split(statements_long, seq(nrow(statements_long))) %>% unname(),
                  resources = split(resources_long, seq(nrow(resources_long))) %>% unname())

# Save the data as a YAML file
write_yaml(list_data, "myapp/import_data.yml")
