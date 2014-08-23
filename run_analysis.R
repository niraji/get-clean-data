# set working directory where data has been downloaded
setwd("/Users/nirajpatel/Desktop/coursera/JH\ -\ getting\ data/project/data")
# read data into R
xTrain <- read.table("./train/X_train.txt", sep="", header=FALSE)
yTrain <- read.table("./train/y_train.txt", sep="", header=FALSE)
xTest <- read.table("./test/X_test.txt", sep="", header=FALSE)
yTest <- read.table("./test/y_test.txt", sep="", header=FALSE)
subTrain <- read.table("./train/subject_train.txt", sep="", header=FALSE)
subTest <- read.table("./test/subject_test.txt", sep="", header=FALSE)
# reading the corresponding variable names,features, defining the Test and Train data sets
# with the second column in features dataset
features <- read.table("./features.txt", sep ="",header=FALSE)
names(xTrain) <- features[,2]
names(xTest) <- features[,2]
names(yTrain) <- "Act_Label"
names(yTest) <- "Act_Label"
names(subTest) <- "SubjectID"
names(subTrain) <- "SubjectID"
# combining test and training data sets
xdata <- rbind(xTrain, xTest)
ydata <- rbind(yTrain, yTest)
sdata <- rbind(subTrain, subTest)
dataset <- cbind(xdata, ydata, sdata)
# grab only measurements that are mean or std. deviations of the measurements
subsetVar1 <- grep("mean|std|Act|Subject", names(dataset))
dataset1 <- dataset[,subsetVar1]
# label the activity with descriptive action, match activity labels with Vol_Label
activitylabels <- read.table("./activity_labels.txt",sep="",header=FALSE)
names(activitylabels) <- c("Act_Label", "Act_Name")
# apply to the labels to the dataset1
dataset1 <- merge(x=dataset1, y=activitylabels, by.x="Act_Label", by.y="Act_Label" )
# reshape function needed
library("reshape2")
# reshape the data
meltdata <- melt(dataset1, id = c("Act_Name", "SubjectID"))
# calculate mean for each activity and subject
tidydata <- dcast(molten, Act_Name + SubjectID ~ variable, mean)
# write tidy dataset to disk
write.table(tidydata, file="tidydata_means.txt", quote=FALSE, row.names=FALSE, sep="\t")
# write codebook
write.table(paste("*", names(tidydata), sep=""), file="CodeBook.md", quote=FALSE, row.names=FALSE, col.names=FALSE, sep="\t")

