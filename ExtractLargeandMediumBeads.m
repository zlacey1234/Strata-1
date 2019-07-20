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
LargeBeadPositionLog = [folderName file1 '_LargeBeadPosition' '.log'];

largeBeadCounter = 1;
mediumBeadCounter = 1;

largeBeadResult = zeros(numel(x),4);
mediumBeadResult = zeros(numel(x),4);
for k = 1:numel(x)
    if sumPixelAreaValue(k) >= 1e+5;
        fprintf('This Bead is Large\n');
        largeBeadResult(largeBeadCounter,1:3) = [x(k) y(k) z(k)];
        largeBeadResult(largeBeadCounter,4) = sumPixelAreaValue(k);
        
        if ( logFlag )
            pFile1 = fopen(LargeBeadPositionLog, 'a');
            
            % write csv log file
            fprintf(pFile1, '%6.6f,',largeBeadResult(largeBeadCounter,1));
            fprintf(pFile1, '%6.6f,',largeBeadResult(largeBeadCounter,2));
            fprintf(pFile1, '%6.6f,',largeBeadResult(largeBeadCounter,3));
            fprintf(pFile1, '%9.6f,',largeBeadResult(largeBeadCounter,4));
            fprintf(pFile1, '%f\n',10); % Diameter of the Bead
            
            fclose(pFile1);
        end
        
        largeBeadCounter = largeBeadCounter + 1;    
    elseif sumPixelAreaValue(k) < 7.5e+4 && sumPixelAreaValue(k) >= 1e+3
        fprintf('This Bead is Medium\n');
        mediumBeadResult(mediumBeadCounter,1:3) = [x(k) y(k) z(k)];
        mediumBeadResult(mediumBeadCounter,4) = sumPixelAreaValue(k);
        mediumBeadCounter = mediumBeadCounter + 1;
    else
        fprintf('May be a small bead\n');
    end
end


% %% Test and Visualize
% for m = 1: largeBeadCounter - 1
%     figure(m)
%     hold on
%     z_slice = round(largeBeadResult(m,3)) - 452;
%     imshow(IMS(:,:,z_slice),[]);
%     viscircles([largeBeadResult(m,1),largeBeadResult(m,2)], 64,'EdgeColor','b');
%     hold off
% end
% 
% for n = 1:20
%     figure(n + largeBeadCounter - 1)
%     hold on
%     z_slice = round(mediumBeadResult(n,3)) - 452
%     if z_slice <= 0
%         z_slice = 1;
%     end
%     imshow(IMS(:,:,z_slice),[]);
%     viscircles([mediumBeadResult(n,1),mediumBeadResult(n,2)], 32,'EdgeColor','b');
%     hold off
% end