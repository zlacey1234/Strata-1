import numpy as np
import cv2 as cv
import matplotlib.pyplot as plt

imagefolder = '/C:/Users/zlace/OneDrive/Documents/Strata-1 Research/Strata-1 Code/Strata-1 Image Data/Strata1 XCT jpgs'
imagestackfolder = '/Beads1_ImageStack/JPEGS/'
imageprefix = 'Beads1'
start_image = 264
end_image = 270
x1 = 1
x2 = 1020
y1 = 1
y2 = 1041


def load_image(start_image, end_image, x1, x2, y1, y2, imagefolder, imagestackfolder, imageprefix):
    dx = x2 - x1 + 1
    dy = y2 - y1 + 1
    no_image = end_image - start_image + 1
    IMS = np.zeros((dx, dy, no_image), dtype=np.float64)
    j = 0

    for i in range(start_image, end_image):
        j = j + 1
        image = str(imagefolder) + str(imagestackfolder) + str(imageprefix) + str(i).zfill(4) + '.jpg'
        'print(image)'
        IMS = np.array([cv.imread(image) j], dtype=np.float64)
        print(IMS)
    return (IMS)


IMS = load_image(start_image, end_image, x1, x2, y1, y2, imagefolder,imagestackfolder, imageprefix)


plt.imshow(IMS[:, :, 4])

