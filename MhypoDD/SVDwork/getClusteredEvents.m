%%%%%%% Gather all earthquake locations %%%%%%%%%
delete('xyz_clustered.loc');
delete('xyz_clustered.ind_loc');

locList = dir('../backFile/cluster*.txt');
% relocList = dir('../hypo_SVD/*.reloc');

fd = fopen('xyz_clustered.loc','w');
for i = 1:length(locList)
    fid = fopen(['../backFile/' locList(i).name]);
    tline = fgetl(fid);
    while ischar(tline)
        fprintf(fd,[tline ' \n']);
        tline = fgetl(fid);
    end
    fclose(fid);
 end
fclose(fd);

locfile = load('xyz_clustered.loc');
lon = locfile(:,1);
lat = locfile(:,2);
depth = locfile(:,3);
ind = zeros(length(lon),1);

ind_event = load('xyz_all.ind_loc');

for i = 1:length(lon)
    a = find(ind_event == lon(i)) - length(ind_event);
    b = find(ind_event == lat(i)) - 2*length(ind_event);
    c = find(ind_event == depth(i)) - 3*length(ind_event);
    temp_ind = intersect(a,intersect(b,c)); % this is the index in origin_file
    if length(temp_ind) == 1
        ind(i) = ind_event(temp_ind,1);
    else
        if ismember(ind_event(temp_ind(1),1), ind) == 0
            ind(i) = ind_event(temp_ind(1),1);
        else
            j = 1;
            while ismember(ind_event(temp_ind(j),1), ind) == 1
                j = j+1;
            end
            ind(i) = ind_event(temp_ind(j),1);
        end
    end
end

fd = fopen('xyz_clustered.ind_loc','w');
for i = 1:length(lon)
    fprintf(fd, '%d %f %f %f \n', ind(i), lat(i), lon(i), depth(i));
end
fclose(fd);


% fd = fopen('all_events_catnccr.reloc','w');
% for i = 1:length(relocList)
%     fid = fopen(['../hypo_SVD/' relocList(i).name]);
%     tline = fgetl(fid);
%     while ischar(tline)
%         fprintf(fd,[tline ' \n']);
%         tline = fgetl(fid);
%     end
%     fclose(fid);
%  end
% fclose(fd);
