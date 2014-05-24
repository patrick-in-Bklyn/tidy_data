## CODE STARTS ON LINE 34.
##
## program to get and clean up data for data specialization 
## begin with the saved data in the files as they were unzipped from 
## put variable names on the files we need to work on. Do this manually in the first section of the code. 
## feed these to the functions in the following order

## 1. merge the data sets in the train.txt file with the test.txt file
## 2. identify the wanted columns using features.txt and the "mean()" and "std()" as parameters
## 3. subset the merged data set to get the wanted data using a simple [wanted] suffix to the select statement.
## 3. take the activity_labels.txt file and reformat the 2nd column to meet good R standards (lower case and dot separated words)
## 4. merge the trial_y and test_y files to get the codes for the activities in the order given.
## 5. use an lapply function to create a vector of activity names that is the same length as the merged trial_y and test_Y data set
## 6. use cbind() to create an array of activity codes in one column and activity name in another. 
## 7. bind the large "wanted" data set with the activity array.
## 8. Move on to reformatting and binding the columns
## 9. load the wanted subset of the column names (features.txt) into an array.
## 10. replace -mean()- and -std()- with Mean and Std respectively. 
## 11. Then search for capital letters and replace these with a dot and a lower case version of the same letter. replace any "-" symbols with a dot too. Remove parentheses.
## 12. use a rbind() function to attach the "wanted" data set to the reformatted column array. 
## 13. return this final array. 

## 14. Move on to getting averages
##      a. create the activity code and the subject row_headers columns. These are just arrays (1:6, and 1:30 respectively)
##      b. use the activity code column to generate the activity labels column. add colnames to this array. 
##      c. take the final table generated in the main function and subset out by activity and then by user.
##      d. get the colmeans on each column in this subset.
##      e. pin together these colmeans with an apply function
##      f. use a cbind command to attach the colmeans to the row headers.
##      g. rename the column headers to reflect that these are the mean of variables extracted from the final table. 
##      h. write that table down to a "tidy_means.txt" file and save it in the paren directory. 


