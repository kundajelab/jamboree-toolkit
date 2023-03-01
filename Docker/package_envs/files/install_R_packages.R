install.packages(c("IRkernel", "BiocManager"), dependencies = TRUE)
IRkernel::installspec(user = TRUE)
BiocManager::install(ask = FALSE)

install.packages(c("devtools"))
BiocManager::install(c("EnhancedVolcano", "cowplot", "openxlsx", "httr", "preprocessCore", "impute", "GO.db", "WGCNA", "DESeq2", "limma", "ggthemes", "tidyverse", "ggdendro", "colorspace", "ComplexHeatmap", "circlize", "BiocParallel", "ggfortify", "ggplot2", "plotly", "sva", "stringr", "gprofiler2", "scran", "scater", "batchelor", "BiocParallel", "gtools", "ggpubr", "ggrepel", "RColorBrewer", "pals", "seriation", "dplyr", "grid", "matrixStats", "gplots", "ComplexHeatmap", "readr", "BiocGenerics", "hdf5r", "Rcpp", "RcppArmadillo", "SingleCellExperiment", "viridis", "fitdistrplus", "umap"),
ask = FALSE, update = TRUE, dependencies = TRUE)

devtools::install_github("shmohammadi86/ACTIONet", ref = "R-devel")
devtools::install_github('immunogenomics/presto')