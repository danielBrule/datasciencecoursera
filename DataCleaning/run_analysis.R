#load library 
library("reshape2")

#set working directory
setwd("C:/datasciencecoursera/DataCleaning")


#read csv 
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
features <- read.table("./UCI HAR Dataset/features.txt")

X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
Y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
Y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")


#prepare column name 
features <- features[,2]
features_extracted <- grepl("mean|std", features)
activity_labels <- activity_labels[,2]


#set columns names 
names(X_test) <- features
names(X_train) <- features


Y_train[,2] = activity_labels[Y_train[,1]]
Y_test[,2] = activity_labels[Y_test[,1]]
names(Y_train) = c("Activity_ID", "Activity_Label")
names(Y_test) = c("Activity_ID", "Activity_Label")

names(subject_train) = "subject"
names(subject_test) = "subject"


#bind data
train_data <- cbind(as.data.frame(subject_train), Y_train, X_train)
test_data <- cbind(as.data.frame(subject_test), Y_test, X_test)

#merge train and and test data set 
data = rbind(test_data, train_data)






data_labels = setdiff(colnames(data), c("subject", "Activity_ID", "Activity_Label"))
melt_data      = melt(data, id = c("subject", "Activity_ID", "Activity_Label"), measure.vars = data_labels)

# Apply mean function to dataset using dcast function
tidy_data   = dcast(melt_data, subject + Activity_Label ~ variable, mean)

write.table(tidy_data, file = "./tidy_data.txt")
