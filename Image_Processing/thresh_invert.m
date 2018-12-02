function new_image_stack = thresh_invert(image_stack, bit, percent)
% This is a function  that essentially loads the images and stores them 
% into a Three-Dimensional Array (or Matrix)
%
% INPUTS:
%    image_stack: This is the 3D Matrix (Image Stack) that we would like to
%                 threshold. 
%          
% OUTPUTS:
%    new_image_stack: This is the new 3D Matrix (Image Stack) after we 
%                     use thresholding technique.
%
% AUTHOR: ZACHARY LACEY
% AFFILIATION : UNIVERSITY OF MARYLAND 
% EMAIL : zlacey@terpmail.umd.edu
%         zlacey1234@gmail.com

thresh = prctile(image_stack(:), percent);
image_stack(image_stack > thresh) = thresh;
new_image_stack = 2^bit-1-image_stack;
