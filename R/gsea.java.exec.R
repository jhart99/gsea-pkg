# Copyright ---------------------------------------------------------------
# 2018 The Scripps Research Institute Author: Jonathan Ross Hart

# Author ------------------------------------------------------------------
# Jonathan Ross Hart(jonathan@jonathanrosshart.com)

# Description -------------------------------------------------------------
# A gene set overlap functions 

# Input -------------------------------------------------------------------
# convert.sigs.to.matrix:
# msigdb formatted gmt files or yuor own gmt formatted gene sets

# Methods -------------------------------------------------

# Outputs -------------------------------------------------
# a sparse matrix of genes by sets


# Library imports ---------------------------------------------------------

#' Title
#'
#' @param input.ds 
#' @param input.cls 
#' @param gs.db 
#' @param output.directory 
#' @param doc.string 
#' @param non.interactive.run 
#' @param reshuffling.type 
#' @param nperm 
#' @param weighted.score.type 
#' @param nom.p.val.threshold 
#' @param fwer.p.val.threshold 
#' @param fdr.q.val.threshold 
#' @param topgs 
#' @param adjust.FDR.q.val 
#' @param gs.size.threshold.min 
#' @param gs.size.threshold.max 
#' @param reverse.sign 
#' @param preproc.type 
#' @param random.seed 
#' @param perm.type 
#' @param fraction 
#' @param replace 
#' @param save.intermediate.results 
#' @param OLD.GSEA 
#' @param use.fast.enrichment.routine 
#' @param metric 
#' @param contrast 
#' @param silent 
#'
#' @return
#' @export
#'
#' @examples
GSEA.java.exec <- function(
  input.ds,           # Input gene expression Affy dataset file in RES or GCT format
  input.cls,           # Input class vector (phenotype) file in CLS format
  gs.db,         # Gene set database in GMT format
  output.directory = "",        # Directory where to store output and results (default: "")
  doc.string            = "GSEA.analysis",   # Documentation string used as a prefix to name result files (default: "GSEA.analysis")
  non.interactive.run   = F,               # Run in interactive (i.e. R GUI) or batch (R command line) mode (default: F)
  reshuffling.type      = "sample.labels", # Type of permutation reshuffling: "sample.labels" or "gene.labels" (default: "sample.labels" 
  nperm                 = 1000,            # Number of random permutations (default: 1000)
  weighted.score.type   =  1,              # Enrichment correlation-based weighting: 0=no weight (KS), 1= weigthed, 2 = over-weigthed (default: 1)
  nom.p.val.threshold   = -1,              # Significance threshold for nominal p-vals for gene sets (default: -1, no thres)
  fwer.p.val.threshold  = -1,              # Significance threshold for FWER p-vals for gene sets (default: -1, no thres)
  fdr.q.val.threshold   = 0.25,            # Significance threshold for FDR q-vals for gene sets (default: 0.25)
  topgs                 = 20,              # Besides those passing test, number of top scoring gene sets used for detailed reports (default: 10)
  adjust.FDR.q.val      = F,               # Adjust the FDR q-vals (default: F)
  gs.size.threshold.min = 15,              # Minimum size (in genes) for database gene sets to be considered (default: 25)
  gs.size.threshold.max = 500,             # Maximum size (in genes) for database gene sets to be considered (default: 500)
  reverse.sign          = F,               # Reverse direction of gene list (pos. enrichment becomes negative, etc.) (default: F)
  preproc.type          = 0,               # Preproc.normalization: 0=none, 1=col(z-score)., 2=col(rank) and row(z-score)., 3=col(rank). (def: 0)
  random.seed           = 3338,            # Random number generator seed. (default: 123456)
  perm.type             = 0,               # For experts only. Permutation type: 0 = unbalanced, 1 = balanced (default: 0)
  fraction              = 1.0,             # For experts only. Subsampling fraction. Set to 1.0 (no resampling) (default: 1.0)
  replace               = F,               # For experts only, Resampling mode (replacement or not replacement) (default: F)
  save.intermediate.results = F,           # For experts only, save intermediate results (e.g. matrix of random perm. scores) (default: F)
  OLD.GSEA              = F,               # Use original (old) version of GSEA (default: F)
  use.fast.enrichment.routine = T,          # Use faster routine to compute enrichment for random permutations (default: T)
  metric = "Signal2Noise",
  contrast = "",
  silent = T
){
  input.cls <- if (contrast !="") paste0(input.cls, "#", contrast)
  system(paste("java -cp ~/gsea/gsea2-2.0.13.jar ",
               "-Xmx4000m xtools.gsea.Gsea ",
               "-res ", input.ds,  " ",
               "-cls ", input.cls, " ",
               "-gmx ", gs.db, " ", 
               "-collapse false ",
               "-norm meandiv ",
               "-nperm 1000 ",
               "-permute gene_set ",
               "-rnd_type no_balance ",
               "-scoring_scheme weighted ",
               "-rpt_label ", doc.string, " ",
               "-metric ", metric, " ",
               "-num 100 ", 
               "-plot_top_x ", topgs, " ",
               "-rnd_seed ", random.seed, " ",
               "-save_rnd_lists false ",
               "-set_max ", gs.size.threshold.max, " ",
               "-set_min ", gs.size.threshold.min, " ", 
               "-zip_report false ",
               "-out ", output.directory, " ",
               "-gui false"), intern=silent)
  report.dir <- list.files(output.directory)
  file.index <- max(grep(paste0("^",doc.string), report.dir))
  # Return the output files
  list.files(paste0(output.directory, "/", report.dir[file.index]), "gsea_report.*html", full.names=T)
}