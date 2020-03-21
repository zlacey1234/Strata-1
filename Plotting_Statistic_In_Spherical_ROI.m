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

%% 
largeBeads = [largeBeadx largeBeady largeBeadz largeBeadDiameterMillimeters];
mediumBeads = [mediumBeadx mediumBeady mediumBeadz mediumBeadDiameterMillimeters];
smallBeads = [smallBeadx smallBeady smallBeadz smallBeadDiameterMillimeters]; 

allBeads = [largeBeads; mediumBeads; smallBeads];
%% Neighboring Percentage in a Spherical Region of Interest Centered on Medium Beads
spherical_ROI_radius = 30; % Radius of Region of Interest (mm)

numberOfLargeBeads = numel(largeBeadx);
numberOfMediumBeads = numel(mediumBeadx);
numberOfSmallBeads = numel(smallBeadx);
numberOfBeads = numel(allBeads(:,1));

% Calculate the Percent(volume) assuming perfectly uniform distribution
volumeOfAllLargeBeads = (4/3)*pi*(5^3)*numberOfLargeBeads;
volumeOfAllMediumBeads = (4/3)*pi*(2.5^3)*numberOfMediumBeads;
volumeOfAllSmallBeads = (4./3)*pi*(1^3)*numberOfSmallBeads;

totalVolume = volumeOfAllLargeBeads + volumeOfAllMediumBeads + volumeOfAllSmallBeads;

zRange = 0:0.1:125;

percentVolumeAverageLarge = volumeOfAllLargeBeads/totalVolume*100*ones(numel(zRange),1);
percentVolumeAverageMedium = volumeOfAllMediumBeads/totalVolume*100*ones(numel(zRange),1);
percentVolumeAverageSmall = volumeOfAllSmallBeads/totalVolume*100*ones(numel(zRange),1);


% Calculate Percent (volume) within the ROI of medium 
neighboringCountStatisticsForMedium = SphericalROICount(allBeads,spherical_ROI_radius,mediumBeadx, mediumBeady, mediumBeadz, 5)

mediumBeadsWithNeighboringCountStat = [mediumBeads neighboringCountStatisticsForMedium];

totalLargeBeadVolumeSum = (4./3).*pi.*(5.^3).*neighboringCountStatisticsForMedium(:,1);
totalMediumBeadVolumeSum = (4./3).*pi.*(2.5.^3).*neighboringCountStatisticsForMedium(:,2);
totalSmallBeadVolumeSum = (4./3).*pi.*(1.^3).*neighboringCountStatisticsForMedium(:,3);

totalVolumeSum = totalLargeBeadVolumeSum + totalMediumBeadVolumeSum + totalSmallBeadVolumeSum;

percentBeadVolumeSumLarge = totalLargeBeadVolumeSum./totalVolumeSum.*100;
percentBeadVolumeSumMedium = totalMediumBeadVolumeSum./totalVolumeSum.*100;
percentBeadVolumeSumSmall = totalSmallBeadVolumeSum./totalVolumeSum.*100;

mediumBeadsWithNeighboringPercentVolumeStat = [mediumBeads percentBeadVolumeSumLarge percentBeadVolumeSumMedium percentBeadVolumeSumSmall];

% Calculate Percent (volume) within the ROI of small
neighboringCountStatisticsForSmall = SphericalROICount(allBeads,spherical_ROI_radius,smallBeadx, smallBeady, smallBeadz, 2);
smallBeadsWithNeighboringCountStat = [smallBeads neighboringCountStatisticsForSmall];

totalLargeBeadVolumeSum_Small = (4./3).*pi.*(5.^3).*neighboringCountStatisticsForSmall(:,1);
totalMediumBeadVolumeSum_Small = (4./3).*pi.*(2.5.^3).*neighboringCountStatisticsForSmall(:,2);
totalSmallBeadVolumeSum_Small = (4./3).*pi.*(1.^3).*neighboringCountStatisticsForSmall(:,3);

