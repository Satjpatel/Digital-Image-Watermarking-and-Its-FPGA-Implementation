# -*- coding: utf-8 -*-
"""
Created on Thu Sep  9 10:37:33 2021

@author: HP
"""

import cv2 as cv 
import scipy.fft as spfft 
import numpy as np


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



cv.imshow('Kung Fu Panda Padded', padded_image)  

cv.waitKey(0)


# Padded Image is now ready for performing DCT 
