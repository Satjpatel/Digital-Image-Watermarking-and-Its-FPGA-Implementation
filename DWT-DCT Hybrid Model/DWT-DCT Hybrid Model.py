# -*- coding: utf-8 -*-
"""
Created on Mon Sep 20 21:30:04 2021

@author: Sat Patel 
"""

""" 
Implementing a Hybrid Scheme of Image Watermarking of 
2 Stage DWT and 1 stage DCT
""" 

# Importing the important libraries 
import cv2 as cv 
import pywt 
import scipy.fft as spfft 
import numpy as np 
import matplotlib.pyplot as plotty 

# Transform Functions used 

# DWT Funtions 
# 2D Forward Discrete Wavelet Transform 
def dwt2D(a): 
    return pywt.wavedec2(a, 'db3', mode = 'symmetric', level = 2)

# 2D Inverse Discrete Wavelet Transform 
def idwt2D(a): 
    return pywt.waverec2(a, 'db3', mode = 'symmetric', level = 2)

# DCT Functions 
# 2D Forward Discrete Cosine Transform
def dct2D(a):
    return spfft.dct(spfft.dct(a.T, norm='ortho').T, norm='ortho')
# 2D Inverse Discrete Cosine Transform
def idct2D(a):
    return spfft.idct(spfft.idct(a.T, norm='ortho').T, norm='ortho')


# Reading and Displaying the Image to be watermark and the watermarking image 
img = cv.imread('Lenna.PNG', 0) 
watermark = cv.imread('discord.png',0)

plotty.subplot(2,1,1) 
cv.imshow('Lenna - Original Image', img) 
plotty.subplot(2,1,2) 
cv.imshow('Discord Logo -- Watermark to be Embedded', watermark) 
cv.waitKey(0) 

# Performing 2 Stage DWT on the Image Now 
[cA2, (cH2, cV2, cD2), (cH1, cV1, cD1)] = dwt2D(img)

# Our interest mainly lies with cH2
cv.imshow('cH2', cH2.astype(np.uint8))
cv.waitKey(0)