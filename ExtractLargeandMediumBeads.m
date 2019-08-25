
clear
close all
clc
%%
IMS = load('ImageMatrixFull.mat');
IMS = IMS.IMS;
IMS = IMS > 105;
%%
[file1,path1] = uigetfile('*.log');
file1
filepath1 = [path1 file1];

data1 = csvread(filepath1);

% parse out
x = data1(:,1);
y = data1(:,2);
z = data1(:,3);
maxPixelValue = data1(:,4);
sumPixelAreaValue = data1(:,5);


logFlag = 1;
folderName = 'D:\Strata-1\ResultLogs\LargeandMediumBeadScanLog\';
% folderName = 'C:\Users\Zach\Documents\Strata-1-Zach_-New\ResultLogs\LargeandMediumBeadScanLog\';
LargeBeadPositionLog = [folderName file1 '_LargeBeadPosition' '.log'];
MediumBeadPositionLog = [folderName file1 '_MediumBeadPosition' '.log'];
SmallBeadPositionLog = [folderName file1 '_SmallBeadPosition' '.log'];

largeBeadCounter = 1;
mediumBeadCounter = 1;
smallBeadCounter = 1;

largeBeadResult = zeros(numel(x),5);
mediumBeadResult = zeros(numel(x),5);
smallBeadResult = zeros(numel(x),5);
tic
for k = 1:numel(x)
    imageSizeX = 1020;
    imageSizeY = 1041;
    [columnsInImage rowsInImage] = meshgrid(1:imageSizeX, 1:imageSizeY);
    % Erosion = 6: sumPixelAreaValue(k) >= 8.5e+5
    % Erosion = 9: sumPixelAreaValue(k) >= 
    if sumPixelAreaValue(k) >= 8.5e+5;
        fprintf('This Bead is Large\n');
        largeBeadResult(largeBeadCounter,1:3) = [x(k) y(k) z(k)];
        largeBeadResult(largeBeadCounter,4) = sumPixelAreaValue(k);
        
        z_slice_LargeBeads = round(smallBeadResult(largeBeadCounter,3)) - 160;
        centerXLargeBead = round(smallBeadResult(largeBeadCounter,1));
        centerYLargeBead = round(smallBeadResult(largeBeadCounter,2));
        
        radius = 50;
        L = (rowsInImage - centerYLargeBead).^2 ...
            + (columnsInImage - centerXLargeBead).^2 <= radius.^2;
        
        Resultunf=regionprops(L,IMS(:,:,z_slice_LargeBeads),'Area');
        s=regionprops(L,'PixelIdxList', 'PixelList');
        
        idx = s.PixelIdxList + (z_slice_LargeBeads)*1020*1041;%lin index of all points in region k
        pixel_values = double(IMS(idx));
        sum_pixel_values = sum(pixel_values);
        largeBeadResult(largeBeadCounter,5) = (sum_pixel_values/numel(idx))*100;
        if ( logFlag )
            pFile1 = fopen(LargeBeadPositionLog, 'a');
            
            % write csv log file
            fprintf(pFile1, '%6.6f,',largeBeadResult(largeBeadCounter,1));
            fprintf(pFile1, '%6.6f,',largeBeadResult(largeBeadCounter,2));
            fprintf(pFile1, '%6.6f,',largeBeadResult(largeBeadCounter,3));
            fprintf(pFile1, '%9.6f,',largeBeadResult(largeBeadCounter,4));
            fprintf(pFile1, '%6.6f,',10); % Diameter of the Bead
            fprintf(pFile1, '%6.6f\n',largeBeadResult(largeBeadCounter,5)); % Diameter of the Bead
            
            fclose(pFile1);
        end
        largeBeadCounter = largeBeadCounter + 1;    
    
    % Erosion = 6: sumPixelAreaValue(k) < 5e+5 && sumPixelAreaValue(k) >= 7.7e+4
    % Erosion = 9: sumPixelAreaValue(k) < 1e+5 && sumPixelAreaValue(k) >= 5e+4
    elseif sumPixelAreaValue(k) < 1e+5 && sumPixelAreaValue(k) >= 5e+4
        fprintf('This Bead is Medium\n');
        mediumBeadResult(mediumBeadCounter,1:3) = [x(k) y(k) z(k)];
        mediumBeadResult(mediumBeadCounter,4) = sumPixelAreaValue(k);
                
        if ( logFlag )
            pFile2 = fopen(MediumBeadPositionLog, 'a');
            
            % write csv log file
            fprintf(pFile2, '%6.6f,',mediumBeadResult(mediumBeadCounter,1));
            fprintf(pFile2, '%6.6f,',mediumBeadResult(mediumBeadCounter,2));
            fprintf(pFile2, '%6.6f,',mediumBeadResult(mediumBeadCounter,3));
            fprintf(pFile2, '%9.6f,',mediumBeadResult(mediumBeadCounter,4));
            fprintf(pFile2, '%f\n',5); % Diameter of the Bead
            
            fclose(pFile2);
        end
        mediumBeadCounter = mediumBeadCounter + 1;
    
    % Erosion = 6: sumPixelAreaValue(k) < 9e+3 && sumPixelAreaValue(k) > 600
    % Erosion = 9: sumPixelAreaValue(k) < 5e+3 && sumPixelAreaValue(k) > 20
    elseif sumPixelAreaValue(k) < 5e+3 && sumPixelAreaValue(k) > 20
        fprintf('May be a small bead\n');
        smallBeadResult(smallBeadCounter,1:3) = [x(k) y(k) z(k)];
        smallBeadResult(smallBeadCounter,4) = sumPixelAreaValue(k);
        
        if ( logFlag )
            pFile3 = fopen(SmallBeadPositionLog, 'a');
            
            % write csv log file
            fprintf(pFile3, '%6.6f,',smallBeadResult(smallBeadCounter,1));
            fprintf(pFile3, '%6.6f,',smallBeadResult(smallBeadCounter,2));
            fprintf(pFile3, '%6.6f,',smallBeadResult(smallBeadCounter,3));
            fprintf(pFile3, '%9.6f,',smallBeadResult(smallBeadCounter,4));
            fprintf(pFile3, '%f\n',2); % Diameter of the Bead
            
            fclose(pFile3);
        end
        
        smallBeadCounter = smallBeadCounter + 1;
    end
