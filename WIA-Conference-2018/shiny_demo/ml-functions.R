#
# Create Fake Iris Data with fakeR
# ML iris algo with caret
# Reference: https://machinelearningmastery.com/machine-learning-in-r-step-by-step/
#

library(fakeR)
library(dplyr)
library(caret)

fake_iris <- fakeR::simulate_dataset(iris[,-5])
new_iris <- as.tibble(fake_iris) %>%
  filter(Petal.Length > 0, Petal.Width > 0)


# ML model with caret
valid_ind <- createDataPartition(iris$Species, p=0.80, list=FALSE)
validation <- iris[-valid_ind,]
training <- iris[valid_ind,]


control <- trainControl(method="cv", number=10)
metric <- "Accuracy"
set.seed(42)
fit.rf <- train(Species~., data=training, method="rf", metric=metric, trControl=control)
fit.knn <- train(Species~., data=training, method="knn", metric=metric, trControl=control)

predict_matrix <- function(model, data){
  predictions <- predict(model, data)
  confusionMatrix(predictions, data$Species)
}

make_predictions <- function(model, data){
  predictions <- predict(model, data)
  data$Species <- predictions
  plot(data$Sepal.Length, data$Petal.Length,
       xlab="Sepal Length", ylab="Petal Length", col=data$Species)
}

predict_matrix(fit.knn, validation)
make_predictions(fit.rf, new_iris[1:3,])

predict_species <- function(model, data){
  predictions <- predict(model, data)
  as.character(predictions)
}

make_predictions(fit.knn, iris[1:3,-5])
