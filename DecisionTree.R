#Creating a decision tree
library (rpart)
fit <- rpart(Survived ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked,
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
write.csv(submit, file="dtree.csv", row.names = FALSE)
setwd("../")
