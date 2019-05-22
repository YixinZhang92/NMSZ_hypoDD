%phiA is strike of cross section in degrees from north measured clockwise
phiA = ginput('enter strike\n');
phiA= (phiA-90)*pi/180;
mdat= load('NM_SW1.reloc');
x = mdat(:,5)/1000; y = mdat(:,6)/1000; z = -mdat(:,4);
theta=45;   %measured clockwise from north
%projection looking from theta direction
scatter((x*cos(phiA)-y*sin(phiA)),z,25,z,'filled');caxis([-18,0])
set(gca,'ylim',[-18,0]);
set(gca,'xlim',[-18,18]);
pbaspect([2 1 1])
set(gca,'Ytick',[-15 -10 -5 0])
grid on
xlabel('Horizontal Distance (km)');
ylabel('Depth (km)');
ttl=['Cross Section Strikes ' phia];
%title 'SW theta 225 phiA -135'

df=1;
beang=20;
for i=1:10
ang=df*i+beang;


% to convert from lat/lon to xy
mdat= load('eq.dat');
lat=mdat(:,2);lon=mdat(:,3);z0=mdat(:,4);mag= mdat(:,18);
plot(lon,lat,'ro')
[lon0,lat0]=ginput(1);
[xv,yv]=ginput(4);
in=inpolygon(lon,lat,xv,yv);
plot(lon,lat,'ro',lon(in),lat(in),'bo')

a=pi/180.0;
anum=cos(a*lat0);
y=(lat(in)-lat0)*111.195;
x=(lon(in)-lon0)*111.195*anum;
z=-z0(in);

phiA = 45*a;
%check angle
scatter((x*cos(phiA)-y*sin(phiA)),(y*cos(phiA)+x*sin(phiA)),25,'o')
set(gca,'ylim',[-100,100]);set(gca,'xlim',[-100,100]);
grid on
%phiA= (phiA-90)*pi/180;
%plot x-section
scatter((x*cos(phiA)-y*sin(phiA)),z,25,z,'filled');caxis([-18,0])
set(gca,'ylim',[-18,0]);
set(gca,'xlim',[-18,18]);
pbaspect([2 1 1])
set(gca,'Ytick',[-15 -10 -5 0])
grid on
xlabel('Horizontal Distance (km)');
ylabel('Depth (km)');

