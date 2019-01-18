fid = fopen('Bead.STL','r');
if fid == -1
    error('Error opening stl file');
end

%%


fclose(fid);
