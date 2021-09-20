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
cv.imwrite('Lenna Original.jpg', img)
coeff_level2 = pywt.wavedec2(img, 'db3', mode = 'symmetric', level=2 )
[cA2, (cH2, cV2, cD2), (cH1, cV1, cD1)] = coeff_level2 


# Level 1 Decomposition Images 

img_intermediate = pywt.idwt2((cA2, (cH2, cV2, cD2)), 'db3',mode = 'symmetric') 
plotty.subplot(2,2,1)
cv.imshow('Approximate Details - Level 1', img_intermediate.astype(np.uint8))
cv.imwrite('Approximate Details - Level 1.jpg', img_intermediate.astype(np.uint8))
plotty.subplot(2,2,2)
cv.imshow('Vertical Details (cV) - Level 1', cV1.astype(np.uint8))
cv.imwrite('Vertical Details (cV) - Level 1.jpg', cV1.astype(np.uint8))
plotty.subplot(2,2,3)
cv.imshow('Horizontal Details (cH) - Level 1', cH1.astype(np.uint8))
cv.imwrite('Horizontal Details (cH) - Level 1.jpg', cH1.astype(np.uint8))
plotty.subplot(2,2,4)
cv.imshow('Diagonal Details (cD) - Level 1', cD1.astype(np.uint8))
cv.imwrite('Diagonal Details (cD) - Level 1.jpg', cD1.astype(np.uint8))
cv.waitKey(0)


# Embedded the image information in cH Level 2 
watermark = cv.imread('star.png',0) 
cv.imshow('Watermark',watermark)
cv.waitKey(0) 

padded_watermark = np.zeros((np.shape(cH2)))
padded_watermark[:np.shape(watermark)[0],:np.shape(watermark)[1]] = watermark
cH2 = padded_watermark 

cv.imwrite('Horizontal Details Modified (cH) - Level 1.jpg', cH2.astype(np.uint8))

'''

# Level 2 Decomposition 
plotty.subplot(2,2,1)
cv.imshow('Approximate Details - Level 2', cA2.astype(np.uint8))
cv.imwrite('Approximate Details - Level 2.jpg', cA2.astype(np.uint8))
plotty.subplot(2,2,2)
cv.imshow('Vertical Details (cV) - Level 2', cV2.astype(np.uint8))
cv.imwrite('Vertical Details (cV) - Level 2.jpg', cV2.astype(np.uint8))
plotty.subplot(2,2,3)
cv.imshow('Horizontal Details (cH) - Level 2', cH2.astype(np.uint8))
cv.imwrite('Horizontal Details (cH) - Level 2.jpg', cH2.astype(np.uint8))
plotty.subplot(2,2,4)
cv.imshow('Diagonal Details (cD) - Level 2', cD2.astype(np.uint8))
cv.imwrite('Diagonal Details (cD) - Level 2.jpg', cD2.astype(np.uint8))
cv.waitKey(0)

''' 

# Reconstructing the image using Inverse DWT 
coefff_level2_dash = [cA2, (cH2, cV2, cD2), (cH1, cV1, cD1)]

img_reconstructed = pywt.waverec2(coefff_level2_dash, 'db3',mode = 'symmetric') 
cv.imshow('Reconstructed Lenna Image', img_reconstructed.astype(np.uint8))
cv.waitKey(0)
# cv.imwrite('Reconstructed Lenna Image.jpg', img_reconstructed.astype(np.uint8))
cv.destroyAllWindows()


# Extracting the Watermark Image from this reconstructed image
# Watermark is in cH2


coeff_level21 = pywt.wavedec2(img_reconstructed, 'db3', mode = 'symmetric', level=2 )
[cA21, (cH21, cV21, cD21), (cH11, cV11, cD11)] = coeff_level21

cv.imshow('Extracted Watermark:', cH21.astype(np.uint8))
cv.waitKey(0) 


