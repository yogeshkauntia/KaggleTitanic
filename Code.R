#Setting working directory
setwd("d:/data analysis/kaggle/titanic")

#Read training and test datasets
trainData <- read.csv("train.csv", header = TRUE, stringsAsFactors = FALSE)
testData <- read.csv("test.csv", header = TRUE, stringsAsFactors = FALSE)