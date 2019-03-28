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

[IMS, bit] = load_images(start_image, end_image, x1, x2, y1, y2, imagefolder, imageprefix);

save('ImageMatrix.mat', 'IMS');
%IMS = thresh_invert(IMS, bit, 95);

IMS = IMS > 105; % 105 if a decent value
figure
imshow(IMS(:,:,1),[])
%%
L=bwlabeln(IMS);
disp('a_s: Imposing Volume minimum');
Resultunf=regionprops(L,'Area');%[NOTE L is array of TAGGED regions]; creates structure Resultunf with one 1x1 matricies(in a col) that are the areas of the tagged regions (sequentially by tag #) 
idx=find([Resultunf.Area]>0);%index of all regions with nonzero area
L2=ismember(L,idx);%output is array with size L of 1's where elements of L are in the set idx~which is just 1:number of regions. Therefore it converts all tagged regions to all 1's
L3=bwlabeln(L2);% L3 now retaggs (L3=old L2)

disp('a_s: Determining weighted centroid locations and orientations');
s=regionprops(L3,'PixelIdxList', 'PixelList');%s is a struct that holds structs for each tagged 
%region. the 2nd level struct holds two matricies: pxlidlist is the linear indicies
%of the nonzero pxls in that region. pxllist is the
%coordinates of each pxl in that region. NOTE:these indicies apply to the
%bandpassed image
%% 
Result=zeros(numel(s),11);
for k = 1:numel(s);%#elements in s (#regions or particles)
%for k = 4236
    idx = s(k).PixelIdxList;%lin index of all points in region k
    pixel_values = double(Convol(idx)+.0001);%list of values of the pixels in convol which has size of idx
    sum_pixel_values = sum(pixel_values);   
    x = s(k).PixelList(:, 1);%the list of x-coords of all points in the region k WITH RESPECT TO the bandpassed image
    y = s(k).PixelList(:, 2);
    z = s(k).PixelList(:, 3);
    xbar = sum(x .* pixel_values)/sum_pixel_values + Cr-1;%PLUS Cr BECAUSE
    ybar = sum(y .* pixel_values)/sum_pixel_values + Cr-1;%I CUT OFF Cr OF THE IMAGE DURING BANDPASS!(in x and y only) AND cropped kernelradius/2 off each side (in x,y,z)(but it was put back)                                                         %cropped radius/2 of each side
    zbar = sum(z .* pixel_values)/sum_pixel_values     -1;
%     x2moment = sum((x - xbar + Cr).^2 .* pixel_values) / sum_pixel_values;%+2*radius is added to translate the x coord(ie xbar has already been translated)
%     y2moment = sum((y - ybar + Cr).^2 .* pixel_values) / sum_pixel_values;%these are with respto the translated image(ie the original IMS)
%     z2moment = sum((z - zbar).^2 .* pixel_values) / sum_pixel_values;%the pixelvalues and sum of pixvalues are taken from the corresponding points in the bandpassed image. only the location has been translated
%     x3moment = sum((x - xbar + Cr).^3 .* pixel_values) / sum_pixel_values;
%     y3moment = sum((y - ybar + Cr).^3 .* pixel_values) / sum_pixel_values;
%     z3moment = sum((z - zbar).^3 .* pixel_values) / sum_pixel_values;
%     xskew = x3moment/(x2moment)^(1.5);
%     yskew = y3moment/(y2moment)^(1.5);
%     zskew = z3moment/(z2moment)^(1.5);
    Result(k,1:3) = [xbar+x1-1 ybar+y1-1 zbar+start_image-1];
    Result(k,4)   = max(pixel_values);
    Result(k,5)   = sum_pixel_values;
    %Result(k,6:8) = zeros(1,3);%[xskew yskew zskew];
    %Result(k,9:11)=zeros(1,3);
end