####### Prepping data for categorical RQA #######
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
library(tidyr)

# read in sound data
sound_interv = read.table('./data/data.txt',
                          sep="\t") %>%

  # rename variables as needed
  rename(start = V1,
         end = V2,
         t = V3) %>%

  # gather to two columns (state and time)
  tidyr::gather(key="event",
                value = "t",
                -t) %>%

  # round time to nearest tenth of a second
  mutate(t = round(t, 1)) %>%
  arrange(t) %>%

  # specify that we're only dealing with sound-on
  mutate(state = dplyr::if_else(event=="start",
                                1,
                                2))

# create a list of all possible times
all_times = data.frame(t = seq(from=0,
                               to=max(sound_interv$t),
                               by=.1))

# join all possible times with sound interval markers
sound_data = full_join(all_times,
                             sound_interv,
                             by='t') %>%
  # fill in sound markers
  fill(state) %>%
  mutate(state = dplyr::if_else(event == "end" & state==2,
                                1,
                                state))

# replace silence with something unique and write to file
sound_data_original = sound_data %>%
  replace_na(list(state=99))
sound_data_original <- sound_data_original[,c(1,3)]
write.table(sound_data_original,
            "./data/sound_data.txt",
            sep="\t",row.names=FALSE)

## to investigate only recurring "sound-on" states, we need a
## contrast file so that shared silent states aren't 
## considered recurrent
# replace silence with something else and write too file
sound_data_contrast = sound_data %>%
  replace_na(list(state=-99))
sound_data_contrast <- sound_data_contrast[,c(1,3)]
write.table(sound_data_contrast,
            "./data/sound_data_contrast.txt",
            sep="\t",row.names=FALSE)

