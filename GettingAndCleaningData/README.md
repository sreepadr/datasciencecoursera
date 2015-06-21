###### SCRIPT run_analysis.R
Created for tidying UCI HAR data, as part of course project for Getting and Cleaning data.
###### ALSO READ: CodeBook.md
Following are the requirements for this script, once it gets the UCI HAR data set.

1. Merges the training and the test sets to create one data set.

2. Extracts only the measurements on the mean and standard deviation for each measurement. 

3. Uses descriptive activity names to name the activities in the data set

4. Appropriately labels the data set with descriptive variable names. 

5. From the data set in step 4, creates a second, independent tidy data set 
    with the average of each variable for each activity and each subject.
 
The script achieves these requirements in the following altered sequence.

* Step 0: Download the data set if we don't have it in our working directory.
* Step 1: Merge the test and the training sets to create one data set.
* Step 2: Use descriptive activity names to name the activities in the data set.
* Step 3: Appropriately label the data set with descriptive variable names.
* Step 4: Extract only the measurements on the mean and standard deviation for each measurement.
* Step 5: From the above data set, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
* Step X: Clean up the environment

