# -*- coding: utf-8 -*-
"""
Created on Thu Sep  9 10:37:33 2021

@author: Sat Patel -- U18EC105
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
# 2. 2D Inverse Discrete Cosine Transform
def idct2D(a):
    return spfft.idct(spfft.idct(a.T, norm='backward').T, norm='backward')

# Reading the Watermark 
watermark = cv.imread('SVNIT_logo.jpg',0)
#cv.imshow('Discord Logo -- To be Watermarked', watermark)
#cv.waitKey(0)

watermark_flattened = watermark.reshape((1,watermark.shape[0]*watermark.shape[1]))

# Reading the Image 
img11 = cv.imread('white.jpg',0) 
#cv.imshow('Lenna - Original', img11)  
#cv.waitKey(0)

plotty.subplot(2,1,1) 
cv.imshow('SVNIT Logo -- To be Watermarked', watermark)
plotty.subplot(2,1,2) 
cv.imshow('Lenna - Original', img11)  
cv.waitKey(0)
cv.destroyAllWindows()


'''
watermark_flattened_and_reshaped = watermark_flattened.reshape(np.shape(watermark))
cv.imshow('Reshaped Watermark Avvi', watermark_flattened_and_reshaped)
cv.waitKey(0) 
cv.destroyAllWindows() 

'''


'''
 Converting the spatial image into Frequency Domain using DCT
''' 



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
dct_of_padded_image_once_again         = np.zeros((np.shape(padded_image)))
dct_of_padded_image_watermark_embedded = np.zeros((np.shape(padded_image)))
# Performing DCT on 8x8 blocks

m = 0 
for i in range(0,new_height,8): 
    for j in range(0,new_width,8): 
        dct_of_padded_image[i:(i+8), j:(j+8)] = dct2D(padded_image[i:(i+8), j:(j+8)]) 
  
dct_of_padded_image_watermark_embedded = dct_of_padded_image    
             
# Embedding the watermark into DCT Domain now 
for i in range(0,new_height,8): 
    for j in range(0,new_width,8): 
        if(m < watermark.shape[0]*watermark.shape[1]):
            dct_of_padded_image_watermark_embedded[(i+4):(i+6), (j+6):(j+8)] = np.reshape(watermark_flattened[0,m:m+4]/255, (2,2)).astype(np.float)
            m = m+4

plotty.subplot(2,1,1) 
cv.imshow('Lenna in DCT Domain', dct_of_padded_image.astype(np.uint8))  
plotty.subplot(2,1,2) 
cv.imshow('Lenna in DCT Domain after Watermark is Embedded', dct_of_padded_image_watermark_embedded.astype(np.uint8))  
cv.waitKey(0)
cv.destroyAllWindows()


'''
difference_image = dct_of_padded_image_watermark_embedded - dct_of_padded_image 
cv.imshow('Difference Image', difference_image.astype(np.uint8))
cv.waitKey(0)
cv.destroyAllWindows()

'''

original_image_after_idct = np.zeros(np.shape(padded_image), dtype=np.uint8)

for k in range(0,new_height,8): 
    for l in range(0,new_width,8): 
        original_image_after_idct[k:(k+8), l:(l+8)] = idct2D(dct_of_padded_image_watermark_embedded[k:(k+8), l:(l+8)]) 
        
cv.imshow('Lenna back in Spatial Domain from DCT Domain', original_image_after_idct)  
cv.waitKey(0)


# Writing all the images in the file 
cv.destroyAllWindows()


# performing DCT once again 
for i in range(0,new_height,8): 
    for j in range(0,new_width,8): 
        dct_of_padded_image_once_again[i:(i+8), j:(j+8)] = dct2D(original_image_after_idct[i:(i+8), j:(j+8)]) 




# Extracting the water mark 
n = 0 
watermark_extracted = np.zeros((1, np.shape(watermark)[0]*np.shape(watermark)[1]))
temp_array = np.zeros((2,2))


for i in range(0,new_height,8): 
    for j in range(0,new_width,8): 
        if(n < m ): 
            temp_array = dct_of_padded_image_once_again[(i+4):(i+6), (j+6):(j+8)]
            watermark_extracted[0, n:n+4] = 255*temp_array.reshape((1,4))
            n = n + 4

watermark_extracted_reshaped = np.reshape(watermark_extracted, (np.shape(watermark)))

cv.imshow('Extracted Watermark', watermark_extracted_reshaped.astype(np.uint8))
cv.waitKey(0) 


cv.imwrite('1. Lenna Before Watermark is Embedded.jpg', img11)  
cv.imwrite('2. Watermark to be embedded.jpg', watermark)  
cv.imwrite('3. Lenna in DCT Domain.jpg', dct_of_padded_image) 
cv.imwrite('4. Lenna with Embedded Watermark in DCT Domain.jpg', dct_of_padded_image_watermark_embedded)
cv.imwrite('5. Lenna and Embedded Watermark.jpg', original_image_after_idct) 
cv.imwrite('6. Extracted Watermark.jpg', watermark_extracted_reshaped)  
