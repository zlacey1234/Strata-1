% Loading in Large, Medium, and Small Beads from csv log files
%% First File Selected should be the Large Beads
[file1,path1] = uigetfile('*.log');
file1
filepath1 = [path1 file1];

data1 = csvread(filepath1);

% Convert pixel to millimeter: 14 px/mm
largeBeadx = data1(:,2)/14;
largeBeady = data1(:,1)/14;
largeBeadz = data1(:,3)/14;
largeBeadsumPixelArea = data1(:,4);
largeBeadDiameterMillimeters = data1(:,5);

%% Second File Selected should be the Medium Beads
[file2,path2] = uigetfile('*.log');
file2
filepath2 = [path2 file2];

data2 = csvread(filepath2);

% Convert pixel to millimeter: 14 px/mm
mediumBeadx = data2(:,2)/14;
mediumBeady = data2(:,1)/14;
mediumBeadz = data2(:,3)/14;
mediumBeadsumPixelArea = data2(:,4);
mediumBeadDiameterMillimeters = data2(:,5);

%% Second File Selected should be the Small Beads
[file3,path3] = uigetfile('*.log');
file3
filepath3 = [path3 file3];

data3 = csvread(filepath3);

% Convert pixel to millimeter: 14 px/mm
smallBeadx = data3(:,2)/14;
smallBeady = data3(:,1)/14;
smallBeadz = data3(:,3)/14;
smallBeadsumPixelArea = data3(:,4);
smallBeadDiameterMillimeters = data3(:,5);
%% Loading in Parmeters
% Center of the Tubular Chamber
xCenterCylinder = 522/14;
yCenterCylinder = 536/14;
zCenterCylinder = 1020/14;

%% Customization Parameters
% Plotting Beads boolean flags
% 1: Enable Plotting of Beads
% 0: Disable Plotting of Beads
plotLargeBeads = 1; 
plotMediumBeads = 1;
plotSmallBeads = 1;

%% 3D Surface Plot
% figure(1)
% hold on
% axis equal
% if (plotLargeBeads)
%     % Convert pixel to millimeter: 14 px/mm
%     largeBeadxCenter = largeBeadx/14;
%     largeBeadyCenter = largeBeady/14;
%     largeBeadzCenter = largeBeadz/14;
%     
%     radius = 5; % Radius of the Bead (millimeters)
%     
%     [largeBeadx1,largeBeady1,largeBeadz1] = sphere;
%     largeBeadx1 = largeBeadx1*radius;
%     largeBeady1 = largeBeady1*radius;
%     largeBeadz1 = largeBeadz1*radius;
%     for i = 1:numel(largeBeadx)
%         h1 = surf(largeBeadx1 + largeBeadxCenter(i), largeBeady1 + largeBeadyCenter(i), largeBeadz1 + largeBeadzCenter(i));
%         set(h1,'FaceColor',[0.7, 0.1840, 0.2], ...
%                     'FaceAlpha', 0.5, 'FaceLighting', 'gouraud', 'EdgeColor', 'none');
%     end
% end
% if (plotSmallBeads)
%     radius = 1; % Radius of the Bead (millimeters)
%     
%     [smallBeadx1,smallBeady1,smallBeadz1] = sphere;
%     smallBeadx1 = smallBeadx1*radius;
%     smallBeady1 = smallBeady1*radius;
%     smallBeadz1 = smallBeadz1*radius;
%     for i = 1:numel(smallBeadx)
%         h1 = surf(smallBeadx1 + smallBeadxCenter(i), smallBeady1 + smallBeadyCenter(i), smallBeadz1 + smallBeadzCenter(i));
%         set(h1,'FaceColor',[0.1, 0.7, 0.460], ...
%                     'FaceAlpha', 0.5, 'FaceLighting', 'gouraud', 'EdgeColor', 'none');
%     end
% end

%% 3D Point Plot
figure(1)
hold on
axis equal
if (plotLargeBeads)
    scatter3(largeBeadx - xCenterCylinder,largeBeady - yCenterCylinder,largeBeadz - zCenterCylinder,'g.')
end
if (plotMediumBeads)
    scatter3(mediumBeadx - xCenterCylinder,mediumBeady - yCenterCylinder,mediumBeadz - zCenterCylinder, 'b.')
end
if (plotSmallBeads)
    scatter3(smallBeadx - xCenterCylinder,smallBeady - yCenterCylinder,smallBeadz - zCenterCylinder, 'r.')
end
xlabel('Position X (millimeters)','FontSize', 20);
ylabel('Position Y (millimeters)','FontSize', 20);
zlabel('Position Z (millimeters)','FontSize', 20);
legend('Large Beads', 'Medium Beads', 'Small Beads');

%% 2D XY Cross-Section Specified Z Slice 
specifiedZSlice = 1000; % In pixels
zSliceTolerance = 20; % In pixels

