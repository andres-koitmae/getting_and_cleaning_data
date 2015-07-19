# Step 0
# download and uzip course project data


url <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
dest_filename <- './courseproject/dataset.zip'

# store data in 'courseproject' directory. If 'courseproject' directory does not exist in current working directory, then create it.

if (!file.exists("./courseproject")) 
    {
    dir.create("./courseproject")
    }

# download file if it's not already there

if (!file.exists(filename)) 
    {
    download.file(url, dest_filename)
    }

# unzip the file if it's not done already
if(!file.exists("./courseproject/UCI HAR Dataset"))
    {
    unzip (dest_filename, exdir = "./courseproject")    
    }


# step 1 - Merge the training and test sest to create one data set.


# 1a
# read test data from test folder

library(dplyr)

df_test_x <- read.table('./courseproject/UCI HAR Dataset/test/X_test.txt')
df_test_y <- read.table('./courseproject/UCI HAR Dataset/test/Y_test.txt')
df_test_subject <- read.table('./courseproject/UCI HAR Dataset/test/subject_test.txt')

# read feature names from features.txt
# and apply them as column names to x_test.txt data

df_test_x_col <- read.table('./courseproject/UCI HAR Dataset/features.txt')
colnames(df_test_x) <-  df_test_x_col[,2]

#change column name in df_test_y to make it more understanable
df_test_y <- rename(df_test_y,label = V1)
# change column names in subject data frame to make it more understandable
df_test_subject <- rename(df_test_subject, subject = V1)

# merge dataframes
df_test <- cbind(df_test_x,df_test_subject)
df_test <- cbind(df_test,df_test_y)


# 1b
# read train data from train folder (follows the same logic as test data)

df_train_x <- read.table('./courseproject/UCI HAR Dataset/train/X_train.txt')
df_train_y <- read.table('./courseproject/UCI HAR Dataset/train/Y_train.txt')
df_train_subject <- read.table('./courseproject/UCI HAR Dataset/train/subject_train.txt')

df_train_x_col <- read.table('./courseproject/UCI HAR Dataset/features.txt')
colnames(df_train_x) <-  df_train_x_col[,2]

df_train_y <- rename(df_train_y,label = V1)
df_train_subject <- rename(df_train_subject, subject = V1)

df_train <- cbind(df_train_x,df_train_y)
df_train <- cbind(df_train,df_train_subject)


# 1c
# Merge test and train data into one dataframe

df_full <- rbind(df_test,df_train)

# Step 2
# Extract only the measurements on the mean and standard deviation for each measurement

df_full<- df_full[,(grepl('std|mean|label|subject',colnames(df_full)))]

# Step3
# use descriptive activity names to name the activities in the data set

# read activities

df_activities <- read.table('./courseproject/UCI HAR Dataset/activity_labels.txt')
df_activities <- rename(df_activities, label = V1)

# join dataframes to get activity names instead of id values

df_full <- merge(df_full, df_activities, by='label', sort = F)

# throw away unnecessary columns and give activity column proper name

df_full <- rename(df_full, activity = V2)
df_full$label <- NULL

# Step 4
# label the data set with descriptive variable names

v_names <- names(df_full)

# modify variable names to be more readable
v_names <- gsub("-",".",v_names)
v_names <- gsub("\\()","",v_names)
v_names <- tolower(v_names)
v_names <- gsub("\\.x$",".x.axis",v_names)
v_names <- gsub("\\.y$",".y.axis",v_names)
v_names <- gsub("\\.z$",".z.axis",v_names)

#assign modified variable names back to data frame
colnames(df_full) <- v_names


# Step5 
# create independent tidy data set with the average of each variable for each activity and each subject

df_tidy <- df_full %>%  group_by(subject,activity) %>%  summarise_each(funs(mean))
write.table(df_tidy, "./courseproject/tidy_data.txt",row.names=FALSE)
