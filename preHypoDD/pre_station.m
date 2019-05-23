% To prepare station.dat file for using in hypoDD ph2dt.f
% Read file 
fid1 = fopen('station_all.dat','r');
fid2 = fopen('station.dat','w');

% Get characters
tline = fgetl(fid1);

while ischar(tline)==1
    sta_name = tline(1:4);
    if tline(7) == 'N'
        sign1 = 1;
    elseif tline(7) == 'S'
        sign1 = -1;
    else
        break
    end
    sta_lat = sign1*(str2num(tline(5:6))+str2num(tline(8:12))/60);
    if tline(17) == 'E'
        sign2 = 1;
    elseif tline(17) == 'W'
        sign2 = -1;
    else
        break
    end
    sta_log = sign2*(str2num(tline(14:16))+str2num(tline(18:22))/60);
    fprintf(fid2,'%s %6.3f %6.3f \n', sta_name, sta_lat, sta_log); 
    
    %skip a line
    fgetl(fid1);
    %continue
    tline = fgetl(fid1);
end
    

fclose(fid2);