# HBM-stimulus-level-fMRI

## Step 1: Data Prep

### A) Define 3 matrices corresponding to the onset time, duration, and condition of the experimental stimuli

#### .mat structure:
- rows = stimulus (i.e., trial/event)
- columns = subject

### B) Extract timeseries from each region of interest (ROI) & merge all subjects' runs into one file: 

#### .mat structure:
- First level:
  - row = subject
  - columns = run
- Second level (within each subject for each run):
  - rows = TR
  - columns = ROI

## Step 2: Convolve design matrix with neural data

*Code adapted with permission from Molloy et al., 2018.*

### A) Install dependencies:

#### JAGS: https://sourceforge.net/projects/mcmc-jags/

- Helpful guide: https://onlinelibrary.wiley.com/doi/pdf/10.1002/9781119287995.app1 

#### Load JAGS and R:

        module load jags

        module load R	

#### Install R packages: 

        install.packages("R.matlab")

        install.packages("rjags")

### B) Clone this repository

### C) Update the paths in `design_matrix_run1.R` for your data:

- cond_path = matrix including condition for each trial by subject (Step 1A)
- dur_path = matrix including duration of each trial by subject (Step 1A)
- onset_path = matrix including onset time for each trial by subject (Step 1A)
- N_path = matrix including timeseries data for each TR by subject (Step 1B) 
- save path

**NOTE*: The script is currently set up as if all matrices created in Step 1 were generated in matlab and saved as .mat files. If you saved the matrices as a different file type, you will need to update the readMat commands in lines 7, 13, 19, and 27 to commands appropriate for your file type.

### D) Run:

        [path]/design_matrix_run1.R

**NOTE*: This takes about 50 minutes (computing environment: Ohio Supercomputer).


## Step 3: Run hierarchical bayesian model (HBM)

*Code adapted with permission from Molloy et al., 2018.*

### A) Update the paths in `m3_osc_roi_args_run1.R` for your data:
- load path
- output path

### B) Run:
        
        [path]/m3_osc_roi_args_run1.R [ROI number]

**NOTE*: This takes about 2 hours for each ROI (computing environment: Ohio Supercomputer), so we suggest looping through ROIs using SLURM/BATCH.

e.g.,

                for ROI in {1..20}
                do
                ssub -c "Rscript [path]/m3_osc_roi_args.R $ROI" -A [account] -t 3:00:00 -m 28
                done

## References:

Molloy, M. F., Bahg, G., Li, X., Steyvers, M., Lu, Z. L., & Turner, B. M. (2018). Hierarchical Bayesian analyses for modeling BOLD time series data. Computational Brain & Behavior, 1, 184-213.
