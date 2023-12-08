# HBM-stimulus-level-fMRI

## Step 1: Data Prep

### A) Create 3 design matrixes: onset time, duration, or condition

rows = trial/event

columns = subject



### B) Extract timeseries from each region of interest (ROI) & merge all subjects into one file: 

rows = TR

columns = subject

## Step 2: Convolve design matrix with neural data

### A) Install JAGS: https://sourceforge.net/projects/mcmc-jags/

Helpful guide: https://onlinelibrary.wiley.com/doi/pdf/10.1002/9781119287995.app1 

### B) Download this repository

### C) Update the paths in design_matrix_run1.R for your data:

• cond_path = design matrix including condition for each trial by subject (Step 1A)

• dur_path = design matrix including duration of each trial by subject (Step 1A)

• onset_path = design matrix including onset time for each trial by subject (Step 1A)

• N_path = design matrix including timeseries data for each TR by subject (Step 1B) 

• save path

**NOTE*: The script is currently set up as if all design matrixes created in Step 1 were generated in matlab and saved as .mat files. If you saved the design matrixes as a different file type, you will need to update the readMat commands in lines  7, 13, 19, and 27 to commands appropriate for your file type.

### D) Run:

        design_matrix_run1.R

**NOTE*: This takes about 50 minutes


## Step 3: Run hierarchical bayesian model (HBM)

### A) Update the paths in m3_osc_roi_args_run1.R for your data:

• load path

• output path

### B) Run:
        
        m3_osc_roi_args_run1.R [ROI number]

**NOTE*: This takes about 2 hours for each ROI, so we suggest looping through ROIs using SLURM/BATCH.

e.g.,

                for ROI in {1..20}
                do
                ssub -c "Rscript m3_osc_roi_args.R $ROI" -A [account] -t 3:00:00 -m 28
                done
