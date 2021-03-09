if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip",method="curl")
#Unzip dataSet to /data direcyory
unzip(zipfile="./data/Dataset.zip", exdir="./data")
path_rf <- file.path("./data", "UCI HAR Dataset")
files <- list.files(path_rf, recursive=TRUE)
#Show the files
files

#Reading training tables
dataActivityTest <- read.table(file.path(path_rf, "test", "Y_test.txt"), header = FALSE)
dataActivityTrain <- read.table(file.path(path_rf, "train", "Y_train.txt"), header = FALSE)
dataSubjectTrain <- read.table(file.path(path_rf, "train", "subject_train.txt"),header = FALSE) dataSubjectTest <- read.table(file.path(path_rf, "test", "subject_test.txt"),header = FALSE)
dataFeaturesTest <- read.table(file.path(path_rf, "test", "X_test.txt"), header = FALSE)
dataFeaturesTrain <- read.table(file.path(path_rf, "train", "X_train.txt"), header = FALSE)
#Showing results for data
str(dataActivityTest)
str(dataActivityTrain)
str(dataSubjectTrain)
str(dataSubjectTest)
str(dataFeaturesTest)

#Read Activity labels
activityLabels = read.table(file.path(pathdata, "activity_labels.txt"),header = FALSE)

#create column values to the Train Data
colnames(xtrain) = features[.2]
colnames(ytrain) = "activityId"
colnames(subject_train) = "subjectId"

#Create Column Values to the test data
colnames(xtest) = features[.2]
colnames(ytest) = "activityId"
colnames(subject_test) = "subjectId"

#Create the checking for the activity labels value
colnames(activityLabels) <- c("activityId", "activityType")

#Merging the train data and the test data
mrg_train = cbind(ytrain, subject_train, xtrain)
mrg_test = cbind(ytest, subject_test, xtest)

#Creating main data table that will merge both tables
setAllInOne = rbind(mrg_train, mrg_test)

#Read all the values available
colnames = colnames(setAllInOne)

#Getting a subset of all the mean and standards corresponding in activityId and subjectid
mean_and_std = (grepl("activityId", colNames) | grepl("subjectId", colNames) | grepl("mean.." , colNames) | grepl("std.." , colNames))

#Creating a subset
setForMeanAndStd <- setAllInOne[ , mean_and_std == TRUE]

#Using a descriptive activity Names to name the activities in the Dataset
setWithActivityNames = merge(setForMeanAndStd,activityLabels, by= "activityId", all.x=TRUE)

#creating a new tidy set
secTidySet <- aggregate(.~subjectId + activityId, setWithActivityNames, mean)
secTidySet <- secTidySet[order(secTidySet$subjectId, secTidySet$activityId),]
#Display the outputto the textfile
write.table(secTidySet, "secTidySet.txt", row.name=FALSE)
 
