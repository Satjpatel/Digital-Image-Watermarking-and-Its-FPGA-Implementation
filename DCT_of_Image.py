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

# Converting the image into DCT domain 
for i in range(0,height,1):
        dct_array[i]= spfft.dct(img11[i], norm = "ortho") 
        