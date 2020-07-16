install.packages("mice")#install all of the packages I will need and want to use first.
install.packages("caret")
install.packages("nnet")
install.packages("e1071")
install.packages("gamlss")#for visualization
install.packages("gamlss.add")#for visualization
library(mice)
library(caret)
library(nnet)
library(e1071)
library(gamlss)
library(gamlss.add)
mushroom <- read.csv(url("http://archive.ics.uci.edu/ml/machine-learning-databases/mushroom/agaricus-lepiota.data"),
                     header = FALSE, sep = ",")#loading the data
str(mushroom)#looking at the astructure of the data.
colnames(mushroom) <- c("edibility", "cap_shape", "cap_surface", 
                        "cap_color", "bruises", "odor", "grill_attachment", 
                        "grill_spacing", "grill_size", "grill_color", "stalk_shape", 
                        "stalk_root", "stalk_surface_above_ring", "stalk_surface_below_ring", 
                        "stalk_color_above_ring", "stalk_color_below_ring", "veil_type", 
                        "veil_color", "ring_number", "ring_type", "spore_print_color", 
                        "population", "habitat")#adding names to the variables
head(mushroom)#check to see the names correct
sum(is.na(mushroom))#we check for missing variables in the data and there are none.
mushroom <- subset(mushroom, select = -veil_type)#remove veil type due to only one level
#we then convert the variable types
mushroom$cap_shape <- as.numeric(mushroom$cap_shape)
mushroom$cap_surface <- as.numeric(mushroom$cap_surface)
mushroom$cap_color <- as.numeric(mushroom$cap_color)
mushroom$bruises <- as.numeric(mushroom$bruises)
mushroom$odor <- as.numeric(mushroom$odor)
mushroom$grill_attachment <- as.numeric(mushroom$grill_attachment)
mushroom$grill_spacing <- as.numeric(mushroom$grill_spacing)
mushroom$grill_size <- as.numeric(mushroom$grill_size)
mushroom$grill_color <- as.numeric(mushroom$grill_color)
mushroom$stalk_shape <- as.numeric(mushroom$stalk_shape)
mushroom$stalk_root <- as.numeric(mushroom$stalk_root)
mushroom$stalk_surface_above_ring <- as.numeric(mushroom$cap_shape)
mushroom$stalk_surface_below_ring <- as.numeric(mushroom$cap_shape)
mushroom$stalk_color_above_ring <- as.numeric(mushroom$stalk_color_above_ring)
mushroom$stalk_color_below_ring <- as.numeric(mushroom$stalk_color_below_ring)
mushroom$veil_color <- as.numeric(mushroom$veil_color)
mushroom$ring_number <- as.numeric(mushroom$ring_number)
mushroom$ring_type <- as.numeric(mushroom$ring_type)
mushroom$spore_print_color <- as.numeric(mushroom$spore_print_color)
mushroom$population <- as.numeric(mushroom$population)
mushroom$habitat <- as.numeric(mushroom$habitat)
#we now look at the distribution of edibility
ed <- as.numeric(mushroom$edibility)
hist(ed)
table(ed)#look at the split of the edibility
4208/8124#look at the edible mushrooms
3916/8124#look at the unedible mushrooms
.7 * 8124#get the 70% split of the data for training
.3 * 8124#get the 30% split of the data for testing
s <- sample(8124, 5687)#build the traing and testing sets
mush_train <- mushroom[s, ]
mush_test <- mushroom[-s, ]
dim(mush_train)#view the sets 
dim(mush_test)
str(mush_train)#assessing the train data 
svm_model <- svm(edibility ~ ., data = mush_train, 
                 kernel = 'linear', cost = 1, scale = FALSE)#build the model
print(svm_model)#view the model results to view the vectors
plot(svm_model)#we then look at the plot
svm.pred = predict(svm_model, mush_test[, !names(mush_test) %in% c("edibility")])
svm.table = table(svm.pred, mush_test$edibility)
svm.table#look at the accuracy in the table format by calculating number within it
1220 + 1144
1220 + 27 + 46 + 1144
2364/2437#overall accuracy
#we can now experiment with the cost and see if that helps  improves the model
svm2 <- svm(edibility ~ ., data = mush_train, kernel = 'linear', cost = 100, scale = FALSE)
#we increase the cost here (the higher the more accurate the model)
svm.pred2 = predict(svm2, mush_test[, !names(mush_test) %in% c("edibility")])
svm.table2 = table(svm.pred2, mush_test$edibility)
svm.table2#new table with increased cost 
(1220+1163)/2437#overall accuracy 
svm3 <- svm(edibility ~ ., data = mush_train, kernel = 'radial', cost = 100, scale = FALSE)
#here we will change to kernel to a nonlinear kernel with radial
svm.pred3 = predict(svm3, mush_test[, !names(mush_test) %in% c("edibility")])
svm.table3 = table(svm.pred3, mush_test$edibility)
svm.table3#the new table with the kernel change 
#the above predicted everything with 100% accuracy so we will now move on to the NNet
#Neural network 
#we will reload in the data again to start new for the neural network analysis
mushroom2 <- read.csv(url("http://archive.ics.uci.edu/ml/machine-learning-databases/mushroom/agaricus-lepiota.data"), header = FALSE, sep = ",")
colnames(mushroom2) <- c("edibility", "cap_shape", "cap_surface", "cap_color", 
                         "bruises", "odor", "grill_attachment", "grill_spacing", 
                         "grill_size", "grill_color", "stalk_shape", "stalk_root", 
                         "stalk_surface_above_ring", "stalk_surface_below_ring", 
                         "stalk_color_above_ring", "stalk_color_below_ring", 
                         "veil_type", "veil_color", "ring_number", "ring_type", 
                         "spore_print_color", "population", "habitat")#add in new names
