# Download and unzip file for the assignment

setwd("C:/Users/lenovo/Desktop/coursera/assignment4")

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./Ziped/file.zip")

zipF<- "./Ziped/file.zip"
outDir<-"./Unziped"
unzip(zipF,exdir=outDir)

#Looking through files and reading them in

setwd("C:/Users/lenovo/Desktop/coursera/assignment4/Unziped")

activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
features <- read.table("./UCI HAR Dataset/features.txt")


#Looking through files in test

subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")


#Looking through files in train

subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")


##The process of preparing data set

#First step: rbind subject_test and subject_train

subject_total <- rbind(subject_test, subject_train)

#Second step: rbind X_test and X_train

x_total <- rbind(x_test, x_train)

#Third step: rbind y_test and y_train

y_total <- rbind(y_test, y_train)

#Fourth step: finding out mean() and std() in features

mean <- grep("mean()", features$V2)
std <- grep("std()", features$V2)


#Fifth step: renaming x_total with features, extracting mean values from x_total and naming "m"

library(dplyr)  

colnames(x_total) <- features$V2

m <- x_total[, mean]


#Sixth step: extracting std values from x_total and naming "s"

s <- x_total[, std]

#Seventh step: cbind m and s in order to get all the measurements with mean and std values
#and naming x

x <- cbind(m, s)

#8th step: renaming column of subject_total with subject

colnames(subject_total) <- c("subject")

#9th step: renaming column of y_total with activity

colnames(y_total) <- c("activity")

#10th step: creating a new data set with means and stds by cbinding 

Data <- cbind(subject_total, y_total, x)

#11th step: renaming activities in Data from activity_labels

Data = within(Data, {
  activity = ifelse(activity %in% 1, "WALKING",ifelse(activity %in% 2, "WALKING_UPSTAIRS",
  ifelse(activity %in% 3, "WALKING_DOWNSTAIRS", ifelse(activity %in% 4, "SITTING",
  ifelse(activity %in% 5, "STANDING",  "LAYING")))))
})


#12th step: creating a final tidy data set grouped and averaged

library(dplyr)
Final <- Data %>% group_by(subject, activity) %>% summarise_all(funs(mean))

#13th step: writing final csv and txt

write.csv(Final,"final.csv", row.names=FALSE)
write.table(Final,"final.txt",sep="\t",row.names=FALSE)
