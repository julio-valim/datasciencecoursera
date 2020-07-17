# Getting and Cleaning Data

## Data files
The data file is available in the UC Irvine Machine Learning repository. To download it click [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "Clicking will download the data").

## Files text description
- features: includes the name of 561 features measured
- X_train: includes the measurements of the features in train set
- y_train: includes activities label for each measurement
- subject_train: includes subject ids for each measurement from the train set
- X_test: includes the measurements of the features in test set
- y_test: includes activities numbers for each measurement from the test set
- subject_test: includes subject ids for each measurement from the test set


## Step works overview
- Merges the training and the test sets to create one data set.
- Extracts only the measurements on the mean and standard deviation for each measurement.
- Uses descriptive activity names to name the activities in the data set
- Appropriately labels the data set with descriptive variable names.
- From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


## Script steps
After set installing packages and loading required libraries, we set working directory, download and unpack data files.
Then into processing code, we get labels and features from activity_labels file and create a data table with instances labels.
So we create a data table of instances features from features text file.
With features on hand, we extracts the mean and standard deviation measurements.
The next step is mount train and test data tables with features, build train dataset, build test dataset.
Finally, to get the tidy dataset, we merge both train and test datasets by row, convert label to activity name and melt subject num and activity.


You can check script click [here](https://github.com/julio-valim/datasciencecoursera/blob/master/GetCleanData.R) .
