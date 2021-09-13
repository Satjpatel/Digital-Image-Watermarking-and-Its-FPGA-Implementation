# -*- coding: utf-8 -*-
"""
Created on Sun Sep 12 22:20:14 2021

@author: HP
"""

# Testing Discrete Wavelet Transform 

import cv2 as cv 
import pywt
import numpy as np
import matplotlib.pyplot as plotty
# Get the image

img = cv.imread('Lenna.png',0) 

cv.imshow('Kung Fu Panda Original',img) 
cv.waitKey(9000)

# Getting the 2d DWT co-effecients 
coff = pywt.dwt2(img, 'db1', mode = 'symmetric' )
cA, (cH, cV, cD) = coff

plotty.subplot(2,2,1) 
cv.imshow('cA', coff[0].astype(np.uint8))
plotty.subplot(2,2,2) 
cv.imshow('cH', coff[1][0].astype(np.uint8))
plotty.subplot(2,2,3)
cv.imshow('cV', coff[1][1].astype(np.uint8))
plotty.subplot(2,2,4)
cv.imshow('cD', coff[1][2].astype(np.uint8))

cv.waitKey(0) 

img_r = pywt.idwt2(coff, 'db3', mode = 'symmetric') 
img_r_dash = img_r.astype(np.uint8)
cv.imshow('Reconstructed Image', img_r_dash)
cv.waitKey(0)