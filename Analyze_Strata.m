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
Gauss2D = single(Gaussian_Filter_2D(1,0,25));

[IMS, bit] = load_images(start_image, end_image, x1, x2, y1, y2, imagefolder, imageprefix);

save('ImageMatrix.mat', 'IMS');
%IMS = thresh_invert(IMS, bit, 95);

Cr = 50;
IMSbp = single(zeros(size(IMS,1)-2*Cr,size(IMS,2)-2*Cr,no_images)); 

for b=1:no_images
    IMSbp(:,:,b)=single(bpass_jhw(IMS(:,:,b),0.5,Cr));
end
IMSCr = max(max(max(IMSbp))) - IMSbp;

[hst,bins] = hist(IMSCr(:),100);
dffs = diff(hst);
thres_val = round(bins(find(dffs < 0, 1,'last')+1));
IMSCr = IMSCr > thres_val; %thresholding value may change for different frames

%imshow(IMSCr(:,:,3),[])

% IMSFilt = jcorr3d(IMS, Gauss3D, 1);
% 
% 
% 
% tic
% [centers, radii, metric] = imfindcircles(IMSCr(:,:,3),[10 40]);
% toc
% viscircles(centers, radii,'EdgeColor','b');
testIMS = conv2(IMS,Gauss2D);
imshow(testIMS, []);