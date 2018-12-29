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

[IMS, bit] = load_images(start_image, end_image, x1, x2, y1, y2, imagefolder, imageprefix);

%IMS = thresh_invert(IMS, bit, 95);

imshow(IMS, [])

[centers, radii, metric] = imfindcircles(IMS,[25 40]);

viscircles(centers, radii,'EdgeColor','b');