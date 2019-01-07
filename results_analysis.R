library(varclust)
library(stringr)
library(ggplot2)
library(RcppEigen) # for linear models

#Below we extract all results to make the analysis easier
num_clusters = c("50", "100", "150", "175", "200", "225", "250")
results <- replicate(length(num_clusters), list(segmentation=NA, BIC=NA, basis=NA), simplify = F)
names(results) <- num_clusters

results_folder_path = "./results/november/"
filename_pattern = "mlcc_res{K}_8_40_30.RData"

for(K in num_clusters) {
  filename <- str_glue(paste0(results_folder_path, filename_pattern))
  load(filename)
  results[[K]] <- res
}

# here we plot mBIC values - turns out 200 has the highest
getmBIC <- function(result) {
  result$BIC
}

mBICs <- unlist(lapply(results, getmBIC))
ggplot(mapping = aes(x=as.numeric(lapply(num_clusters, strtoi)), y=mBICs)) + geom_point() + 
  labs(x = "Number of clusters", y="mBIC")

#this is how you can extract clustering of interest (use double squared brackets and number of clusters of interest)
result <- results[["200"]]
K <- length(result$basis)

dataset_file   <- "valerie_data.txt" #name of the file with Valerie's data
x <- t(read.table(file=dataset_file, header=T))
cluster_dimensionalities <- sapply(result$basis, ncol) #you can for example check dimensionalities of each subpace
print(paste("Dimensionalities are: ", cluster_dimensionalities))
ggplot(mapping = aes(x=cluster_dimensionalities)) + geom_histogram(binwidth = 1) #You can also plot a histogram
number_of_variables <- NULL; 
for(i in 1:K){
    number_of_variables <- c(number_of_variables, length(which(result$segmentation==i))) #you can find how many variables are in each cluster
}
print(paste("Number of variables in each cluster: ", number_of_variables))
ggplot(mapping = aes(x=number_of_variables)) + geom_histogram(bins=50)  #You can also plot a histogram
ggplot(mapping = aes(x=number_of_variables[number_of_variables < 200])) + geom_histogram(bins=50)
print(number_of_variables[cluster_dimensionalities==1])
print(which(cluster_dimensionalities==1))
print(length(which(number_of_variables==0)))

ind <- 1
cl <- which(result$segmentation==ind) # you can check which variables are in the first cluster
rsss <- NULL; # let's try to find what variables are most correlated with the principal components
# to do so we will compute RSS when trying to fit a linear model where a variable is being 
#explained and the PCs are the explanatory varaibles
#Beware! The code below can take quite long time to compute
for(i in 1:ncol(x[,cl])) {
  var <- x[,cl][ , i];
  rsss <- c(rsss, sum(fastLmPure(result$basis[[ind]], var, method=0L)$residuals^2))
}
print(paste("Residual sum of squares for cluster ",ind, " ", rsss))
 
# to find out more info you could also calculate the PCs from scratch using prcomp 
# (in order to get loadings, eigenvalues, etc)

principal <- prcomp(x=x[,cl])


# extract number of variables in cluster with given dimension
indices <- which(cluster_dimensionalities == 5)
print(number_of_variables[indices])
# or extract the variables form a cluster with small dimensionality
ind <- which(cluster_dimensionalities==2)[1]
vars <- x[, which(result$segmentation==ind)]


factors <- do.call(cbind, result$basis) #extract all factors to a single matrix 
#(the order is kept so if result$basis[[1]] [the factors in the first cluster] has 8 columns[principal components]
# then the first 8 columns of calculated factors matrix are these PCs)
