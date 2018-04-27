# Varclust on Valerie's data

## Structure of repository

1. Results of running varclust on the dataset are stored in the results folder.
2. Two important files are: [data_analysis.R](data_analysis.R) and [results_analysis.R](results_analysis.R). The first one contains the code to run varclust on Valerie's data and the other one is for analysing the results.

## A bit more about varclust

In the package there are to most important function [https://github.com/sjwilczynski/varclust/blob/master/R/mlcc.reps.R](mlcc.reps) and [https://github.com/sjwilczynski/varclust/blob/master/R/mlcc.bic.R](mlcc.bic). You can check the documentation in the links. You can also check varclust's vignette for some more examples or [https://github.com/mstaniak/varclust_example](real data analysis).

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
