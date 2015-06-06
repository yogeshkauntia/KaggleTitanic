#Feature Engineering is tried here
#A combination dataset is created for doing the feature engineering

testData$Survived <- NA
combi <- rbind(trainData, testData)

#Embarked has 2 missing values and will be predicted using fare
table(combi$Embarked)


#Fare is missing for one passenger who embarked from 'S' traveling 3rd Class
combi[which(is.na(testData$Fare)),]

#Such passengers have a mean fare of 14.43542
mean(combi$Fare[intersect(which(combi$Pclass==3),which(combi$Embarked=='S'))],na.rm=TRUE)
combi$Fare[which(is.na(combi$Fare))] <- 14.43542


library(plyr)
ddply(combi,~Embarked,summarize,mean=mean(Fare),median=median(Fare))

embark_null <- intersect(intersect(which(combi$Embarked!="C"),which(combi$Embarked!="S")),which(combi$Embarked!="Q"))

combi$Embarked[intersect(embark_null, which(trainData$Fare<20))] <- "Q"
combi$Embarked[intersect(embark_null, which(trainData$Fare<44))] <- "S"
combi$Embarked[intersect(embark_null, which(trainData$Fare>=44))] <- "C"

#First letter of the Cabin is considered and stored as Cabin Type
#Missing cabin types are not estimated because of variation

combi$CabinType <- substr(combi$Cabin,1,1)

#Age is a very important variable and missing data can estimated by title

combi$Title <- sapply(combi$Name, FUN=function(x) {strsplit(x, split='[,.]')[[1]][2]})
combi$Title <- sub(' ', '', combi$Title)

combi$Title[combi$Title %in% c('Capt', 'Col', 'Don', 'Jonkheer', 'Major', 'Rev', 'Sir')] <- 'Sir'

combi$Title[combi$Title %in% c('the Countess', 'Dona', 'Lady')] <- 'Lady'
combi$Title[combi$Title %in% c('Mlle', 'Ms', 'Miss')] <- 'Miss'
combi$Title[combi$Title %in% c('Mme', 'Mrs')] <- 'Mrs'

#Since 'Miss' alone is not a good predictor of age, we will check if the Miss is traveling alone or with parents

Miss_e <- intersect(which(combi$Title=='Miss'),which(combi$Parch==0))
Miss_ch <- intersect(which(combi$Title=='Miss'),which(combi$Parch>0))

Mr_age <- mean(combi$Age[which(combi$Title=='Mr')],na.rm = TRUE)
Mrs_age <- mean(combi$Age[which(combi$Title=='Mrs')],na.rm = TRUE)
Master_age <- mean(combi$Age[which(combi$Title=='Master')],na.rm = TRUE)
Miss_e_age <- mean(combi$Age[Miss_e],na.rm = TRUE)
Miss_ch_age <- mean(combi$Age[Miss_ch],na.rm = TRUE)
Dr_age <- mean(combi$Age[which(combi$Title=='Dr')],na.rm = TRUE)

combi$Age[intersect(which(combi$Title=='Mr'), which(is.na(combi$Age)))] <- Mr_age
combi$Age[intersect(which(combi$Title=='Mrs'), which(is.na(combi$Age)))] <- Mrs_age
combi$Age[intersect(which(combi$Title=='Master'), which(is.na(combi$Age)))] <- Master_age
combi$Age[intersect(which(combi$Title=='Dr'), which(is.na(combi$Age)))] <- Dr_age
combi$Age[intersect(Miss_e, which(is.na(combi$Age)))] <- Miss_e_age
combi$Age[intersect(Miss_ch, which(is.na(combi$Age)))] <- Miss_ch_age

#Creating a variable for children, i.e. age is below 15
combi$Child <- 0
combi$Child[which(combi$Age<=15)] <- 1

#Creating a variable for total family size
combi$Family <- combi$SibSp + combi$Parch + 1

#Creating a variable for a mother
combi$Mother <- 0
combi$Mother[intersect(which(combi$Title=='Mrs'), which(combi$Parch>1))] <- 1

#Categorical variables are converted to factors
combi$Pclass <- as.factor(combi$Pclass)
combi$Sex <- as.factor(combi$Sex)
combi$Embarked <- as.factor(combi$Embarked)
combi$CabinType <- as.factor(combi$CabinType)
combi$Title <- as.factor(combi$Title)
combi$Child <- as.factor(combi$Child)
combi$Mother <- as.factor(combi$Mother)

#Splitting into training and test again
trainData <- combi[1:891,]
testData <- combi[892:1309,]