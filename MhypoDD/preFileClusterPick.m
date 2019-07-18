reloc = load('hypoDD.reloc');
loc = load('hypoDD.loc');

reloc_lat = reloc(:,2);
reloc_lon = reloc(:,3);
reloc_depth = -reloc(:,4);

loc_lat = loc(:,2);
loc_lon = loc(:,3);
loc_depth = -loc(:,4);

fid = fopen('xyz.reloc','w');

for i = 1:length(reloc_lat)
    
    fprintf(fid,'%6.3f %6.3f %5.2f\n',...
        reloc_lat(i),reloc_lon(i),reloc_depth(i));
    
end

fid = fopen('xyz.loc','w');

for i = 1:length(loc_lat)
    
    fprintf(fid,'%6.3f %6.3f %5.2f\n',...
        loc_lat(i),loc_lon(i),loc_depth(i));
    
end