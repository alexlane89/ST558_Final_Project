#myAPI.R 
library(GGally)
library(plumber)
library(tidyverse)
library(caret)

#Read in diabetes data
diabapi <- read_csv("diabetes_binary_health_indicators_BRFSS2015.csv")

#Convert read-in dataframe such that Diabetes binary result is a class
diabapi2 <- diabapi |>
  mutate(DiabetesStatus = 
           ifelse(Diabetes_binary == 0, "No",
                  ifelse(Diabetes_binary == 1, "Yes",
                         "ERROR"))) |>
  select(!Diabetes_binary)

#Convert Diabetes Status to factor
diabapi2$DiabetesStatus <- as.factor(diabapi2$DiabetesStatus)
diabapi2$Age <- as.numeric(diabapi2$Age)
diabapi2$Income <- as.numeric(diabapi2$Income)

#Create cross-validation training object
trctrlapi <- trainControl(method = "cv", number = 5, classProbs = TRUE,
                       summaryFunction = mnLogLoss)
set.seed(56)


#Generate the classification tree model
glmFitapi <- train(DiabetesStatus ~ Age*Income,
                  data = diabapi2,
                  method = "glm",
                  metric = "logLoss",
                  trControl=trctrlapi)

#Predict Diabetes Status based on classification tree model predictors
#* @param Age Observation Age
#* @param Income Income stratus
#* @get /pred
function(Age, Income) {
  pred_df <- data.frame(Age = as.numeric(Age),
                        Income = as.numeric(Income))
  predict(glmFitapi, newdata = pred_df, type = "prob")
}

#http://localhost:PORT/pred?Age=8&Income=5
#http://localhost:PORT/pred?Age=12&Income=1
#http://localhost:PORT/pred?Age=3&Income=4


#Reveal information
#* @get /info
function() {
  list(msg = "Charles Lane /
       https://alexlane89.github.io/ST558_Final_Project/")
}

#query with http://localhost:PORT/info
