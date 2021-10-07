# -*- coding: utf-8 -*-
"""
Created on Tue Oct  5 17:20:43 2021

@author: Sat Patel
"""

# Libraries to Use 
import cv2 as cv 
import scipy.fft as spfft 
import numpy as np
import matplotlib.pyplot as plotty 



# Functions to be used 
# 1. 2D Discrete Cosine Transform
def dct2D(a):
    return spfft.dct(spfft.dct(a.T, norm='backward').T, norm='backward')



# Reading the Image 
img11 = cv.imread('31. Watermark Embedded Image.jpg',0).astype(np.int64)
img_normalizer = np.full((np.shape(img11)), 128)
img = img11 - 128

# Reading the original watermark 
watermark = cv.imread('2. Watermark Used.jpg',0)

wm_normalizer = np.full((np.shape(watermark)), 128) 

# Empty Array for DCT Co-effecients 
dct_of_padded_image                    = np.zeros((np.shape(img11)), dtype = np.int64)

# Performing DCT on 8x8 blocksCal
m = 0 
for i in range(0,np.shape(img11)[0],8): 
    for j in range(0,np.shape(img11)[1],8): 
        dct_of_padded_image[i:(i+8), j:(j+8)] = (dct2D(img[i:(i+8), j:(j+8)])).astype(np.int64)
  

# Extracting the water mark 
n = 0 
watermark_extracted = np.zeros((16384), dtype = np.int64)
temp_array = np.zeros((2,2), dtype = np.int64)


for i in range(0,np.shape(img11)[0],8): 
    for j in range(0,np.shape(img11)[1],8): 
        temp_array = dct_of_padded_image[(i+4):(i+6), (j):(j+2)]
        # watermark_extracted[n:n+4] = np.ravel(temp_array)
        watermark_extracted[n]   = min(np.ravel(temp_array)[0], 127) 
        watermark_extracted[n+1] = min(np.ravel(temp_array)[1], 127)
        watermark_extracted[n+2] = min(np.ravel(temp_array)[2], 127)
        watermark_extracted[n+3] = min(np.ravel(temp_array)[3], 127)
        n = n + 4

watermark_extracted_reshaped = np.reshape(watermark_extracted, (128,128))
final_wm = np.zeros(np.shape(watermark), dtype = np.int64)
final_wm = watermark_extracted_reshaped + wm_normalizer.astype(np.int64)

cv.imshow('Extracted Watermark', final_wm.astype(np.uint8))
cv.waitKey(0) 
cv.destroyAllWindows()

cv.imwrite('Extracted Watermark From Other Code.jpg', final_wm)