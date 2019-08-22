reloc = load('../hypoDD.reloc');
loc = load('../hypoDD.loc');
% set origin
x0 = -90;
y0 = 36.35;
d2l = cos(y0/180*pi)*111.699; % degree to km

reloc_lat = reloc(:,2);
reloc_lon = reloc(:,3);
reloc_depth = -reloc(:,4);
reloc_ind = reloc(:,1);

loc_lat = loc(:,2);
loc_lon = loc(:,3);
loc_depth = -loc(:,4);
loc_ind = loc(:,1);


fid = fopen('../xyz.reloc','w');
fd = fopen('xyz_ind.reloc','w');

for i = 1:length(reloc_lat)
    
    x = d2l*(reloc_lon(i) - x0);
    y = d2l*(reloc_lat(i) - y0);
    z = reloc_depth(i);
    ind = reloc_ind(i);
    fprintf(fid,'%6.3f %6.3f %5.2f \n ', x, y, z);
    fprintf(fd,'%6.3f %6.3f %5.2f %d \n ', x, y, z, ind);
    
end
fclose(fid);
fclose(fd);


fid = fopen('../xyz.loc','w');
fd = fopen('xyz_ind.loc','w');

for i = 1:length(loc_lat)
    
    xo = d2l*(loc_lon(i) - x0);
    yo = d2l*(loc_lat(i) - y0);
    zo = loc_depth(i);
    indo = loc_ind(i);
    fprintf(fid,'%6.3f %6.3f %5.2f \n', xo, yo, zo);
    fprintf(fd,'%6.3f %6.3f %5.2f %d \n', xo, yo, zo, indo);
    
end
fclose(fid);
fclose(fd);

