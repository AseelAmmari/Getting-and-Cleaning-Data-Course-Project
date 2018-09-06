library(reshape2)
## set Directory
getwd()
setwd( "C:/Users/ASEEL/Desktop") 
getwd()
## download data 
File_Url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(File_Url,"UCI HAR Dataset.zip")
unzip("UCI HAR Dataset.zip")
dataLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
dataLabels
dataFeatures <- read.table("UCI HAR Dataset/features.txt")
dataFeatures
dataFeatures[,2] <- as.character(dataFeatures[,2])
## mean and standard deviation features 
features <- grep(".*mean.*|.*std.*", dataFeatures[,2])
features
dataFeatures.names <- dataFeatures[features,2]
dataFeatures.names
dataFeatures.names <- sub("-mean","Mean",dataFeatures.names)
dataFeatures.names
dataFeatures.names <- sub("-std","STD",dataFeatures.names)
dataFeatures.names

## Read train and test data 
Training_set<- read.table("UCI HAR Dataset/train/X_train.txt")[features]
Training_set
Training_labels<- read.table("UCI HAR Dataset/train/y_train.txt")
Training_labels
subject_train<- read.table("UCI HAR Dataset/train/subject_train.txt")
subject_train
nrow(Training_set)
nrow(Training_labels)
nrow(subject_train)
Training<- cbind(subject_train,Training_labels,Training_set)
Training

Test_set <- read.table("UCI HAR Dataset/test/X_test.txt")[features]
Test_set 
Test_labels<- read.table("UCI HAR Dataset/test/y_test.txt")
Test_labels
subject_test <-read.table("UCI HAR Dataset/test/subject_test.txt")
subject_test
nrow(Test_set)
nrow(Test_labels)
nrow(subject_test)
Test <- cbind(subject_test,Test_labels,Test_set)
Test

##Merge train and test data 

Data_All <- rbind(Training,Test)
Data_All
nrow(Data_All)
class(Data_All)
colnames(Data_All) <- c("sub", "actv", dataFeatures.names)
names(Data_All)


Data_All$actv <- factor(Data_All$actv,levels = dataLabels[,1],labels =dataLabels[,2] )
Data_All$actv 
Data_All$sub <- as.factor(Data_All$sub )
Data_All
Data_All.melted<- melt(Data_All, id = c("sub", "actv"))
Data_All.melted
Data_All.mean <- dcast(Data_All.melted, sub + actv ~ variable, mean)
Data_All.mean 


write.table(Data_All.mean,"Tidy Data.txt",row.names = FALSE, quote = FALSE)
