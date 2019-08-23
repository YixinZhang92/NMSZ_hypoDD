%%%%%%% Plot horizontal map %%%%%%%%

%% Define map margin and file terms
file_reloc='hypoDD.reloc'; file_loc='hypoDD.loc'; file_sta='hypoDD.sta'; 
file_line=''; phiA=150; xshift=0; yshift=0.1; box_l=1.5; box_w=0.2;
axlim=1; minmag=1; id=[]; itake=[]; err=1;
axis_latmin = 35.5;
axis_latmax = 37.5;
axis_lonmin = -90.5;
axis_lonmax = -88.5;
%========== data processing starts here....
%--- read events 

% phiAA= phiA; phiB= phiA-90;  
% phiB= (phiB-90)*pi/180; phiA= (phiA-90)*pi/180; 

mdat1=load(file_reloc); 
mdat2=load(file_loc); 

cusp = mdat1(:,1); mag= mdat1(:,17); lon1=mdat1(:,3); lat1=mdat1(:,2);
depth1 = mdat1(:,4); rms = mdat1(:,23);
% x1 = mdat1(:,5)/1000; y1 = mdat1(:,6)/1000; z1 = -mdat1(:,4);
% ex1 = mdat1(:,8)/1000; ey1 = mdat1(:,9)/1000; ez1 = mdat1(:,10)/1000;

lon2=mdat2(:,3); lat2=mdat2(:,2); depth2 = mdat2(:,4); 
% x2 = mdat2(:,5)/1000; y2 = mdat2(:,6)/1000; z2 = -mdat2(:,4);
% ex2 = mdat2(:,8)/1000; ey2 = mdat2(:,9)/1000; ez2 = mdat2(:,10)/1000;

% if(sum(ex1)==0); ex1=ex1+1;ey1=ey1+1;ez1=ez1+1;end; 
mag(find(mag==0))= 0.2; % Need explaination

%% plot horizontal map

if(length(file_line)>0);border=load(file_line); else; border=[0,0];end;

figure('Name','Relocation_horizontal'); set(gcf,'clipping','off');
%--- STATION PLOT  (map view)
% subplot(2,2,1);hold on; 
plot(border(:,1),border(:,2),'linewidth',0.1,'color',[0.8 0.8 0.8]);
for i=1:length(lon1)
    plot(lon1,lat1,'o','markersize',2,'color','r');
end
% plot(slon,slat,'v','markersize',2); 
% for i=1:length(slon); text(slon(i),slat(i),sta(i,:),'fontsize',8);end
axis([axis_lonmin axis_lonmax axis_latmin axis_latmax]); 
title('Relocation Map'); xlabel('longitude'); ylabel('latitude');
zlabel('depth'); set(gca,'Zdir','reverse')
axis('equal');box('on');
xlim([axis_lonmin axis_lonmax])
ylim([axis_latmin axis_latmax])
% subplot(2,2,2);hold on
% plot(x,y,'.','markersize',1,'color','r');
% if(err==1); for i=1:length(x)
% 	hold on 
% 	plot([x(i)-ex(i) x(i)+ex(i)],[y(i) y(i)],'color','r');
% 	plot([x(i) x(i)],[y(i)-ey(i) y(i)+ey(i)],'color','r'); end; end
% if(length(id)>0); for i=1:length(x)
% 	hold on 
% 	for k=1:length(id); if(id(k)==cusp(i)); 
% 		plot(x(i),y(i),'o','markersize',10,'color','g'); end;end;
% end;end;
% plot(x(find(mag>minmag)),y(find(mag>minmag)),'o','color','r');
% axis('equal'); axis([-axlim axlim -axlim axlim]); set(gca,'box','on');
% title('MAP VIEW'); xlabel('distance [km]'); ylabel('distance [km]');
% hold on
%--- CROSS SECTION  A-A'
%--- plot box location on map 

% subplot(2,2,2); hold on
% plot([(-box_l/2)*cos(phiA)-box_w*cos(phiB)+xshift (box_l/2)*cos(phiA)-box_w*cos(phiB)+xshift (box_l/2)*cos(phiA)+box_w*cos(phiB)+xshift (-box_l/2)*cos(phiA)+box_w*cos(phiB)+xshift (-box_l/2)*cos(phiA)-box_w*cos(phiB)+xshift],[(box_l/2)*sin(phiA)+box_w*sin(phiB)+yshift (-box_l/2)*sin(phiA)+box_w*sin(phiB)+yshift (-box_l/2)*sin(phiA)-box_w*sin(phiB)+yshift (box_l/2)*sin(phiA)-box_w*sin(phiB)+yshift (box_l/2)*sin(phiA)+box_w*sin(phiB)+yshift]);
% text(-box_l/2*cos(phiA)+xshift, box_l/2*sin(phiA)+yshift,'A'); 
% text(box_l/2*cos(phiA)+xshift, -box_l/2*sin(phiA)+yshift,'A`'); 

axis normal

hold on

% figure('Name','Origin Location'); set(gcf,'clipping','off');
% %--- STATION PLOT  (map view)
% % subplot(2,2,1);hold on; 
% plot(border(:,1),border(:,2),'linewidth',0.1,'color',[0.8 0.8 0.8]);
for i=1:length(lon2)
    plot(lon2,lat2,'o','markersize',2,'color','b');
end
% plot(slon,slat,'v','markersize',2); 
% for i=1:length(slon); text(slon(i),slat(i),sta(i,:),'fontsize',8);end
% axis([axis_lonmin axis_lonmax axis_latmin axis_latmax]); 
% title('Relocation Map'); xlabel('longitude'); ylabel('latitude');
% zlabel('depth'); set(gca,'Zdir','reverse')
% axis('equal');box('on');

% axis normal
% pbaspect([1 1 1])
legend({'relocation','origin location'},'FontSize',14)