totalVolumeSum_Small = totalLargeBeadVolumeSum_Small + totalMediumBeadVolumeSum_Small + totalSmallBeadVolumeSum_Small;

percentBeadVolumeSumLarge_Small = totalLargeBeadVolumeSum_Small./totalVolumeSum_Small.*100;
percentBeadVolumeSumMedium_Small = totalMediumBeadVolumeSum_Small./totalVolumeSum_Small.*100;
percentBeadVolumeSumSmall_Small = totalSmallBeadVolumeSum_Small./totalVolumeSum_Small.*100;

smallBeadsWithNeighboringPercentVolumeStat = [smallBeads percentBeadVolumeSumLarge_Small percentBeadVolumeSumMedium_Small percentBeadVolumeSumSmall_Small];

% Calculate Percent (volume) within the ROI of large
neighboringCountStatisticsForLarge = SphericalROICount(allBeads,spherical_ROI_radius,largeBeadx, largeBeady, largeBeadz, 10);
largeBeadsWithNeighboringCountStat = [largeBeads neighboringCountStatisticsForLarge];

totalLargeBeadVolumeSum_Large = (4./3).*pi.*(5.^3).*neighboringCountStatisticsForLarge(:,1);
totalMediumBeadVolumeSum_Large = (4./3).*pi.*(2.5.^3).*neighboringCountStatisticsForLarge(:,2);
totalSmallBeadVolumeSum_Large = (4./3).*pi.*(1.^3).*neighboringCountStatisticsForLarge(:,3);

totalVolumeSum_Large = totalLargeBeadVolumeSum_Large + totalMediumBeadVolumeSum_Large + totalSmallBeadVolumeSum_Large;

percentBeadVolumeSumLarge_Large = totalLargeBeadVolumeSum_Large./totalVolumeSum_Large.*100;
percentBeadVolumeSumMedium_Large = totalMediumBeadVolumeSum_Large./totalVolumeSum_Large.*100;
percentBeadVolumeSumSmall_Large = totalSmallBeadVolumeSum_Large./totalVolumeSum_Large.*100;

largeBeadsWithNeighboringPercentVolumeStat = [largeBeads percentBeadVolumeSumLarge_Large percentBeadVolumeSumMedium_Large percentBeadVolumeSumSmall_Large];

%%
% NOTE: Add the Best Fit Lines on these Plots

