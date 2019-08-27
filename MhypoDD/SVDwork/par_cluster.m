%%%%%%%% Partition hypocenters into clusters %%%%%%%%%%%

loc_file = load('xyz.loc');
ind_file = load('xyz.ind_loc');

bndr_left = floor(min(loc_file(:,2))/10)*10;
bndr_right = ceil(max(loc_file(:,2))/10)*10;
bndr_down = floor(min(loc_file(:,1))/10)*10;
bndr_up = ceil(max(loc_file(:,1))/10)*10;

nx = (bndr_right - bndr_left)/10;
ny = (bndr_up - bndr_down)/10;
nn = 0;
nf = 0;

for i = 1:nx
    for j = 1:ny
        temp_area = [bndr_left+(i-1)*10, bndr_left+i*10, ...
            bndr_down+(j-1)*10, bndr_down+j*10];
        nf = nf + 1;
        file_name = ['cluster' num2str(nf) '.txt'];
        fd = fopen(file_name, 'w');
        for k = 1:max(size(loc_file))
            
            if temp_area(1)<loc_file(k,2) & loc_file(k,2)<temp_area(2) ...
                    & temp_area(3)<loc_file(k,1) ...
                    & loc_file(k,1)<temp_area(4)
                nn = nn+1;
                temp_file(nn,:) = loc_file(k,:);
                fprintf(fd, '%f %f %f \n', loc_file(k,1), ...
                    loc_file(k,2), loc_file(k,3));
            end
        end
                
        fclose(fd);
        temp_s = dir(file_name);
        if temp_s.bytes == 0
            delete(file_name);
            nf = nf-1;
        end  
                
    end
end










