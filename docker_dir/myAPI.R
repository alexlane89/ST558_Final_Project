#API.R 
library(GGally)
library(plumber)
library(tidyverse)

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


#Predict Diabetes Status based on classification tree model predictors
#* @param BMI BMI value
#* @param GenHlth General Health category
#* @param Smoker Smoker status
#* @param Education Education stratus
#* @param Income Income stratus
#* @param Age Observation Age
#* @param PhysActivity Physical Active stratus
#* @get /pred
function(BMI = 25, GenHlth = 3, Smoker = 1, Education = 4, Income = 5, Age = 8,
         PhysActivity = 1) {
  pred_df <- data.frame(BMI = BMI, GenHlth = GenHlth, Smoker = Smoker,
                        Education = Education, Income = Income, Age = Age,
                        PhysActivity = PhysActivity)
  predict(treeFit1, newdata = pred_df)
}

#http://localhost:PORT/pred?BMI=25&GenHlth=3&Smoker=1&Education=4&Income=5&Age=8&PhysActivity=1

#Find multiple of two numbers
#* @get /info
function() {
  list(msg = "Charles Lane /
       url")
}

#http://localhost:PORT/info
