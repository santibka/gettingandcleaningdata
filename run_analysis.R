##Download data for the project
library(dplyr)

if (!file.exists("./data")) {
  dir.create("./data")
}
fileUrl <-
  "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./data/Dataset.zip")

##Unzip dataset to the directory created
unzip(zipfile = "./data/Dataset.zip", exdir = "./data")

##1) Merges the training and the test sets to create one data set

##Reading the data files
features <- read.table('./data/UCI HAR Dataset/features.txt', header = FALSE)
activityLabels <-  read.table('./data/UCI HAR Dataset/activity_labels.txt', header = FALSE)
subjectTrain <-  read.table('./data/UCI HAR Dataset/train/subject_train.txt', header = FALSE)
xTrain <- read.table('./data/UCI HAR Dataset/train/x_train.txt', header = FALSE)
yTrain <- read.table('./data/UCI HAR Dataset/train/y_train.txt', header = FALSE)


##Assign column names to the imported data
colnames(activityLabels)  <- c("activityid", "activitylabel")
colnames(subjectTrain)  <- "subjectid"
colnames(xTrain)        <- features[, 2]
colnames(yTrain)        <- "activityid"


##Creating the final set by merging all the tables (yTrain, subjectTrain, xTrain)
trainingData <- cbind(yTrain, subjectTrain, xTrain)


##Read all the test data
subjectTest <- read.table('./data/UCI HAR Dataset/test/subject_test.txt', header = FALSE)
xTest       <- read.table('./data/UCI HAR Dataset/test/x_test.txt', header = FALSE)
yTest       <- read.table('./data/UCI HAR Dataset/test/y_test.txt', header = FALSE)

##Assign the column names to the test data
colnames(subjectTest) <- "subjectid"
colnames(xTest)       <- features[, 2]
colnames(yTest)       <- "activityid"


# Create the final test set by merging all the tables (xTest, subjectTest, yTest)
testData <- cbind(yTest, subjectTest, xTest)

# Combining both the training and test data as a final dataset
finalData <- rbind(trainingData, testData)

## Getting column names from finalData
colNames  <- colnames(finalData)


##2) Extracts only the measurements on the mean and standard deviation for each measurement

## logical vector
logical <- (grepl("activityid",colNames) | grepl("subjectid",colNames) | grepl("mean\\(",colNames) | grepl("-std\\(",colNames))

##Subsetting finalData based on the logical vector
finalDataSubset <- finalData[logical]


##3) Uses descriptive activity names to name the activities in the data set

# Merge the finalData with the activityLabels table
finalDataSubset <- merge(finalDataSubset, activityLabels, by.x="activityid", by.y="activityid", all.x=TRUE)

##4) Appropriately labels the data set with descriptive variable names

colNames <- tolower(colnames(finalDataSubset))

colNames <- gsub("^t", "time", colNames)
colNames <- gsub("^f", "freq", colNames)
colNames <- gsub("std", "stddev", colNames)
colNames <- gsub("mag", "magnit", colNames)
colNames <- gsub("acc", "accele", colNames)
colNames <- gsub("\\(", "", colNames)
colNames <- gsub("\\)", "", colNames)

# Reassign the new descriptive column names to the finalData set
colnames(finalDataSubset) <- colNames


##5) Create a second, independent tidy data set with the average of each variable for each activity and each subject
#

finalDataSubset1 <- finalDataSubset %>% group_by(activityid, subjectid) %>% summarize_if(is.numeric, mean)

write.table(finalDataSubset1, "./data/UCI HAR Dataset/final_subset.txt", sep = "\t", col.names = TRUE)
