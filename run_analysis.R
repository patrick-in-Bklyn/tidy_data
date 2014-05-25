#############################################################################################
##                                                                                       ####
##                                      run_analysis()                                   ####
##                              A program to get and clean up data                       ####
##                              JHU/Coursera Data Scientist Specializat                  ####
##                                   Getting and Cleaning Dat                            ####
##                                   CODE STARTS ON LINE 49.                             ####
##                                                                                       ####
##                              by Patrick - in - Bklyn                                  ####
#############################################################################################

## program to get and clean up data for data specialization 
## begin with the saved data in the files as they were unzipped from 
## put variable names on the files we need to work on. 
## Do this manually in the first section of the code. 
## feed these to the functions in the following order

## 1. merge the data sets in the train.txt file with the test.txt file

## 3. subset the merged data set to get the wanted data

## 3. take the activity_labels.txt file and reformat the 2nd column to meet good 
#                       R standards (lower case and dot separated words)
## 4. merge the trial_y and test_y files to get the activity codes.
## 5. create a vector of activity names to align with trial_y and test_Y data
## 6. use cbind() to create an array called activity array. 
## 7. bind the large "wanted" data set with the activity array.
## 8. Move on to reformatting and binding the columns
## 9. load the wanted subset of the column names (features.txt) into an array.
## 10. reformat column names to meet good R standards
## 12. Change column labels to  x.xxxx.xxxx.xxx.x type name convention
## 13. return this final array. 

## 14. Move on to getting averages
##      a. create the activity code and the subject row_headers columns. 
##      These are just arrays  (1:6, and 1:30 respectively)
##                                                             
##      b.generate the activity.labels, activity.code and subject column array.
##                                                               
##      c. subset the merged original data set by activity and then by user.
##      d. get the colMeans on each column in this subset.
##      e. pin together these colmeans with an apply function
##      f. use a cbind command to attach the colmeans to the row headers.
##      g. rename the column headers to reflect that these are the mean of variables 
                                                               
##      h. write the table of means to a "tidy_means.txt" file and save it in the parent directory. 


