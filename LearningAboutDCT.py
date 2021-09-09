# -*- coding: utf-8 -*-
"""
Created on Thu Sep  9 11:36:44 2021

@author: HP
"""

# Learning how DCT actually works 

import matplotlib.pyplot as plt 
import numpy as np 
import scipy.fft as spfft

original_ts = np.array([0, 0.707, 1, 0.707, 0, -0.707, -1, -0.707])
L = len(original_ts) 
plt.plot(original_ts, "p") 
plt.title("Original Time Series of Lenght L = {}".format(L)) 

# Deriving the DCT co-effecients manually now 
def get_Xk(Xs,k):
    '''
    calculate the Fourier coefficient X_n of 
    Discrete Fourier Transform (DFT)
    '''
    L  = len(Xs)
    ns = np.arange(0,L,1)
    terms = 2*Xs*np.cos((np.pi*k*(1/2+ns))/L)
    terms[0]  *= np.sqrt(1/(4*L))
    terms[1:] *= np.sqrt(1/(2*L))
    xn = np.sum(terms)
    return(xn)


xs =[]
for n in range(L):
    x = get_Xk(original_ts,n)
    xs.append(x)
    print("DCT coefficient: x_{}={:+3.2f}".format(n,x))
    
# Our 7 Point signal is now in DCT Domain 

# Getting back our original time series signal 
    
def get_xn(xs,n):
    L = len(xs)
    ks = np.arange(1,L,1)
    out = 1/2*xs[0]
    out += np.sum(xs[1:]*np.cos(np.pi/L*ks*(n+1/2)))
    return(out*2/L)

def get_xn(Xs,n):
    '''
    calculate the Fourier coefficient X_n of 
    Discrete Fourier Transform (DFT)
    '''
    L  = len(Xs)
    ks = np.arange(0,L,1)
    terms = Xs*np.cos((np.pi*ks*(1/2+n))/L)*2
    terms[0]  *= np.sqrt(1/(4*L))
    terms[1:] *= np.sqrt(1/(2*L))
    xn = np.sum(terms)
    return(xn)


for n in range(L):
    Xn = get_xn(xs,n)
    print("Reproduced original series {:+5.3f}".format(Xn))
    
# Doing using just functions 

original_time = np.array([0, 0.707, 1, 0.707, 0, -0.707, -1, -0.707])
dct_domain = spfft.dct(original_time, type = 2, norm = "ortho")
idct_domain = spfft.idct(dct_domain, norm = "ortho") 
for n in range(len(original_time)):
    print("DCT coefficient using function: x_{}={:+3.2f}".format(n,dct_domain[n]))
    print("IDCT Coeffecient using function: x_{} = {:+3.3f}".format(n, idct_domain[n]))