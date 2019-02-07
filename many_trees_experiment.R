library(rpart)
library(mlbench)
library(rpart.plot)
library(gtools)
library(phonTools)
data("Ionosphere")

make_multiple_trees <- function(train_fraction,number_of_repetition,dataset,split_metric,prune_tree=FALSE){

	accuracy_ith_tree <- rep(NA,number_of_repetition)
	
	#Use a seed to obtain a deterministic test
	set.seed(42)
	for (i in 1:number_of_repetition){
	
		#Compute a random set for trainset and testset
		Indexes <- permute(1:nrow(dataset))
		train_size <- (train_fraction*nrow(dataset))
		trainset <- dataset[Indexes[1:train_size],]
		testset <- dataset[Indexes[(train_size+1):nrow(dataset)],]
		
		#Compute "Class" attribute index
		typeColNum <- grep("Class",names(dataset))
		tree <- rpart(Class~.,data = trainset, method="class",parms = list(split = split_metric))
		if(prune_tree==FALSE){
		
			test_predict <- predict(tree,testset[,-typeColNum],type="class")
			accuracy_ith_tree[i] <- mean(test_predict==testset$Class)
			
		}
		else{
		
			#Find factor cp that minimize xerror
			min_cp_row <- which.min(tree$cptable[,"xerror"])
			min_cp <- tree$cptable[min_cp_row, "CP"]
			pruned_tree <- prune(tree,min_cp)
			pruned_predictions <- predict(pruned_tree,testset[,-typeColNum],type="class")
			accuracy_ith_tree[i] <- mean(pruned_predictions==testset$Class)
			
		}
	}
	return(accuracy_ith_tree)
	
}

#Gini index
#No pruning
unpruned_accuracies <- make_multiple_trees(0.7,100,Ionosphere,"gini")
mean_unpruned_gini = mean(unpruned_accuracies)
print(paste("mean_unpruned_gini:",mean_unpruned_gini))

#With Pruning
pruned_accuracies <- make_multiple_trees(0.7,100,Ionosphere,"gini",prune_tree=TRUE)
mean_pruned_gini = mean(pruned_accuracies)
print(paste("mean_pruned_gini:",mean_pruned_gini))


#Information gain index
#No pruning
unpruned_accuracies <- make_multiple_trees(0.7,100,Ionosphere,"information")
mean_unpruned_information = mean(unpruned_accuracies)
print(paste("mean_unpruned_information:",mean_unpruned_information))
#With Pruning
pruned_accuracies <- make_multiple_trees(0.7,100,Ionosphere,"information",prune_tree=TRUE)
mean_pruned_information = mean(pruned_accuracies)
print(paste("mean_pruned_information:",mean_pruned_information))
