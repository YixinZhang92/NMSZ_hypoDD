% study area
lat = [35.5, 37.5];
lon = [-91, -89];
% set origin
x0 = mean(lon);
y0 = mean(lat);
d2l = cos(y0/180*pi)*111.699; % degree to km


delete('xyz_SVDcat.loc');
delete('xyz_SVDcat.ind_loc');
delete('xyz_SVDcat.reloc');
delete('xyz_SVDcat.ind_reloc');

locList = dir('../hypo_SVD/cat/cluster*.loc');
relocList = dir('../hypo_SVD/cat/cluster*.reloc');

fd1 = fopen('xyz_SVDcat.loc','w');
fd2 = fopen('xyz_SVDcat.ind_loc','w');
for i = 1:length(locList)
    fid = load(['../hypo_SVD/cat/' locList(i).name]);
    for j = 1:size(fid,1)
        x = d2l*(fid(j,3) - x0);
        y = d2l*(fid(j,2) - y0);
        z = -fid(j,4);
        id = fid(j,1);
        fprintf(fd1, '%f %f %f \n', x, y, z);
        fprintf(fd2, '%d %f %f %f \n', id, x, y, z);
    end
end
fclose(fd1);
fclose(fd2);

fd1 = fopen('xyz_SVDcat.reloc','w');
fd2 = fopen('xyz_SVDcat.ind_reloc','w');
for i = 1:length(relocList)
    fid = load(['../hypo_SVD/cat/' relocList(i).name]);
    for j = 1:size(fid,1)
        x = d2l*(fid(j,3) - x0);
        y = d2l*(fid(j,2) - y0);
        z = -fid(j,4);
        id = fid(j,1);
        fprintf(fd1, '%f %f %f \n', x, y, z);
        fprintf(fd2, '%d %f %f %f \n', id, x, y, z);
    end
end
fclose(fd1);
fclose(fd2);
