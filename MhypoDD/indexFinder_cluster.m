%%%%%% Index finder %%%%%%
% This code is used for searching the index events that are from a specific cluster. 
% The cluster is generated by picking clusters manully using the OADC code.

% Input file: target cluster
cluster_file = '/Users/yixinzhang/Desktop/test_HYPODD/Data_2000_2019/SVD/clusFile/cluster5_1.txt';
cluster_ind_file = 'xyz_ind.reloc';
% Input file: original data file with index
% origin_file = '../hypoDD.reloc';
% Input file: phase files
ori_phase_file = '../data_all.phase';
% Input file: cc files
ori_cc_file = '../dt_all.cc';

% Output file: Index numbers
% 'index_cluster1.txt'
% phase files
phase_file = 'cluster5_1.phase';
% cc files
cc_file = 'cluster5_1.cc';
% location file
loc_file = 'cluster5_1.loc';

% Default parameters (from preFileClusterPick.m) 
x0 = -90;
y0 = 36.35;
d2l = cos(y0/180)*111.699;

% Get event information
event = load(cluster_file);
ind_event = load(cluster_ind_file); 
% ori_event = load(origin_file);

elon = event(:,1);%./d2l + x0;
elat = event(:,2);%./d2l + y0;
edepth = event(:,3);%-event(:,3);
ind = zeros(length(elon),1);

for i = 1:length(elon)
    a = find(ind_event == elon(i)) ;
    b = find(ind_event == elat(i)) - length(ind_event);
    c = find(ind_event == edepth(i)) - 2*length(ind_event);
    ind(i) = intersect(a,intersect(b,c)); % this is the index in origin_file 
end


fid = fopen(ori_phase_file);
fd = fopen(phase_file,'w');
fd1 = fopen(loc_file,'w');

tline = fgetl(fid);
while ischar(tline)
    
    if tline(1) == '#'
        n = length(tline);
        temp_ind = find(tline == ' ', 2, 'last');
        id = str2num(tline(temp_ind(1) + 1 : temp_ind(2) - 1));
        
        if ismember(id, ind) == 1
            fprintf(fd, [tline '\n']);
            temp_loc_ind = find(tline == ' ', 10);
            temp_lat = str2num(tline(lat_ind(7)+1 : lat_ind(8)-1));
            temp_lon = str2num(tline(lat_ind(8)+1 : lat_ind(9)-1));
            temp_depth = str2num(tline(lat_ind(9)+1 : lat_ind(9)+5));
            fprintf(fd1, '%d %f %f %f \n', id, temp_lat, temp_lon, temp_depth);
            tline = fgetl(fid);
            
            while tline(1) ~= '#'
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
% 
% fid = fopen(ori_cc_file);
% fd = fopen(cc_file,'w');
% 
% tline = fgetl(fid);
% while ischar(tline)
%     
%     if tline(1) == '#'
%         n = length(tline);
%         temp_ind = find(tline == ' ', 2);
%         id = str2num(tline(temp_ind(1) + 1 : temp_ind(2) - 1));
%         
%         if ismember(id, ind) == 1
%             fprintf(fd, [tline '\n']);
%             tline = fgetl(fid);
%             
%             while tline(1) ~= '#'
%                 fprintf(fd, [tline '\n']);
%                 tline = fgetl(fid);
%             end
%             
%         else
%             tline = fgetl(fid);
%         end
%         
%     else
%         tline = fgetl(fid);
%     end
% end
% 
% fclose(fid);
% fclose(fd);
%     






