Study Design
============
The final data set was produced using an original data set from the study which can be found at:
    http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The summary description of that study is as follows:

> The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 
>        
> The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. 


Based on the raw data from the phone accelerometer and gyroscope, the original data set derived 561 features. It also contained data for 10299 experiments(rows) involving the 30 subjects and 6 activities

The transformations applied to the original data set were the following:

1. Only the subset of the features that were mean or standard deviation were kept - the original data set has a number of additional features derived from sensor raw data

    This resulted in keeping 66 features, out of the original 561

2. An average summary of each of the 66 features was calculated for every combination of subject/activity. Only this average summary was kept in the final data set. This resulted in a final data set with 180 rows (30 subjects x 6 activities, all represented in the original data set)

    The final data set then has 180 rows x 68 columns(subject id, activity and 66 features)

3. Some minor transformations were made to the original activity and feature names, to improve readability and adherence to best practices (more detail in the following section)


Name Tranformations
===================
Activity Names
--------------
Activity names were transformed to all lower case, and stripped from non-alphanumerical characters. Given their low number and relatively short length, the resulting strings are still quite readable

Feature Names
-------------
Original data feature names are composed of abbreviations that identify the defining characteristics of each feature:

1. "t" or "f" in the first character, for time and frequency domain features, respectively
2. "Body" vs "Gravity" to distinguish - especially in linear acceleration features - body motion vs gravity components
3. "Acc", "AccJerk", "Gyro", "GyroJerk" to identify respectively: linear acceleration, its derivative in time, angular velocity and its derivative in time
4. "mean()" or "std()" to identify mean or standard deviation (and many other not relevant to our final data set)
5. "X", "Y", "Z" or "Mag" to identify features calculated along the X, Y, Z axis or Euclidian magnitudes respectively

In addition to that, original feature names included "-" separators, resulting in feature names as in the following examples:

    tBodyAcc-mean()-X
    fBodyAccMag-mean()

The final data set used - for its average summary features - names that are very close to the original data corresponding features. This was done for the following reasons:
    - Expanding the abbreviations, while making it more descriptive, would result in unreasonably long feature names
    - The camel case approach of the original data makes it easier to identify the parts of the feature name. Compared to have it all in lower case, for example
    - Keeping the names of the new features close to their correspondent features in the original data facilitates cross referincing if needed

That said, a couple of small changes where made to the original feature names, to improve readability. Specifically:
    1. Non-alphanumeric characters - specifically "-", "(", ")" -  were removed
    2. "mean" and "std" were changed to "Mean" and "Std" to make camel casing of the new feature names more consistent

Applying 1. and 2. to the previous examples of original feature names results in the following new feature names:

    tBodyAccMeanX
    fBodyAccMagMean

Code Book
=========
- *subjectid*

    An integer in the interval [1, 30] identifying a specific volunteer/ subject in the study

- *activity*

    A factor identifying the activity in the experiment. Possible values:

        laying
        sitting
        standing
        walking
        walkingdownstairs
        walkingupstairs

- *features*

    Our features are averages of the corresponding features in the original data, for each combination subjectid/activity

    The original features were normalized in the [-1, 1] interval, and therefore unitless

    The final data features, being averages, will also have values in the [-1, 1] interval, but no futher normalization has been done

    The complete list of all 66 feature names is below. An explanation of the abbreviations used in the final feature names follows

        tBodyAccMeanX
        tBodyAccMeanY
        tBodyAccMeanZ
        tBodyAccStdX
        tBodyAccStdY
        tBodyAccStdZ
        tGravityAccMeanX
        tGravityAccMeanY
        tGravityAccMeanZ
        tGravityAccStdX
        tGravityAccStdY
        tGravityAccStdZ
        tBodyAccJerkMeanX
        tBodyAccJerkMeanY
        tBodyAccJerkMeanZ
        tBodyAccJerkStdX
        tBodyAccJerkStdY
        tBodyAccJerkStdZ
        tBodyGyroMeanX
        tBodyGyroMeanY
        tBodyGyroMeanZ
        tBodyGyroStdX
        tBodyGyroStdY
        tBodyGyroStdZ
        tBodyGyroJerkMeanX
        tBodyGyroJerkMeanY
        tBodyGyroJerkMeanZ
        tBodyGyroJerkStdX
        tBodyGyroJerkStdY
        tBodyGyroJerkStdZ
        tBodyAccMagMean
        tBodyAccMagStd
        tGravityAccMagMean
        tGravityAccMagStd
        tBodyAccJerkMagMean
        tBodyAccJerkMagStd
        tBodyGyroMagMean
        tBodyGyroMagStd
        tBodyGyroJerkMagMean
        tBodyGyroJerkMagStd
        fBodyAccMeanX
        fBodyAccMeanY
        fBodyAccMeanZ
        fBodyAccStdX
        fBodyAccStdY
        fBodyAccStdZ
        fBodyAccJerkMeanX
        fBodyAccJerkMeanY
        fBodyAccJerkMeanZ
        fBodyAccJerkStdX
        fBodyAccJerkStdY
        fBodyAccJerkStdZ
        fBodyGyroMeanX
        fBodyGyroMeanY
        fBodyGyroMeanZ
        fBodyGyroStdX
        fBodyGyroStdY
        fBodyGyroStdZ
        fBodyAccMagMean
        fBodyAccMagStd
        fBodyBodyAccJerkMagMean
        fBodyBodyAccJerkMagStd
        fBodyBodyGyroMagMean
        fBodyBodyGyroMagStd
        fBodyBodyGyroJerkMagMean
        fBodyBodyGyroJerkMagStd

    Final data feature names are composed of abbreviations that identify the defining characteristics of each feature:
    1. "t" or "f" in the first character, for time and frequency domain features, respectively
    2. "Body" vs "Gravity" to distinguish - especially in linear acceleration features - body motion vs gravity components
    3. "Acc", "AccJerk", "Gyro", "GyroJerk" to identify respectively: linear acceleration, its derivative in time, angular velocity and its derivative in time
    4. "Mean" or "Std" to identify mean or standard deviation
    5. "X", "Y", "Z" or "Mag" to identify features calculated along the X, Y, Z axis or Euclidian magnitudes respectively
