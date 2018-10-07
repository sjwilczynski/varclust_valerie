# Varclust on Valerie's data

## Github

It would be easier for us if everyone uses github. You can find a very good interactive tutorial [here](https://try.github.io/levels/1/challenges/1). Of course there are many many tutorials on github on web, simple or more advanced. I also recommend [this one](https://readwrite.com/2013/09/30/understanding-github-a-journey-for-beginners-part-1/).

And here is a short summary of most important commands(if you don't understand some words, go through tutorial first):

```bash
git clone https://github.com/sjwilczynski/varclust_valerie.git # download this repository to the computer (you can do this on calc in LAREMA)
git add . # add all unstaged local changes
git commit -m "message" # commit your changes to the local repository (change message to a description of what you did in this commit)
git push origin master # push the changes to the remote so that everybody could see/download them
##############################################
git fetch origin master # check if there are some changes in the remote repository
git pull origin master # download the changes from the remote to your local copy
```

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
Rscript script_varclust.R 8 25 40 30 "c(50,100,150,200,75,125,175,225,250)" "valerie_data.txt"
```
where "valerie_data.txt" is the name of the file with our genetic data.

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
plot(c(10,20,30,40), c(res10$BIC, res20$BIC, res30$BIC, res40$BIC), xlab="Number of clusters", ylab="Value of mBIC") #plots values of mBIC criterion for different number of clusters
ncol(res40$basis[[2]]) - #number of factors(dimensionality) for 2nd cluster
```

## Problems with varclust

1. Value of mBIC returned by mlcc.reps or mlcc.bic is -Inf. This happens and to fin out why you have to check out [this file](https://github.com/sjwilczynski/varclust/blob/master/R/auxiliary.functions.R) and function *cluster.pca.BIC*. Basically, this can happen when the dimensionality of the clustered was estimated to be bigger than number of variables assigned to the cluster - see the warning.

In case of any problems or ideas for improvements don't hesitate to contact me (Stanisław).
