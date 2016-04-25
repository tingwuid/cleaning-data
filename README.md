# cleaning-data

Download the data:
1. Assign url : dataurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
2. Use download.file function to download the data file in zip fomat: 
download.file(dataurl,destfile="./UCI HAR Dataset.zip",method="curl")
3. Unzip the file: unzip(zipfile="./UCI HAR Dataset.zip",exdir="./UCI HAR Dataset")
4. View files in the folder: 
files <- list.files("./UCI HAR Dataset",recursive=TRUE)
files

Read files into R:
1. Read test and train data files:
feature_test <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)
activity_outcome_test <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE)

feature_train <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)
activity_outcome_train<- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE)

subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)

2. Merge files:

feature <- rbind(feature_test,feature_train)
activity <- rbind(activity_outcome_test,activity_outcome_train)
subject <- rbind(subject_test,subject_train)

names(activity) <- c("activity")
names(subject) <- c("subject")
featurenames <- read.table("./UCI HAR Dataset/features.txt")
names(feature) <- featurenames$V2

dataset <- cbind(subject,activity,feature)

meanstandardnames <- featurenames$V2[grep("mean\\(\\)|std\\(\\)",featurenames$V2)]
dataset <- dataset[c("activity","subject",as.character(meanstandardnames))]

activity_label <- read.table("./UCI HAR Dataset/activity_labels.txt", header = FALSE)
names(activity_label) <- c("activity_label","activitynames")

dataset1 <- merge(x=dataset,y=activity_label,by.x = "activity", by.y="activity_label", all.x = TRUE)
dataset <- dataset1[c("activitynames","subject",as.character(meanstandardnames))]
head(dataset$activitynames,30)

names(dataset) <- gsub("^t","time",names(dataset))
names(dataset)<-gsub("^f", "frequency", names(dataset))
names(dataset)<-gsub("Acc", "Accelerometer", names(dataset))
names(dataset)<-gsub("Gyro", "Gyroscope", names(dataset))
names(dataset)<-gsub("Mag", "Magnitude", names(dataset))
names(dataset)<-gsub("BodyBody", "Body", names(dataset))

datasetnew <- aggregate(. ~subject + activitynames, dataset, mean)

write.table(datasetnew, file = "cleandataset.txt",row.name=TRUE)




