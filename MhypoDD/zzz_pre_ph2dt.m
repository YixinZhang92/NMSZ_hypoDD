% get phase data from arc files for input to ph2dt
datadir='/Volumes/Untitled/Data/2000/Loc';
fd=fopen('data_2000.pha','w');
fp=fopen('/Volumes/Untitled/Event_list/2000.txt');
wt=[1.0 0.5 0.2 0.1];

id=0;
while 1
fn=fgetl(fp);
n=length(fn)-1;
if ~ischar(fn), break, end
fname=[datadir fn fn(1:n) '.arc'];
fid=fopen(fname);
id=id+1;
lat_sign=1;lon_sign=1;

%work on first line
tline = fgetl(fid);
if ~ischar(tline), break, end
if tline(15) == ' ',tline(15) ='0';end
if tline(22) == ' ',tline(22) ='0';end
if tline(30) == ' ',tline(30) ='0';end
if tline(35) == ' ',tline(35) ='0';end
if tline(50) == ' ',tline(50) ='0';end
if tline(59) == ' ',tline(59) ='0';end
if tline(68) == ' ',tline(68) ='0';end
if tline(77) == ' ',tline(77) ='0';end
if tline(19) == 'S',lat_sign=-1;end
if tline(27) == 'W',lon_sign=-1;end
lat=str2num(tline(17:18))+(str2num([tline(20:21) '.' tline(22:23)])/60.0);
lon=str2num(tline(24:26))+(str2num([tline(28:29) '.' tline(30:31)])/60.0);
lat=lat*lat_sign; lon=lon*lon_sign;
depth=str2num([tline(32:34) '.' tline(35:36)]);
yr=tline(1:4);mo=tline(5:6);day=tline(7:8);hr=tline(9:10);mn=tline(11:12);sec=[tline(13:14) '.' tline(15:16)];
ohr=str2num(hr);omn=str2num(mn);osec=str2num(sec);
otime=(ohr*60*60)+(omn*60)+osec;		%origin time in seconds
fprintf(fd,'# %s %s %s %s %s %s %6.3f %6.3f %5.2f ',yr,mo,day,hr,mn,sec,lat,lon,depth);
mag=[tline(37) '.' tline(38)];if mag(3) == ' ',mag(3)='0';end
eh1=str2num([tline(57:58) '.' tline(59:60)]);
eh2=str2num([tline(66:67) '.' tline(68:69)]);
eh3=str2num([tline(75:76) '.' tline(77:78)]);
eh=max(eh1,eh2)/1.87;ez=eh3/1.87;
rms=[tline(48:49) '.' tline(50:51)];
fprintf(fd,'%s %4.2f %4.2f %s %d \n',mag,eh,ez,rms,id);
%now work on station lines
while 1
    tline = fgetl(fid);
    if ~ischar(tline), break, end
    if isempty(tline),break,end
    if tline(1:2) == 'C*',continue,end 
    if tline(1) == ' ',continue,end
if tline(23) == ' ',tline(23) ='0';end
if tline(21) == '.',tline(21) ='0';end
if tline(35) == ' ',tline(35) ='0';end
    sta=tline(1:4);
    if tline(8) == ' ',continue,end
    if tline(8) ~= '4'
       hr=tline(16:17);mn=tline(18:19);sec=[tline(21:22) '.' tline(23:24)];
       phr=str2num(hr);pmn=str2num(mn);psec=str2num(sec);
       ptime=(phr*60*60)+(pmn*60)+psec;		%arrival time in seconds
       ptt=ptime-otime;
       if ptt < 0.0, continue,end
       wt_id=str2num(tline(8))+1;
       fprintf(fd,'%s %6.3f %3.1f P \n',sta,ptt,wt(wt_id));
    end
    if tline(40) == ' ',continue,end
    if tline(40) ~= '4'
       hr=tline(16:17);mn=tline(18:19);sec=[tline(33:34) '.' tline(35:36)];
       phr=str2num(hr);pmn=str2num(mn);psec=str2num(sec);
       ptime=(phr*60*60)+(pmn*60)+psec;            %arrival time in seconds
       ptt=ptime-otime;
       if ptt < 0.0, continue,end
       wt_id=str2num(tline(40))+1;
       fprintf(fd,'%s %6.3f %3.1f S \n',sta,ptt,wt(wt_id));
    end
end
fclose(fid);
end

fclose(fd);