run_analysis <- function()
        {
        ## check the files are in the current working directory
        
        if (!("UCI HAR Dataset" %in% dir(getwd()))){ stop("your working directory is not set to the Zip files you downloaded.");}
        
        ## if they are get a list containing the names, No of rows and No. of cols in each file.
        
        file_list <- if( "file_list.txt" %in% list.files("../")){ read.table(as.character("../file_list.txt"), sep =",");} else{investigate_files();}
        
        ##      set up the variables from this file list to feed into the functions.
        
        column_names <- as.character(file_list[3,1]);
        key_word1 <- "mean()"; key_word2 <- "std()";
        
        table_body_file1 <- as.character(file_list[27,1]); table_body_file2 <- as.character(file_list[15,1]);
        
        activity_column1 <- as.character(file_list[28,1]); activity_column2 <- as.character(file_list[16,1]);
        activity_labels <- as.character(file_list[1,1]);
        subject_file1 <- as.character(file_list[26,1]); subject_file2 <- as.character(file_list[14,1]); 
        
        ##      work through the check list
        ##      1. merge files to make the body of the table

        table_body <- merge_set(table_body_file1, table_body_file2);
        
        ##      2. get the column titles and filter for our required keywords and reformat them

        factor_labels <- find_wanted_cols(column_names, key_word1, key_word2);
        variables <- read.table(column_names)[,2];
        variables <-variables[factor_labels];
        variables <- sapply(variables, function(x) format_cols(x));        

        ##      3. reduce the table body to the wanted set only

        table_body <- table_body[factor_labels];

        ##      4. put the subject codes and the activity names together and format them
        
        row_codes <- merge_set(activity_column1, activity_column2);
        row_names <- add_labels(row_codes, activity_labels);

        subjects <- merge_set(subject_file1, subject_file2);
        row_data <- cbind(row_names, row_codes, subjects);
        colnames(row_data) <- c("activity", "activity.code", "subject");
        
        ##      5. bind everything together
        
        colnames(table_body) <- variables;
        full_table <- cbind(row_data, table_body);
        final_table <- as.data.frame(full_table);
        
        
        ##      6. Save the table to the parent directory of the working directory as a txt file. 
        
        write.table(final_table, file = "../tidy.txt", quote = FALSE, sep = " ");
        
        ##      7. start working on the means of each variable in the original data set.
        
        ##      begin by setting up an array of activity codes( 1:6) and subjects (1:30). Attach the activity names column to this
        
        act_codes <- 1:6; subj <- 1:30;
        num_cols <- unlist(lapply(act_codes, function(x) rep(x, length.out = length(subj))));
        active_col <- add_labels(num_cols, activity_labels);
        row_heads <- as.data.frame(cbind(active_col, as.numeric(num_cols), as.numeric(subj)));
        colnames(row_heads) <- c("activity", "activity.code", "subject");
        
        ##      get the original files again, reformat the column titles and bind the columns and data to make one frame. 
        means_cols <- read.table(column_names)[,2];
        means_cols <- sapply(means_cols, function(x) format_cols(x))
        
        means_body <- merge_set(table_body_file1, table_body_file2);
        
        colnames(means_body) <- means_cols;
        
        means_body <- cbind(row_data, means_body);
        
        ## subset the data by activity and then by user and calculate the mean for each subset.
        
        means_table <- apply(row_heads, 1, function(x) get_means(means_body, x["activity.code"], x["subject"]));
        means_cols <- sapply(means_cols, function(x) rename_means_cols(x));
        
        ## transpose the frame to wide and bind it to the row headers to make the final frame
        means_table <- t(means_table);
        means_table <- cbind(row_heads, means_table);
        
        ## write the table to the tidy_means.txt file and save it in the parent directory.
        
        write.table(means_table, file = "../tidy_means.txt", quote = FALSE, sep = " ");
        

        ##################### FUNCTIONS START HERE ####################################

        
        investigate_files <- function(dir = ".") ## opens each file and counts rows and columns, saves the result in parent directory.
                {
                file_list <- list.files(dir, recursive = TRUE)
                files <- lapply(file_list, function(x) paste("./", x, sep = "", collapse = "/"))
                rows <- lapply(files, function(x) length(readLines(x)));
                cols <- lapply(files, function(x) ncol(read.table(x, nrows=1)));
                files <- unlist(files); rows <- unlist(rows); cols <- unlist(cols);
                description <- cbind(files, rows, cols);
                description <- as.data.frame(description);
                
                colnames(description) <- c("Files", "Rows", "Columns");

                write.table(description, "../file_list.txt", quote = FALSE, sep = ",");
                return(description);
        
                }

        merge_set <- function(x,y) ## merges two files
                {
                file_1 <- read.table(x, nrows =-1);
                merged_set <- rbind(file_1, read.table(y));
                return(merged_set);
                }
        
        find_wanted_cols <- function(file, key1, key2) ## filters the columns according to the key words supplied
                {
                array <- read.table(file)[,2];
                want_cols <- sapply(array, function(x) (key1 %in% unlist(strsplit(as.character(x), "-"))) || (key2 %in% unlist(strsplit(as.character(x), "-"))));
                return(which(want_cols))
                }

        add_labels <- function(y,z) ## creates a properly formatted column of activity labels
                {
                row_names <- y;
                act_labels <- read.table(as.character(z));
                act_labels2 <- sapply(act_labels[,2], function(x) format_act_labels(x));
                final_labels <- sapply(row_names, function(x) act_labels2[x]);
                return(final_labels);
        
                }

        format_act_labels <- function(x) ## helper function to add_labels. It formats the labels
                {
                start_str <- unlist(strsplit(as.character(x), ""));
        
        
                formatted <- if("_" %in% start_str)
                        {
                        str_fix <- unlist(strsplit(as.character(x), "_"));
                        paste(str_fix, sep = "", collapse = ".");
                        }
                        else {paste(start_str, sep = "", collapse = "")}
                return(tolower(formatted));
                }


        format_cols <- function(x) ## re-formats the columns to meet tidy data principals.
                {
                start <- unlist(strsplit(as.character(x), "-"));
                if ("mean()" %in% start) {start[which(start == "mean()")] <- "Mean";}
                if("std()" %in% start) {start[which(start == "std()")] <- "Std";}
                start <- paste(start, sep = " ", collapse = "");
                next_step <- unlist(strsplit(start, ""))
        
                replace_caps <- function(x){ if (x %in% LETTERS){x <- paste(".", tolower(x), sep = "", collapse = "")}else{x}}
        
                final <- paste(sapply(next_step, replace_caps), sep = "", collapse = "")
                return(final);
                }

        

        
        get_means <- function(frame, x, y) # subsets the frame according to activity and subject and calculates column means.
                {
                subset <- subset(frame, activity.code == x & subject == y, drop = TRUE); 
                return(colMeans(subset[,4:ncol(frame)]));
                }
        rename_means_cols <- function(x) # changes the column titles to reflect that there are means of raw data.
                {
                return(paste("mean.of.", x, sep = "", collapse = ""));
                
                }
        return(final_table);
        }