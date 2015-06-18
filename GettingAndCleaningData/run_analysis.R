#####################################################################################################
## SCRIPT run_analysis.R
## ALSO READ: CodeBook.md, README.md
## Following are the requirements for this script, once it gets the UCI HAR data set.
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names. 
## 5. From the data set in step 4, creates a second, independent tidy data set 
##    with the average of each variable for each activity and each subject.
## 
## The script achieves these requirements in the following altered sequence.
## STEP 0: DOWNLOAD THE DATA SET IF WE DON'T HAVE IT IN OUR WORKING DIRECTORY.
## STEP 1: MERGE THE TEST AND THE TRAINING SETS TO CREATE ONE DATA SET.
## STEP 2: USE DESCRIPTIVE ACTIVITY NAMES TO NAME THE ACTIVITIES IN THE DATA SET.
## STEP 3: APPROPRIATELY LABEL THE DATA SET WITH DESCRIPTIVE VARIABLE NAMES.
## STEP 4: EXTRACT ONLY THE MEASUREMENTS ON THE MEAN AND STANDARD DEVIATION FOR EACH MEASUREMENT.
## STEP 5: FROM THE ABOVE DATA SET, CREATES A SECOND, INDEPENDENT TIDY DATA SET 
##         WITH THE AVERAGE OF EACH VARIABLE FOR EACH ACTIVITY AND EACH SUBJECT.
## STEP X: CLEAN UP THE ENVIRONMENT
#####################################################################################################

# We need these two libraries to use ddply() and summarise_each().
library(plyr)
library(dplyr)

## STEP 0: DOWNLOAD THE DATA SET IF WE DON'T HAVE IT IN OUR WORKING DIRECTORY.

# The directory containing the data set, which we get upon uncompressing the downloaded file.
sourcepath <- file.path(getwd(),"UCI HAR Dataset")

# If we don't have the directory, download the data set.
if(!file.exists(sourcepath)){
    fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20data set.zip"
    sourcefile <- "sourcefile.zip"
    download.file(fileURL, destfile=sourcefile, method="curl")
    unzip(sourcefile)
}

## STEP 1: MERGE THE TEST AND THE TRAINING SETS TO CREATE ONE DATA SET.

# The test directory contains three files: X_test.txt, subject_test.txt and y_test.txt.
# The X_test.txt file contains the actual 561 computed measures.
# The subject_test.txt file contains the subject ids for whom these measures are made.
# The y_test.txt file contains the activities for which these measures are made.
# These three files need to be read in conjuntion, and they have the same number of rows.
# Row N in X_test.txt gives us the measures for the subject in the row N of subject_test.txt
# while performing the activity in row N of y_test.txt.

# Let us first read X_test.txt.
testdata.file <- file.path(sourcepath,"test/X_test.txt")
testdata <- read.table(testdata.file)

# Now read subject_test.txt.
testdata.sub.file <- file.path(sourcepath,"test/subject_test.txt") 
testdata.sub <- read.table(testdata.sub.file)

# And finally read y_test.txt, and add another column to hold the activity name.
testdata.act.file <- file.path(sourcepath,"test/y_test.txt") 
testdata.act <- read.table(testdata.act.file)
testdata.act$activity <- rep(NA,nrow(testdata.act)) 

# Now merge the subject, activity and test data into one data set.
testdata <- cbind(testdata.sub,testdata.act,testdata)

# We also have data in train directory, which is exactly the same as test directory above.
# The train directory contains three files: X_train.txt, subject_train.txt and y_train.txt.
# The X_train.txt file contains the actual 561 computed measures.
# The subject_train.txt file contains the subject ids for whom these measures are made.
# The y_train.txt file contains the activities for which these measures are made.
# These three files need to be read in conjuntion, and they have the same number of rows.
# Row N in X_train.txt gives us the measures for the subject in the row N of subject_train.txt
# while performing the activity in row N of y_train.txt.

# Let us first read X_train.txt.
traindata.file <- file.path(sourcepath,"train/X_train.txt")
traindata <- read.table(traindata.file)

# Now read subject_train.txt.
traindata.sub.file <- file.path(sourcepath,"train/subject_train.txt")
traindata.sub <- read.table(traindata.sub.file)

# And finally read y_train.txt, and add another column to hold the activity name.
traindata.act.file <- file.path(sourcepath,"train/y_train.txt")
traindata.act <- read.table(traindata.act.file)
traindata.act$activity <- rep(NA,nrow(traindata.act))

# Now merge the subject, activity and train data into one data set.
traindata <- cbind(traindata.sub,traindata.act,traindata)

