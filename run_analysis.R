

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" 
download.file(url,"C:/Users/xyz/Documents", method = "curl")
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}
library(dplyr)
install.packages("tidyverse")
library(tidyverse)

# We can use this directly if we have downloaded and unzip the file

# Assigning variable to each data
features <- read.table("UCI HAR Dataset/features.txt")
activities <- read.table("UCI HAR Dataset/activity_labels.txt")
                      
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
head(x_train)

# Merging train and test data set to form one data set

subject <- rbind(subject_train,subject_test)
X <- rbind(x_train,x_test)
Y <- rbind(y_train,y_test)
names(subject) <- c("subject")
names(Y) <- c("activity")
names(X) <- features$V2
datacombine <- cbind(subject,Y)
mergedata <- cbind(X,datacombine)



# Extracting the measurements on the mean and standard deviation for each measurement
subdatafeaturesnames <- features$V2[grep(".*mean.*|.*std.*",features$V2)]
subdatafeaturesnames
selectednames <- c(as.character(subdatafeaturesnames), "subject", "activity" )
mergedata <- subset(mergedata,select = selectednames )
str(mergedata)


# using discriptive activity names to name activities in the data set
mergedata$activity <- activities[mergedata$activity,2]
head(mergedata$activity,30)
levels(mergedata$activity)



# Appropriately labeling the data sets with descriptive variable name
names(mergedata)<-gsub("^t", "time", names(mergedata))
names(mergedata)<-gsub("^f", "frequency", names(mergedata))
names(mergedata)<-gsub("Acc", "Accelerometer", names(mergedata))
names(mergedata)<-gsub("Gyro", "Gyroscope", names(mergedata))
names(mergedata)<-gsub("Mag", "Magnitude", names(mergedata))
names(mergedata)<-gsub("BodyBody", "Body", names(mergedata))
names(mergedata)


#Creating a second and independent tidy data set
mergedata2<-aggregate(. ~subject + activity, mergedata, mean)
mergedata2<-mergedata2[order(mergedata2$subject,mergedata2$activity),]
write.table(mergedata2, file = "tidydata.txt",row.name=FALSE)
