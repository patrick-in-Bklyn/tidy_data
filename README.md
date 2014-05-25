tidy_data
=========

###Code for extracting and cleaning data in the "Human Activity Recognition using Smartphones" Dataset.
#### Course project for JHU/Coursera Data Science course "Getting and Cleaning Data"
####           By patrick in Bklyn                       May 2014
       Raw data files were extracted from the link:
       
        https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
        
        files were unzipped to a directory named zip_files.
        
        The directory should hold __**ONLY**__ the unzipped files. 
        
        change the working directory in the evnironment to zip_files. 
        
        To understand the data correctly refer to:
        
        http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
        
        This site provides a full description of the experiments done, the variables measured
        and the organization of the data. 
        
        __**Refer to this site to understand the tables**__

####Copy the program and each sub function into your environment.
        The functions under the main run_analysis function must
        be copied into your environment separately. 
        
####Run the investigate_files function. 

        This will save down a "file_list" which maps all of the files 
        in the dataset and provides the dimensions of each file. 
        
####Put variable names on the files we need to work on. 

         This is already done, but it is important to know the reference files
         to manage errors if they arise. 
        
####Generate the tidy data set  of the mean and std of each variable by subject and activity.
####    Save this file to "../tidy.txt"

        1. merge the data sets in the train.txt file with the test.txt file
        2. Subset the arrays according to column names (key words are mean() and std()).
        3. if a different filter is needed you can change the key_word1 and key_word2 parameters. 
        4. reformat the labels within the original data to meet good R practice.
        5. Naming conventions were kept as close to the original as possible.

        for columns:    tBodyAcc-mean()-X was transformed to t.body.acc.mean.x
        for rows:       WALKING_DOWNSTAIRS was transformed to walking.downstairs
                        
        7. This final array has 10,299 rows and 69 columns.
        8. The array is saved to a file entitled tidy.txt in the parent directory. 
        
        
####Generate a data.frame of which has the mean of all variable by activity and by subject
####    Save to "../tidy_means.txt":
        
        1. Take the merged data from the train.txt and test.txt files.
        2. filter the data sucessively by subject and then by activity
        3. calculate the mean of each column in the subset. 
        4. take original variables.txt file and reformat to R standard.
        
        4. create a frame of all subset means and bind to row_names.  
        5. The first 3 columns of this frame are titles for row names 
                (activity, activity.code and subject)
        6. there are 561 columns of output data.

        
        columns:        "tBodyAcc-mean()-X" was transformed to "mean.t.body.acc.mean.x"
        Rows            WALKING_DOWNSTAIRS was transformed to walking.downstairs
        
        8. resulting table has dimensions of 180 rows x 564 columns                
        9. This array is saved to a file entitled "tidy_means.txt" in the parent dir.     
        
        
        