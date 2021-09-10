# -*- coding: utf-8 -*-
"""
Created on Fri Sep 10 16:55:35 2021

@author: HP
"""

# Small DCT example 

import numpy as np 
import scipy.fftpack as spfft 
import cv2 as cv 


def dct2(a):
    return spfft.dct(spfft.dct(a.T, norm='ortho').T, norm='ortho')

def idct2(a):
    return spfft.idct(spfft.idct(a.T, norm='ortho').T, norm='ortho')

a = np.array([(1,2,2,1), (2,1,2,1),(1,2,2,1), (2,1,2,1)], dtype=np.uint8)

dct_a = dct2(a)
a_back = idct2(dct_a)