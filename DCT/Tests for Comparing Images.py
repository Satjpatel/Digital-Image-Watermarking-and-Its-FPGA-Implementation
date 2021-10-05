# -*- coding: utf-8 -*-
"""
Created on Mon Oct  4 20:13:27 2021

@author: Sat Patel 

Test Performing on Images 
"""


import cv2 as cv 
import numpy as np 
import skimage.metrics as sm 

# Tests for Comparing 2 Images 

# Peak Signal to Noise Ratio 

img_clean = cv.imread('Corr_1.jpg', 0)
img_noisy = cv.imread('Corr_2.jpg', 0)

# Peak Signal to Noise Ratio between the Images
psnr = cv.PSNR(img_clean, img_noisy)

# Structural Similarity between the images
d = sm.structural_similarity(img_clean, img_noisy) 
