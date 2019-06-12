tabPanel("Hyper Enrichment",
  tags$head(
      tags$style(HTML("hr {border-top: 1px solid #000000;}"))
  ),
  fixedRow(
    column(1),
    column(10,
      flowLayout(
        selectizeInput('hyper_signature', label="Signature", choices=signatures, selected="Ranked Signature"),      
        selectizeInput('hyper_genesets', label="Genesets", choices=list(rgsets=rgsets_options, msigdb=msigdb_options, hyperdb=hyperdb_options), selected="REACTOME-377.rds"),
        numericInput("hyper_background", label="Background", value=52000),
        align="center"
      ),
      flowLayout(
        numericInput("hyper_top", label="Limit Genesets", value=25),
        selectInput("hyper_metric", label="Significance Metric", choices=c("P-Value"="pval", "FDR"="fdr"), selected="fdr"),
        numericInput("hyper_cutoff", label="Significance Cutoff", value=0.25),
        align="center"
      ),
      flowLayout(
        actionButton("hyper_button", "Perform hypeR"),
        align="center"
      )
    ),
    column(1)
  ),
  hr(),
  fixedRow(
    tags$br(),
    column(12,
      h4("Enrichment Results", align="center"),
      dataTableOutput("hyper_table")
    )
  ),
  fixedRow(
    tags$br(),
    column(7,
      plotOutput("hyper_dots", height="400px")
    ),
    column(5,
      plotOutput("hyper_plot", height="400px")
    )
  ),
  fixedRow(
    tags$br(),
    column(1),
    column(10,
      visNetworkOutput("hyper_emap", height="700px")
    ),
    column(1)
  ),
  fixedRow(
    tags$br(),
    column(1),
    column(10,
      visNetworkOutput("hyper_hmap", height="700px")
    ),
    column(1)
  )
)
