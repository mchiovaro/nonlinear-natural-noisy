##### Reformatting Data for DFA #####
#
# Code by: M. Chiovaro and A. Paxton
# University of Connecticut
#
# Accompanying manuscript:
# "Nonlinear, Natural, and Noisy: A Quantitative Approach to
# the Collection and Analysis of Real-World Social Behavior"
#
##### Last updated: Jan. 21, 2020 #####

# To conduct DFA, data must be formatted as a series of bins.
# This script will help tranform raw sound-marker data into
# the appropriate format.

# set working directory
setwd("./nonlinear-natural-noisy/")

# check that we have needed libraries installed
source('./scripts/required_packages-nonlinear_natural_noisy.R')

# load the required packages
library(dplyr)
library(purrr)

#### Formatting Sound Coding Data ####

# read in sound marker data
fractal_sound_data = read.table('./data/raw/',
                                sep="\t") %>%

  # rename variables to be more intuitive
  dplyr::rename(onset = V1,
                  offset = V2) %>%

  # remove unnecessary index
  dplyr::select(-V3) %>%

  # create inter-onset intervals
  mutate(inter_onset_intervals = onset - dplyr::lag(onset, 1)) %>%

  # create turn duration
  mutate(turn_duration = offset-onset)

# write full data to file
write.table(x = fractal_sound_data,
            file='./data/formatted/fractal_sound_data',
            sep=",",
            col.names=TRUE,
            row.names=FALSE)

### truncating data for comparison to rqa ##
# (25,000 sample maximum for rqa)

# add 2499.9 sec to beginning time
# (for 25,000th sample value in rqa data)
end_time <- fractal_sound_data[c(1),1] + 2499.9

# create a function that finds the row just after the 25,000th sample value
just_greater <- function(x) x > end_time

# using the function above, find the row just greater and subtract 1
cut_off <- detect_index(fractal_sound_data$onset, just_greater)
cut_off = cut_off - 1

# truncate to that row
fractal_sound_trunc <- fractal_sound_data[c(1:cut_off),]

# check to see if the 25,000th sample fell within a sound duration
# and adjust accordingly
if (fractal_sound_trunc[cut_off, 2] >= end_time) {

  # update end time
  fractal_sound_trunc[cut_off,2] <- end_time

  # calculate new turn_duration for last observation
  fractal_sound_trunc[cut_off,4] <- fractal_sound_trunc[cut_off, 2]-fractal_sound_trunc[cut_off, 1]

}

# write truncated data to file
write.table(x = fractal_sound_trunc,
            file='./data/formatted/fractal_sound_trunc',
            sep=",",
            col.names=TRUE,
            row.names=FALSE)

#### Formatting Task Coding Data ####

# read in task coded data
fractal_task_data = read.table('./data/formatted_data/',
                               sep=",", header= TRUE)  %>%
  rename(task_coding = state.1) # for late data only

# find consequctive values
fractal_task_data = rle(fractal_task_data$task_coding) %>%
  unclass() %>%

  # turn data into a .csv
  as.data.frame() %>%

  # create the start and end values based on row
  mutate(offset = cumsum(lengths),
         onset = c(1, dplyr::lag(offset)[-1] + 1)) %>%

  # reorder rows for easier reading
  magrittr::extract(c(1,2,4,3)) %>%

  # turn start #s into time
  mutate(onset = onset *.1) %>%

  # turn end #s into time
  mutate(offset = offset *.1)  %>%

  # create inter-onset intervals
  mutate(inter_onset_intervals = onset - dplyr::lag(onset, 1)) %>%

  # create turn duration
  mutate(turn_duration = offset-onset)

# write full data to file
write.table(x = fractal_task_data,
            file='./data/formatted/fractal_task_data',
            sep=",",
            col.names=TRUE,
            row.names=FALSE)

### Truncating data for comparison to rqa ##
# (25,000 sample maximum for rqa)

# add 2499.9 sec to beginning time
# (to get 25,000th sample value in rqa data)
end_time <- fractal_task_data[c(1),1] + 2499.9

# create function to find the row just after end_time
just_greater <- function(x) x > end_time

# using the function above, find the row just greater and subtract 1
cut_off <- detect_index(fractal_task_data$onset, just_greater)
cut_off = cut_off - 1

# truncate to that row
fractal_task_trunc <- fractal_task_data[c(1:cut_off),]

# check if the 25,000th sample fell in a sound duration
# and adjust accordingly
if (fractal_task_trunc[cut_off, 2] >= end_time) {

  # update end time
  fractal_task_trunc[cut_off,2] <- end_time

  # calculate new turn_duration for last observation
  fractal_task_trunc[cut_off,4] <- fractal_task_trunc[cut_off, 2]-fractal_task_trunc[cut_off, 1]

}

# write truncated data to file
write.table(x = fractal_task_trunc,
            file='./data/formatted/fractal_task_trunc.csv',
            sep=",",
            col.names=TRUE,
            row.names=FALSE)
