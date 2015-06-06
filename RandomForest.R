#Creating a decision tree after feature engineering
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