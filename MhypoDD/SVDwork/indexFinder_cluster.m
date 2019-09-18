%%%%%% Index finder %%%%%%
% This code is used for searching the index events that are from a specific cluster.
% The cluster is generated by picking clusters manully using the OADC code.
clear all;


% Input file: target cluster
cluster_list = '/Users/yixinzhang/Desktop/test_HYPODD/Data_2000_2019/SVD/genLoc/clusterList.txt';

fd = fopen(cluster_list);
tline = fgetl(fd);
nfile = 0; % number of cluster files
while ischar(tline)
    nfile = nfile+1;
    cluster_file{nfile} = ['../File/' tline ];
    [filepath,name,ext] = fileparts(tline);
    phase_file{nfile} = ['../File/' name '.phase']; % Output files: phase files
    cc_file{nfile} = ['../File/' name '.ccr']; % Output files: cc files
    loc_file{nfile} = ['../File/' name '.ori_loc']; % Output files: location file
    tline = fgetl(fd);
end
fclose(fd);

cluster_ind_file = 'xyz.ind_reloc';

% Input file: original data file with index
% origin_file = 'ori_xyz.ind_loc';
% location with index
ind_event = load('xyz.ind_loc');

% Input file: phase files
ori_phase_file = 'data_all.phase';
% Input file: cc files
ori_cc_file = '/Users/yixinzhang/Desktop/test_HYPODD/Data_2000_2019/LSQR/CCORR/2000_2019/dt_all.cc';

% Output file: Index numbers
% 'index_cluster1.txt'


% Default parameters (from preFileClusterPick.m)
% study area
lat = [35.5, 37.5];
lon = [-91, -89];
% set origin
x0 = mean(lon);
y0 = mean(lat);
d2l = cos(y0/180*pi)*111.699; % degree to km

for e = 1:nfile
    % Get event information
    event = load(cluster_file{e});
    % ind_event = load(cluster_ind_file);
    % ori_event = load(origin_file);
    
    elon = event(:,1);%./d2l + x0;
    elat = event(:,2);%./d2l + y0;
    edepth = event(:,3);%-event(:,3);
    eind{e} = zeros(length(elon),1);
    
    for i = 1:length(elon)
        a = find(ind_event == elon(i)) - length(ind_event);
        b = find(ind_event == elat(i)) - 2*length(ind_event);
        c = find(ind_event == edepth(i)) - 3*length(ind_event);
        temp_ind = intersect(a,intersect(b,c)); % this is the index in origin_file
        if length(temp_ind) == 1
            eind{e}(i) = ind_event(temp_ind,1);
        else
            if ismember(ind_event(temp_ind(1),1), eind{e}(i)) == 0
                eind{e}(i) = ind_event(temp_ind(1),1);
            else
                j = 1;
                while ismember(ind_event(temp_ind(j),1), eind{e}(i)) == 1
                    j = j+1;
                end
                eind{e}(i) = ind_event(temp_ind(j),1);
            end
        end
    end
        
    clear temp_ind;
    
    fid = fopen(ori_phase_file);
    fd = fopen(phase_file{e},'w');
    fd1 = fopen(loc_file{e},'w');
    
    tline = fgetl(fid);
    while ischar(tline)
        
        if tline(1) == '#'
            n = length(tline);
            temp_ind = find(tline == ' ', 2, 'last');
            id = str2num(tline(temp_ind(1) + 1 : temp_ind(2) - 1));
            
            if ismember(id, eind{e}) == 1
                fprintf(fd, [tline '\n']);
                temp_loc_ind = find(tline == ' ', 9);
                temp_lat = str2num(tline(temp_loc_ind(7)+1 : temp_loc_ind(8)-1));
                temp_lon = str2num(tline(temp_loc_ind(8)+1 : temp_loc_ind(9)-1));
                temp_depth = str2num(tline(temp_loc_ind(9)+1 : temp_loc_ind(9)+5));
                fprintf(fd1, '%d %f %f %f \n', id, temp_lat, temp_lon, temp_depth);
                tline = fgetl(fid);
                
                while tline(1) ~= '#' & ischar(tline)
                    fprintf(fd, [tline '\n']);
                    tline = fgetl(fid);
                end
                
            else
                tline = fgetl(fid);
            end
            
        else
            tline = fgetl(fid);
        end
    end
    
    fclose(fid);
    fclose(fd);
%     fclose(fd1);
    
    fid = fopen(ori_cc_file);
    fd = fopen(cc_file{e},'w');
    
    tline = fgetl(fid);
    while ischar(tline)
        
        if tline(1) == '#'
            n = length(tline);
            temp_ind = find(tline == ' ', 2);
            id = str2num(tline(temp_ind(1) + 1 : temp_ind(2) - 1));
            
            if ismember(id, eind{e}) == 1
                fprintf(fd, [tline '\n']);
                tline = fgetl(fid);
                
                while tline(1) ~= '#' & ischar(tline)
                    fprintf(fd, [tline '\n']);
                    tline = fgetl(fid);
                end
                
            else
                tline = fgetl(fid);
            end
            
        else
            tline = fgetl(fid);
        end
    end
    
    
    
    fclose(fid);
    fclose(fd);
    
end




