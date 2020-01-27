# A toolkit for nonlinear analyses

This repository contains the necessary code and tools to begin using categorical recurrence quantification analysis and fractal analysis (detrended fluctuation analysis).

Accompanying manuscript: Chiovaro, M., & Paxton, A. (*under review*). Nonlinear, Natural, and Noisy: A Quantitative Approach to the Collection and Analysis of Real-World Social Behavior.

Presented at: The 49th Annual Meeting of the Society for Computers in Psychology (SCiP) (Montréal, Québec, Canada)

## Using this repository
To get started using this repository, clone it and create the following subdirectories:
+ `./data/raw/`
+ `./data/formatted/`
+ `./results/rqa/`
+ `./results/dfa/`

## Data preparation

These analyses start with time-series of sound on-off markers in .txt format (generated using Audacity)

Load your sound-marker data into: `./data/raw/`

To get your data into the appropriate format, follow:
+ `./scripts/01-formatting-data/formatting_rqa.R`: for categorical recurrence quantification analysis.
+ `./scripts/01-formatting-data/formatting_dfa.R`: for generating "Inter-Onset Interval" and "Turn Duration" on full time-series and truncated (25k samples) data for fractal analysis (detrended fluctuation analysis, DFA).
These formatted data will be saved to `./data/formatted/`

## Analyses

To run the analyses, adapt:
+ `./scripts/02-analyses/catRQA/analysis.R`
+ `./scripts/02-analyses/fractal_analysis/analysis.R`

To compare fractal results with results of categorical RQA, we ran DFA on the truncated 25k sample using:
+ `./scripts/02-analyses/fractal_analysis/analysis_truncated.R`

All formatted data/images/results will be saved to:
+ `./results/rqa`
+ `./results/dfa`

## Open science = open conversation!

Feel free to submit a pull request to contribute!
