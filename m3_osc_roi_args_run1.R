#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

#set up workspace, load packages 
setwd("/path/to/save_dir")
require("rjags")

#loads run 1 observed data and design (run design_matrix.R first to get convolved design matrix)
print("Preparing model input...")
load("run1_input.RData")

#declare jags model (as .txt)
model.3 = "  
model{

#Likelihood: predict neural
for(j in 1:numS){
for (i in 1:lenN) {
N[i,j] ~ dnorm(muN[i,j], sigma[j])
Npred[i,j] ~ dnorm(muN[i,j], sigma[j])
muN[i,j] = beta0[j] + inprod(beta[1:lenS ,j], X[i,,j])
}}

# Priors

# intercept hyperparameter
mu0 ~ dnorm(0, 0.001)

# subject level noise (sigma) and intercept beta0
for(j in 1:numS){
sigma[j] ~ dgamma(.001, .001)
beta0[j] ~ dnorm(mu0, 0.001)
}

# subject level neural activity for conditions
for(j in 1:numS){
for (i in 1:numCond){
delta[i,j] ~ dnorm(mu[i], 0.001)
}}

# group level neural activity for conditions
for(i in 1:numCond){
mu[i] ~ dnorm(0, 0.001)
}

# trial by trial noise
sigmabeta~ dgamma(0.001,0.001)

# single trial neural activity
for(j in 1:numS){
for (k in 1:lenS){
beta[k,j] ~ dnorm(delta[cond[k,j],j], sigmabeta)
}}

}
"

# prepare data to load into JAGS 
roi=as.numeric(args[1]); #read in what's next in the bash command. can be a number between 1 to 20
lenN=nrow(N[[roi]]) #length of neural data 
numS=ncol(N[[roi]]) #number of subjects

lenS=nrow(cond) #number of trials
numCond=length(unique(as.factor(cond))) #number of different conditions

cond_num=matrix(as.double(as.factor(cond)),dim(cond)) #set condition matrix to numeric
cond_num_key=levels(as.factor(cond)) #labels for each number

# change NaNs in N to NA
N[[roi]][which(is.nan(N[[roi]]))]=NA

# put all of the data we'll put into the model as a list
dat_m3 = list(N = N[[roi]], lenN = lenN, numS = numS, X=DesignMatrix, lenS = lenS, cond=cond_num, numCond=numCond)

#initialize JAGS model
model_m3 = jags.model(textConnection(model.3), data = dat_m3, n.chains = 3, n.adapt = 2000)


print("Burn in...")
update(model_m3, n.iter = 4000, progress.bar = "text")

print("Posterior sampling...")
#Posterior sampling
m3_out = coda.samples(model = model_m3, variable.names = c("delta","beta","mu","Npred","sigma","sigmabeta","muN","mu0","beta0"), n.iter = 6000)

post.samples = function(out){
  n.chains = length(out)
  nrow = nrow(out[[1]])
  ncol = ncol(out[[1]])
  post = array(NA, c(nrow, ncol, n.chains))
  for (i in 1:n.chains){
    post[,,i] = out[[i]]
  }
  colnames(post) = colnames(out[[1]])
  return(post)
}

post = post.samples(m3_out)

print("Saving data...")

setwd("/path/to/save_dir/m3")

save(file=paste(c("run1_output_roi",args[1], "_redo_090822.RData"),sep="",collapse=""),post,cond_num,cond_num_key,m3_out)



