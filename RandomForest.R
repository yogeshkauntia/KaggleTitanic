#Creating a decision tree after feature engineering
set.seed(415)
library (rpart)
fit <- rpart(Survived ~ Pclass + Sex + Age + SibSp + Parch + Fare + 
               Embarked + CabinType  + Child + Title + Family + Mother,
             data = trainData, method = "class")

plot(fit)
text(fit)

library(rattle)
library(rpart.plot)
library(RColorBrewer)

fancyRpartPlot(fit)

prediction <- predict(fit, testData, type="class")
submit <- data.frame(PassengerId = testData$PassengerId, Survived = prediction)
setwd("random forest")
write.csv(submit, file="dtree2.csv", row.names = FALSE)
setwd("../")

#Creating a forest ensemble
library(randomForest)

fit <- randomForest(as.factor(Survived) ~ Pclass + Sex + Age + SibSp + Parch + Fare +
                      Embarked + CabinType + Child + Title + Family + Mother,
             data = trainData, importance=TRUE, ntree=2000)

varImpPlot(fit)

prediction <- predict(fit, testData)

#The score reduced compared to the single tree model
submit <- data.frame(PassengerId = testData$PassengerId, Survived = prediction)
setwd("random forest")
write.csv(submit, file="rf1.csv", row.names = FALSE)
setwd("../")

#Trying conditional inference forest instead of just purity based
library(party)
set.seed(415)
fit <- cforest(as.factor(Survived) ~ Pclass + Sex + Age + SibSp + Parch + Fare +
                      Embarked + CabinType + Child + Title + Family + Mother,
                    data = trainData, controls=cforest_unbiased(ntree=2000, mtry=3))

prediction <- predict(fit, testData, OOB=TRUE, type = "response")

submit <- data.frame(PassengerId = testData$PassengerId, Survived = prediction)
setwd("random forest")
write.csv(submit, file="rf2.csv", row.names = FALSE)
setwd("../")
