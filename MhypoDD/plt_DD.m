% to convert from lat/lon to xy
%dat= load('MC.loc');
%lat=mdat(:,1);lon=mdat(:,2);z0=mdat(:,3);mag= mdat(:,17);
mag=5;
%scatter(dat(:,3),dat(:,2),mag,'bo','filled')
%hold on
%scatter(dat(:,3),dat(:,2),mag,'ko')

dat1= load('MC.reloc');
scatter(dat1(:,3),dat1(:,2),mag,'ro','filled')
hold on
scatter(dat1(:,3),dat1(:,2),mag,'ko')

set(gca,'ylim',[38.3 38.6])
set(gca,'xlim',[-88 -87.7])
plotsta
lat0=38.45*pi/180;
pbaspect([cos(lat0) 1 1]);