mushroom2 <- subset(mushroom2, select = -veil_type)# taking this out due to only 1 level
mushroom2 <- subset(mushroom2, select = -stalk_root)#in this set we will take this out 
#due to having too many missing values 
#next we create a set that will have dummy variables to then create the train an test sets
swag <- createDataPartition(mushroom2$edibility, p = .7, list = FALSE)
dummy <- subset(mushroom2, select = -edibility)#create the dummy data to make test and train 
shroomDummy <- dummyVars(~., data = dummy, sep = ".")
shroomDummy <- data.frame(predict(shroomDummy, dummy))
ncol(shroomDummy)
shroomDummy$edibility <- mushroom2$edibility#we add the edibility back in
ncol(shroomDummy)
train <- shroomDummy[swag,]#we will create our train and test sets
test <- shroomDummy[-swag,]
testLabels <- subset(test, select = edibility)
testset <- subset(test, select = -edibility)
#we then build our neural net model for the analysis
net <- nnet(edibility ~ ., data = train, size = 2, rang = 0.1, maxit = 200)
summary(net)#then we look at out nnet to ensure it took properly
shroom.predict <- predict(net, testset, type = "class")#we build the prediction
net.table <- table(test$edibility, shroom.predict)
net.table#no w look at the prediction table for the net
#even though the table says the model is 100% it is not due to there being 1 value
#misclassified fro mthe original 2437 that should be there
2436/2437#this is the observed and the number that is supposed to be giving us 99.85%
confusionMatrix(net.table)#looks as the other numbers involved
plot(net, .3)#this helps us visualize the plot of the nnet


#here we are going to build a parallel 3rd set to see what imputing does
mushroom3 <- read.csv(url("http://archive.ics.uci.edu/ml/machine-learning-databases/mushroom/agaricus-lepiota.data"), header = FALSE, sep = ",")
colnames(mushroom2) <- c("edibility", "cap_shape", "cap_surface", "cap_color", 
                         "bruises", "odor", "grill_attachment", "grill_spacing", 
                         "grill_size", "grill_color", "stalk_shape", "stalk_root", 
                         "stalk_surface_above_ring", "stalk_surface_below_ring", 
                         "stalk_color_above_ring", "stalk_color_below_ring", 
                         "veil_type", "veil_color", "ring_number", "ring_type", 
                         "spore_print_color", "population", "habitat")#adding in names
mushroom3 <- subset(mushroom3, select = -veil_type)#taking this out due to 1 level
tempData <- mice(mushroom3,m=5,maxit=50,meth='pmm',seed=500)#imputation
summary(tempData)#look at it 
tempData$imp$Ozone
tempData$meth
mushroom4 <- complete(tempData,1)#we complete the imputed dataset to use
#next we create a set that will have dummy variables to then create the train an test sets
swag2 <- createDataPartition(mushroom4$edibility, p = .7, list = FALSE)
dummy2 <- subset(mushroom4, select = -edibility)
shroomDummy2 <- dummyVars(~., data = dummy2, sep = ".")
shroomDummy2 <- data.frame(predict(shroomDummy2, dummy2))
ncol(shroomDummy2)
shroomDummy2$edibility <- mushroom4$edibility
ncol(shroomDummy2)
train2 <- shroomDummy2[swag,]#we will create our train and test sets
test2 <- shroomDummy2[-swag,]
testLabels2 <- subset(test2, select = edibility)
testset2 <- subset(test2, select = -edibility)
net2 <- nnet(edibility ~ ., data = train2, size = 2, rang = 0.1, maxit = 200)
summary(net2)#then we look at out nnet to ensure it took properly
shroom.predict2 <- predict(net2, testset2, type = "class")
net.table2 <- table(test2$edibility, shroom.predict2)
net.table2#no we look at the table
2394/2437#shows the accuracy for the imputed model as 98.23%
confusionMatrix(net.table2)
plot(net2, .3)#this helps us visualize the plot of the nnet2