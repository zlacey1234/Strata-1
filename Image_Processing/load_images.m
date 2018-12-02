function [IMS, bit] = load_images(start_image, end_image, x1, x2, y1, y2, imagefolder, imageprefix)
% This is a function loads the images and stores them into a 
% Three-Dimensional Array/Matrix (Image Stack)
%
% INPUTS:
%    start_image: this defines the image that you start at. 
%    end_image: this defines the image that you stop at.
%    x1, x2, y1, y2: these represent the upper and lower bounds for the
%                    region of the image that you are loading. (Defined by
%                    pixels)
%    imagefolder: this is location of your folder that contains the image
%                 stack.
%    imageprefix: this refers to the prefix name for your image.
%          
% OUTPUTS:
%    IMS: this is the 3D matrix that contains the pixel values for each
%         image slice. (Image Stack)
%    bit: bit depth of the image
%
% AUTHOR: ZACHARY LACEY
% AFFILIATION : UNIVERSITY OF MARYLAND 
% EMAIL : zlacey@terpmail.umd.edu
%         zlacey1234@gmail.com

% dx and dy represent the range for the bounded region
dx = x2 - x1 + 1; 
dy = y2 - y1 + 1;
no_images=end_image-start_image+1;
IMS=(zeros(dy,dx,no_images));
j=0;
for i=start_image:end_image %bottom z slice to top
    j=j+1;
    %imhist(imread([imagefolder imageprefix num2str(i,'%04.0f') '.jpg']));
    IMSr=double(imread([imagefolder imageprefix num2str(i,'%04.0f') '.jpg']));%the image that is a single z slice
    im=IMSr(y1:y2,x1:x2);%selects the 2d region of interest as the region to put in the 3d image at slice i
    IMS(:,:,j)=im;
end
info = imfinfo([imagefolder imageprefix num2str(i,'%04.0f') '.jpg']);
bit = info.BitDepth;