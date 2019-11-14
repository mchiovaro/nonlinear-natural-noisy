####### Prepping data for fractal analysis (DFA) #######
#
# This code stems from the presentation: "Nonlinear, 
# Natural, and Noisy: A Quantitative Approach to the 
# Collection and Analysis of Real-World Social Behavior"
#
# Presented at the 49th Annual Meeting of the Society for
# Computers in Psychology (SCiP) (Montréal, Québec, Canada)
# 
# By: M. Chiovaro (@mchiovaro) and A. Paxton (@a-paxton)
# Univeristy of Connecticut

# set working directory
setwd("./nonlinear-natural-noisy/")

# check that we have needed libraries
source('./scripts/required_packages.R')

# load the required libraries
library(dplyr)

# read in the dataset and keep only the onset times
fractal_df = read.table('./data/data.txt', sep="\t") %>%

  # rename variables
  dplyr::rename(onset = V1,
                  offset = V2) %>%

  # remove index
  dplyr::select(-V3) %>%

  # create inter-onset intervals
  mutate(inter_onset_intervals = onset - dplyr::lag(onset, 1)) %>%

  # create turn duration
  mutate(turn_duration = offset-onset)

# write to file
write.table(x = fractal_df,
            file='data/fractal_data.csv',
            sep=",",
            col.names=TRUE,
            row.names=FALSE)

##### truncating data for comparison to crqa #####

# truncate top to 25kth sample
fractal_trunc <- fractal_df[c(1:583),]

# replace last end time with timestamp of crqa at 25000th sample
fractal_trunc[583,2] <- 2496.4

# calculate new turn_duration for last observation
fractal_trunc[583,4] <- fractal_trunc[583, 2]-fractal_trunc[583, 1]

# write truncated data to file
write.table(x = fractal_trunc,
            file='data/fractal_data_trunc.csv',
            sep=",",
            col.names=TRUE,
            row.names=FALSE)
