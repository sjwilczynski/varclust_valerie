# Varclust on Valerie's data

## Structure of repository

1. Results of running varclust on the dataset are stored in the results folder.
2. Two important files are: [data_analysis.R](data_analysis.R) and [results_analysis.R](results_analysis.R). The first one contains the code to run varclust on Valerie's data and the other one is for analysing the results.

## A bit more about varclust

In the package there are to most important function [mlcc.reps](https://github.com/sjwilczynski/varclust/blob/master/R/mlcc.reps.R) and [mlcc.bic](https://github.com/sjwilczynski/varclust/blob/master/R/mlcc.bic.R). You can check the documentation in the links. You can also check varclust's vignette for some more examples or [real data analysis](https://github.com/mstaniak/varclust_example).

## How to use screen to run the simulations?

The basic tutorial can be found [here](https://www.rackaid.com/blog/linux-screen-tutorial-and-how-to/).

## Running varclust on Valerie's data

First of all the computations are quite long. Do them on calc and remember to use screen. You can run the script using:

```bash
Rscript data_analysis.R 8 28 28 30 "c(10,20,30,40)" "valerie_data.txt"
```

The first argument is maximal subspace dimension, the second one is the number of cores of the processor to use to make the computation parallel (maximum on calc is 28 but it is probably a good idea not to use them all), next is the number of random initialization of our algorithm, then number of iterations within kmeans loop, next one is R array with number of clusters to test and the last argument is the name of the file with Valerie's data set.

The results are stored in the results folder.

## Analysing the results

In the file [results_analysis.R](results_analysis.R) are some R commands for analysing the results. When you are using code from there remember to change the following lines to choose properly currently analysed number of clusters, file with results, file with dataset.

```r
K           <- 40 #number of clusters currently checked
filename1   <- "mlcc_res40.RData" #name of the file in which results of mlcc.reps are stored
filename2   <- "valerie_data.txt" #name of the file with Valerie's data
```

How to go analyse the object returned by varclust? You can of course check out the documentation: [mlcc.reps](https://github.com/sjwilczynski/varclust/blob/master/R/mlcc.reps.R). Here are some basics. Lets imagine you have a result of varclust for 40 clusters stored in *res40* variable then there are 3 elements of the returned object:

```r
res40$segmentation #an array, a partition of variables into clusters. On the i-th element indices the index of clusters to which i-th variable was assigned.
res40$BIC # Value of mBIC criterion for returned clustering - the bigger the value, the better is the clustering (at least for the algorithm)
res40$basis # A list containing factors. An i-th element of the list are the factors/principal components for i-th cluster.
#Examples
which(res40$segmentation==i) #returns indices of variables in i-th cluster
plot(c(1,2,3,4), c(res10$BIC, res20$BIC, res30$BIC, res40$BIC,)) #plots values of mBIC criterion for different number of clusters
ncol(res40$bais[[2]]) - #number of factors(dimensionality) for 2nd cluster
```