# -*- coding: utf-8 -*-
"""
Created on Tue Oct  5 11:58:46 2021

@author: HP
"""

import scipy.fft as spfft 
import numpy as np
import cv2 as cv 

b = np.full((8,8), 128) 
c = np.full((2,2), 128).astype(np.uint8) 

# Functions to be used 
# 1. 2D Discrete Cosine Transform
def dct2D(a):
    return spfft.dct(spfft.dct(a.T, norm='backward').T, norm='backward')
# 2. 2D Inverse Discrete Cosine Transform
def idct2D(a):
    return spfft.idct(spfft.idct(a.T, norm='backward').T, norm='backward')

# Read the images

''' 
img = cv.imread('sadi_img.jpg',0) 
watermark = cv.imread('sado_watermark.jpg',0)

# Normalize image 
img_1 = img - b
watermark_1 = watermark - c 

# Performing DCT 
dct_of_image = dct2D(img_1) 
dct_of_image[6:8, 6:8] = watermark_1

# Performing IDCT 
idct_of_image_dash = idct2D(dct_of_image)
idct_of_image = idct_of_image_dash
# Performing DCT again 
dct_again = dct2D(idct_of_image) 

a = dct_again[6:8, 6:8].astype(np.uint8)

final = a + c 

diff = final - watermark

cv.imwrite('A. Input Image.jpg', img)
cv.imwrite('B. Asli Watermark.jpg', watermark) 
cv.imwrite('C. Extracted Watermark.jpg', final)
'''

# Trying on a slightly bigger image

img1       = cv.imread('chotu.jpg',0)  
wm1        = cv.imread('choti.jpg',0)  

img_normalize = np.full(np.shape(img1), 128)
wm_normalize = np.full(np.shape(wm1), 128)

img = img1 - img_normalize 
wm  = wm1   - wm_normalize 

dct_of_img = np.zeros(np.shape(img))
idct_of_img = np.zeros(np.shape(img)) 
dct_of_img_again = np.zeros(np.shape(img)) 

wm_flat = np.ravel(wm) 
n = 0 
# Performing DCT and Embedding 
for i in range(0, np.shape(img)[0], 8): 
    for j in range(0, np.shape(img)[1], 8): 
        dct_of_img[i:i+8, j:j+8] = dct2D(img[i:i+8, j:j+8])
        dct_of_img[i+6:i+8, j+6:j+8] = np.reshape(wm_flat[n:n+4], (2,2))
        n = n + 4
        
# Performing IDCT now 
for i in range(0, np.shape(img)[0], 8): 
    for j in range(0, np.shape(img)[1], 8): 
        idct_of_img[i:i+8, j:j+8] = idct2D(dct_of_img[i:i+8, j:j+8])


# Performing DCT once again 
for i in range(0, np.shape(img)[0], 8): 
    for j in range(0, np.shape(img)[1], 8): 
        dct_of_img_again[i:i+8, j:j+8] = dct2D(idct_of_img[i:i+8, j:j+8])  
        
# Extracting Watermark 
wm_extracted = np.zeros(16)  
m = 0 

temp = np.zeros((2,2))
for i in range(0, np.shape(img)[0], 8): 
    for j in range(0, np.shape(img)[1], 8): 
        temp = dct_of_img_again[i+6:i+8, j+6:j+8]  
        wm_extracted[m:m+4] = np.ravel(temp)
        m = m + 4 
        
wm_final_extracted = np.reshape(wm_extracted, (4,4))
watermark_final = wm_final_extracted + wm_normalize

cv.imwrite('A. Input Image.jpg', img)
cv.imwrite('B. Asli Watermark.jpg', wm) 
cv.imwrite('C. Extracted Watermark.jpg', watermark_final)