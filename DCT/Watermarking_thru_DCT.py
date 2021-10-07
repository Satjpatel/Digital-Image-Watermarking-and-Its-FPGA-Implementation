# -*- coding: utf-8 -*-
"""
Created on Tue Oct  5 16:41:54 2021

@author: Sat Patel
"""

# Libraries Used 

import cv2 as cv 
import scipy.fft as spfft 
import numpy as np
import matplotlib.pyplot as plotty 



# Functions to be used 
# 1. 2D Discrete Cosine Transform
def dct2D(a):
    return spfft.dct(spfft.dct(a.T, norm='backward').T, norm='backward')
# 2. 2D Inverse Discrete Cosine Transform
def idct2D(a):
    return spfft.idct(spfft.idct(a.T, norm='backward').T, norm='backward')

# Reading the img and watermark 
