%datadir='/gaia/data/fdl/MtCarmel/EVENTS/';
datadir='/gaia/data/fdl/MtCarmel/DATA/';
%datadir='/gaia/data/fdl/MtCarmel/BOTH/';
%fp=fopen([datadir 'net_list']);
fp=fopen([datadir 'lnet_list']);
%fp=fopen([datadir 'big_list']);
id=0;
while 1
fn=fgetl(fp);
n=length(fn)-1;
if ~ischar(fn), break, end
%fname=[datadir fn fn(1:n) '.arc_save'];
fname=[datadir fn fn(1:n) '.arc'];
fid=fopen(fname);
if fid == -1, continue, end
id=id+1;
lat_sign=1;lon_sign=1;

%work on first line
tline = fgetl(fid);
if tline(19) == 'S',lat_sign=-1;end
if tline(27) == 'W',lon_sign=-1;end
lat=str2num(tline(17:18))+(str2num([tline(20:21) '.' tline(22:23)])/60.0);
lon=str2num(tline(24:26))+(str2num([tline(28:29) '.' tline(30:31)])/60.0);
lat=lat*lat_sign; lon=lon*lon_sign;
depth=str2num([tline(32:34) '.' tline(35:36)]);
yr=tline(1:4);mo=tline(5:6);day=tline(7:8);hr=tline(9:10);mn=tline(11:12);
sec=[tline(13:14) '.' tline(15:16)];
ohr=str2num(hr);omn=str2num(mn);osec=str2num(sec);
otime=(ohr*60*60)+(omn*60)+osec;                %origin time in seconds
mag=[tline(37) '.' tline(38)];if mag(3) == ' ',mag(3)='0';end
eh1=str2num([tline(57:58) '.' tline(59:60)]);
eh2=str2num([tline(66:67) '.' tline(68:69)]);
eh3=str2num([tline(75:76) '.' tline(77:78)]);
eh=max(eh1,eh2)/1.87;ez=eh3/1.87;
rms=[tline(48:49) '.' tline(50:51)];
dat(id,1)=lat; dat(id,2)=lon; dat(id,3)=depth;
dat(id,4)=str2num(mag);
if dat(id,4) == 0, dat(id,4)=2.0; end;
end

scatter(dat(:,2),dat(:,1),dat(:,4)*20,'co','filled')
set(gca,'ylim',[38.3 38.6])
set(gca,'xlim',[-88 -87.7])
hold on
scatter(dat(:,2),dat(:,1),dat(:,4)*20,'ko')
plotsta
lat0=38.45*pi/180;
pbaspect([cos(lat0) 1 1]);

%datadir='/gaia/data/fdl/MtCarmel/DATA/';
%fn=input('Enter Directory for EQ to plot','s');
%n=length(fn)-1;
%fname=[datadir fn '/' fn '.arc'];
%fid=fopen(fname);
%tline = fgetl(fid);
%lat=str2num(tline(17:18))+(str2num([tline(20:21) '.' tline(22:23)])/60.0);
%lon=str2num(tline(24:26))+(str2num([tline(28:29) '.' tline(30:31)])/60.0);
%depth=str2num([tline(32:34) '.' tline(35:36)]);
%mag=2.0;
%scatter(-lon,lat,mag*20,'bo','filled');

