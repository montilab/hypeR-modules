library(shiny)
library(shinyjs)
library(shinythemes)
library(hypeR)

# Some other packages you might need in this example
library(magrittr)
library(tibble)
library(stringr)
library(dplyr)
library(reactable)
library(ggplot2)

# An example signature
example <- "ACHE,ADGRG1,AMOT,CDK5R1,CRMP1,DPYSL2,ETS2,GLI1,HEY1,HEY2,UNC5C,VEGFA,VLDLR"

ui <- 
navbarPage(
    title="hypeR - Shiny",
    id="app",
    theme=shinytheme("simplex"),
    tags$head(includeCSS("www/fonts.css")),
    tags$head(includeCSS("www/reactable.css")),
    fluidPage(
        sidebarLayout(
            sidebarPanel(
                # Put your geneset selector module anywhere
                hypeR::genesets_UI("genesets"),
                
                # Add components specific to your application
                hr(),
                textAreaInput("signature", 
                              label="Signature", 
                              rows=5,
                              value=example, 
                              resize="vertical"),
                
                actionButton("enrichment", "Enrichment")
            ),
            mainPanel(
                # Fetched Genesets
                uiOutput("table"),
                # Enrichment plot
                plotOutput("plot")
            )
        )
    )
)

server <- function(input, output, session) {
    # Retrieve selected genesets as a reactive variable
    # Selection changes will update this variable and propogate to downstream functions
    genesets <- hypeR::genesets_Server("genesets", clean=TRUE)
    
    # Your custom downstream functions
    output$table <- renderUI({
        
        # Here are the fetched genesets
        gsets <- genesets()
        
        # Show them in a fancy table
        df <- data.frame(Geneset=names(gsets), Symbols=sapply(gsets, function(x) paste(head(x,5), collapse=",")))
        tbl <- reactable(df,
                         rownames=FALSE,
                         compact=TRUE, 
                         fullWidth=TRUE,
                         defaultPageSize=5,
                         defaultColDef=colDef(headerClass="rctbl-header"),
                         style=list(backgroundColor="#FCFCFC"),
                         showPageSizeOptions=TRUE,
                         rowStyle=list(cursor="pointer"))
        
        dat <- htmltools::div(class="rctbl-obj-teeny", tbl)
        return(dat)
    })
    
    reactive_plot <- eventReactive(input$enrichment, {
        
        # Here are the fetched genesets again
        gsets <- genesets()
        
        # Process the signature into a character vector
        signature <- input$signature %>%
                     stringr::str_split(pattern=",", simplify=TRUE) %>%
                     as.vector()
        
        # Run hypeR
        hyp <- hypeR::hypeR(signature, gsets, test="hypergeometric", background=36000)
        p <- hypeR::hyp_dots(hyp, top=10, abrv=100, sizes=TRUE, fdr=0.25)
        
        # These are just ggplot objects you could customize
        p + theme(axis.text=element_text(size=12, face="bold"),
                  plot.background=element_rect(fill="#FCFCFC"),
                  legend.background=element_rect(fill="#FCFCFC"))
    })
    
    output$plot <- renderPlot({
        reactive_plot()
    })
}

options(shiny.autoreload = TRUE)
shinyApp(ui, server)
