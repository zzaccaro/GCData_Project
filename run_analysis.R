##########################################################################################################

## Coursera Getting and Cleaning Data Course Project
## Zach Zaccaro
## June 16th, 2015

# run_analysis.R

# This script will perform the following steps on the UCI HAR Dataset downloaded from: 
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
# 1. Merge the training and the test sets to create one data set.
# 2. Extract only the measurements on the mean and standard deviation for each measurement. 
# 3. Use descriptive activity names to name the activities in the data set
# 4. Appropriately label the data set with descriptive variable names. 
# 5. From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject. 

##########################################################################################################

## Make sure you are in the correct working directory (inside the UCI HAR Dataset folder)

# 1. Merge the training and test sets into one data set.

# Read in the training data, test data, plus the features and activity labels.
features <- read.table("./features.txt", header = F)
activity <- read.table("./activity_labels.txt", header = F)

subjectTrain <- read.table("./train/subject_train.txt", header = F)
xTrain <- read.table("./train/X_train.txt", header = F)
yTrain <- read.table("./train/Y_train.txt", header = F)

subjectTest <- read.table("./test/subject_test.txt", header = F)
xTest <- read.table("./test/X_test.txt", header = F)
yTest <- read.table("./test/Y_test.txt", header = F)

# Create column names for each of the tables.
colnames(activity) <- c("activityID", "activityType")

colnames(subjectTrain) <- c("subjectID")
colnames(xTrain) <- features[, 2]
colnames(yTrain) <- c("activityID")

colnames(subjectTest) <- c("subjectID")
colnames(xTest) <- features[, 2]
colnames(yTest) <- c("activityID")

# Create the training data set.
training <- cbind(yTrain, subjectTrain, xTrain)

# Create the test data set.
testing <- cbind(yTest, subjectTest, xTest)

# Merge the two data sets.
combined <- rbind(training, testing)

# 2. Extract only the mean and standard deviation measurements.
mean_std_data <- combined[, grep("subjectID|activityID|mean|std", names(combined))]


# 3. Name the activities in the data set.
mean_std_data <- merge(mean_std_data, activity, by = 'activityID', all.x = TRUE)


# 4. Label the data set with descriptive variable names.
names(mean_std_data) <- gsub("\\()", "", names(mean_std_data))
names(mean_std_data) <- gsub("-mean", "Mean", names(mean_std_data))
names(mean_std_data) <- gsub("-std", "StdDev", names(mean_std_data))
names(mean_std_data) <- gsub("^(t)", "time", names(mean_std_data))
names(mean_std_data) <- gsub("^(f)", "freq", names(mean_std_data))
names(mean_std_data) <- gsub("Mag", "Magnitude", names(mean_std_data))
names(mean_std_data) <- gsub("BodyBody", "Body", names(mean_std_data))
names(mean_std_data) <- gsub("Acc", "Acceleration", names(mean_std_data))


# 5. Create a second, independent tidy data set with the average of each variable for each activity and each subject.

# Calculate the averages for each variable for each activity and each subject.
library(plyr)
avg_act_sub = ddply(mean_std_data, c("subjectID","activityType"), numcolwise(mean))

# Export the data.
write.table(avg_act_sub, file = "finalData.txt", row.names = FALSE)





