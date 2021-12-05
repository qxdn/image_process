'''
本文件主要用于分析周期性噪声图片的频谱
'''
import numpy as np
import cv2
import matplotlib.pyplot as plt
from matplotlib.patches import Rectangle


plt.figure()
plt.subplot(121)
image = cv2.imread('noise.jpg')
# 转换灰度图
gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
# fft
F = np.fft.fft2(gray)
# fft
fft_shift = np.fft.fftshift(F)
# 取log方便观察
plt.imshow(np.log(np.abs(fft_shift)+1), cmap='gray')
ax = plt.gca()
zooms = [(180, 200, 245, 243), (224, 285, 278, 317), (335, 300, 377, 334),
         (400, 235, 460, 278), (364, 156, 419, 193), (255, 135, 311, 177)]

for zoom in zooms:
    leftup = (zoom[0], zoom[1])
    rightdown = (zoom[2], zoom[3])
    rect = Rectangle((leftup[0], rightdown[1]), rightdown[0]-leftup[0],
                     leftup[1]-rightdown[1], linewidth=1, edgecolor='r', facecolor='none')
    ax.add_patch(rect)


plt.subplot(122)
fft_shift_temp = np.log(np.abs(fft_shift)+1)
mask = np.ones_like(fft_shift_temp)
for zoom in zooms:
    '''
    midx = (zoom[1]+zoom[3])/2
    midy = (zoom[0]+zoom[2])/2
    for x in range(zoom[1], zoom[3]):
        for y in range(zoom[0], zoom[2]):
            r = np.sqrt((x-midx)**2+(y-midy)**2)
            if r <= min(abs(zoom[0]-midy), abs(zoom[1]-midx)):
                mask[x, y] = 0
    '''
    mask[zoom[1]:zoom[3],zoom[0]:zoom[2]] = 0

fft_shift_temp = np.multiply(fft_shift_temp, mask)
plt.imshow(fft_shift_temp, cmap='gray')

plt.show()
