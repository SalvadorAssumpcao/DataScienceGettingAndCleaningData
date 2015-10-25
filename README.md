Summary
=======
This folder/repo contains the course project for the Getting and Cleaning Data class on Coursera/JHPU Data Science track

Contents
========
- README.md (this file)
- run_analysis.R - script to produce the required tidy data set from the original data
- CodeBook.md - code book for the produced data set
- tidydata.txt - a text representation of the produced tidy data set, obtained by using write.table(...)
    NOTE - this is the same file submitted through the Coursera web interface

Data Transformation
===================
More details on the processing of the data later in this file and in [CodeBook.md](CodeBook.md)

Original Data
------------
- Download 
    https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

- Full Description
    http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

- Overview
    The data set includes data for 10299 experiments/rows. Each experiment has 1 of 30 volunteer subjects performing 1 of 6 activities - WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING - and generating 561 features derived from cell phones accelerometer and gyroscope measurements. For a total of 563 columns/ variables for each experiment/row

Produced Data
-------------
A tidy data set, after applying the following transformations:
- The 561 features are filtered, so we only keep the ones that are mean or standard deviation. This reduces the number of features to 66.
- Each of the 66 kept features is averaged for each combination of subject and activity. This reduces the number of rows from 10299 to 180 (30 subjects x 6 activities)
- The final data set has 180 rows and 68 columns - subject, actvity plus 66 features - and meets the tidy data requirements in a wide data format: each observation in a row, each variable measured on its own column, descriptive names for the columns and string values


Steps to run the script
=======================
1. Download run_analysis.R to your local machine. 
    "git clone" the repo, for example, though you only need the single .R file to run

2. In your R console, make sure that your working directory is set to the folder that contains run_analysis.R

3. Download and unzip the original data to your working directory. This is crucial, as the script depends on that. If you did it correctly, your working directory should have a new subfolder named "UCI HAR DataSet", which will contain the original data

4. Type 'source("run_analysis.R")' to run the script

5. After a few seconds, the script should produce 2 outputs:
    1. A file named "tidydata.txt" in the working directory
    2. a variable in the global scope named "tidy_data"

    Both are representations of the produced tidy data set
    You can read the tidy data from text by typing the following in the R console:
        `myData <- read.table("tidydata.txt", header=TRUE)`

Summary of the script processing of the data
============================================
[CodeBook.md](CodeBook.md) has an extensive discussion of the produced data set, and run_analysis.R has extensive comments on the details of how the script operates, but here is a high level enumeration of the steps taken by the script.

1. Make sure the library we depend on - dplyr - is installed

2. Read in the original data. Initially this produces 5 separate data frames:
    1. activity_labels_data - a dictionary with the 6 activity labels
    2. features_labels_data - a dictionary with the names for the 561 features
    3. features_data - a data frame with 561 features (columns) for each of the 10299 experiments (rows) in the original data set. At this point, the columns have non-descriptive names (V1, V2, etc)
    4. subjects_data - a data frame with 1 column (an integer, subjectid) for each of the 10299 experiments (rows)
    5. activity_data - a dataframe with 1 column (an integer, activityid) for each of the 10299 experiments (rows)

    NOTE - in the original data set, each of c), d) and e) above are split in 2 different files: 1 for training data, 1 for test data. We merge both by rbind() the second file read to the previously read frame imediately, in one line

3. Both the activity and feature names in activity_labels_data and features_labels_data are string processed to "tidy up" them according to the best practices seen in class. See [CodeBook.md](CodeBook.md) for more details

4. Apply the tidier feature names in feature_labels_data as column names for the 561 columns in features_data

5. Filter the column/features to keep only the ones we want
    Essentially, we only keep the features whose original names include either "mean()" OR "std()" - we only want features that are "mean" or "standard deviation" in the original data. And also, that are not duplicated - the original data has 477 unique feaure names, but 561 features. In practice, the de-dupe step does not drop any features if the filtering of "mean" and "standard deviation" is done first - i.e. none of the features we want is duplicated.
    This step reduces features_data to 66 column/ features (from 561)

6. Generate a factor called "activity" which has the same 10299 rows as activity_data, but with descriptive names in each row instead of an int.

7. Generate consolidated_data by column binding subjects_data and activity to the filtered features_data. The resulting data frame has the 10299 rows/experiments. And 66 columns. For each row we have the subjectid (as integer), activity (in a descriptive form) and 66 feature columns. This is already a tidy data set, but the requested data still needs some additional processing

8. consolidated_data is grouped by subject and activity, using group_by

9. A new data set is produced, averaging each feature for each combination (subject, activity). This is done by using summary_each() in the data set produced in 8)

    This is the final data set and it is both stored in a global scope variable "tidy_data" and written as text using wrtie.table() to a local file "tidydata.txt"

    The produced data set has 180 rows (30 subjects x 6 activities per subject) and the same 68 columns as consolidated_data


        