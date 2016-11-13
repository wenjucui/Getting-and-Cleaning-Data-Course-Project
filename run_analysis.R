## 11-12-2016
## Getting and Cleaning Data Course Project

## Make sure of the current working directory
getwd()  


## Install package reshape2
library(reshape2)

## Download and unzip data
Data <- "data.zip"

if (!file.exists(Data))
{
    fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileURL, Data)
}  
if (!file.exists("UCI HAR Dataset"))
{ 
    unzip(Data) 
}


## Read-in activity labels and features
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
activity_labels
activity_labels[,2] <- as.character(activity_labels[,2])

features <- read.table("UCI HAR Dataset/features.txt")
features
head(features)
features[,2] <- as.character(features[,2])
head(features[,2])


## Get only the features on mean and standard deviation
features_sub <- grep(".*mean.*|.*std.*", features[,2])
features_sub
features_sub_names <- features[features_sub,2]
features_sub_names
features_sub_names = gsub('-mean', 'Mean', features_sub_names)
features_sub_names = gsub('-std', 'Std', features_sub_names)
features_sub_names <- gsub('[-()]', '', features_sub_names)
features_sub_names


## Read-in train data
train_X <- read.table("UCI HAR Dataset/train/X_train.txt")[features_sub]
head(train_X)
train_Y <- read.table("UCI HAR Dataset/train/Y_train.txt")
head(train_Y)
train_subject <- read.table("UCI HAR Dataset/train/subject_train.txt")
head(train_subject)
train <- cbind(train_subject, train_Y, train_X)
head(train)


## Read-in test data
test_X <- read.table("UCI HAR Dataset/test/X_test.txt")[features_sub]
head(test_X)
test_Y <- read.table("UCI HAR Dataset/test/Y_test.txt")
head(test_Y)
test_subjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
head(test_subjects)
test <- cbind(test_subjects, test_Y, test_X)
head(test)


## Merge train/test and add labels
Data_all <- rbind(train, test)
head(Data_all)
colnames(Data_all) <- c("subject", "activity", features_sub_names)
head(Data_all)


## Turn activities & subjects from integer to factor
class(Data_all$activity)
class(Data_all$subject)
Data_all$activity <- factor(Data_all$activity, levels = activity_labels[,1], labels = activity_labels[,2])
Data_all$subject <- as.factor(Data_all$subject)
class(Data_all$activity)
class(Data_all$subject)

Data_all_melted <- melt(Data_all, id = c("subject", "activity"))
head(Data_all_melted)
Data_all_mean <- dcast(Data_all_melted, subject + activity ~ variable, mean)
head(Data_all_mean)


## Save cleaned data
write.table(Data_all_mean, "tidy.txt", row.names = FALSE, quote = FALSE)
