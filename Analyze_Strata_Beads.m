% Analyze_ Strata_Grains.m is an m-file that is intended to load the 
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
%%
% initializes the parameters
ConfigGrains

[IMS, bit] = load_images(start_image, end_image, x1, x2, y1, y2, imagefolder, imageprefix);
save('ImageMatrix.mat', 'IMS','-v7.3');
imtool(IMS(:,:,1),[]);
IMS = IMS > 104;       

%%
figure
imshow(IMS(:,:,1),[]);

se = strel('sphere', erosionRadius);   % erosion radius of 9 is very good for both large and medium beads
afterErode = imerode(IMS,se);
clear IMS
figure
imshow(afterErode(:,:,1),[]);

fprintf('Done Eroding Image');

[rowsIMS, colsIMS, slicesIMS] = size(afterErode);

for i = 1:slicesIMS
    BW(:,:,i) = imfill(afterErode(:,:,i),'holes');
    figure
    imshow(BW(:,:,i))
    title('Filled Image')
    
    figure
    imshow(afterErode(:,:,i),[]);
%     se = strel('disk', erosionRadius);
%     BW(:,:,i) = imclose(IMS(:,:,i), se);
%     figure
%     imshow(BW(:,:,i))
%     title('Imclose Image Slice i');
end