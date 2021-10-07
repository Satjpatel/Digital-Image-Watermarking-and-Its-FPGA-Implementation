# -*- coding: utf-8 -*-
"""
Created on Tue Oct  5 11:00:02 2021

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
    return spfft.dct(spfft.dct(a.T, norm='ortho').T, norm='ortho')



# Reading the Image 
img11 = cv.imread('5. Lenna and Embedded Watermark.jpg',0) 

# Reading the original watermark 
watermark = cv.imread('SVNIT_logo.jpg',0)


# Finding the number of rows and columns to pad with zeros to make a perfect 
# rectangle that an 8x8 matrix of DCT coeffecients can easily traverse 
rows_to_add    = (img11.shape[0])%8 
columns_to_add = (img11.shape[1])%8 


new_height     = img11.shape[0] if (img11.shape[0]%8 == 0) else (img11.shape[0] + 8 - rows_to_add)
new_width      = img11.shape[1] if (img11.shape[1]%8 == 0) else (img11.shape[1] + 8 - columns_to_add)


# Zero padding to make perfect dimensions for 8x8 DCT block 
padded_image = np.zeros((new_height, new_width), dtype=np.uint8)
padded_image[:img11.shape[0],:img11.shape[1]] = img11 

# Empty Array for DCT Co-effecients 
dct_of_padded_image                    = np.zeros((np.shape(padded_image)))

# Performing DCT on 8x8 blocks
m = 0 
for i in range(0,new_height,8): 
    for j in range(0,new_width,8): 
        dct_of_padded_image[i:(i+8), j:(j+8)] = dct2D(padded_image[i:(i+8), j:(j+8)]) 
  

# Extracting the water mark 
n = 0 
watermark_extracted = np.zeros((1, np.shape(watermark)[0]*np.shape(watermark)[1]))
temp_array = np.zeros((2,2))


for i in range(0,new_height,8): 
    for j in range(0,new_width,8): 
        if(n < m ): 
            temp_array = dct_of_padded_image[(i+4):(i+6), (j+6):(j+8)]
            watermark_extracted[0, n:n+4] = 255*temp_array.reshape((1,4))
            n = n + 4

watermark_extracted_reshaped = np.reshape(watermark_extracted, (np.shape(watermark)))

cv.imshow('Extracted Watermark', watermark_extracted_reshaped.astype(np.uint8))
cv.waitKey(0) 
cv.destroyAllWindows()




