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

Gauss3D = single(Gaussian_Filter_3D(1,0,10));

[IMS, bit] = load_images(start_image, end_image, x1, x2, y1, y2, imagefolder, imageprefix);

save('ImageMatrix.mat', 'IMS');

IMS = thresh_invert(IMS, bit, 95);

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

%%
%Convolve
disp('a_s: Convolving... This may take a while');
Convol=single(jcorr3d(IMSbp,Gauss3D,splits));

sizekernel=size(Gauss3D);
sC=size(Convol);%convolve does change size by adding a Kernel radius on either side of all dimmensions
Convol=Convol( round(sizekernel(1)/2) : round(sC(1) - sizekernel(1)/2) ...
            ,  round(sizekernel(2)/2) : round(sC(2) - sizekernel(2)/2) ...
            ,  round(sizekernel(3)/2) : round(sC(3) - sizekernel(3)/2)  );%crops (radius of the kernel*2) in order to bring Covol back to the same dimensions as the bandpassed image
imshow(Convol(:,:,3),[])
sIMSCr=size(IMSCr); 
sC=size(Convol);
if sIMSCr~=sC
    disp('error: size of bandpassed image ~= to convolved+cropped image')
    return
end

disp('a_s: Thresholding');
%TWEAK THRESHOLD
pksbw = Convol > .95;
imshow(pksbw(:,:,1),[])