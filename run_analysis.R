setwd("~/workspace/coursera/cleandata/project/getting-cleaning-data")
source("constants.R")
library(data.table)
library(plyr)

loadSubjects <- function() {
  subjectsTraining <- fread(file.path(data.directory, trainDir, paste("subject_",trainDir, ".txt", sep="")))
  subjectsTest <- fread(file.path(data.directory, testDir, paste("subject_",testDir, ".txt", sep="")))
  subjects <- rbind(subjectsTraining, subjectsTest)
  setnames(subjects, "subject")
}

loadActivities <- function() {
  activitiesTrainind <- fread(file.path(data.directory, trainDir, paste("y_",trainDir, ".txt", sep="")))
  activitiesTest <- fread(file.path(data.directory, testDir, paste("y_",testDir, ".txt", sep="")))
  activities <- rbind(activitiesTrainind, activitiesTest)
  setnames(activities, "activity")
}

loadValues <- function() {
  xTraining <- read.table(file.path(data.directory, trainDir, paste("X_",trainDir, ".txt", sep="")))
  xTest <- read.table(file.path(data.directory, testDir, paste("X_",testDir, ".txt", sep="")))
  dataset <- rbind(xTraining, xTest)
  dataset
}

loadActivityLabels <- function() {
  aLabels <- read.table(paste(data.directory,"activity_labels.txt", sep = "/"))
  activities[, 1] <- aLabels[activities[, 1], 2]
  activities
}

# 1 Merges the training and the test sets to create one data set
subjects <- loadSubjects()
activities <- loadActivities()
xData <- loadValues()
#View(xData)

# 2 Extracts only the measurements on the mean and standard deviation for each measurement.
features <- read.table(paste(data.directory,featuresFile, sep = "/"))
#mean or std
featuresFilter <- grep("-(mean|std)\\(\\)", features[, 2])
xData <- xData[, featuresFilter]
names(xData) <- features[featuresFilter, 2]
#View(xData)

# 3 Uses descriptive activity names to name the activities in the data set
activities <- loadActivityLabels()
#View(activities)

# 4 Appropriately labels the data set with descriptive variable names.
#  labels done :)
fullData <- cbind(xData, activities, subjects)
#View(fullData)

# 5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
tidyData <- ddply(fullData, .(subject, activity), function(x) colMeans(x[, 1:66]))
#View(tidyData)
write.table(tidyData,"tidy_average_data.txt",row.names=FALSE)