toleranceBoolLargeBead = abs(specifiedZSlice/14 - largeBeadz) <= zSliceTolerance/14
largeBeads = [largeBeadx largeBeady largeBeadz largeBeadDiameterMillimeters toleranceBoolLargeBead]';
colsWithZeros = any(largeBeads==0);
largeBeadsInRegion = largeBeads(:, ~colsWithZeros)';

toleranceBoolMediumBead = abs(specifiedZSlice/14 - mediumBeadz) <= zSliceTolerance/14
mediumBeads = [mediumBeadx mediumBeady mediumBeadz mediumBeadDiameterMillimeters toleranceBoolMediumBead]';
colsWithZerosMediumBeads = any(mediumBeads==0);
mediumBeadsInRegion = mediumBeads(:, ~colsWithZerosMediumBeads)';

toleranceBoolSmallBead = abs(specifiedZSlice/14 - smallBeadz) <= zSliceTolerance/14
smallBeads = [smallBeadx smallBeady smallBeadz smallBeadDiameterMillimeters toleranceBoolSmallBead]';
colsWithZerosSmallBeads = any(smallBeads==0);
smallBeadsInRegion = smallBeads(:, ~colsWithZerosSmallBeads)';

totalBeadsInRegion = [largeBeadsInRegion; mediumBeadsInRegion; smallBeadsInRegion]
beadType = [num2str(totalBeadsInRegion(:,4))];

figure(3)
hold on
axis equal
scatterhist(totalBeadsInRegion(:,1),totalBeadsInRegion(:,2),'Group',beadType,'Kernel','on');
xlabel('Position X (millimeters)','FontSize', 20);
ylabel('Position Y (millimeters)','FontSize', 20);

%% 2D XZ Cross-Section Specified Y Slice 
specifiedYSlice = 520; % In pixels
ySliceTolerance = 50; % In pixels

toleranceBoolLargeBead = abs(specifiedYSlice/14 - largeBeady) <= ySliceTolerance/14;
largeBeads = [largeBeadx largeBeady largeBeadz largeBeadDiameterMillimeters toleranceBoolLargeBead]';
colsWithZeros = any(largeBeads==0);
largeBeadsInRegion = largeBeads(:, ~colsWithZeros)';

toleranceBoolMediumBead = abs(specifiedYSlice/14 - mediumBeady) <= ySliceTolerance/14;
mediumBeads = [mediumBeadx mediumBeady mediumBeadz mediumBeadDiameterMillimeters toleranceBoolMediumBead]';
colsWithZerosMediumBeads = any(mediumBeads==0);
mediumBeadsInRegion = mediumBeads(:, ~colsWithZerosMediumBeads)';

toleranceBoolSmallBead = abs(specifiedYSlice/14 - smallBeady) <= ySliceTolerance/14;
smallBeads = [smallBeadx smallBeady smallBeadz smallBeadDiameterMillimeters toleranceBoolSmallBead]';
colsWithZerosSmallBeads = any(smallBeads==0);
smallBeadsInRegion = smallBeads(:, ~colsWithZerosSmallBeads)';

totalBeadsInRegion = [largeBeadsInRegion; mediumBeadsInRegion; smallBeadsInRegion]
beadType = [num2str(totalBeadsInRegion(:,4))];

figure(4)
hold on
axis equal
scatterhist(totalBeadsInRegion(:,1),totalBeadsInRegion(:,3),'Group',beadType,'Kernel','on');
xlabel('Position X (millimeters)','FontSize', 20);
ylabel('Position Z (millimeters)','FontSize', 20);

%% 1D Z, Radial, and Theta Variation

[thetaLargeBeads, rhoLargeBeads] = cart2pol(largeBeadx - xCenterCylinder,largeBeady - yCenterCylinder);
thetaLargeBeads = rad2deg(thetaLargeBeads);
[thetaMediumBeads, rhoMediumBeads] = cart2pol(mediumBeadx - xCenterCylinder, mediumBeady - yCenterCylinder);
thetaMediumBeads = rad2deg(thetaMediumBeads);
[thetaSmallBeads, rhoSmallBeads] = cart2pol(smallBeadx - xCenterCylinder, smallBeady - yCenterCylinder);
thetaSmallBeads = rad2deg(thetaSmallBeads);

%% Z Variation
binWidthZVariation = 10; % Bin Width Size in (mm)
edgesZVariation = 0:binWidthZVariation:140;

% Count based Z Variation
hLargeBeadsZVariation = histcounts(largeBeadz, edgesZVariation);
hMediumBeadsZVariation = histcounts(mediumBeadz, edgesZVariation);
hSmallBeadsZVariation = histcounts(smallBeadz, edgesZVariation);

