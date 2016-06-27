setwd("~/workspace/coursera/datascience/cleandata/project/getting-cleaning-data")
source("constants.R")
library(data.table)

loadAndMerge <- function(dir) {
  subjects <- fread(file.path(data.directory, dir, paste("subject_",dir, ".txt", sep="")))
  setnames(subjects, "subject")
  activities <- fread(file.path(data.directory, dir, paste("y_",dir, ".txt", sep="")))
  setnames(activities, "activity")
  dataset <- fread(file.path(data.directory, dir, paste("X_",dir, ".txt", sep="")))
  result <- cbind(subjects,activities,dataset)
  result
}

loadFeatures <- function() {
  features <- fread(file.path(data.directory, "features.txt"))
  setnames(features, names(features), c("feature", "description"))
  features <- features[grepl("mean\\(\\)|std\\(\\)", description)]
}

trainingdata <- loadAndMerge(trainDir)
testdata <- loadAndMerge(testDir)
totaldata <- rbind(trainingdata, testdata)
rm(trainingdata, testdata)

features <- loadFeatures()
View(features)