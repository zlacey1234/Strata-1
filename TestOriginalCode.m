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
radius = 26/2;
sigma0 = 1;
h = 9;
local_ind = 10;
local_sph_IND = 10;
% Gauss3D = single(Gaussian_Filter_3D(1,0,10));
kx=round(2.5*radius);%these are the matrix dimesions of the box that contains the kernel
ky=round(2.5*radius);
kz=round(2.5*radius/AR_z);%AR_z=1 currently

Gauss3D = single(Gauss_sphere(radius,sigma0,kx,ky,kz,AR_z));

[IMS, bit] = load_images(start_image, end_image, x1, x2, y1, y2, imagefolder, imageprefix);

figure(1)
imshow(IMS(:,:,1),[])
title('Original Image');

save('ImageMatrix.mat', 'IMS');
IMS = thresh_invert(IMS, bit, 99);

figure(2)
imshow(IMS(:,:,1),[])
title('Threshold and Invert');

Cr = 2*radius;
IMSbp = single(zeros(size(IMS,1)-2*Cr,size(IMS,2)-2*Cr,no_images)); 

for b=1:no_images
    IMSbp(:,:,b)=single(bpass_jhw(IMS(:,:,b),0.5,Cr));
end

figure(3)
imshow(IMSbp(:,:,1),[])
title('Bandpass');

IMSCr = max(max(max(IMSbp))) - IMSbp;

figure(4)
imshow(IMSCr(:,:,1),[])
title('Cropped Image');
imtool(IMSCr(:,:,1),[])
[hst,bins] = hist(IMSCr(:),100);
dffs = diff(hst);
thres_val = round(bins(find(dffs < 0, 1,'last')+1));
IMSCr = IMSCr > thres_val; %thresholding value may change for different frames

figure(5)
imshow(IMSCr(:,:,1),[])
title('Cropped Image Threshold');

%%
%Convolve
disp('a_s: Convolving... This may take a while');
Convol=single(jcorr3d(IMSbp,Gauss3D,splits));

figure(6)
imshow(Convol(:,:,1),[])
title('Convolved Image');

% sizekernel=size(Gauss3D);
% sC=size(Convol);%convolve does change size by adding a Kernel radius on either side of all dimmensions
% Convol=Convol( round(sizekernel(1)/2) : round(sC(1) - sizekernel(1)/2) ...
%             ,  round(sizekernel(2)/2) : round(sC(2) - sizekernel(2)/2) ...
%             ,  round(sizekernel(3)/2) : round(sC(3) - sizekernel(3)/2)  );%crops (radius of the kernel*2) in order to bring Covol back to the same dimensions as the bandpassed image
% sIMSCr=size(IMSCr); 
% sC=size(Convol);
% if sIMSCr~=sC
%     disp('error: size of bandpassed image ~= to convolved+cropped image')
%     return
% end
figure
imshow(Convol(:,:,1),[])
imtool(Convol(:,:,1),[])
%% create pkswb (thresholded convolution image)
disp('a_s: Thresholding');
%TWEAK THRESHOLD
pksbw = Convol > -2;%-0.5e+1;
figure
imshow(pksbw(:,:,1),[])
%%
disp('a_s: Tagging regions');
L=bwlabeln(pksbw);%output is an array with size of pksbw where all touching pixels in the 3d array have the same id number, an integer)
disp('a_s: Imposing Volume minimum');
Resultunf=regionprops(L,'Area');%[NOTE L is array of TAGGED regions]; creates structure Resultunf with one 1x1 matricies(in a col) that are the areas of the tagged regions (sequentially by tag #) 
idx=find([Resultunf.Area]>0);%index of all regions with nonzero area
L2=ismember(L,idx);%output is array with size L of 1's where elements of L are in the set idx~which is just 1:number of regions. Therefore it converts all tagged regions to all 1's
L3=bwlabeln(L2);% L3 now retaggs (L3=old L2)
%%
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


    %NOW using the centroids(xyzbar), which are with respect to the
    %IMS (not original image), find the x,y,z lists(coords) of the points in the bandpassed img IMSCr within 1
    %physical radius of the centroid. and find priciple axes.
    %if (xbar<(2.7*radius))||(xbar>((x2-x1+1)-2.7*radius))||(ybar<(2.7*radius))||(ybar>((y2-y1+1)-2.7*radius))||(zbar<(2.7*radius+1))||(zbar>(no_images-2.7*radius-1))||(Result(k,5)<80)%last condition takes only viable(large+bright) pixel clusters
    %    disp([num2str(k) 'no Orientation found'])%THIS WILL DISPLAY FOR ALL BEADS SATISFYING CONDS(DESPITE THE FACT ITS WITHIN THE LOOP(ITS WEIRD)
    %    Result(k,6:11)=[0 0 0 0 0 0];%both orientation vects made zero
    %    continue;
        %plot(Result(:,5),Result(:,4),'.') check threshold for particle blob size
        %if particle on border, it cannot be relavant data since we have incomplete spacial information
    %end
   
    xbar = xbar - Cr; % Translate back to cropped image (now realigned with IMSCr, pksbw, convol,and IMSbp)                     
    ybar = ybar - Cr;
% k == 4236 -- debugging orientation finder
    if round(ybar)-radius<1||round(ybar)+radius>size(IMSCr,1)||round(xbar)-radius<1||round(xbar)+radius>size(IMSCr,2)||round(zbar)-radius<1||round(zbar)+radius>size(IMSCr,3)||(Result(k,5)<80)%if this true, orientation_finder wont be able to find a bead's pixel collection that fits within dimensions of IMSCr
        Result(k,6:11)=[0 0 0 0 0 0];
        continue;
    end
    Result(k,6:11)=orientation_finder_mjh(IMSCr,local_ind,local_sph_IND,xbar,ybar,zbar,radius,h);       
end  
%%   
disp('a_s: Removing leftover invalid boundary points and missing orientations');%result x y z are IN IMS
% Manually set these; at what point should there be no grains?
r= Result(:,1)<x1+radius | Result(:,1) > x2-radius;%r has size of Result and is logical
Result(r,:)=[];
r= Result(:,2)<x1+radius | Result(:,2) > y2-radius;
Result(r,:)=[];
r= Result(:,3)<20 | Result(:,3) > end_image-radius/AR_z;
Result(r,:)=[];
r= Result(:,6)==0 & Result(:,7)==0 & Result(:,8)==0 & Result(:,9)==0 & Result(:,10)==0 & Result(:,11)==0;
Result(r,:)=[];

%%
disp('a_s: DONE, the analyze_scan function has ended.');
disp('***********************************************');
%toc
out_as=Result;