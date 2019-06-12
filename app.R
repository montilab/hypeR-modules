# Packages
library(magrittr)
library(dplyr)
library(plyr)
library(hypeR)
library(DT)
library(visNetwork)

# Shiny
library(shiny)
library(shinyjs)
library(shinythemes)

# Local data objects and helper functions
source(file.path("utils", "helpers.R"), local=TRUE)

# ~~~~~~~~~~~~~~~~~
# Shiny Application

ui <- navbarPage(
    "hyperR - Shiny Example", id="tabs",
    source(file.path("ui", "tab1.R"), local=TRUE)$value
)

server <- function(input, output, session) {
    source(file.path("server", "tab1.R"), local=TRUE)$value
}

shinyApp(ui=ui, server=server)
