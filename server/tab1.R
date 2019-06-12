global_values <- reactiveValues(
    hyp = NULL
)

do_hypeR <- function() {

    # Signature
    signature <- input$hyper_signature
    if (signature == "Signature") {
        signature <- unranked.signature
        test <- "hypergeometric"
    }
    if (signature == "Ranked Signature") {
        signature <- ranked.signature
        test <- "kstest"
    }

    # Genesets
    genesets <- input$hyper_genesets
    if (genesets %in% rgsets_options) {    
        gsets <- readRDS(file.path("data/rgsets", genesets))
    }
    if (genesets %in% msigdb_options) {
        gsets <- msigdb_fetch(msigdb_path, genesets)
    }
    if (genesets %in% hyperdb_options) {
        gsets <- hyperdb_fetch(genesets)
    }

    bg <- input$hyper_background
    
    hyp <- hypeR(signature=signature, 
                 gsets=gsets, 
                 test=test,
                 bg=bg, 
                 do_plots=TRUE)
    
    return(hyp)
}

wrap_do_hypeR <- eventReactive(input$hyper_button, {
    global_values$hyp <- do_hypeR()
})

dynamic_hyp <- function() {
    if (!is.null(global_values$hyp)) {
        
        # Store data
        dat = list()

        # Dynamic filters
        dat$top <- input$hyper_top
        dat$val <- input$hyper_metric
        dat$pval_cutoff <- ifelse(input$hyper_metric == "pval", input$hyper_cutoff, 1)
        dat$fdr_cutoff <- ifelse(input$hyper_metric == "fdr", input$hyper_cutoff, 1)
       
        # Grab globally stored hyp object
        dat$hyp <- global_values$hyp

        return(dat)
    }  
}

output$hyper_table <- renderDataTable({
    wrap_do_hypeR(); dat <- dynamic_hyp()
    if (!is.null(dat)) {
        dat$hyp$data %>%
        dplyr::filter(pval <= dat$pval_cutoff) %>%
        dplyr::filter(fdr <= dat$fdr_cutoff) %>%
        head(dat$top) %>%
        datatable(options=list("pageLength"=10), 
                  rownames=FALSE, 
                  selection="single", 
                  style="bootstrap")
    }
})

output$hyper_dots <- renderPlot({
    wrap_do_hypeR(); dat <- dynamic_hyp()
    if (!is.null(dat)) {
        return(hyp_dots(dat$hyp, 
                        title="Dots Plot",
                        pval_cutoff=dat$pval_cutoff,
                        fdr_cutoff=dat$fdr_cutoff,
                        top=dat$top, 
                        val=dat$val,
                        show_plots=FALSE, 
                        return_plots=TRUE))
    }
})

output$hyper_plot <- renderPlot({
    wrap_do_hypeR(); dat <- dynamic_hyp()
    if (!is.null(dat)) {
        hyp_df <- dat$hyp$data %>%
                  dplyr::filter(pval <= dat$pval_cutoff) %>%
                  dplyr::filter(fdr <= dat$fdr_cutoff) %>%
                  head(dat$top)
        
        # Find selected geneset in table
        if(nrow(hyp_df) > 0) {
            row <- input$hyper_table_cell_clicked$row
            if (!is.null(row)) {
                label <- hyp_df[row, "label"]
            } else {
                label <- hyp_df[1, "label"]
            }
            return(dat$hyp$plots[[label]])
        }
    }
})

output$hyper_emap <- renderVisNetwork({
    wrap_do_hypeR(); dat <- dynamic_hyp()
    if (!is.null(dat)) {
        return(hyp_emap(dat$hyp,
                        similarity_metric="jaccard_similarity",
                        similarity_cutoff=0.5,
                        pval_cutoff=dat$pval_cutoff,
                        fdr_cutoff=dat$fdr_cutoff,
                        top=dat$top, 
                        val=dat$val,
                        show_plots=FALSE, 
                        return_plots=TRUE))
    }
})

output$hyper_hmap <- renderVisNetwork({
    wrap_do_hypeR(); dat <- dynamic_hyp()
    if (!is.null(dat)) {
        if (is(dat$hyp$args$gsets, "rgsets")) {
            return(hyp_hmap(dat$hyp,
                            pval_cutoff=dat$pval_cutoff,
                            fdr_cutoff=dat$fdr_cutoff,
                            top=dat$top, 
                            val=dat$val,
                            show_plots=FALSE, 
                            return_plots=TRUE))
        }
    }
})
