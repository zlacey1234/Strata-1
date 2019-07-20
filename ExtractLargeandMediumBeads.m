[file1,path1] = uigetfile('*.log');
file1
filepath1 = [path1 file1 ];
data1 = csvread(filepath1);

% parse out
x = data1(:,1);
y = data1(:,2);
z = data1(:,3);
maxPixelValue = data1(:,4);
sumPixelAreaValue = data1(:,5);

largeBeadCounter = 1;
mediumBeadCounter = 1;

largeBeadResult = zeros(numel(x),3);
mediumBeadResult = zeros(numel(x),3);
for k = 1:numel(x)
    if sumPixelAreaValue(k) >= 1e+5;
        fprintf('This Bead is Large\n');
        largeBeadResult(largeBeadCounter,1:3) = [x(k) y(k) z(k)];
        largeBeadCounter = largeBeadCounter + 1;
    elseif sumPixelAreaValue(k) < 1e+5 && sumPixelAreaValue(k) >= 1e+3
        fprintf('This Bead is Medium\n');
        mediumBeadResult(mediumBeadCounter,1:3) = [x(k) y(k) z(k)];
        mediumBeadCounter = mediumBeadCounter + 1;
    else
        fprintf('May be a small bead\n');
    end
end
