# HBM-stimulus-level-fMRI

**Step 1: Data Prep**
A) Create 3 design matrixes: onset time, duraction, or condition
        rows = trial/event
      	columns = subject

B) Extract timeseries from each region of interest

C) Organize timeseries: 
    rows = TR
    columns = subject

**Step 2: Convolve design matrix with neural data**
A) Install JAGS: https://sourceforge.net/projects/mcmc-jags/
    Helpful guide: https://onlinelibrary.wiley.com/doi/pdf/10.1002/9781119287995.app1 

B) Update the paths in the R script for your data:
      •	cond_path = design matrix including condition for each trial by subject (Step 1A)
      •	dur_path = design matrix including duration of each trial by subject (Step 1A)
      •	onset_path = design matrix including onset time for each trial by subject (Step 1A)
      •	N_path = design matrix including timeseries data for each TR by subject (Step 1C) 
      •	save path

C) Download this repository

D) Run:
   design_matrix_feedback_run1.R
   *NOTE: This takes about 50 minutes


**Step 3: Run hierarchical bayesian model (HBM)**
A) Update the paths in the R script for your data:
    •	load path
    •	output path
B) Run:
   m3_osc_roi_args_feedback_run1.R
   *NOTE: This takes about 2 hours for each ROI, so we suggest looping through subjects using SLURM/BATCH.
![image](https://github.com/z-lab-osu/HBM-stimulus-level-fMRI/assets/139483246/715678c5-a7ff-4771-a827-6585fde24d85)
