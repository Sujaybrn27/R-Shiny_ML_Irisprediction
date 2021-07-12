setwd("C:/Users/HP/Documents/iris_ML_app/Iris_ML")
library(RCurl)
library(randomForest)
library(caret)
iris <- read.csv(text = getURL("https://raw.githubusercontent.com/dataprofessor/data/master/iris.csv"))
TrainingIndex <- createDataPartition(iris$Species, p=0.8, list=FALSE)
TrainingSet <- iris[TrainingIndex,]
TestingSet <- iris[-TrainingIndex,]

write.csv(TrainingSet, "Train.csv")
write.csv(TestingSet, "Test.csv")
Trainset <- read.csv("Train.csv", header = TRUE)
Trainset <- Trainset[,-1]
Trainset$Species <- as.factor(Trainset$Species)
model <- randomForest(Species ~ .,data = Trainset, ntree =500,mtry =4, importance=TRUE)

saveRDS(model, "model.rds")