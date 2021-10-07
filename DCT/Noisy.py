# -*- coding: utf-8 -*-
"""
Created on Wed Oct  6 23:59:38 2021

@author: Sat Patel
"""

# Adding Salt and Pepper Noise to image
import cv2 as cv
import numpy as np
import random 


# Adding salt and pepper noise

def gaussian_noise(image):
      row = 512
      col = 512
      mean = 0
      var = 0.1
      sigma = var**0.5
      gauss = np.random.normal(mean,sigma,(row,col))
      gauss = gauss.reshape(row,col)
      gauss_noisy = image + gauss
      return gauss_noisy

def salt_and_pepper_noise(image):
  
    # Getting the dimensions of the image
    row , col = img.shape
      
    # Randomly pick some pixels in the
    # image for coloring them white
    # Pick a random number between 300 and 10000
    number_of_pixels = random.randint(300, 10000)
    for i in range(number_of_pixels):
        
        # Pick a random y coordinate
        y_coord=random.randint(0, row - 1)
          
        # Pick a random x coordinate
        x_coord=random.randint(0, col - 1)
          
        # Color that pixel to white
        img[y_coord][x_coord] = 255
          
    # Randomly pick some pixels in
    # the image for coloring them black
    # Pick a random number between 300 and 10000
    number_of_pixels = random.randint(300 , 10000)
    for i in range(number_of_pixels):
        
        # Pick a random y coordinate
        y_coord=random.randint(0, row - 1)
          
        # Pick a random x coordinate
        x_coord=random.randint(0, col - 1)
          
        # Color that pixel to black
        img[y_coord][x_coord] = 0
          
    return img
  
    
img = cv.imread('Lenna.jpg', 0)
gn =  gaussian_noise(img) 
snp = salt_and_pepper_noise(img)


