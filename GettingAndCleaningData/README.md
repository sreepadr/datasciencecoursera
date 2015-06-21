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
