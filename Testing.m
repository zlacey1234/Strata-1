Config
start_image = 264;
end_image = 264;
no_images=end_image-start_image+1;
radius = 50;
x1 = 1;
x2 = 1020;
y1 = 1;
y2 = 1041;

[IMS, bit] = load_images(start_image, end_image, x1, x2, y1, y2, imagefolder, imageprefix);
%%

IMS = thresh_invert(IMS, bit, 95);
figure;
imshow(IMS,[]);

Cr=2*radius;%the amount that the original image is cropped by in x and y on either side by the bandpass
IMSbp=single(zeros(size(IMS,1)-2*Cr,size(IMS,2)-2*Cr,no_images));
disp('a_s: Band-filtering all images');
for b=1:no_images
    IMSbp(:,:,b)=single(bpass_jhw(IMS(:,:,b),0,Cr));
end
IMSCr=max(max(max(IMSbp)))-IMSbp;
%% create IMSCr (thresholded bandpassed image)
%IMSCr is an inverted copy of the bandpassed img since IMSbp gets convolved
%IMSCr has a two-peaked disribution; one that corresponds to the bright
%background and one that corresponds to dark solid grains; the threshold is
%determined by locating the local minima between those two peaks
[hst,bins] = hist(IMSCr(:),100);
dffs = diff(hst);
thres_val = round(bins(find(dffs < 0, 1,'last')+1));
IMSCr = IMSCr > thres_val; %thresholding value may change for different frames
imshow(IMSCr,[]);