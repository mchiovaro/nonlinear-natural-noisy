##### Ideas Lab Project: Required Packages #####

# list of required packages as strings
required_packages = c(
  'dplyr',
  'ggplot2',
  'tseriesChaos',
  'nonlinearTseries',
  'crqa',
  'fractal',
  'tidyr',
  'purrr',
  'tidyverse',
  'rPraat',
  'tuneR'
)

# install missing packages (adapted from <http://stackoverflow.com/a/4090208>)
missing_packages = required_packages[!(required_packages %in% installed.packages()[,"Package"])]
if (length(missing_packages) > 0) {
  install.packages(missing_packages, repos='http://cran.us.r-project.org')
}


