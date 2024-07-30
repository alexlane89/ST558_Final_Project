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
diabapi2$BMI <- as.numeric(diabapi2$BMI)

#Create cross-validation training object
trctrlapi <- trainControl(method = "cv", number = 5, classProbs = TRUE,
                       summaryFunction = mnLogLoss)
set.seed(56)


#Generate the classification tree model
glmFitapi <- train(DiabetesStatus ~ Age*BMI*HighBP*HighChol,
                  data = diabapi2,
                  method = "glm",
                  metric = "logLoss",
                  trControl=trctrlapi,
                  family = "binomial")

#Predict Diabetes Status based on GLM model predictors
#* @param Age Observation Age
#* @param BMI Body Mass Index
#* @param HighBP High Blood Pressure
#* @param HighChol High Cholesterol
#* @get /pred
function(Age, BMI, HighBP, HighChol) {
  pred_df <- data.frame(Age = as.numeric(Age),
                        BMI = as.numeric(BMI),
                        HighBP = as.numeric(HighBP),
                        HighChol = as.numeric(HighChol))
  predict(glmFitapi, newdata = pred_df, type = "prob")
}

#http://localhost:8000/pred?Age=8&BMI=28&HighBP=0&HighChol=0
#http://localhost:8000/pred?Age=11&BMI=50&HighBP=1&HighChol=1
#http://localhost:8000/pred?Age=4&BMI=20&HighBP=1&HighChol=0


#Reveal information
#* @get /info
function() {
  list(msg = "Charles Lane /
       https://alexlane89.github.io/ST558_Final_Project/")
}

#query with http://localhost:PORT/info
