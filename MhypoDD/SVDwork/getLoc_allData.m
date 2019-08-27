%%%%%%% preSVD get Locations for all Data %%%%%%%%%

% This code is used for extracting the locations of all datapoints in the 
% study area
lat = [35.5, 37.5];
lon = [-91, -89];


% Group are determined by velocity changes (Dunn et. al, 2013) 


% Input file
phase_file = 'data_all.phase';

% Output file
loc_file = 'ori_xyz.loc';
loc_ind_file = 'ori_xyz.ind_loc';
loc_xyz = 'xyz.loc';
loc_ind_xyz = 'xyz.ind_loc';

% set origin
x0 = mean(lon);
y0 = mean(lat);
d2l = cos(y0/180*pi)*111.699; % degree to km

fid = fopen(phase_file);
fd1 = fopen(loc_file,'w');
fd2 = fopen(loc_ind_file,'w');
fd3 = fopen(loc_xyz,'w');
fd4 = fopen(loc_ind_xyz,'w');

tline = fgetl(fid);
while ischar(tline)
    
    if tline(1) == '#'
        n = length(tline);
        temp_ind = find(tline == ' ', 2, 'last');
        temp_loc_ind = find(tline == ' ', 10);
        id = str2num(tline(temp_ind(1) + 1 : temp_ind(2) - 1));
        temp_lat = str2num(tline(temp_loc_ind(7)+1 : temp_loc_ind(8)-1));
        temp_lon = str2num(tline(temp_loc_ind(8)+1 : temp_loc_ind(9)-1));
        temp_depth = str2num(tline(temp_loc_ind(9)+1 : temp_loc_ind(9)+5));
        
        if temp_lat< 37.5 & temp_lat > 35.5 & temp_lon < -89 & temp_lon > -91
            x = d2l*(temp_lon - x0);
            y = d2l*(temp_lat - y0);
            z = -temp_depth;
            fprintf(fd1, '%f %f %f \n', temp_lat, temp_lon, temp_depth);
            fprintf(fd2, '%d %f %f %f \n', id, temp_lat, temp_lon, temp_depth);
            fprintf(fd3, '%f %f %f \n', x, y, z);
            fprintf(fd4, '%d %f %f %f \n', id, x, y, z);
            
        end
        
    end
    
    tline = fgetl(fid);
end

fclose(fid);
fclose(fd1);
fclose(fd2);
fclose(fd3);
fclose(fd4);