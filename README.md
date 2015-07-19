## Getting and Cleaning Data Course Project

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. 

Everything is done in one script called run_analysis.R
Script is divided into 5 steps in a way it was described in the course project description. Additionally it has step 0 which is used to download and extract data. Here is the short description (inside run_alaysis.R all steps are commented in more detailed level) of the steps:

0. Folder "courseproject" will be created into your current working directory. All necessary files will be downloaded and unzipped into that directory
1. Test and train data sets are merged into one data set
2. Only variables which hold measurement of the mean and standard deviation are taken into account. Other variables are ignored.
3. Numeric values of activities are replaced with descriptive names
4. Variable names in data set are modified to be more easily readable and understandable
5. Tidy data set is into "courseproject" directory as tidy_data.txt

Easiest way to view tidy data is to issue the following commands from your current working directory in RStudio
```
data <- read.table('./courseproject/tidy_data.txt', header = TRUE)
View(data)
```
codebook.md gives a list of all variables found in tidy data set tidy_data.txt
