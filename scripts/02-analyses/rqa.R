##### Categorical Recurrence Quantification Analysis #####
#
# Code by: M. Chiovaro and A. Paxton
# University of Connecticut
#
# Accompanying manuscript:
# "Nonlinear, Natural, and Noisy: A Quantitative Approach to
# the Collection and Analysis of Real-World Social Behavior"
#
##### Last updated: Jan. 27, 2020 #####

#================
##### Setup #####
#================

# set working directory
setwd("./nonlinear-natural-noisy/")

# check that we have needed libraries
source('./scripts/required_packages-nonlinear_natural_noisy.R')

# load libraries
library(dplyr)
library(crqa) 
library(ggplot2) 

# Reading in data and keep only the time series
sound_data = read.table('./data/formatted/sound_data.txt', 
                        sep="\t",
                        header = TRUE) %>% .$V2

# Plot the time series 
TS <- qplot(sound_data,
      x=seq_along(sound_data), geom="point") +
      geom_path() +
      theme(legend.position="none", 
            axis.text.x = element_blank(),
            axis.text.y = element_blank()) +
      xlab("Time (ms)") + ylab("Sound state") +
      ggtitle("On-Off Sound Signal")

# save the TS plot
ggsave(TS, file = "./results/rqa/time_series_rqa.png")

#==========================
##### Categorical RQA #####
#==========================

##### Recurrence parameter setting #####

# decide Theiler window (tw) parameter
# for categorical RQA, a tw of 1 will remove the line of 
# identity from the analysis
theiler_window = 1

# set radius to be very small for categorical matches
rec_categorical_radius = .0001

##### Run RQA #####

# run cross recurrence over each
# to run locally, set the sample span to be 5k or less
cross_recurrence_analysis = crqa(ts1=sound_data[1:5000],
                                 ts2=sound_data[1:5000],
                                 delay=0,
                                 embed=1,
                                 rescale=0,
                                 radius=rec_categorical_radius,
                                 normalize=0,
                                 mindiagline=2,
                                 minvertline=2,
                                 tw=theiler_window)

# save the crqa results
rqa_results <- data.frame(c(cross_recurrence_analysis[1:9]))
write.table(rqa_results,'./results/rqa/rqa_results.csv',
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
png(filename='./results/rqa/CRP_rqa.png')
plot(cross_recurrence_analysis$RP@i,
  type='p',cex=.05, xlab = "On/Off Time Series", ylab="On/Off Time Series")
dev.off()
