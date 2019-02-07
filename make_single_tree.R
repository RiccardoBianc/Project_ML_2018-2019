library(rpart)
library(mlbench)
library(rpart.plot)
library(gtools)
data("Ionosphere")


#The first 250 rows are part of the training set, the remaining 151 rows are part of the  test set
trainset <- Ionosphere[1:200,]
testset <- Ionosphere[201:351,]

#Grow the tree
tree <- rpart(Class~.,data = trainset, method="class",parms = list(split = "gini"))

#Predict and compute accuracy
predictions <- predict(tree,testset[-35],type="class")
accuracy<- mean(predictions==testset$Class)

#Plot the tree
rpart.plot(tree,main = paste("Unpruned tree\n Accuracy = ",accuracy,sep=""))

#Find factor cp that minimize xerror
opt <- which.min(tree$cptable[,"xerror"])
cp <- tree$cptable[opt, "CP"]
#print on the console and plot information about cross-validation of the tree
printcp(tree)
dev.new()
plot(tree$cptable[,c("CP","xerror")],main="Cross validation with cp",pch=19,cex=2,lwd=3,type="o",col=c("blue"),xlab="cp",ylab="Cross validation error")

#Prune,predict and compute accuracy
pruned_tree <- prune(tree,cp)
predictions <- predict(tree,testset[-35],type="class")
accuracy<- mean(predictions==testset$Class)

#Plot the tree
dev.new()
rpart.plot(tree,main = paste("Pruned tree\n Accuracy = ",accuracy,sep=""))
