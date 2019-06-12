# Example data
hypdat <- readRDS(file.path(system.file("extdata", package="hypeR"), "hypdat.rds"))

# Signature
limma <- hypdat$limma
unranked.signature <- limma %>% filter(t > 0 & fdr < 0.001) %>% use_series(symbol)
ranked.signature <- limma %>% arrange(desc(t)) %>% use_series(symbol)
signatures <- list("hypergeometric"=c("Signature"="Signature"), "kstest"=c("Ranked Signature"="Ranked Signature"))

# Genesets
msigdb_path <- list("output_dir"="data/msigdb", "vs"="v6.2.1")

msigdb_options <- c("Positional (326)"                          = "C1",
                    "Chemical and Genetic Perturbations (3433)" = "C2.CGP",
                    "Canonical Pathways (252)"                  = "C2.CP",
                    "Canonical Biocarta (217)"                  = "C2.CP.BIOCARTA",
                    "Canonical Kegg (186)"                      = "C2.CP.KEGG",
                    "Canonical Reactome (674)"                  = "C2.CP.REACTOME",
                    "Motif miRNA Targets (221)"                 = "C3.MIR",
                    "Motif Transcription Factor Targets (615)"  = "C3.TFT",
                    "Cancer Gene Neighborhoods (427)"           = "C4.CGN",
                    "Cancer Modules (431)"                      = "C4.CM",
                    "GO Biological Process (4436)"              = "C5.BP",
                    "GO Cellular Component (580)"               = "C5.CC",
                    "GO Molecular Function (901)"               = "C5.MF",
                    "Oncogenic Signatures (189)"                = "C6",
                    "Immunologic Signatures (4872)"             = "C7",
                    "Hallmark (50)"                             = "H")

hyperdb_options <- readRDS("data/hyperdb/hyperdb_pathways.rds")

rgsets_options <- c("Reactome (377)" = "REACTOME-377.rds")
