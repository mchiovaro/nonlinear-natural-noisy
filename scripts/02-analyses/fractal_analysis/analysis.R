####### Detrended Fluctuation Analysis #######
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

# load the required libraries
library(dplyr)
library(ggplot2)
library(nonlinearTseries)

# Reading in fractal data
data = read.csv('./data/fractal_data.csv', 
                sep=",")

#======================================
##### Turn duration analysis (td) #####
#======================================

# calculate DFA
dfa_results_td = nonlinearTseries::dfa(data$turn_duration,
                                       window.size.range = c(10,floor(length(data$turn_duration)/2)))

# get H value
observed_H_td = unname(lm(log(dfa_results_td$fluctuation.function) ~ log(dfa_results_td$window.sizes))$coefficients[2])

# calculate td DFA and save plot
png(filename='./results/fractal/full/dfa_td_plot.png', 
    height=1600, width=1600, res=400)
estimate(dfa_results_td, do.plot = TRUE,
         add.legend=F, main="DFA on Turn Duration\n(Full)")
dev.off()

# save results
dfa_td_frame = data.frame(observed_H = observed_H_td)
write.table(dfa_td_frame,'./results/fractal/full/dfa_td_frame.csv',
            sep=",", row.names=FALSE)

#==============================================
##### Inter-onset-interval analysis (ioi) #####
#==============================================

# trim off first row because of NA value from ioi calculcation
data_ioi <- data %>% na.omit() %>% .$inter_onset_intervals

# calculate DFA
dfa_results_ioi = nonlinearTseries::dfa(data_ioi,
                                        window.size.range = c(10,floor(length(data_ioi)/2)))


# calculate ioi DFA and save plot
png(filename='./results/fractal/full/dfa_ioi_plot.png', 
    height=1600, width=1600, res=400)
estimate(dfa_results_ioi, do.plot = TRUE,
         add.legend=F, main="DFA on Inter-Onset-Intervals\n(Full)")
dev.off()

# get H value
observed_H_ioi = unname(lm(log(dfa_results_ioi$fluctuation.function) ~ log(dfa_results_ioi$window.sizes))$coefficients[2])

# save results
dfa_ioi_frame = data.frame(observed_H = observed_H_ioi)
write.table(dfa_ioi_frame,'./results/fractal/full/dfa_ioi_frame.csv',
            sep=",", row.names=FALSE)