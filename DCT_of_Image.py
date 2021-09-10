# -*- coding: utf-8 -*-
"""
Created on Thu Sep  9 10:37:33 2021

@author: HP
"""

import cv2 as cv 
import scipy.fft as spfft 
import numpy as np


def dct2D(a):
    return spfft.dct(spfft.dct(a.T, norm='ortho').T, norm='ortho')

def idct2D(a):
    return spfft.idct(spfft.idct(a.T, norm='ortho').T, norm='ortho')

img11 = cv.imread('KungFuPanda.jpg',0) 



cv.imshow('Kung Fu Panda', img11)  

cv.waitKey(0)


# Getting the dimensions of the image 

height = img11.shape[0]  
width = img11.shape[1] 


# Converting the spatial image into Frequency Domain using DCT
# DCT - Discrete Cosine Transform 

dct_array = np.zeros(shape=(height, width))
print('Height: {}'.format(height))
print('Weight: {}'.format(width))

# Zero padding to make perfect dimensions for 8x8 DCT block 

# Finding the number of rows and columns to pad with zeros to make a perfect 
# rectangle that an 8x8 matrix of DCT coeffecients can easily traverse 

rows_to_add = (height+8)%8 
columns_to_add = (width+8)%8 

new_height = height + rows_to_add 
new_width = width + columns_to_add 

padded_image = np.zeros((new_height, new_width), dtype=np.uint8)
padded_image[:height,:width] = img11 


dct_of_padded_image = np.zeros((np.shape(padded_image)))
cv.imshow('Kung Fu Panda Padded', padded_image)  
cv.waitKey(0)


# Padded Image is now ready for performing DCT 

# Performing DCT on 8x8 blocks now 

for i in range(0,height,8): 
    for j in range(0,height,8): 
        dct_of_padded_image[i:(i+8), j:(j+8)] = dct2D(padded_image[i:(i+8), j:(j+8)]) 



cv.imshow('Kung Fu Panda in DCT Domain', dct_of_padded_image)  
cv.waitKey(0)


original_image_after_idct = np.zeros(np.shape(padded_image), dtype=np.uint8)

for k in range(0,height,8): 
    for l in range(0,height,8): 
        original_image_after_idct[k:(k+8), l:(l+8)] = idct2D(dct_of_padded_image[k:(k+8), l:(l+8)]) 


cv.imshow('Kung Fu Panda bank in spatial domain from DCT Domain', original_image_after_idct)  
cv.waitKey(0)








