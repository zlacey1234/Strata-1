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

tic
[IMS, bit] = load_images(start_image, end_image, x1, x2, y1, y2, imagefolder, imageprefix);
save('ImageMatrix.mat', 'IMS','-v7.3');
figure
imshow(IMS(:,:,1));
IMS = IMS > 105;% 105 Best for Bead 1
               % 65 Best for Bead 2
figure
imshow(IMS(:,:,1));
%imtool(IMS(:,:,1));
[rowsIMS, colsIMS, slicesIMS] = size(IMS);
for i = 1:slicesIMS
    BW(:,:,i) = imfill(IMS(:,:,i),4,'holes');
end
figure
imshow(BW(:,:,1));

%%
se = strel('sphere', erosionRadius);   % erosion radius of 9 is very good for both large and medium beads
afterErode = imerode(BW,se);
clear IMS
figure
imshow(afterErode(:,:,1),[]);

fprintf('Done Eroding Image');
%%
disp('a_s: Tagging regions');
L=bwlabeln(afterErode);%output is an array with size of pksbw where all touching pixels in the 3d array have the same id number, an integer)
clear afterErode;
disp('a_s: Imposing Volume minimum');
Resultunf=regionprops(L,'Area');%[NOTE L is array of TAGGED regions]; creates structure Resultunf with one 1x1 matricies(in a col) that are the areas of the tagged regions (sequentially by tag #) 
idx=find([Resultunf.Area]>0);%index of all regions with nonzero area
clear Resultunf;
L2=ismember(L,idx);%output is array with size L of 1's where elements of L are in the set idx~which is just 1:number of regions. Therefore it converts all tagged regions to all 1's
clear L
%%
L3=bwlabeln(L2);% L3 now retaggs (L3=old L2)
clear L2;
fprintf('Done Tagging');
%%
disp('a_s: Determining weighted centroid locations and orientations');
s=regionprops(L3,'PixelIdxList', 'PixelList');%s is a struct that holds structs for each tagged 
clear L3;
%region. the 2nd level struct holds two matricies: pxlidlist is the linear indicies
%of the nonzero pxls in that region. pxllist is the
%coordinates of each pxl in that region. NOTE:these indicies apply to the
%bandpassed image
fprintf('Done');
%% 

% logFlag = 1;
% dateString = datestr(now,'mmmm_dd_yyyy_HH_MM_SS_FFF');
% scanSet = '/Scan_Set_1';
% folderName = 'D:\Strata-1\ResultLogs';
% %folderName = 'C:\Users\Zach\Documents\Strata-1-Zach_-New\ResultLogs';
% ExtractedPositionLog = [folderName scanSet '_PositionExtraction' dateString '.log'];

IMS = load('ImageMatrix.mat');
IMS = IMS.IMS;
IMS = IMS > 104;

Result=zeros(numel(s),11);
for k = 1:numel(s)%#elements in s (#regions or particles)
%for k = 4236
    idx = s(k).PixelIdxList;%lin index of all points in region k
    pixel_values = double(IMS(idx));%list of values of the pixels in convol which has size of idx
    sum_pixel_values = sum(pixel_values);   
    x = s(k).PixelList(:, 1);%the list of x-coords of all points in the region k WITH RESPECT TO the bandpassed image
    y = s(k).PixelList(:, 2);
    z = s(k).PixelList(:, 3);
    xbar = sum(x .* pixel_values)/sum_pixel_values;
    ybar = sum(y .* pixel_values)/sum_pixel_values;%I CUT OFF Cr OF THE IMAGE DURING BANDPASS!(in x and y only) AND cropped kernelradius/2 off each side (in x,y,z)(but it was put back)                                                         %cropped radius/2 of each side
    zbar = sum(z .* pixel_values)/sum_pixel_values;
    %Result(k,1:3) = [xbar+x1-1 ybar+y1-1 zbar+start_image-1];
    Result(k,1:3) = [xbar+x1 ybar+y1 zbar+start_image];
    Result(k,4)   = max(pixel_values);
    Result(k,5)   = sum_pixel_values;
    
    if ( logFlag )
        pFile = fopen( ExtractedPositionLog, 'a');
        
        % write csv log file
        fprintf(pFile, '%6.6f,',Result(k,1));
        fprintf(pFile, '%6.6f,',Result(k,2));
        fprintf(pFile, '%6.6f,',Result(k,3));
        fprintf(pFile, '%6.6f,',Result(k,4));
        fprintf(pFile, '%9.6f\n',Result(k,5));
        
        fclose(pFile);
    end
end
fprintf('Finished');