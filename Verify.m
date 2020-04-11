% Load the combined log file
[file1,path1] = uigetfile('*.log');
file1
filepath1 = [path1 file1];

data1 = csvread(filepath1);

x = data1(:,1);
y = data1(:,2);
z = data1(:,3);
sumPixelArea = data1(:,4);
beadDiameterMeters = data1(:,5);

plotSpecifiedZSliceRangeSections = 1;
specifiedZSlice = 250;    % should be between 200 and 1800
zSliceTolerance = 30;

figure(1)
imshow(IMS(:,:,1),[])
for k = 1:numel(x)
    if (abs(specifiedZSlice - z(k)) <= zSliceTolerance)
        if (beadDiameterMeters(k) == 10)
            hold on
            xCenter = x(k);
            yCenter = y(k);
            radius = 5; % Radius of the Bead (millimeters)
            plot(xCenter,yCenter,'.r')
            
        elseif (beadDiameterMeters(k) == 5)
            hold on
            xCenter = x(k);
            yCenter = y(k);
            radius = 2.5; % Radius of the Bead (millimeters)
            plot(xCenter,yCenter,'.g')
        else
            hold on
            xCenter = x(k);
            yCenter = y(k);
            radius = 5; % Radius of the Bead (millimeters)
            plot(xCenter,yCenter,'.c')
        end
    end
end