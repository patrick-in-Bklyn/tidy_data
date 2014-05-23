tidy_data
=========

###tidy data set and code for extracting and cleaning data.
# Program to get and clean up data for data specialization 
        begin with the saved data in the files as they were unzipped from 
                https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
        these files were unzipped into a directory named zip_files created to hold #$ONLY$# the unzipped files. 
        
        change the working directory in the evnironment to zip_files. 
        
#Run the investigate_files function. 

        This allows us to visually view the files and, by looking at the dimensions of the data in each file we can match them.
        
#put variable names on the files we need to work on. 

        Do this manually in the first section of the code. 
        
#Generate the tidy data set 
        which shows the mean and std of each variable by subject and activity. Re-label rows and columns in line with good data science practice. 

        1. merge the data sets in the train.txt file with the test.txt file
        2. identify the wanted columns using features.txt and the "mean()" and "std()" as parameters
        3. subset the merged data set to get the wanted data using a simple [wanted] suffix to the select statement.
        3. take the activity_labels.txt file and reformat the 2nd column to meet good R standards (lower case and dot separated words)
        4. merge the trial_y and test_y files to get the codes for the activities in the order given.
        5. use an lapply function to create a vector of activity names that is the same length as the merged trial_y and test_Y data set
        6. use cbind() to create an array of activity codes in one column and activity name in another. 
        7. bind the large "wanted" data set with the activity array.
        8. Move on to reformatting and binding the columns
        9. load the wanted subset of the column names (features.txt) into an array.
        10. replace -mean()- and -std()- with Mean and Std respectively. 
        11. Search for capital letters and replace these with a dot and a lower case version of the same letter. 
        12. Replace any "-" symbols with a dot too. Remove parentheses.
        12. use a rbind() function to attach the "wanted" data set to the reformatted column array. 
        13. return this final array. 
        
# Generate a data.frame 
        of the variable means by activity and by user, savt to tidy_means.txt:

        a. create the activity code and the subject row_headers columns. These are just arrays (1:6, and 1:30 respectively)
        b. use the activity code column to generate the activity labels column. add colnames to this array. 
        c. take the final table generated in the main function and subset out by activity and then by user.
        d. get the colmeans on each column in this subset.
        e. pin together these colmeans with an apply function
        f. use a cbind command to attach the colmeans to the row headers.
        g. rename the column headers to reflect that these are the mean of variables extracted from the final table. 
        h write that table down to a "tidy_means.txt" file and save it in the parent directory. 
        
        