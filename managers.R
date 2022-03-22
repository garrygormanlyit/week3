# This script builds the managers dataset
# and populates it with data

# Load data from previous session
column_names <- c("Date", "Country", "Gender", "Age", "Q1", "Q2", "Q3", "Q4", "Q5")

# Enter data into vectors before constructing the data frame
date_col <- c("2018-15-10", "2018-01-11", "2018-21-10", "2018-28-10", "2018-01-05")
country_col <- c("US", "US", "IRL", "IRL", "IRL")
gender_col <- c("M", "F", "F", "M", "F")
age_col <- c(32, 45, 25, 39, 99) # 99 is one of the values in the age attribute - will require recoding
q1_col <- c(5, 3, 3, 3, 2)
q2_col <- c(4, 5, 5, 3, 2)
q3_col <- c(5, 2, 5, 4, 1)
q4_col <- c(5, 5, 5, NA, 2) # NA is inserted in place of the missing data for this attribute
q5_col <- c(5, 5, 2, NA, 1)

# Construct a data frame using the data from all vectors above
managers <- data.frame(date_col, country_col, gender_col, age_col, q1_col, q2_col, q3_col, q4_col, q5_col)

# Add column names to data frame using column_names vector
colnames(managers) <- column_names

# Recode the incorrect 'age' data to NA
managers$Age[managers$Age == 99] <- NA

# Create a new attribute called AgeCat and set valuess
# in AgeCat to the following if true:
# <= 25 = Young
# >= 26 & <= 44 = Middle Aged
# >= 45 = Elderly
# We will also recode age 'NA' to Elder

managers$AgeCat[managers$Age >= 45] <- "Elder"
managers$AgeCat[managers$Age >= 26 & managers$Age <= 44] <- "Middle Aged"
managers$AgeCat[managers$Age <= 25] <- "Young"
managers$AgeCat[is.na(managers$Age)] <- "Elder"

managers
str(managers) # also prints the datatypes
summary(managers) # gives a summary of the data. max, min, mean, median, mode, NAs, datatypes, 1st and 3rd quartile

# recode ageCat to make it ordinaled and factored. makes young = 1, middle aged = 2, elder = 3.
agecat <- factor(managers$AgeCat, 
                 order=TRUE,
                 levels = c("Young", "Middle Aged", "Elder"))

# replace managers AgeCat with newly factored variable
managers$AgeCat <- agecat
managers
str(managers) # we can see that young, middle aged and elder is still there but is 1,2,3 in the background

# create new column called summary_col that contains a summary of each row.
# create a vector of the sum of Q1 to Q3 in each row
#summary_col <- managers$Q1 + managers$Q2 + managers$Q3 + managers$Q4 + managers$Q5

attach(managers)
summary_col <- Q1 + Q2 + Q3 + Q4 + Q5
detach(managers)
summary_col

managers$summaryCol <- summary_col
managers

# create a new dataframe that adds summary_col onto the managers dataframe
managers <- data.frame(managerst, summary_col)

# create a new column called mean_value to contain means of the answers
# rowMeans()
# gets the values in columns 5 to 9, calculates the mean, assign to mean_value as a vector
mean_value <- rowMeans(managers[5:9])
mean_value

# create a new column in DF managers called Mean_Value. Put the values in mean_value in that column
managers$Mean_Value <- mean_value
managers

# change the column names from summaryCol to Summary
# names(manager) is a vector containing all the column names
names(managers)[11] <- "Summary"
names(managers)[12] <- "Mean"
managers

str(managers)

# convert date to a useful date type
dates <- managers$Date # gets values from Dates column
#                       match this with the chr date
dates <- as.Date(dates, "%Y-%d-%m") # convert to dates
dates

managers$Date <- dates # replace existing dates column with new real dates
managers