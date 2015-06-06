#Setting working directory
setwd("d:/data analysis/kaggle/titanic")

#Read training and test datasets
trainData <- read.csv("train.csv", header = TRUE, stringsAsFactors = FALSE)
testData <- read.csv("test.csv", header = TRUE, stringsAsFactors = FALSE)

#Looking at the number of people that survived
prop.table(table(trainData$Survived))

#Number of people survived by gender
prop.table(table(trainData$Sex))
prop.table(table(trainData$Sex, trainData$Survived),1)


