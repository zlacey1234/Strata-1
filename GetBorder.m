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
%%
[IMS, bit] = load_images(start_image, end_image, x1, x2, y1, y2, imagefolder, imageprefix);
save('ImageMatrix.mat', 'IMS');

imtool(IMS(:,:,70),[]);

IMS = IMS > 99;        % 105 is a decent value

figure
imshow(IMS(:,:,1),[]);