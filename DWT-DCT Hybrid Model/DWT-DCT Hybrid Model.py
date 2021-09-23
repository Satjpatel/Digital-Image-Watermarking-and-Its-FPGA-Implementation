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
    return pywt.wavedec2(a, 'db3', mode = 'symmetric', level = 1)

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
img = cv.imread('batman.jpg', 0) 
watermark = cv.imread('star.png',0)

watermark_flattened = np.reshape(watermark, (1, np.shape(watermark)[0]*np.shape(watermark)[0]))

plotty.subplot(2,1,1) 
cv.imshow('Lenna - Original Image', img) 
plotty.subplot(2,1,2) 
cv.imshow('Discord Logo -- Watermark to be Embedded', watermark) 
cv.waitKey(0) 
cv.destroyAllWindows()


# Performing Stage-1 DWT on the Image Now 
[cA1, (cH1, cV1, cD1)] = dwt2D(img)

plotty.subplot(2,2,1) 
cv.imshow('Lenna - Approximate Details', cA1.astype(np.uint8)) 
plotty.subplot(2,2,2) 
cv.imshow('Lenna - Horizontal Details ', cH1.astype(np.uint8)) 
plotty.subplot(2,2,3) 
cv.imshow('Lenna - Vertical Details   ', cV1.astype(np.uint8)) 
plotty.subplot(2,2,4) 
cv.imshow('Lenna - Diagonal Details   ', cD1.astype(np.uint8)) 
cv.waitKey(0) 
cv.destroyAllWindows()

# Performing Stage-2 DWT on cH1 
[cA2, (cH2, cV2, cD2)] = dwt2D(cH1)

plotty.subplot(2,2,1) 
cv.imshow('Lenna cH1 - Approximate Details', cA2.astype(np.uint8)) 
plotty.subplot(2,2,2) 
cv.imshow('Lenna cH1- Horizontal Details ', cH2.astype(np.uint8)) 
plotty.subplot(2,2,3) 
cv.imshow('Lenna cH1- Vertical Details   ', cV2.astype(np.uint8)) 
plotty.subplot(2,2,4) 
cv.imshow('Lenna cH1- Diagonal Details   ', cD2.astype(np.uint8)) 
cv.waitKey(0) 
cv.destroyAllWindows()


# Performing the DWT on cH2 
new_height = np.shape(cH2)[0] + 8 - (np.shape(cH2)[0]%8)
new_width  = np.shape(cH2)[1] + 8 - (np.shape(cH2)[1]%8)

# Array is padded to make a perfect 8x8 
cH2_padded = np.zeros((new_height, new_width), dtype=np.uint8)
cH2_padded[:np.shape(cH2)[0],:np.shape(cH2)[1]] = cH2 
dct_of_cH2_padded              = np.zeros(np.shape(cH2_padded))
dct_of_cH2_padded_img_embedded = np.zeros(np.shape(cH2_padded))

# Performing 8x8 DCT now 
for i in range(0,new_height,8): 
    for j in range(0,new_width,8):
        dct_of_cH2_padded[i:i+8, j:j+8] = dct2D(cH2_padded[i:i+8, j:j+8])
        
dct_of_cH2_padded_img_embedded = dct_of_cH2_padded 
m = 0
# Embeddeding the watermark now 
for i in range(0,new_height,8): 
    for j in range(0,new_width,8):
        dct_of_cH2_padded_img_embedded[i+6:i+8, j+6:j+8] = np.reshape(watermark_flattened[0,m:m+4], (2,2)) 
        m = m + 4
     
# Image Embedding now completed

# Performing Inverse 8x8 DCT now 
idct_of_img = np.zeros(np.shape(dct_of_cH2_padded))

for i in range(0,new_height,8): 
    for j in range(0,new_width,8):
        idct_of_img[i:i+8, j:j+8] = idct2D(dct_of_cH2_padded_img_embedded[i:i+8, j:j+8])

# Performing Stage 2 of Inverse DWT 

cH1_dash_reshaped = np.resize(idct_of_img, np.shape(cH2))

cH1_dash = idwt2D((cA2, (cH1_dash_reshaped, cV2, cD2))) 
# Performing Stage 1 of Inverse DWT 
img_with_watermark = idwt2D((cA1, (cH1_dash, cV1, cD1)))

cv.imshow('Image is back', img_with_watermark.astype(np.uint8)) 
cv.waitKey(0) 
cv.destroyAllWindows
'''
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
       if ( n < np.shape(watermark)[0]*np.shape(watermark)[1]):
           dct_of_padded_cH2[(i+5), (j+5)] = np.reshape(watermark_reshaped[0,n], (1,1)) 
           n = n+1
        
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

cv.imshow('Reconstructed and Watermark Embedded Lenna Image',img_reconstructed.astype(np.uint8))
cv.waitKey(0) 
cv.destroyAllWindows()


# Extracting the Watermark from the Image 
[cA21, (cH21, cV21, cD21), (cH11, cV11, cD11)] = dwt2D(img_reconstructed)
rows_to_add1    = 8 - ((np.shape(cH21)[0]))%8 
columns_to_add1 = 8 - ((np.shape(cH21)[1]))%8 

padded_cH21 = np.zeros((rows_to_add1 + np.shape(cH21)[0], columns_to_add1 + np.shape(cH21)[1]))
padded_cH21[:np.shape(cH21)[0], :np.shape(cH21)[1]] = cH21 

dct_of_padded_cH21 = np.zeros(np.shape(padded_cH21))

for i in range(0,np.shape(padded_cH21)[0],8): 
    for j in range(0,np.shape(padded_cH21)[1],8): 
        dct_of_padded_cH21[i:(i+8), j:(j+8)] = dct2D(padded_cH21[i:(i+8), j:(j+8)]) 
 
    
watermark_extracted = np.zeros((1, np.shape(watermark)[0]*np.shape(watermark)[1]))

m = 0 
for i in range(0,np.shape(padded_cH21)[0],8): 
    for j in range(0,np.shape(padded_cH21)[1],8): 
        if ( m < np.shape(watermark)[0]*np.shape(watermark)[1]):
            watermark_extracted[0,m] = dct_of_padded_cH2[(i+5), (j+5)] 
            m = m + 1
        
        
watermark_extracted_resized = np.resize(watermark_extracted, np.shape(watermark))
cv.imshow("Watermark Extracted", watermark_extracted_resized.astype(np.uint8))
cv.waitKey(0) 
cv.destroyAllWindows() 
''' 