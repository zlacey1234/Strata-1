% This m-file is used to initialize the  
addpath('./Image_Processing');

imagefolder = ('D:\Strata Data\Strata1 XCT jpgs\Beads1_ImageStack\JPEGS\');
%imagefolder = ('D:\Strata Data\Strata1 XCT tifs\Beads1_ImageStack\Tiffs\');
%imagefolder = ('C:\Users\zlace\OneDrive\Documents\Strata-1 Research\Strata-1 Code\Strata-1 Image Data\Strata1 XCT jpgs\Beads1_ImageStack\JPEGS\');
imageprefix = ('Beads1');
start_image = 560;
end_image = 960;
no_images=end_image-start_image+1;
x1 = 1;
x2 = 1020;
y1 = 1;
y2 = 1041;
% x1 = 510;
% x2 = 1020;
% y1 = 1;
% y2 = 720;


logFlag = 1;
dateString = datestr(now,'mmmm_dd_yyyy_HH_MM_SS_FFF');
scanSet = '/Scan_Set_1';
folderName = 'D:\Strata-1\ResultLogs';
ExtractedPositionLog = [folderName scanSet '_PositionExtraction' dateString '.log'];


