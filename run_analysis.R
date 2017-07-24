setwd("~/data/UCI HAR Dataset")

names <- read.table("features.txt", sep=" ")[,2]
act_desc <- data.frame(num = 1:6, act = c("walking", "walkingupstairs", "walkingdownstairs", "sitting", "standing", "laying"))

setwd("~/data/UCI HAR Dataset/test")
act_test <- read.table("y_test.txt")
act_test <- merge(act_desc, act_test, by.x = "num", by.y = "V1")
subj_test <- read.table("subject_test.txt")
data_test <- read.table("X_test.txt", col.names = names)
data_test_mean_std <- data_test[, grep(".mean...[XYZ]$|std", names)]
data_test_mean_std <- cbind(activity = act_test[,2], subjectnum = subj_test[,1], datatype = "test", data_test_mean_std)

setwd("~/data/UCI HAR Dataset/train")
act_train <- read.table("y_train.txt")
act_train <- merge(act_desc, act_train, by.x = "num", by.y = "V1")
subj_train <- read.table("subject_train.txt")
data_train <- read.table("X_train.txt", col.names = names)
data_train_mean_std <- data_train[, grep(".mean...[XYZ]$|std", names)]
data_train_mean_std <- cbind(activity = act_train[,2], subjectnum = subj_train[,1], datatype = "train", data_train_mean_std)

merged_data <- rbind(data_train_mean_std, data_test_mean_std)
names(merged_data) <- gsub("\\.","",names(merged_data))
names(merged_data) <- gsub("X","-X",names(merged_data))
names(merged_data) <- gsub("Y","-Y",names(merged_data))
names(merged_data) <- gsub("Z","-Z",names(merged_data))
names(merged_data) <- gsub("^t","t-",names(merged_data))
names(merged_data) <- gsub("^f","f-",names(merged_data))
names(merged_data) <- gsub("BodyBody","Body",names(merged_data))

library(dplyr)

avg_merged_data <- select(merged_data, -datatype) %>%
  group_by(activity, subjectnum) %>%
  summarise_all(mean)

avg_merged_data <- as.data.frame(avg_merged_data)

setwd("~/data")
write.table(avg_merged_data, "avg_merged_data.txt", row.names = FALSE)

  