end
disp(toc)
% 
% %%
% m1 = 1;
% m2 = 2;
% for m = m1: m2
%     figure(m)
%     hold on
%     z_slice = round(largeBeadResult(m,3)) - 160;
%     imshow(IMS(:,:,z_slice),[]);
%     viscircles([largeBeadResult(m,1),largeBeadResult(m,2)], 64,'EdgeColor','b');
%     hold off
% end
% % 
%  %% Test
% n1 = 9;
% n2 = 17;
% for n = n1:n2
%     figure(n)
%     hold on
%     z_slice = round(mediumBeadResult(n,3)) - 160
%     if z_slice <= 0
%         z_slice = 1;
%     end
%     imshow(IMS(:,:,z_slice),[]);
%     viscircles([mediumBeadResult(n,1),mediumBeadResult(n,2)], 35,'EdgeColor','b');
%     hold off
% end

% %% Test
% zDesired = 250;
% ztolerance = 30;
% figure(5)
%     z_slice = zDesired - 160;
%     imshow(IMS(:,:,z_slice),[]);
% for n = 1:mediumBeadCounter
%     hold on
%     if (abs(zDesired - mediumBeadResult(n,3)) <= ztolerance)
%         viscircles([mediumBeadResult(n,1),mediumBeadResult(n,2)], 32,'EdgeColor','b');
%     end
% end
% % 
%% Test Small
o1 = 6433;
o2 = 6434;
for o = o1:o2
    figure(o)
    hold on
    z_slice = round(smallBeadResult(o,3)) - 160;
    if z_slice <= 0
        z_slice = 1;
    end
    imshow(IMS(:,:,z_slice),[]);
    viscircles([smallBeadResult(o,1),smallBeadResult(o,2)], 14,'EdgeColor','b');
    hold off
end
% 
% %% Test
% zDesired = 220;
% ztolerance = 14;
% figure(5)
%     z_slice = zDesired - 160;
%     imshow(IMS(:,:,z_slice),[]);
% for n = 1:smallBeadCounter
%     hold on
%     if (abs(zDesired - smallBeadResult(n,3)) <= ztolerance)
%         viscircles([smallBeadResult(n,1),smallBeadResult(n,2)], 14,'EdgeColor','b');
%     end
% end

% %%
%                 
% p1 = 1;
% p2 = 250;
% percentAccuracy = zeros(250,1);
% for p = p1:p2
%     z_slice = round(smallBeadResult(p,3)) - 160;
%     centerX = round(smallBeadResult(p,1));
%     centerY = round(smallBeadResult(p,2));
%     
%     imageSizeX = 1020;
%     imageSizeY = 1041;
%     [columnsInImage rowsInImage] = meshgrid(1:imageSizeX, 1:imageSizeY);
%     % Next create the circle in the image.
%     radius = 14;
%     L = (rowsInImage - centerY).^2 ...
%         + (columnsInImage - centerX).^2 <= radius.^2;
% 
%     Resultunf=regionprops(L,IMS(:,:,z_slice),'Area');
%     s=regionprops(L,'PixelIdxList', 'PixelList');
%     
% %     for k = 1:numel(s)
%         idx = s.PixelIdxList + (z_slice)*1020*1041;%lin index of all points in region k
%         pixel_values = double(IMS(idx));
%         sum_pixel_values = sum(pixel_values);
%         percentAccuracy(p) = (sum_pixel_values/numel(idx))*100;
% %     end
%     
%     
% end    

