####### Detrended Fluctuation Analysis #######
#
# To compare results with categorical RQA and test general
# robustness, we re-ran the analyses on the fractal 
# time-series truncated to 25k samples.
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

# install and load needed packages
library(dplyr)
library(ggplot2)
library(nonlinearTseries)

# Reading in fractal data
data_trunc = read.csv('./data/fractal_data_trunc.csv', sep=",")

#==============================================
##        Turn duration analysis (td)        ##
#==============================================

# calculate td DFA
dfa_results_td_trunc = nonlinearTseries::dfa(data_trunc$turn_duration,
                                             window.size.range = c(10,floor(length(data_trunc$turn_duration)/2)),
                                             do.plot=FALSE,
                                             add.legend = TRUE)

# get H value
observed_H_td_trunc = unname(lm(log(dfa_results_td_trunc$fluctuation.function) ~ log(dfa_results_td_trunc$window.sizes))$coefficients[2])

# save plot
png(filename='./results/fractal/trunc/dfa_td_trunc_plot.png', 
    height=1600, width=1600, res=400)
estimate(dfa_results_td_trunc, do.plot = TRUE,
         add.legend=F, main="DFA on Turn Duration\n(Truncated)")
dev.off()

# save results
dfa_td_frame = data.frame(observed_H = observed_H_td_trunc)
write.table(dfa_td_frame,'./results/fractal/trunc/dfa_td_trunc_frame.csv',
            sep=",", row.names=FALSE)

#==============================================
##    Inter-onset-interval analysis (ioi)    ##
#==============================================

# trim off first row because of NA value from ioi calculcation
data_ioi_trunc <- data_trunc %>% na.omit() %>% .$inter_onset_intervals

# calculate ioi DFA and save plot
dfa_results_ioi_trunc = nonlinearTseries::dfa(data_ioi_trunc,
                                              window.size.range = c(10,floor(length(data_ioi_trunc)/2)))

# get H value
observed_H_ioi_trunc = unname(lm(log(dfa_results_ioi_trunc$fluctuation.function) ~ log(dfa_results_ioi_trunc$window.sizes))$coefficients[2])

# save plot
png(filename='./results/fractal/trunc/dfa_ioi_trunc_plot.png', 
    height=1600, width=1600, res=400)
estimate(dfa_results_ioi_trunc, do.plot = TRUE,
         add.legend=F, main="DFA on Inter-Onset-Intervals\n(Truncated)")
dev.off()

# save results
dfa_ioi_frame = data.frame(observed_H = observed_H_ioi_trunc)
write.table(dfa_ioi_frame,'./results/fractal/trunc/dfa_ioi_trunc_frame.csv',
            sep=",", row.names=FALSE)