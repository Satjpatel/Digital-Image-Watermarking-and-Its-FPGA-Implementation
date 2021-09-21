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
    return pywt.waverec2(a, 'db3', mode = 'symmetric')

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

watermark_reshaped = np.reshape(watermark, (1, np.shape(watermark)[0]*np.shape(watermark)[0]))

plotty.subplot(2,1,1) 
cv.imshow('Lenna - Original Image', img) 
plotty.subplot(2,1,2) 
cv.imshow('Discord Logo -- Watermark to be Embedded', watermark) 
cv.waitKey(0) 
cv.destroyAllWindows()
# Performing 2 Stage DWT on the Image Now 
[cA2, (cH2, cV2, cD2), (cH1, cV1, cD1)] = dwt2D(img)

# Our interest mainly lies with cH2
cv.imshow('cH2', cH2.astype(np.uint8))
cv.waitKey(0)
cv.destroyAllWindows()


# Performing DCT on this block now 
# First, we will make sure the image can be broken into 8x8 blocks 

rows_to_add    = 8 - ((np.shape(cH2)[0]))%8 
columns_to_add = 8 - ((np.shape(cH2)[1]))%8 

padded_cH2 = np.zeros((rows_to_add + np.shape(cH2)[0], columns_to_add + np.shape(cH2)[1]))
padded_cH2[:np.shape(cH2)[0], :np.shape(cH2)[1]] = cH2 

dct_of_padded_cH2 = np.zeros(np.shape(padded_cH2))

# Performing Block wise DCT on this 
for i in range(0,np.shape(padded_cH2)[0],8): 
    for j in range(0,np.shape(padded_cH2)[1],8): 
        dct_of_padded_cH2[i:(i+8), j:(j+8)] = dct2D(padded_cH2[i:(i+8), j:(j+8)]) 
        
# Image is now ready to be embedded now 
n = 0 
for i in range(0,np.shape(padded_cH2)[0],8): 
    for j in range(0,np.shape(padded_cH2)[1],8): 
        dct_of_padded_cH2[(i+5), (j+5)] = np.reshape(watermark_reshaped[0,n], (1,1)) 
        
# Watermark Successfully Embedded -- Let us view the effect on the image

idct_of_padded_cH2 = np.zeros(np.shape(padded_cH2))


# Perform 8x8 IDCT now
for i in range(0,np.shape(padded_cH2)[0],8): 
    for j in range(0,np.shape(padded_cH2)[1],8): 
        idct_of_padded_cH2[i:(i+8), j:(j+8)] = idct2D(dct_of_padded_cH2[i:(i+8), j:(j+8)]) 
        
cH2_embedded = np.resize(idct_of_padded_cH2, np.shape(cH2))
# Performing 2 Level 2D DWT now 
coeff_level2 = [cA2, (cH2_embedded, cV2, cD2), (cH1, cV1, cD1)]
img_reconstructed = idwt2D(coeff_level2)

cv.imshow('Reconstructed and Watermark Embedded Lenna Image',img_reconstructed.astype(np.uint8) )
cv.waitKey(0) 
cv.destroyAllWindows()