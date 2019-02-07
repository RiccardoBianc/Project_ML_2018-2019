# Project_ML_2018-2019
Project for machine learning course

This code is written in R, so it's necessary to install the r interpreter. I installed the version in this link
http://cran.mirror.garr.it/mirrors/CRAN/.
It's necessary to install these packages from the menu bar:
1) rpart
2) mlbench
3) rpart.plot
4) phonTools

I installed these packages from italian (Padua) mirror CRAN.
In the file "make_single_tree.R" is built a tree from a dataset (Ionosphere in mlbench package) and is plotted the resulting tree, varying split metric and pruning or not the tree.

In the file "many_trees_experiment" are built 400 trees; 100 unpruned with gini index, 100 pruned with gini index, the remaining 200 are made with the same pattern, but with information gain metric. Then the average accuracies are computed and showed on command terminal in R interpreter.
