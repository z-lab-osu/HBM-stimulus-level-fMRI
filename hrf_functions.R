hrf = function(t.start , length = 30, resolution = 0.01){
   # Shape parameters: assumed to be fixed as used in SPM 12
   a1 = 6; a2 = 16; b1 = 1; b2 = 1; c = 1/6
  
   # t.start is the stimulus onset time
   # ts is the generated time vector (seconds)
   ts = seq(0, length , resolution) - t.start
  ts[ts<0] = 0
  
  # ys is the hemodynamic responses
   ys = ( ((ts^(a1-1) * b1^a1 * exp(-b1 * ts) )/gamma(a1) ) - c * (((ts^(a2 - 1) * b2^a2 * exp(-b2 * ts) )/gamma(a2))) )
  ys
}

 boxcar = function(length , t.start , t.end, resolution = 0.01){
   # the default resolution of the upsampled time series: 10msec
   if (length %% resolution != 0){
     print("length %% resolution must be zero")
     }
  else{
     # xs is the upsampled time vector
     # ts is the boxcar vector
    xs = seq(0, length , resolution)
     ts = rep(0, length(xs))
     ts[(xs >= t.start) & (xs <= t.end)] = 1
    
     # Return both outputs
     list(xs = xs, ts = ts)
  }
 }
 
 
 hrf.conv = function(t.start , duration , measurement , TR = 2, resolution =0.01){
    # Uses the functions 'hrf' and 'boxcar ' defined at Appendices A and B.
    # Measurement is the number of TRs
    # length is the total time for data acquisition in seconds
    # t.end is the stimulus offset time
    length = (measurement -1)*TR
    t.end = t.start + duration
   
    # Define the boxcar functions
    bc = boxcar(length , t.start , t.end, resolution)
    boxcars = bc$ts
   ts = bc$xs
    # Find the time that a stimulus is presented
    stim.on = ts[boxcars == 1]
   
    # Convolve the HRF with a boxcar function:
    # This part works for the procedure described in Figure 1,
    # but with a boxcar function that specifies the stimulus onset and duration.
    # (1) apply the 'hrf' function to all time points that the boxcar function returns 1.
   hrfs = sapply(stim.on, hrf, length=length)
    # (2) Sum the generated hemodynamic responses.
    conv = rowSums(hrfs)
    # (3) For boxcar convolution , scale the result
    if (duration != 0) {conv = conv / max(conv)}
   
    # Downsample the result
    temp.idx = which(ts%%TR == 0)
    
    ts.TR = ts[temp.idx]
     conv.hrfs.TR = conv[temp.idx]
    
     # Return the result
     res = conv.hrfs.TR
     res
    }
    
# test = sapply(X = c(4, 7, 12, 20),FUN=hrf.conv, duration = 0, measurement = 30,
# TR = 2, resolution = 0.01)
# test2 = sapply(X = c(4, 7, 12, 20),FUN=hrf.conv, duration = c(2,3,4,5), measurement = 30,
# TR = 2, resolution = 0.01)
# identical(test,test2)
# plot.ts(test)
# plot.ts(test2)

