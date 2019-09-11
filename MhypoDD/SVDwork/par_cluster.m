%%%%%%%% Partition hypocenters into clusters %%%%%%%%%%%
clear all;
delete('../clusFile/cluster*.txt');
delete('file_names.txt');
loc_file = load('xyz.loc');
ind_file = load('xyz.ind_loc');

bndr_left = floor(min(loc_file(:,2))/10)*10;
bndr_right = ceil(max(loc_file(:,2))/10)*10;
bndr_down = floor(min(loc_file(:,1))/10)*10;
bndr_up = ceil(max(loc_file(:,1))/10)*10;

nx = (bndr_right - bndr_left)/10;
ny = (bndr_up - bndr_down)/10;
nc = 0; % number of big clusters

fname = fopen('file_names.txt','w');
tnewif = 0; % total number of events written into file

for i = 1:nx
    for j = 1:ny
        % seperate study area into 10*10 square clusters area
        nc = nc + 1;
        cluster_area{nc} = [bndr_left+(i-1)*10, bndr_left+i*10, ...
            bndr_down+(j-1)*10, bndr_down+j*10];
        
        file_name = ['../clusFile/cluster' num2str(nc) '.txt'];
        %         fprintf(fname,'%s \n', file_name);
        fd = fopen(file_name, 'w');
        ne(nc) = 0; % number of events in 'nc'th cluster
        ng{nc} = 0; % number of groups in 'nc'th cluster
        
        for k = 1:size(loc_file,1)
            
            if cluster_area{nc}(1)<loc_file(k,2) & loc_file(k,2)<cluster_area{nc}(2) ...
                    & cluster_area{nc}(3)<loc_file(k,1) ...
                    & loc_file(k,1)<cluster_area{nc}(4) % seperate them into clusters
                
                ne(nc) = ne(nc)+1;
                tnewif = tnewif+1;
                cluster_loc{nc}(ne(nc),:) = loc_file(k,:);
                
                fprintf(fd, '%f %f %f \n', loc_file(k,1), ...
                    loc_file(k,2), loc_file(k,3));
            end
        end
        
        fclose(fd);
        
        if ne(nc) < 2 % maybe also the size < 70
            delete(file_name);
            nc = nc-1;
            
        elseif ne(nc) > 99
            
            clear indg;
            clear group_loc;
            clear group_area;
            clear gne_r;
            
            tnewif = tnewif-ne(nc);
            ng{nc} = 1; % number of groups in one cluster
            
            group_loc{1} = cluster_loc{nc}; % initial group in 'nc'th cluster
            group_area{1} = cluster_area{nc}; % set up a cell for the cluster has more than 100 hypocenters
            
            while ne(nc) >99
                
                % get the index of groups contains more than 99 hypocenters
                indg = find(cellfun('size',group_loc,1)>99);
                
                for l = 1:length(indg)
                    
                    ng{nc} = ng{nc}-1;
                    
                    temp_target_loc = group_loc{indg(l)};
                    temp_target_area = group_area{indg(l)};
                    
                    group_loc{indg(l)} = [];
                    group_area{indg(l)} = [];
                    
                    area_left = temp_target_area(1);
                    area_right = temp_target_area(2);
                    area_down = temp_target_area(3);
                    area_up = temp_target_area(4);
                    
                    dx = (area_right - area_left)/2;
                    dy = (area_up - area_down)/2;
                    
                    if size(group_loc,2)>1
                        for o = indg(l)+1:ng{nc}+1
                            temp_group_loc{o-indg(l)} = group_loc{o};
                            temp_group_area{o-indg(l)} = group_area{o};
                            group_loc{o}=[];
                            group_area{o}=[];
                            
                        end
                        for q = indg(l)+4:ng{nc}+4
                            group_loc{q} = temp_group_loc{q-3-indg(l)};
                            group_area{q} = temp_group_area{q-3-indg(l)};
                        end
                    end
                    
                    for m = 1:4 % seperate cluster (ne>99) into 4 groups
                        
                        ng{nc} = ng{nc}+1;
                        neg = 0; % number of events in each group
                        
                        group_area{m+indg(l)-1} = [...
                            area_left + mod(m+1,2)*dx, ...
                            area_left + (1+mod(m+1,2))*dx, ...
                            area_down + double(m<3)*dy,...
                            area_down + (1+double(m<3))*dy];
                        
                        for n = 1:size(temp_target_loc,1)
                            if group_area{m+indg(l)-1}(1)<temp_target_loc(n,2)...
                                    & group_area{m+indg(l)-1}(2)>temp_target_loc(n,2)...
                                    & group_area{m+indg(l)-1}(3)<temp_target_loc(n,1)...
                                    & group_area{m+indg(l)-1}(4)>temp_target_loc(n,1)
                                
                                neg = neg+1;
                                group_loc{m+indg(l)-1}(neg,:) = temp_target_loc(n,:);
                                
                            end
                        end
                        
                        gne_r = cellfun('size',group_loc,1);
                        ne(nc) = max(gne_r);
                        
                    end
                    
                end
                
            end
            
            grouparea{nc} = group_area;
            group{nc} = group_loc;
            
            for p = 1:ng{nc}
                
                if gne_r(p) ~= 0
                    
                    file_name = ['../clusFile/cluster' num2str(nc) '_' num2str(p) '.txt'];
                    fprintf(fname,'%s \n', file_name);
                    fdg = fopen(file_name, 'w');
                    
                    for r = 1:size(group_loc{p},1)
                        tnewif = tnewif+1;
                        fprintf(fdg, '%f %f %f \n', group_loc{p}(r,:));
                    end
                    fclose(fdg);
                    
                end
                
            end
        else
            ng{nc} = 0;
            fprintf(fname,'%s \n', file_name);
        end
        
    end
end

fclose(fname);