figure(5)
bar(edgesZVariation(1:end-1), [hLargeBeadsZVariation; hMediumBeadsZVariation; hSmallBeadsZVariation]');
title(['Z-Variation Histogram (Bin Width ' num2str(binWidthZVariation) ' millimeters)'],'FontSize', 20);
xlabel('Z Position (millimeters)','FontSize', 20);
ylabel('Number of Beads within Bin (count)','FontSize', 20);
legend('Large Beads (10mm diameter)', 'Medium Beads (5mm diameter)', 'Small Beads (2mm diameter)'); 

% Percent based Z Variation
hLargeBeadsZVariationPercent = hLargeBeadsZVariation/numel(largeBeadz)*100;
hMediumBeadsZVariationPercent = hMediumBeadsZVariation/numel(mediumBeadz)*100;
hSmallBeadsZVariationPercent = hSmallBeadsZVariation/numel(smallBeadz)*100;

figure(6)
bar(edgesZVariation(1:end-1), [hLargeBeadsZVariationPercent; hMediumBeadsZVariationPercent; hSmallBeadsZVariationPercent]');
title(['Z-Variation Histogram in Percent(Bin Width ' num2str(binWidthZVariation) ' millimeters)'],'FontSize', 20);
xlabel('Z Position (millimeters)','FontSize', 20);
ylabel('Percent of Beads within Bin (%)','FontSize', 20);
legend('Large Beads (10mm diameter)', 'Medium Beads (5mm diameter)', 'Small Beads (2mm diameter)');
set(gca,'FontSize',20)

% Radial Variation
binWidthRhoVariation = 2;
edgesRhoVariation = 0:binWidthRhoVariation:36;
numberOfRhoBin = numel(edgesRhoVariation);

AreaRhoBins = zeros(numberOfRhoBin - 1,1);

for iteration = 1:numberOfRhoBin - 1
    AreaRhoBins(iteration) = pi.*(edgesRhoVariation(iteration +1).^2) - pi.*(edgesRhoVariation(iteration).^2);
end
   
sumArea = sum(AreaRhoBins)
% Count based Radial Variation
hLargeBeadsRhoVariation = histcounts(rhoLargeBeads, edgesRhoVariation);
hMediumBeadsRhoVariation = histcounts(rhoMediumBeads, edgesRhoVariation);
hSmallBeadsRhoVariation = histcounts(rhoSmallBeads, edgesRhoVariation);

figure(7)
bar(edgesRhoVariation(1:end-1), [hLargeBeadsRhoVariation; hMediumBeadsRhoVariation; hSmallBeadsRhoVariation]');
title(['Radial Variation Histogram (Bin Width ' num2str(binWidthRhoVariation) ' millimeters)'],'FontSize', 20);
xlabel('Radius from Z axis (millimeters)','FontSize', 20);
ylabel('Number of Beads within Bin (count)','FontSize', 20);
legend('Large Beads (10mm diameter)', 'Medium Beads (5mm diameter)', 'Small Beads (2mm diameter)');

sum(hLargeBeadsRhoVariation)

hLargeBeadsRhoVariationPercent = (hLargeBeadsRhoVariation./numel(largeBeadz).*100)%./AreaRhoBins';
hMediumBeadsRhoVariationPercent = hMediumBeadsRhoVariation./numel(mediumBeadz).*100%./AreaRhoBins';
hSmallBeadsRhoVariationPercent = hSmallBeadsRhoVariation./numel(smallBeadz).*100%./AreaRhoBins';

figure(8)
bar(edgesRhoVariation(1:end-1), [hLargeBeadsRhoVariationPercent; hMediumBeadsRhoVariationPercent; hSmallBeadsRhoVariationPercent]');
title(['Radial Variation Histogram (Bin Width ' num2str(binWidthRhoVariation) ' millimeters)'],'FontSize', 20);
xlabel('Radius from Z axis (millimeters)','FontSize', 20);
ylabel('Percent of Beads within Bin (%)','FontSize', 20);
legend('Large Beads (10mm diameter)', 'Medium Beads (5mm diameter)', 'Small Beads (2mm diameter)');
set(gca,'FontSize',20)

hLargeBeadsRhoVariationPercentPerArea = hLargeBeadsRhoVariationPercent./AreaRhoBins';
hMediumBeadsRhoVariationPercentPerArea = hMediumBeadsRhoVariationPercent./AreaRhoBins';
hSmallBeadsRhoVariationPercentPerArea = hSmallBeadsRhoVariationPercent./AreaRhoBins';

sumLargeBeadsRhoVariationPercent = sum(hLargeBeadsRhoVariationPercentPerArea)
sumMediumBeadsRhoVariationPercent = sum(hMediumBeadsRhoVariationPercentPerArea)
sumSmallBeadsRhoVariationPercent = sum(hSmallBeadsRhoVariationPercentPerArea)

figure(9)
bar(edgesRhoVariation(1:end-1), [hLargeBeadsRhoVariationPercentPerArea; hMediumBeadsRhoVariationPercentPerArea; hSmallBeadsRhoVariationPercentPerArea]');
title(['Radial Variation Histogram (Bin Width ' num2str(binWidthRhoVariation) ' millimeters)'],'FontSize', 20);
xlabel('Radius from Z axis (millimeters)','FontSize', 20);
ylabel('Percent of Beads per Area within Bin (%/mm^2)','FontSize', 20);
legend('Large Beads (10mm diameter)', 'Medium Beads (5mm diameter)', 'Small Beads (2mm diameter)');
set(gca,'FontSize',20)