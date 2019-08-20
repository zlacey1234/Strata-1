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
camlight
for k = 1:numel(x)
    if (plotSpecifiedZSliceRangeSections == 1)
        if (abs(specifiedZSlice - z(k)) <= zSliceTolerance)
            if (beadDiameterMeters(k) == 10)
                hold on
                axis equal
                xCenter = x(k)/14; % Convert pixel to millimeter: 14 px/mm
                yCenter = y(k)/14;
                zCenter = z(k)/14;
                radius = 5; % Radius of the Bead (millimeters)
                
                if sumPixelArea(k) >= 1.5e+6  % Represents 2 Large Beads
                    [x1,y1,z1] = sphere;
                    x1 = x1*radius;
                    y1 = y1*radius;
                    z1 = z1*radius;
                    
                    h1 = surf(x1 + xCenter, y1 + yCenter, z1 + zCenter);
                    set(h1,'FaceColor',[0.7, 0.1840, 0.2], ...
                        'FaceAlpha', 0.5, 'FaceLighting', 'gouraud', 'EdgeColor', 'none');
                else
                    [x1,y1,z1] = sphere;
                    x1 = x1*radius;
                    y1 = y1*radius;
                    z1 = z1*radius;
                    
                    h2 = surf(x1 + xCenter, y1 + yCenter, z1 + zCenter);
                    set(h2,'FaceColor',[0.494, 0.1840, 0.5560], ...
                        'FaceAlpha', 0.5, 'FaceLighting', 'gouraud', 'EdgeColor', 'none');
                end
            elseif (beadDiameterMeters(k) == 5)
                hold on
                axis equal
                xCenter = x(k)/14; % Convert pixel to millimeter: 14 px/mm
                yCenter = y(k)/14;
                zCenter = z(k)/14;
                radius = 2.5; % Radius of the Bead (millimeters)
                
                [x1,y1,z1] = sphere;
                x1 = x1*radius;
                y1 = y1*radius;
                z1 = z1*radius;
                
                h2 = surf(x1 + xCenter, y1 + yCenter, z1 + zCenter);
                set(h2,'FaceColor',[0.2, 0.5, 0.5560], ...
                    'FaceAlpha', 0.5, 'FaceLighting', 'gouraud', 'EdgeColor', 'none');
            end
        end
    else 
        if (beadDiameterMeters(k) == 10)
            hold on
            axis equal
            xCenter = x(k)/14; % Convert pixel to millimeter: 14 px/mm
            yCenter = y(k)/14;
            zCenter = z(k)/14;
            radius = 5; % Radius of the Bead (millimeters)
            
            if sumPixelArea(k) >= 1.5e+6  % Represents 2 Large Beads
                [x1,y1,z1] = sphere;
                x1 = x1*radius;
                y1 = y1*radius;
                z1 = z1*radius;
                
                h1 = surf(x1 + xCenter, y1 + yCenter, z1 + zCenter);
                set(h1,'FaceColor',[0.7, 0.1840, 0.2], ...
                    'FaceAlpha', 0.5, 'FaceLighting', 'gouraud', 'EdgeColor', 'none');
            else
                [x1,y1,z1] = sphere;
                x1 = x1*radius;
                y1 = y1*radius;
                z1 = z1*radius;
                
                h2 = surf(x1 + xCenter, y1 + yCenter, z1 + zCenter);
                set(h2,'FaceColor',[0.494, 0.1840, 0.5560], ...
                    'FaceAlpha', 0.5, 'FaceLighting', 'gouraud', 'EdgeColor', 'none');
            end
        elseif (beadDiameterMeters(k) == 5)
            hold on
            axis equal
            xCenter = x(k)/14; % Convert pixel to millimeter: 14 px/mm
            yCenter = y(k)/14;
            zCenter = z(k)/14;
            radius = 2.5; % Radius of the Bead (millimeters)
            
            [x1,y1,z1] = sphere;
            x1 = x1*radius;
            y1 = y1*radius;
            z1 = z1*radius;
            
            h2 = surf(x1 + xCenter, y1 + yCenter, z1 + zCenter);
            set(h2,'FaceColor',[0.2, 0.5, 0.5560], ...
                'FaceAlpha', 0.5, 'FaceLighting', 'gouraud', 'EdgeColor', 'none');
        end
    end
end


