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


watermark = cv.imread('star.png',0)
cv.imshow('Star -- To be Watermarked', watermark)
cv.waitKey(0)
print(watermark.shape[0]) 
print(watermark.shape[1])
watermarked_reshaped = watermark.reshape((1,watermark.shape[0]*watermark.shape[1]))
watermark_nparray = np.zeros((1,watermark.shape[0]*watermark.shape[1]))
watermark_nparray = watermarked_reshaped

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

for i in range(0,new_height,8): 
    for j in range(0,new_width,8): 
      #  for m in range(0, watermark.shape[0], 4) :
       #     for n in range(0, watermark.shape[1], 4): 
                dct_of_padded_image[i:(i+8), j:(j+8)] = dct2D(padded_image[i:(i+8), j:(j+8)]) 
               # dct_of_padded_image[(i+4):(i+8), j:(j+4)] = watermark[m:(m+4), n:(n+4)]
# Embedding the watermark into DCT Domain now 

m = 0 
for i in range(0,new_height,8): 
    for j in range(0,new_width,8): 
        if(m < 10000):
            dct_of_padded_image[(i+4), (j+4)] = np.reshape(watermark_nparray[0,m], (1,1)) 
            m = m+1



print(dct_of_padded_image[0:(8), 0:(8)])
print(dct_of_padded_image[1112:(1112+8), 784])

print(watermark[0:(4), 0:(4)])

cv.imshow('Kung Fu Panda in DCT Domain', dct_of_padded_image)  
cv.waitKey(0)


original_image_after_idct = np.zeros(np.shape(padded_image), dtype=np.uint8)

for k in range(0,new_height,8): 
    for l in range(0,new_width,8): 
        original_image_after_idct[k:(k+8), l:(l+8)] = idct2D(dct_of_padded_image[k:(k+8), l:(l+8)]) 
        
cv.imshow('Kung Fu Panda bank in spatial domain from DCT Domain', original_image_after_idct)  
cv.waitKey(0)


# Writing all the images in the file 
cv.destroyAllWindows()

# Extracting the water mark 
n = 0 
watermark_extracted = np.zeros((1, np.shape(watermark)[0]*np.shape(watermark)[1]))

for i in range(0,new_height,8): 
    for j in range(0,new_width,8): 
        if(n < 10000): 
            watermark_extracted[0,n] = dct_of_padded_image[(i+4), (j+4)]  
            n = n + 1 

watermark_extracted_reshaped = np.reshape(watermark_extracted, (np.shape(watermark)[0], np.shape(watermark)[1]))

cv.imshow('Extracted Watermark', watermark_extracted_reshaped.astype(np.uint8))
cv.waitKey(0) 

cv.imwrite('Kung Fu Panda Padded.jpg', padded_image)  
cv.imwrite('Kung Fu Panda Padded.jpg', padded_image)  
cv.imwrite('Kung Fu Panda in DCT Domain.jpg', dct_of_padded_image)  
cv.imwrite('Kung Fu Panda bank in spatial domain from DCT Domain.jpg', original_image_after_idct)  