# And now we merge the test and train data into one big data set.
# This contains all the computed measures - all 561 of them.
fulldata <- rbind(testdata,traindata)

## STEP 2: USE DESCRIPTIVE ACTIVITY NAMES TO NAME THE ACTIVITIES IN THE DATA SET.

# The activity_labels.txt file contains the description of different activities.
# For example, WALKING, WALKING_UPSTAIRS etc. Let us populate them in our data set.
activities.file <- file.path(sourcepath,"activity_labels.txt")
activities <- read.table(activities.file)
for (i in 1:nrow(fulldata)) {
    full.actid <- fulldata[i,2]
    fulldata[i,3] <- as.character(activities[full.actid,2])
}

## STEP 3: APPROPRIATELY LABEL THE DATA SET WITH DESCRIPTIVE VARIABLE NAMES.

# The features.txt file contains the names of the 561 computed measures.
# In our tidy data set, these would correspond to the column names.
features.file <- file.path(sourcepath,"features.txt")
features <- read.table(features.file)
colnames(features) <- c("feature_id","feature")
featurenames <- as.vector(features$feature)

# Let us clean up the column names a little, by removing hyphens and parenetheses.
featurenames <- sub("-","_",featurenames, fixed = TRUE)
featurenames <- sub("-","_",featurenames, fixed = TRUE)
featurenames <- sub("()","_",featurenames, fixed = TRUE)

# Now let us add the subject and activity column names, and apply it to the full data set.
fulldatacolumnnames <- c("subject_id","activity_id","activity",featurenames)
colnames(fulldata) <- fulldatacolumnnames

## STEP 4: EXTRACT ONLY THE MEASUREMENTS ON THE MEAN AND STANDARD DEVIATION FOR EACH MEASUREMENT.

# We now have all the computed measures - all 561 of them.
# But we are interested only in mean and standard deviation measures.
# We can identify these by the column names - they have mean() or std() in them.
# A quick check tells us there are 33 each of them. Let us extract only those column names.
fulldatacols <- colnames(fulldata)
meancols <- fulldatacols[grep("mean_",fulldatacols, fixed = TRUE)]
stdcols <- fulldatacols[grep("std_",fulldatacols, fixed = TRUE)]
outputcols <- c("subject_id","activity_id","activity",meancols,stdcols)

# Now let us subset our data set to get data for only those columns.
# This is our first output data set
outputdata <- fulldata[,outputcols]

## STEP 5: FROM THE ABOVE DATA SET, CREATE A SECOND, INDEPENDENT TIDY DATA SET 
##         WITH THE AVERAGE OF EACH VARIABLE FOR EACH ACTIVITY AND EACH SUBJECT.

# Now we make our second data set, which has the average for each mean and std dev measure
# for each subject and activity. We use ddply and summarise_each for that.
outputavgdata <- ddply(outputdata, c("subject_id","activity_id","activity"),summarise_each,funs(mean))

# Using summarise_each for mean overwrites our descriptive activity names with NAs
# because it tries to get the means for activity names as well. It does this for subject id and
# activity id as well, but since they are repeating numbers, applying mean doesn't alter them.
# So let us populate the activity names once again, in this new data set.
for (i in 1:nrow(outputavgdata)) {
    output.actid <- outputavgdata[i,2]
    outputavgdata[i,3] <- as.character(activities[output.actid,2])
}

# Finally write this new data set to a file.
write.table(outputavgdata,"outputavgdata.txt",row.name=FALSE)

## STEP X: CLEAN UP THE ENVIRONMENT

# And in the very end, some house keeping - clean up all objects from memory.
# If we need any of the objects for debugging/viewing:
# 1. Comment out both the rm call on list=ls(), and the rm call for that object.
# 2. Uncomment rm calls for all other objects.
# If we need everything, comment out all the following rm calls.

rm(list=ls())
# rm (activities)
# rm (activities.file)
# rm (featurenames)
# rm (features)
# rm (features.file)
# rm (full.actid)
# rm (fulldata)
# rm (fulldatacols)
# rm (fulldatacolumnnames)
# rm (i)
# rm (meancols)
# rm (output.actid)
# rm (outputavgdata)
# rm (outputcols)
# rm (outputdata)
# rm (sourcepath)
# rm (stdcols)
# rm (testdata)
# rm (testdata.act)
# rm (testdata.act.file)
# rm (testdata.file)
# rm (testdata.sub)
# rm (testdata.sub.file)
# rm (traindata)
# rm (traindata.act)
# rm (traindata.act.file)
# rm (traindata.file)
# rm (traindata.sub)
# rm (traindata.sub.file)
