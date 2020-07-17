## GETTING AND CLEANING DATA

# Pre-processing functions
# Packages and libraries required
        LoadLibraries <- function(){

                install.packages("reshape2")
                install.packages("data.table")
                library(reshape2)
                library(data.table)

        }
# Set working directory
        SetworkingDirectory <- function(path = getwd()){

                # Get working directory path and set a coursera folder
                folder <<- (paste0(path,"/coursera"))
                if(!dir.exists(folder)){dir.create(folder)}
                setwd(folder)
                return(folder)
                paste("Working directory folder where files will be written: ", folder)

        }

# Get files from repository, save and unpack it into working directory
        LoadFiles <- function(folder = getwd()){

                url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
                download.file(url, file.path(folder, "Dataset.zip"))
                unzip(zipfile = "Dataset.zip")
                print(paste("Download completed! Files save in ->",folder,"<-folder." ))

        }

# Install packages and load libraries
LoadLibraries()
SetworkingDirectory()
LoadFiles()



# Processing code
# Get labels and features from local working directory
        # create data table with instances labels from text file
        labelInfo <- fread(file.path(folder, "/UCI HAR Dataset/activity_labels.txt")
                           , col.names = c("classLabels", "activityName"))

        # create data table of instances features from text file
        featuresInfo <- fread(file.path(folder, "/UCI HAR Dataset/features.txt")
                              , col.names = c("index", "featureNames"))

        # extracts measurements on the mean and standard deviation
        measurements <- grep("(mean|std)\\(\\)", featuresInfo[, featureNames])
        features <- featuresInfo[measurements, featureNames]
        features <- gsub('[()]', '', features)


# Mount train and test data tables with features
        #get data from text file
        trainTable <- fread(file.path(folder, "/UCI HAR Dataset/train/X_train.txt"))[, measurements, with = FALSE]
        trainTest <- fread(file.path(folder, "/UCI HAR Dataset/test/X_test.txt"))[, measurements, with = FALSE]

        #build train dataset
        data.table::setnames(trainTable, colnames(trainTable), features)
        trainActivities <- fread(file.path(folder, "/UCI HAR Dataset/train/Y_train.txt")
                                 , col.names = c("Activity"))
        trainSubjects <- fread(file.path(folder, "/UCI HAR Dataset/train/subject_train.txt")
                               , col.names = c("SubjectNum"))
        trainTable <- cbind(trainSubjects, trainActivities, trainTable)

        #build test dataset
        data.table::setnames(trainTest, colnames(trainTest), features)
        testActivities <- fread(file.path(folder, "/UCI HAR Dataset/test/Y_test.txt")
                                , col.names = c("Activity"))
        testSubjects <- fread(file.path(folder, "/UCI HAR Dataset/test/subject_test.txt")
                              , col.names = c("SubjectNum"))

        testTable <- cbind(testSubjects, testActivities, trainTest)


# Merge both datasets to build final tidy dataset

        # merge datasets by row
        mergedDataset <- rbind(trainTable, testTable)

        # convert labels to activities name
        mergedDataset[["Activity"]] <- factor(mergedDataset[, Activity]
                                         , levels = labelInfo[["classLabels"]]
                                         , labels = labelInfo[["activityName"]])
        # convert subject number to factor type
        mergedDataset[["SubjectNum"]] <- as.factor(mergedDataset[, SubjectNum])
        #melt subject number and activities
        mergedDataset <- reshape2::melt(data = mergedDataset, id = c("SubjectNum", "Activity"))
        mergedDataset <- reshape2::dcast(data = mergedDataset, SubjectNum + Activity ~ variable, fun.aggregate = mean)


#Save tidy dataset in working directory

        data.table::fwrite(x = mergedDataset, file = "tidyData.txt", quote = FALSE)
        paste("Tyde dataset saved in", folder, "!")
