##Getting and Cleaning Data Peer-graded Assignment

The source data for the project:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

This repo contains one R script called run_analysis.R that does the following:

1. Merges the training and the test sets to create one data set:
- Data set is downloaded from above URL
- Zip file is unzipped
- Train data files are read and column names are assigned
- Test data files are read and column names are assigned
- Train and test data sets are merged
2. Extracts only the measurements on the mean and standard deviation for each measurement with grepl function
3. Uses descriptive activity names to name the activities in the data set with merge function
4. Appropriately labels the data set with descriptive variable names with gsub function
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject with group_by and summarize_if functions
- **The output of the R script is a text file named final_subset.txt**