foo = fit(zRange', percentVolumeAverageLarge, 'fourier2')
%% Plot


figure(1)
hold on
plot(zRange,percentVolumeAverageLarge,'r.');
plot(zRange,percentVolumeAverageMedium,'b.');
plot(zRange,percentVolumeAverageSmall,'g.');
scatter(mediumBeadsWithNeighboringPercentVolumeStat(:,3), mediumBeadsWithNeighboringPercentVolumeStat(:,5),'r.');
scatter(mediumBeadsWithNeighboringPercentVolumeStat(:,3), mediumBeadsWithNeighboringPercentVolumeStat(:,6),'b.');
scatter(mediumBeadsWithNeighboringPercentVolumeStat(:,3), mediumBeadsWithNeighboringPercentVolumeStat(:,7),'g.');
plot(foo)
title(['Z Variation vs Percent-Volume (' num2str(spherical_ROI_radius) ' millimeter Spherical Region of Interest Radius Around Medium Beads)'], 'FontSize', 24);
xlabel('Z Variation (mm)','FontSize', 24);
ylabel('Percent-Volume (%)','FontSize', 24);
legend({'Large Beads', 'Medium Beads', 'Small Beads'},'FontSize', 24);

figure(2)
hold on
plot(zRange,percentVolumeAverageLarge,'r.');
plot(zRange,percentVolumeAverageMedium,'b.');
plot(zRange,percentVolumeAverageSmall,'g.');
scatter(smallBeadsWithNeighboringPercentVolumeStat(:,3), smallBeadsWithNeighboringPercentVolumeStat(:,5),'r.');
scatter(smallBeadsWithNeighboringPercentVolumeStat(:,3), smallBeadsWithNeighboringPercentVolumeStat(:,6),'b.');
scatter(smallBeadsWithNeighboringPercentVolumeStat(:,3), smallBeadsWithNeighboringPercentVolumeStat(:,7),'g.');
title([ num2str(spherical_ROI_radius) ' mm Spherical ROI Radius Around Small Beads'], 'FontSize', 25);
xlabel('Z Location (mm)','FontSize', 25);
ylabel('Percent-Volume (%)','FontSize', 25);
legend({'Large Beads', 'Medium Beads', 'Small Beads'},'FontSize', 24);
set(gca,'FontSize',20)

figure(3)
hold on
plot(zRange,percentVolumeAverageLarge,'r.');
plot(zRange,percentVolumeAverageMedium,'b.');
plot(zRange,percentVolumeAverageSmall,'g.');
scatter(largeBeadsWithNeighboringPercentVolumeStat(:,3), largeBeadsWithNeighboringPercentVolumeStat(:,5),'r.');
scatter(largeBeadsWithNeighboringPercentVolumeStat(:,3), largeBeadsWithNeighboringPercentVolumeStat(:,6),'b.');
scatter(largeBeadsWithNeighboringPercentVolumeStat(:,3), largeBeadsWithNeighboringPercentVolumeStat(:,7),'g.');

title(['Z Variation vs Percent-Volume (' num2str(spherical_ROI_radius) ' millimeter Spherical Region of Interest Radius Around Large Beads)'], 'FontSize', 24);
xlabel('Z Variation (mm)','FontSize', 24);
ylabel('Percent-Volume (%)','FontSize', 24);
legend('Large Beads', 'Medium Beads', 'Small Beads');

function neighborStatistics = SphericalROICount(allBeads,spherical_ROI_radius,Beadx, Beady, Beadz, focusedBeadDiameterSize)
% Calculate Percent (volume) within the ROI of 'interested bead'
numberOfInterestedBeads = numel(Beadx);
numberOfBeads = numel(allBeads(:,1));
neighborStatistics = zeros(numberOfInterestedBeads,3);

for iteration = 1:numberOfInterestedBeads
    focusedBeadx = ones(numberOfBeads,1)*Beadx(iteration);
    differenceInX = focusedBeadx - allBeads(:,1);
    
    focusedBeady = ones(numberOfBeads,1)*Beady(iteration);
    differenceInY = focusedBeady - allBeads(:,2);
    
    focusedBeadz = ones(numberOfBeads,1)*Beadz(iteration);
    differenceInZ = focusedBeadz - allBeads(:,3);
    
    distanceBetweenBeads = sqrt(differenceInX.^2 + differenceInY.^2 + differenceInZ.^2);
    
    BoolIsBeadInROI = abs(distanceBetweenBeads) <= spherical_ROI_radius;
    
    allBeadsWithBool = [allBeads BoolIsBeadInROI]';
    colsWithZeros = any(allBeadsWithBool==0);
    allBeadsInRegion = allBeadsWithBool(:, ~colsWithZeros)';
    
    BoolIsBeadLarge = allBeadsInRegion(:,4) == 10;
    BoolIsBeadMedium = allBeadsInRegion(:,4) == 5;
    BoolIsBeadSmall = allBeadsInRegion(:,4) == 2;
    
    numberOfLargeInROI = sum(BoolIsBeadLarge);
    numberOfMediumInROI = sum(BoolIsBeadMedium); 
    numberOfSmallInROI = sum(BoolIsBeadSmall);
    
    if (focusedBeadDiameterSize == 10)
        numberOfLargeInROI = numberOfLargeInROI - 1;  
    elseif (focusedBeadDiameterSize == 5)
        numberOfMediumInROI = numberOfMediumInROI - 1;
    else
        numberOfSmallInROI = numberOfSmallInROI - 1;
    end
    
    neighborStatistics(iteration,1) = numberOfLargeInROI;
    neighborStatistics(iteration,2) = numberOfMediumInROI;
    neighborStatistics(iteration,3) = numberOfSmallInROI;
end
end