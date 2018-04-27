library(varclust)
library(RcppEigen) # for linear models

K           <- 40 #number of clusters currently checked
filename1   <- "mlcc_res40.RData" #name of the file woth Valerie's data
filename2   <- "valerie_data.txt" #name of the file in which results of mlcc.reps are stored
load(filename2) #now the result are inside res variable
res40 <- get("res") #assign the results to a variable with more meaningful name
x <- t(read.table(file=filename1, header=T))
dims <- sapply(res$basis, ncol) #you can for example check dimensionalities of each subpace
#print(paste("Dimensionalities are: ", dims))
#hist(dims) You can also plot a histogram
lens <- NULL; 
for(i in 1:K){
    lens <- c(lens, length(which(res$segmentation==i))) #you can find how many variables are in each cluster
}
#print(paste("Number of variables in each cluster: ", lens))
#hist(lens)  You can also plot a histogram

ind <- 1
cl <- which(res$segmentation==ind) # you can check which variables are in the first cluster
rsss <- NULL; # let's try to find what variables are most correlated with the principal components
# to do so we will compute RSS when trying to fit a linear model where a variable is being 
#explained and the PCs are the explanatory varaibles
#Beware! The code below can take quite long time to compute
for(i in 1:ncol(x[,cl])) {
  var <- x[,cl][ , i];
  rsss <- c(rsss, sum(fastLmPure(res$basis[[ind]], var, method=0L)$residuals^2))
}
print(paste("Residual sum of squares for cluster ",ind, " ", rsss))
 
# to find out more info you could also calculate the PCs from scratch using prcomp 
# (in order to get loadings, eigenvalues, etc)

principal <- prcomp(x=x[,cl])


#extract number of variables in cluster with given dimension


factors < do.call(cbind, res$basis) #extract all factors to a single matrix 
#(the order is kept so if res$basis[[1]] [the factors in the first cluster] has 8 columns[principal components]
# then the first 8 columns of calculated factors matrix are these PCs)