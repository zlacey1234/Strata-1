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
IMS = IMS > 104;        % 53 Good for Grain1; 16 Good for Grain2
%%
figure
imshow(IMS(:,:,1),[]);

[rowsIMS, colsIMS, slicesIMS] = size(IMS);
tic
% afterErode = imageProcessing(IMS,slicesIMS);
for i = 1:slicesIMS
    se = strel('disk', 2);   % erosion radius of 9 is very good for both large and medium beads
    afterErode(:,:,i) = imerode(BW(:,:,i),se);
    
    BW(:,:,i) = imfill(IMS(:,:,i),'holes');
    figure
    imshow(BW(:,:,i))
    title('Filled Image')
    
    se = strel('square', 2);   % erosion radius of 9 is very good for both large and medium beads
    afterErode(:,:,i) = imerode(BW(:,:,i),se);
    
    figure
    imshow(afterErode(:,:,i),[]);
%     se = strel('disk', erosionRadius);
%     BW(:,:,i) = imclose(IMS(:,:,i), se);
%     figure
%     imshow(BW(:,:,i))
%     title('Imclose Image Slice i');
end
disp(toc)
% BW2 = imfill(IMS,'holes');
% figure
% imshow(BW2(:,:,1))
% title('Filled Image')
% 
% se = strel('sphere', erosionRadius);   % erosion radius of 9 is very good for both large and medium beads
% afterErode = imerode(BW2,se);
% 
% figure
% imshow(afterErode(:,:,1),[]);

% function afterErode = imageProcessing(IMS, slicesIMS)
% for i = 1:slicesIMS
%     BW(:,:,i) = imfill(IMS(:,:,i),'holes');
%     figure
%     imshow(BW(:,:,i))
%     title('Filled Image')
%     
%     se = strel('square', 2);   % erosion radius of 9 is very good for both large and medium beads
%     afterErode(:,:,i) = imerode(BW(:,:,i),se);
%     
%     figure
%     imshow(afterErode(:,:,i),[]);
% %     se = strel('disk', erosionRadius);
% %     BW(:,:,i) = imclose(IMS(:,:,i), se);
% %     figure
% %     imshow(BW(:,:,i))
% %     title('Imclose Image Slice i');
% end
% end