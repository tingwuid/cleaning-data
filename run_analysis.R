library(plyr)

##Download the data:
dataurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(dataurl,destfile="./UCI HAR Dataset.zip",method="curl")

unzip(zipfile="./UCI HAR Dataset.zip",exdir="./UCI HAR Dataset")

##Read files into R:
    
feature_test <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)
activity_outcome_test <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE)

feature_train <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)
activity_outcome_train<- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE)

subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)

##Merge files:
    
##1. Combine files of train and testing data

feature <- rbind(feature_train,feature_test)
activity <- rbind(activity_outcome_train,activity_outcome_test)
subject <- rbind(subject_train,subject_test)

##2. Assign the proper names of the data

names(activity) <- c("activity")
names(subject) <- c("subject")
featurenames <- read.table("./UCI HAR Dataset/features.txt")
names(feature) <- featurenames$V2

##3. merge data

dataset <- cbind(subject,activity,feature)

##Extracts only the measurements on the mean and standard deviation for each measurement:

meanstandardnames <- featurenames$V2[grep("mean\\(\\)|std\\(\\)",featurenames$V2)]
dataset <- dataset[c("activity","subject",as.character(meanstandardnames))]


##Uses descriptive activity names to name the activities in the data set:
    
activity_label <- read.table("./UCI HAR Dataset/activity_labels.txt", header = FALSE)
names(activity_label) <- c("activity_label","activitynames")

dataset1 <- merge(x=dataset,y=activity_label,by.x = "activity", by.y="activity_label", all.x = TRUE)
dataset <- dataset1[c("activitynames","subject",as.character(meanstandardnames))]


##Appropriately labels the data set with descriptive variable names:
    
names(dataset) <- gsub("^t","time",names(dataset))
names(dataset)<-gsub("^f", "frequency", names(dataset))
names(dataset)<-gsub("Acc", "Accelerometer", names(dataset))
names(dataset)<-gsub("Gyro", "Gyroscope", names(dataset))
names(dataset)<-gsub("Mag", "Magnitude", names(dataset))
names(dataset)<-gsub("BodyBody", "Body", names(dataset))


##creates a second, independent tidy data set with the average of each variable for each activity and each subject:

datasetnew <- aggregate(. ~subject + activitynames, dataset, mean)

##Write the data into txt file:

write.table(datasetnew, file = "cleandataset.txt",row.name=TRUE)


