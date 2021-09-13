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

''' 

Level 1 - DWT and IDWT 
# Get the image

img = cv.imread('springer.png',0) 

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

''' 

# Now working on 2 Level Discrete Wavelet Transforms 

img = cv.imread('Lenna.png',0) 

cv.imshow('Lenna Original',img) 
cv.waitKey(0)

coeff_level2 = pywt.wavedec2(img, 'db3', mode = 'symmetric', level=2 )
[cA2, (cH2, cV2, cD2), (cH1, cV1, cD1)] = coeff_level2 

# Level 1 Decomposition Images 
img_intermediate = pywt.idwt2((cA2, (cH2, cV2, cD2)), 'db3',mode = 'symmetric') 
plotty.subplot(2,2,1)
cv.imshow('Approximate Details', img_intermediate.astype(np.uint8))
plotty.subplot(2,2,2)
cv.imshow('Vertical Details (cV)', cV1.astype(np.uint8))
plotty.subplot(2,2,3)
cv.imshow('Horizontal Details (cH)', cH1.astype(np.uint8))
plotty.subplot(2,2,4)
cv.imshow('Diagonal Details (cD)', cD1.astype(np.uint8))
cv.waitKey(0)


# Level 2 Decomposition 
plotty.subplot(2,2,1)
cv.imshow('Approximate Details', cA2.astype(np.uint8))
plotty.subplot(2,2,2)
cv.imshow('Vertical Details (cV)', cV2.astype(np.uint8))
plotty.subplot(2,2,3)
cv.imshow('Horizontal Details (cH)', cH2.astype(np.uint8))
plotty.subplot(2,2,4)
cv.imshow('Diagonal Details (cD)', cD2.astype(np.uint8))
cv.waitKey(0)

# Reconstructing the image using Inverse DWT 
img_reconstructed = pywt.waverec2(coeff_level2, 'db3',mode = 'symmetric') 
cv.imshow('Reconstructed Lenna Image', img_reconstructed.astype(np.uint8))
cv.waitKey(0)
