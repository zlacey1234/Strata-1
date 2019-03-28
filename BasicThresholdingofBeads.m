% Analyze_ Strata.m is an m-file that is intended to load the 
% Strata-1 Experiment Data (image stack) and analyze the orientation.
% The primary purpose of the this m-file is to utilize the various 
% functions and apply them to the analysis of the Strata-1 data set. 
% 
% AUTHOR: ZACHARY LACEY
% AFFILIATION : UNIVERSITY OF MARYLAND 
% EMAIL : zlacey@terpmail.umd.edu
%         zlacey1234@gmail.com
% clear workspace 
clear
clc
close all

% initializes the parameters
Config
% radius = 12;
% sigma0 = 2;
% h = 10;
% local_ind = 10;
% local_sph_IND = 10;
% Out = analyze_scan_orientations(imagefolder, imageprefix, start_image, end_image, x1,x2,y1,y2,radius,sigma0,1,local_ind,local_sph_IND,h);
%Gauss2D = single(Gaussian_Filter_2D(1,0,25));

%Gauss3D = single(Gaussian_Filter_3D(1,0,10));
[IMS, bit] = load_images(start_image, end_image, x1, x2, y1, y2, imagefolder, imageprefix);

save('ImageMatrix.mat', 'IMS');
%IMS = thresh_invert(IMS, bit, 95);

IMS = IMS > 105; % 105 if a decent value
figure
imshow(IMS(:,:,1),[])

% se = strel('disk',10);
% afterOpening = imopen(IMS,se);
% 
% figure
% imshow(afterOpening(:,:,1),[])

L = bwlabeln(IMS);

imtool(L,[])

stats = regionprops(IMS,'Centroid',...
    'MajorAxisLength','MinorAxisLength')

t = linspace(0,2*pi,50);

