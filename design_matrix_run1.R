#load packages
#install.packages('R.matlab')
library('R.matlab')

#load mat files
cond_path="path/to/condition_matrix.mat"
cond_mat=readMat(cond_path)

cond=matrix(unlist(cond_mat$cond.run1),dim(cond_mat$cond.run1))

#load durations
dur_path="path/to/duration_matrix.mat"
dur_mat=readMat(dur_path)

dur=matrix(unlist(dur_mat$dur.run1),dim(dur_mat$dur.run1))

#load onsets
onset_path="path/to/onset_matrix.mat"
onset_mat=readMat(onset_path)

onset=matrix(unlist(onset_mat$onset.run1),dim(onset_mat$onset.run1))
onset=matrix(as.numeric(onset),dim(onset))


#load neural data
N_path="path/to/timeseries_matrix.mat"
N_mat=readMat(N_path)

N_all=N_mat$timeseries

#temp=N_all[1,1,1]$run1[,1]
temp=N_all[1,1,5]$run1[,1]   # third dimension should be a subject with the highest TR for the sublish 
N_temp=matrix(NA,length(temp),ncol(onset))
N=vector(mode='list', length=20)

for(roi in 1:20){
  N[[roi]]=N_temp
for (s in 1:ncol(onset)){
  N[[roi]][1:length(N_all[1,1,s]$run1[,roi]),s]=N_all[1,1,s]$run1[,roi]
}
}

setwd("/path/to/rscripts")
source("hrf_functions.R")

DesignMatrix=array(NA,c(length(N[[1]][,1]),nrow(onset),ncol(onset)))
for(s in 1:ncol(onset)){
  DesignMatrix[,,s] = sapply(X = onset[,s],FUN=hrf.conv, duration = dur[,s], measurement = length(N[[1]][,1]), TR = 1, resolution = 0.01)
  print(s)
}

setwd("/path/to/save_dir")

save(file="run1_input.RData",cond,dur,onset,N,DesignMatrix)
