# -*- coding: utf-8 -*-
"""
Created on Tue Oct  5 16:41:54 2021

@author: Sat Patel
"""

# Libraries Used 

import cv2 as cv 
import scipy.fft as spfft 
import numpy as np




# Functions to be used 
# 1. 2D Discrete Cosine Transform
def dct2D(a):
    return spfft.dct(spfft.dct(a.T, norm='backward').T, norm='backward')
# 2. 2D Inverse Discrete Cosine Transform
def idct2D(a):
    return spfft.idct(spfft.idct(a.T, norm='backward').T, norm='backward')

# Reading the img and watermark 
img = cv.imread('Lenna.jpg',0)

# Reading watermark 
watermark = cv.imread('Address.jpg',0)

# Normalizing img and watermark 
img_normalizer = np.full((np.shape(img)), 128)
wm_normalizer = np.full((np.shape(watermark)), 128) 

img_1 = img - img_normalizer 
wm_1  = watermark - wm_normalizer 
wm_1_flat = np.ravel(wm_1) 


# Arrays for DCT and IDCT 
dct_of_img        = np.zeros((np.shape(img_1)), dtype=np.int64)
dct_of_img_again  = np.zeros((np.shape(img_1)), dtype=np.int64)
idct_of_img       = np.zeros((np.shape(img_1)), dtype=np.int64)

# Performing DCT on the input 
for i in range(0, np.shape(img_1)[0], 8): 
    for j in range(0, np.shape(img_1)[1], 8): 
        dct_of_img[i:i+8, j:j+8] = (dct2D(img_1[i:i+8, j:j+8])).astype(np.int64)
        
# Embedding watermark in the DCT domain 
m = 0 
for i in range(0, np.shape(img_1)[0], 8): 
    for j in range(0, np.shape(img_1)[1], 8): 
        dct_of_img[i+4:i+6, j:j+2] = np.reshape((wm_1_flat[m:m+4]), (2,2)).astype(np.int64)
        m = m + 4 
        
# Back into Spatial Domain 
for i in range(0, np.shape(img_1)[0], 8): 
    for j in range(0, np.shape(img_1)[1], 8): 
        idct_of_img[i:i+8,j:j+8] = idct2D(dct_of_img[i:i+8,j:j+8]).astype(np.int64)
        
embedded_image = idct_of_img + img_normalizer



# Performing DCT once again 
for i in range(0, np.shape(img_1)[0], 8): 
    for j in range(0, np.shape(img_1)[1], 8): 
        dct_of_img_again[i:i+8, j:j+8] = dct2D(idct_of_img[i:i+8, j:j+8]).astype(np.int64)

# Extracting Watermark 
temp_array = np.zeros((2,2)) 
n = 0 
wm_extracted_flat = np.zeros((np.shape(wm_1_flat)))
for i in range(0, np.shape(img_1)[0], 8): 
    for j in range(0, np.shape(img_1)[1], 8): 
        temp_array = dct_of_img_again[i+4:i+6, j:j+2].astype(np.int64) 
        wm_extracted_flat[n] =   min(np.ravel(temp_array)[0], 127) 
        wm_extracted_flat[n+1] = min(np.ravel(temp_array)[1], 127)
        wm_extracted_flat[n+2] = min(np.ravel(temp_array)[2], 127)
        wm_extracted_flat[n+3] = min(np.ravel(temp_array)[3], 127)
        #wm_extracted_flat[n:n+4] = np.ravel(temp_array).astype(np.int64)
        n = n + 4 
# wm_extracted = np.zeros(np.shape(wm_1)) 

wm_extracted = np.reshape(wm_extracted_flat, (np.shape(wm_1))).astype(np.int64)
wm_final = (wm_extracted + wm_normalizer).astype(np.int64)

cv.imshow('Extracted Watermark', wm_final.astype(np.uint8))
cv.waitKey(0)
cv.destroyAllWindows()

cv.imwrite('1. Original Image.jpg', img)
cv.imwrite('2. Watermark Used.jpg', watermark)
cv.imwrite('3. Watermark Embedded Image.jpg', embedded_image.astype(np.int64))
cv.imwrite('4. Extracted Watermark.jpg', wm_final)
cv.imwrite('Difference Image.jpg', wm_final - watermark)
