## getting and cleaning data
## course project

# download raw data and unzip
setwd("~/GoogleDrive/workshop/Data Science Specialization/03_Getting and Cleaning Data/project/")
fname="FUCI HAR Dataset.zip"
furl="https://d396qusza40orc.cloudfront.net/getdata%2Fproject les%2FUCI%20HAR%20Dataset.zip"
if(!file.exists(fname)) {download.file(furl,fname)}
unzip(fname)
list.files("UCI HAR Dataset/",recursive = TRUE)

# read data and check dimensions
trainX<-read.table("UCI HAR Dataset/train/X_train.txt")
trainY<-read.table("UCI HAR Dataset/train/y_train.txt")
trainsub<-read.table("UCI HAR Dataset/train/subject_train.txt")
testX<-read.table("UCI HAR Dataset/test/X_test.txt")
testY<-read.table("UCI HAR Dataset/test/y_test.txt")
testsub<-read.table("UCI HAR Dataset/test/subject_test.txt")
cnametb<-read.table("UCI HAR Dataset/features.txt")
dim(trainX)
dim(trainY)
dim(trainsub)
dim(testX)
dim(testY)
dim(testsub)
dim(cnametb)

# combine train and test data sets
combX<-rbind(trainX,testX)
combY<-rbind(trainY,testY)
combsub<-rbind(trainsub,testsub)
# combine data sets with subject and activity
combone<-cbind(combsub,combY,combX)
dim(combone)
Xname<-as.vector(cnametb[,2])
names(combone)<-c("Subject","Activity",Xname)


# get columns with mean or standard deviation
meanstdcol<-grep("mean|std",ignore.case = TRUE,names(combone))
# check the name of selected columns
# names(combone)[meanstdcol]
combonems<-combone[,c(1,2,meanstdcol)]
dim(combonems)


# get activity names and replace number with string
acttb<-read.table("UCI HAR Dataset/activity_labels.txt")
actnum<-acttb$V1
actchar<-as.vector(acttb$V2)
library(plyr)
combonems$Activity<-mapvalues(combone$Activity,from=actnum,to=actchar)


# rename the column names
names(combonems)<-gsub("\\(\\)","",names(combonems))

# group and get mean
library(dplyr)
bygroup<-group_by(combonems,Activity,Subject)
comb2<-summarize_all(bygroup,mean)

# write to file
write.table(combonems, file="tidyData1.txt")
write.table(comb2,file="tidyData2.txt")

