## The buildTidyData() function does the bulk of the work, which is
##  placed on its own function primarily so any intermediary variables
##  are cleared when the function returns 
## 
## No input parameters, but it assumes the folder containing the 
##  original data (named "UCI HAR DataSet") is a subfolder of the
##  current directory
buildTidyData <- function () {
    ## Saves the current dir and switches to original data folder
    saved_current_dir <- getwd();
    setwd("./UCI HAR DataSet")
    
    ## Read features and activity labels
    ## The features and activity labels are read in as strings, 
    ##  so we can more easily manipulate them before using as factors
    features_labels_data <- read.table("features.txt", 
                                       col.names=c("Id", "Name"), 
                                       stringsAsFactors = FALSE)
    activity_labels_data <- read.table("activity_labels.txt", 
                                       col.names = c("Id", "Name"), 
                                       stringsAsFactors = FALSE)
    
    ## Read the training data, 
    ##  already into the data frames for the merged data.
    ## Initially we read subject, feature values(i.e. "x") 
    ##  and activity values (i.e. "y") into separate data frames
    subjects_data <- read.table("./train/subject_train.txt", 
                                col.names = c("subjectid"))
    features_data <- read.table("./train/X_train.txt")
    activity_data <- read.table("./train/y_train.txt", 
                                col.names = c("ActivityId"))
    
    ## Read the test data, already merging with the training data
    subjects_data <- rbind(subjects_data, 
                           read.table("./test/subject_test.txt", 
                                      col.names = c("subjectid")))
    features_data <- rbind(features_data, read.table("./test/X_test.txt"))
    activity_data <- rbind(activity_data, 
                           read.table("./test/y_test.txt", 
                                      col.names = c("ActivityId")))
  
    ## Restores working directory, after all data is read in
    setwd(saved_current_dir)
    
    ## Cleaning up and tidying up the data
    
    ## Before we start manipulating the features names to make them more tidy,
    ##  build a couple of logical vectors using the original names
    ## They will allow us, later, to filter the features we are interested in
    
    ## We have 561 features in the data, but only 477 distinct feature names,
    ##  so duplicatedFeatures just keep track of the duplicates
    ## The first ocurrence of each feature will be kept
    duplicatedFeatures <- duplicated(features_labels_data$Name)
    
    ## We only want means (identified by features with "mean()" in name)
    ##  or standard deviations (feature names with "std()")
    wantedFeatures <- grepl("mean()", features_labels_data$Name, fixed=TRUE) | 
                      grepl("std()", features_labels_data$Name, fixed=TRUE)
    
    ## Perform a series of pipelined changes to features and activity names,
    ##  to get them formatted as we want, as per codebook
    features_labels_data$Name <- features_labels_data$Name %>%
                                 gsub("()", "", ., fixed=TRUE) %>%
                                 gsub("-", "", .,  fixed=TRUE) %>%
                                 gsub("mean", "Mean", ., fixed=TRUE) %>%
                                 gsub("std", "Std", ., fixed=TRUE)
    
    activity_labels_data$Name <- activity_labels_data$Name %>%
                                 gsub("_", "", .) %>%
                                 tolower()
    
    ## Apply the feature names to the columns/variables of the features data
    colnames(features_data) <- features_labels_data$Name
    
    ## Filter the features
    features_data <- features_data[wantedFeatures & !duplicatedFeatures]
    
    ##  Build the consolidated data, by incorporating both the subjects,
    ##   activity and features data in a single frame
    ##  For activity data, convert the id in the original data to
    ##   the descriptive activity names, as a factor
    activity <- as.factor(
                      activity_labels_data$Name[
                          match(activity_data$ActivityId, 
                                activity_labels_data$Id)
                      ])
    consolidated_data <- cbind(subjects_data, activity, features_data)
    
    ## Finally, build the tidy_data we want, and return it
    ## We group by subject and activity and summarize the mean 
    ##  of each feature for each combination(subject, activity)
    tidy_data<-summarize_each(
                  group_by(consolidated_data, subjectid, activity), 
                  c('mean'))
}

## The actual main script

## First make sure dplyr is installed
if(!("dplyr" %in% installed.packages()[,"Package"])) {
    install.packages("dplyr", quiet = TRUE)
}
require(dplyr, quietly = TRUE)

## Now, build tidyData and write it to 
tidyData <- buildTidyData()
write.table(tidyData, "tidydata.txt", row.names = FALSE)
