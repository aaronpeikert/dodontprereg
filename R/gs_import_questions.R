# Load necessary libraries
library(googlesheets4)
library(yaml)
library(dplyr)
library(tidyr)

# Specify the URL of the Google Spreadsheet
spreadsheet_url <- "https://docs.google.com/spreadsheets/d/1SSGMwThXidvQ_ACh4A4RltSF-JLbfRq3_qrLPi5Cee8/edit#gid=836920715"

gs4_deauth()

# Read the Google Spreadsheet without authentication
questions <- read_sheet(spreadsheet_url, sheet = "questions_programatic")
write.csv(questions, here::here("shiny/questions.csv"))