run_analysis <- function()
        {
        ## check the files are in the current working directory
        
        if (!("UCI HAR Dataset" %in% dir(getwd()))){ stop("your working directory is not 
                                                          set to the Zip files you downloaded.");}
        
        ## if they are get a list containing the names, No of rows and No. of cols in each file.
        
        file_list <- if( "file_list.txt" %in% list.files("../")){ read.table
                                (as.character("../file_list.txt"), sep =",");} 
                        else{investigate_files();}
        
        ##      set up the variables from this file list to feed into the functions.
        
        column_names <- as.character(file_list[3,1]);
        key_word1 <- "mean()"; key_word2 <- "std()";
        
        table_body_file1 <- as.character(file_list[27,1]); table_body_file2 <- 
                                                        as.character(file_list[15,1]);
        
        activity_column1 <- as.character(file_list[28,1]); activity_column2 <- 
                                                        as.character(file_list[16,1]);
        activity_labels <- as.character(file_list[1,1]);
        subject_file1 <- as.character(file_list[26,1]); subject_file2 <- 
                                                        as.character(file_list[14,1]); 
        
        ##      work through the check list
        ##      1. merge files to make the body of the table

        table_body <- merge_set(table_body_file1, table_body_file2);
        
        ##      2. get the column titles and filter for our keywords and reformat them

        factor_labels <- find_wanted_cols(column_names, key_word1, key_word2);
        variables <- read.table(column_names)[,2];
        variables <-variables[factor_labels];
        variables <- sapply(variables, function(x) format_cols(x));        

        ##      3. reduce the table body to the wanted set only

        table_body <- table_body[factor_labels];

        ##      4. combine subject codes and the activity names and re-format
        
        row_codes <- merge_set(activity_column1, activity_column2);
        row_names <- add_labels(row_codes, activity_labels);

        subjects <- merge_set(subject_file1, subject_file2);
        row_data <- cbind(row_names, row_codes, subjects);
        colnames(row_data) <- c("activity", "activity.code", "subject");
        
        ##      5. bind everything together
        
        colnames(table_body) <- variables;
        full_table <- cbind(row_data, table_body);
        final_table <- as.data.frame(full_table);
        
        
        ##      6. Save table.txt to  parent of  working directory. 
        
        write.table(final_table, file = "../tidy.txt", quote = FALSE, sep = " ");
        write.table(head(final_table, 20)[, 1:30], quote = FALSE, sep = "");
        
        ## Generate table of the means of every variable by activity and subject. 
        
        # a. Set up the row headers an array of 180 rows and 2 columns . 
        # Column 1 activity codes 1 to 6 for 30 times, column 2 repeats subject 
        #                                                               codes 1:30 by six times. 
        # cbind the activities to the 180 x 2 array to get activity names. 
        
        act_codes <- 1:6; subj <- 1:30;
        num_cols <- unlist(lapply(act_codes, function(x) rep(x, length.out = length(subj))));
        active_col <- add_labels(num_cols, activity_labels);
        row_heads <- as.data.frame(cbind(active_col, as.numeric(num_cols), as.numeric(subj)));
        
        #name these three columns. 
        colnames(row_heads) <- c("activity", "activity.code", "subject");
        
        # begin work on the body of the means table by calling the 
        #                               data tables and the column names. 
        
        #      merge the data tables and reformat the columns. 
        
        means_cols <- read.table(column_names)[,2];
        means_cols <- sapply(means_cols, function(x) format_cols(x))
        
        means_body <- merge_set(table_body_file1, table_body_file2);
        

        means_cols <- sapply(means_cols, function(x) rename_means_cols(x));
        colnames(means_body) <- means_cols;
        
        means_body <- cbind(row_data, means_body);
        
        #subset the body of the table by activity code and then by user 
        #                               and generate the mean of each column
        
        means_table <- apply(row_heads, 1, function(x) get_means(means_body,
                                                x["activity.code"], x["subject"]));
        
        # reshape the resulting table and bind with the row_headers 
        #               (the three columns created at the beginning. )
        means_table <- t(means_table);
        means_table <- cbind(row_heads, means_table);
        # save down the file. 
        
        write.table(means_table, file = "../tidy_means.txt", quote = FALSE, sep = " ");
        
        write.table(head(means_table, 15)[1:15], file = "../segment_tidy_means.txt", 
                                                        quote = FALSE, sep = " ");
        

        ################         FUNCTIONS BEGIN HERE ################################
        
        investigate_files <- function(dir = ".") 
                
                # opens files and gets dimensions ncol and nrow of each file 
                {
                file_list <- list.files(dir, recursive = TRUE)
                files <- lapply(file_list, function(x) paste("./", x, sep = "", 
                                                                collapse = "/"))
                rows <- lapply(files, function(x) length(readLines(x)));
                cols <- lapply(files, function(x) ncol(read.table(x, nrows=1)));
                files <- unlist(files); rows <- unlist(rows); cols <- unlist(cols);
                description <- cbind(files, rows, cols);
                description <- as.data.frame(description);
                
                colnames(description) <- c("Files", "Rows", "Columns");

                write.table(description, "../file_list.txt", quote = FALSE, sep = ",");
                return(description);
        
                }
        
        merge_set <- function(x,y)
                # merges tables.
                {
                file_1 <- read.table(x, nrows =-1);
                merged_set <- rbind(file_1, read.table(y));
                return(merged_set);
                }
        
        find_wanted_cols <- function(file, key1, key2)
                #finds the columns we want for the main return table
                {
                array <- read.table(file)[,2];
                want_cols <- sapply(array, function(x) (key1 %in% unlist(strsplit
                (as.character(x), "-"))) || (key2 %in% unlist(strsplit(as.character(x), "-"))));
                
                return(which(want_cols))
                }

        add_labels <- function(y,z)
                # Adds activity name labels to rows
                {
                row_names <- y;
                act_labels <- read.table(as.character(z));
                act_labels2 <- sapply(act_labels[,2], function(x) format_act_labels(x));
                final_labels <- sapply(row_names, function(x) act_labels2[x]);
                return(final_labels);
        
                }

        format_act_labels <- function(x)
                # Helper function to put activity labels in lower case.
                
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


        format_cols <- function(x)
                ## strips apart column names, removes parenthesis and adds a dot 
                        #                               instead of a capital letter. 
                {
                start <- unlist(strsplit(as.character(x), "-"));
                start <- unlist(lapply(start, function(x) gsub("\\()$", "", x)));
                start_a <- start[2:length(start)]; 
                start_b <- unlist(lapply(start_a, function(x) paste(toupper(substring(x,1,1)), 
                                                        substring(x,2), sep = "", collapse = "")));
                 start <- c(start[1], start_b);
                start <- paste(start, sep = " ", collapse = "");
                next_step <- unlist(strsplit(start, ""))
                

                replace_caps <- function(x){ if (x %in% LETTERS){x <- paste(".", 
                                                        tolower(x), sep = "", collapse = "")}
                                             else{x}}

                final <- paste(sapply(next_step, replace_caps), sep = "", collapse = "");
                
                return(final);
                }

        

        
        get_means <- function(frame, x, y)
                # basic colMeans function on the data portion of the main table.
                {
                subset <- subset(frame, activity.code == x & subject == y, drop = TRUE); 
                return(colMeans(subset[,4:ncol(frame)]));
                }
        rename_means_cols <- function(x)
                {
                return(paste("mean.", x, sep = "", collapse = ""));
                
                }
        write.table(head(final_table, 15)[1:15], file = "../segment_tidy.txt", 
                                                                quote = FALSE, sep = " ");
        return(head(final_table, 15)[1:15]);
        }
