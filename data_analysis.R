# IMPORTANT: Run simulations using screen. The instruction is in README.md.

# Usage example: Rscript script_varclust.R 8 28 30 30 "c(10,20,30,40)" "valerie_data.txt"
library(varclust)

args        <- commandArgs(trailingOnly = TRUE)
max.dim     <- as.numeric(args[1]) # maximal subspace dimension
numb.cores  <- as.numeric(args[2]) # number of processor's cores to use
numb.runs   <- as.numeric(args[3]) # number of random initializations
max.iter    <- as.numeric(args[4]) # number of iterations of the algorithm
clusts      <- eval(parse(text=args[5])) #number of clusters to test
filename    <- args[6] #name of the file in which data is stored


x <- t(read.table(filename, header = T))
for(num_clust in clusts){
  print(paste("Starting mlcc.reps for", num_clust, "clusters", sep = " "))
  res <- mlcc.reps(x, numb.clusters = num_clust, numb.runs = numb.runs, 
                   max.dim = max.dim, numb.cores = numb.cores, max.iter = max.iter)
  print(paste("Finished mlcc.reps for", num_clust, "clusters", sep = " "))
  print("Saving results")
  filename = paste("results/mlcc_res", paste(num_clust, max.dim, numb.runs, max.iter, sep="_"), ".RData", sep = "")
  save(res, file = filename)
  rm(res) #for saving a bit of memory 
}