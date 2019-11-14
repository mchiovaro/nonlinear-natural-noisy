##### Categorical Recurrence Quantification Analysis #####
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

#================
##### Setup #####
#================

# set working directory
setwd("./nonlinear-natural-noisy/")

# check that we have needed libraries
source('./scripts/required_packages.R')

# load libraries
library(dplyr)
library(crqa) 
library(ggplot2) 

# Reading in data
sound_data = read.table('./data/sound_data.txt', 
                        sep="\t") %>% .$V2
sound_data_contrast = read.table('./data/sound_data_contrast.txt', 
                                 sep="\t") %>% .$V2

# Plot time-series (starting at 2 to remove the "state" label)
TS <- qplot(sound_data[2:length(sound_data)],
      x=seq_along(sound_data[2:length(sound_data)]), geom="point") +
      geom_path() +
      theme(legend.position="none", axis.text.x = element_blank(),
      axis.text.y = element_blank()) +
      xlab("Time (ms)") + ylab("Sound state") +
      ggtitle("On-Off Sound Signal")

# save the TS plot
ggsave(TS, file = "./results/catRQA/TS_catRQA.png")

#==========================
##### Categorical RQA #####
#==========================

##### Recurrence parameter setting #####

# decide Theiler window parameter
theiler_window = 0

# set radius to be very small for categorical matches
rec_categorical_radius = .0001

##### Run RQA #####

# run cross recurrence over each
# to run locally, set the sample span to be 5k or less
# always start after 2 to remove "state" label
cross_recurrence_analysis = crqa(ts1=sound_data[2:5001],
                                 ts2=sound_data[2:5001],
                                 delay=0,
                                 embed=1,
                                 rescale=0,
                                 radius=rec_categorical_radius,
                                 normalize=0,
                                 mindiagline=2,
                                 minvertline=2,
                                 tw=theiler_window)

# save the crqa results
catRQA_results <- data.frame(c(cross_recurrence_analysis[1:9]))
write.table(catRQA_results,'./results/catRQA/catRQA_results.csv',
            sep=",", row.names=FALSE)

##### Create the recurrence plot (CRP) #####

# convert cross-recurrence output into a dataframe for easier plotting
cross_rec_df = data.frame(points = cross_recurrence_analysis$RP@i,
                          loc = seq_along(cross_recurrence_analysis$RP@i))

# build the CRP
CRP <- ggplot(cross_rec_df,aes(x=points,
                        y=loc)) +
  geom_point(color="red",size=.0001) +
  theme_classic() +
  theme(legend.position="none", axis.text.x = element_blank(),
        axis.text.y = element_blank()) +
  ylab("Time (in ms)") +
  xlab("Time (in ms)") +
  ggtitle("Categorical cross-recurrence quantification
            analysis")

# use standard plot function to generate and save the recurrence plot
png(filename='./results/catRQA/CRP_catRQA.png')
plot(cross_recurrence_analysis$RP@i,
  type='p',cex=.05, xlab = "On/Off Time Series", ylab="On/Off Time Series")
dev.off()
