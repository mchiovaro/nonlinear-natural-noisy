##### Reformatting Data for RQA #####
#
# Code by: M. Chiovaro and A. Paxton
# University of Connecticut
#
# Accompanying manuscript:
# "Nonlinear, Natural, and Noisy: A Quantitative Approach to
# the Collection and Analysis of Real-World Social Behavior"
#
##### Last updated: Jan. 21, 2020 #####

# To conduct RQA, data must be formatted as a series of 
# states. This script will help tranform raw sound-marker 
# data into the appropriate format.

# set working directory
setwd("./nonlinear-natural-noisy/")

# check that we have needed libraries installed
source('./scripts/required_packages-nonlinear_natural_noisy.R')

# load libraries
library(dplyr)
library(tidyr)

# read in sound marker data
sound_interv = read.table('./data/raw/',
                          sep="\t") %>%

  # rename variables to be more intuitive
  rename(start = V1,
         end = V2,
         t = V3) %>%

  # gather to two columns (event and time)
  tidyr::gather(key="event",
                value = "t",
                -t) %>%

  # round time to nearest tenth of a second (sampling rate)
  mutate(t = round(t, 1)) %>%

  # make time into a numeric variable and arrange order
  mutate(t = as.numeric(t)) %>%
  arrange(t) %>%

  # create categorical variables for event
  mutate(state = dplyr::if_else(event=="start",
                                1,
                                2))

# create list of all possible times (sound and silence)
all_times = data.frame(t = seq(from=min(sound_interv$t),
                               to=max(sound_interv$t),
                               by=.1)) %>%

  # round to nearest tenth of a second (sampling rate)
  mutate(t = round(t, 1))

# fill the all_times dataframe with actual data
rqa_data = full_join(all_times,
                             sound_interv,
                             by="t") %>%

  # make sure time is arranged correctly
  arrange(t) %>%

  # fill out the sound and silence moments
  fill(state) %>%
  mutate(state = dplyr::if_else(event == "end" & state==2,
                                1,
                                state)) %>%

  # slice to retain only the first timestamp for duplicates
  group_by(t) %>%
  slice(1) %>%
  ungroup()

# replace silence with another value
rqa_data = rqa_data %>%
  replace_na(list(state=99))

# keep only the needed columns
rqa_data <- rqa_data[,c(1,3)]

# save output
write.table(rqa_data,
            "./data/formatted/",
            sep="\t",row.names=FALSE)
