corpha.m                                                                                            000700  000765  000024  00000007430 10205131243 012765  0                                                                                                    ustar 00steve                           staff                           000000  000000                                                                                                                                                                         % correlate earthquake data for input to hypoDD
d_dir='/gaia/home/horton/BARD/dat1/';
dt=100.0; delta=0.01;
npts=128;n2=npts/2; nfft=n2+1; df=1.0/(delta*npts);
T=(npts-1)*delta;
t=0:delta:T;

%h=hann(npts); the nuttall window clobbers the ends best
h=nuttallwin(npts);
%define filter stuff
lp = 2.0*30.0/dt; hp = 2.0*0.6/dt;
[b_lw,a_lw] = butter (4,lp);
[b_hp,a_hp] = butter (4,hp,'high');

%get origin times 
fid=fopen('data.pha');
p=0;
while 1
    tline = fgetl(fid);
    if ~ischar(tline), break, end
    if tline(1) == '#'
       n=length(tline);
       p=p+1;
       ev(p).id=str2num(tline(n-2:n));
       ev(p).ohr=str2num(tline(14:15));
       ev(p).omin=str2num(tline(17:18));
       ev(p).osec=str2num(tline(20:24));
       end
    end
fclose(fid);

%read event directories
fid=fopen('event_list');
p=1;
while 1
    tline = fgetl(fid);
    if ~ischar(tline), break, end
    ev(p).dir = tline;
    p=p+1;
    end
fclose(fid);

fd=fopen('dt.cc','w');
origin=0.0;

%read file containg event associations
fid=fopen('dt.ct');
p=0;
while 1
    tline = fgetl(fid);
    if ~ischar(tline), break, end
    if tline(1) == '#'
       p=p+1;
fprintf('%i \n',p);
       e_1=str2num(tline(10:11));
       e_2=str2num(tline(20:21));
       fprintf(fd,'%s %i %i %f \n','#',e_1,e_2,origin);
    else
       if tline(4) == ' '
          sta=tline(1:3);
       else
          sta=tline(1:4);
          end
       psec_e1=str2num(tline(10:14));
       psec_e2=str2num(tline(18:23));
       type=tline(32);
%open file for e_1
       otime=(ev(e_1).ohr*60*60)+(ev(e_1).omin*60)+ev(e_1).osec;
       if type == 'P'
          n_suffix = '.HHZ.NM';
          else
          n_suffix = '.HHE.NM';
          end
       name = [d_dir ev(e_1).dir '/' sta n_suffix];
       if ~exist(name),break,end 
       [data,dum,nheader,fip] = g_sac(name);
       data_mean  = mean (data); data = data - data_mean;
       y=filter (b_lw,a_lw,data);
       data=filter (b_hp,a_hp,y);
       hour = nheader(3); minu = nheader(4); seco = nheader(5) + (nheader(6)/1000);
       htime=(hour*60*60)+(minu*60)+seco;
       off_time=(otime-htime)+psec_e1;
       np=round((off_time)*dt);
       if np-n2 < 1 | np-n2 > length(data), continue, end
       a1=data(np-n2:np+n2-1).*h;

%open file for e_2
       otime=(ev(e_2).ohr*60*60)+(ev(e_2).omin*60)+ev(e_2).osec;
       name = [d_dir ev(e_2).dir '/' sta n_suffix];
       if ~exist(name),continue ,end 
       [data,dum,nheader,fip] = g_sac(name);
       data_mean  = mean (data); data = data - data_mean;
       y=filter (b_lw,a_lw,data);
       data=filter (b_hp,a_hp,y);
       hour = nheader(3); minu = nheader(4); seco = nheader(5) + (nheader(6)/1000);
       htime=(hour*60*60)+(minu*60)+seco;
       off_time=(otime-htime)+psec_e1;
       np=round((off_time)*dt);
       if np-n2 < 1 | np-n2 > length(data), continue, end
       a2=data(np-n2:np+n2-1).*h;

%             figure(1)
%             a1_max=max(a1);a2_max=max(a2);
%             scale=a1_max/a2_max;
%             subplot(2,1,1);plot(t,a1,'b',t,a2*scale,'r')
%             title(name)
       [acor,lag]=xcorr(a1,a2,n2,'coeff');
       [amax,imax]=max(acor);
       wdel=lag(imax)*delta;
       wt=amax;
              %fprintf('%s %f %f %s %f \n',ev(e_1).data(kk).sta,wdel,wt,ev(e_1).data(kk).type,test);
%              figure(2)
%              plot(lag*delta,acor,'b',lag(imax)*delta,amax,'ro')
%              np=round((off_time-wdel)*dt);
%              a2=data(np-n2:np+n2-1).*h;
%              a1_max=max(a1);a2_max=max(a2);
%              scale=a1_max/a2_max;
%              figure(1)
%              subplot(2,1,2);plot(t,a1,'b',t,a2*scale,'r')
%              pause(3)   %iflag=input('enter 1 to write to file');
       if wt >= 0.7
          fprintf(fd,'%s %f %f %s \n',sta,wdel,wt,type);
%                 fprintf('%s %f %f %s \n',sta,wdel,wt,type);
          end
       end
end
                                                                                                                                                                                                                                        corpha_IL.m                                                                                         000700  000765  000024  00000010006 11052360237 013352  0                                                                                                    ustar 00steve                           staff                           000000  000000                                                                                                                                                                         % correlate earthquake data for input to hypoDD
d_dir='/gaia/data/fdl/MtCarmel/DATA/';
dt=100.0; delta=0.01;
npts=128;n2=npts/2; nfft=n2+1; df=1.0/(delta*npts);
T=(npts-1)*delta;
t=0:delta:T;

%h=hann(npts); the nuttall window clobbers the ends best
h=nuttallwin(npts);
%define filter stuff
lp = 2.0*10.0/dt; hp = 2.0*1.0/dt;
[b_lw,a_lw] = butter (4,lp);
[b_hp,a_hp] = butter (4,hp,'high');

%get origin times 
fid=fopen('data.pha');
p=0;
while 1
    tline = fgetl(fid);
    if ~ischar(tline), break, end
    if tline(1) == '#'
       n=length(tline);
       p=p+1;
       ev(p).id=str2num(tline(n-2:n));
       ev(p).ohr=str2num(tline(14:15));
       ev(p).omin=str2num(tline(17:18));
       ev(p).osec=str2num(tline(20:24));
       end
    end
fclose(fid);

%read event directories
fid=fopen('event_list');
p=1;
while 1
    tline = fgetl(fid);
    if ~ischar(tline), break, end
    ev(p).dir = tline;
    p=p+1;
    end
fclose(fid);

fd=fopen('dt.cc','w');
origin=0.0;

%read file containg event associations
fid=fopen('dt.ct');
p=0;
while 1
    tline = fgetl(fid);
    if ~ischar(tline), break, end
    if tline(1) == '#'
       p=p+1;
fprintf('%i \n',p);
       e_1=str2num(tline(9:11));
       e_2=str2num(tline(19:21));
       fprintf(fd,'%s %i %i %f \n','#',e_1,e_2,origin);
    else
       if tline(4) == ' '
          sta=tline(1:3);
       else
          sta=tline(1:4);
          end
       psec_e1=str2num(tline(10:14));
       psec_e2=str2num(tline(18:23));
       type=tline(32);
%open file for e_1
       otime=(ev(e_1).ohr*60*60)+(ev(e_1).omin*60)+ev(e_1).osec;
       if type == 'P'
          %n_suffix = '.HHZ.NM';
          n_suffix = '*Z*';
          else
          %n_suffix = '.HHE.NM';
          n_suffix = '*E*';
          end
       %name = [d_dir ev(e_1).dir '/' sta n_suffix];
       temp = dir([d_dir ev(e_1).dir sta n_suffix]);
       if length(temp) == 0, continue, end
       name= [d_dir ev(e_1).dir temp(1).name];
       if ~exist(name),continue,end 
       [data,dum,nheader,fip] = g_sac(name);
       data_mean  = mean (data); data = data - data_mean;
       y=filter (b_lw,a_lw,data);
       data=filter (b_hp,a_hp,y);
       hour = nheader(3); minu = nheader(4); seco = nheader(5) + (nheader(6)/1000);
       htime=(hour*60*60)+(minu*60)+seco;
       off_time=(otime-htime)+psec_e1;
       np=round((off_time)*dt);
       if np-n2 < 1 | np+n2 > length(data), continue, end
       a1=data(np-n2:np+n2-1).*h;

%open file for e_2
       otime=(ev(e_2).ohr*60*60)+(ev(e_2).omin*60)+ev(e_2).osec;
       %name = [d_dir ev(e_2).dir '/' st
       name = [d_dir ev(e_2).dir temp(1).name];
       if ~exist(name),continue ,end 
       [data,dum,nheader,fip] = g_sac(name);
       data_mean  = mean (data); data = data - data_mean;
       y=filter (b_lw,a_lw,data);
       data=filter (b_hp,a_hp,y);
       hour = nheader(3); minu = nheader(4); seco = nheader(5) + (nheader(6)/1000);
       htime=(hour*60*60)+(minu*60)+seco;
       off_time=(otime-htime)+psec_e1;
       np=round((off_time)*dt);
       if np-n2 < 1 | np+n2 > length(data), continue, end
       a2=data(np-n2:np+n2-1).*h;

%             figure(1)
%             a1_max=max(a1);a2_max=max(a2);
%             scale=a1_max/a2_max;
%             subplot(2,1,1);plot(t,a1,'b',t,a2*scale,'r')
%             title(name)
       [acor,lag]=xcorr(a1,a2,n2,'coeff');
       [amax,imax]=max(acor);
       wdel=lag(imax)*delta;
       wt=amax;
              %fprintf('%s %f %f %s %f \n',ev(e_1).data(kk).sta,wdel,wt,ev(e_1).data(kk).type,test);
%              figure(2)
%              plot(lag*delta,acor,'b',lag(imax)*delta,amax,'ro')
%              np=round((off_time-wdel)*dt);
%              a2=data(np-n2:np+n2-1).*h;
%              a1_max=max(a1);a2_max=max(a2);
%              scale=a1_max/a2_max;
%              figure(1)
%              subplot(2,1,2);plot(t,a1,'b',t,a2*scale,'r')
       if wt >= 0.7
          fprintf(fd,'%s %f %f %s \n',sta,wdel,wt,type);
                 fprintf('%s %f %f %s \n',sta,wdel,wt,type);
          end
%              pause   %iflag=input('enter 1 to write to file');
       end
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          corpha_NM.m                                                                                         000700  000765  000024  00000011625 10676776725 013420  0                                                                                                    ustar 00steve                           staff                           000000  000000                                                                                                                                                                         dt=100.0; delta=0.01;
%npts=128;n2=npts/2; nfft=n2+1; df=1.0/(delta*npts);
%npts=256;n2=npts/2;
%T=(npts-1)*delta;
%t=0:delta:T;
%h=hann(npts); the nuttall window clobbers the ends best
%h=nuttallwin(npts);
%define filter stuff
lp = 2.0*30.0/dt; hp = 2.0*0.6/dt;
[b_lw,a_lw] = butter (4,lp);
[b_hp,a_hp] = butter (4,hp,'high');

fid=fopen('phase.dat');
p=0;
while 1
    tline = fgetl(fid);
    if ~ischar(tline), break, end
    if tline(1) == '#'
       n=length(tline);
       ind=find(tline == ' ',2,'last');
       p=p+1;
       ev(p).id=str2num(tline(ind(1)+1:ind(2)-1));
       ev(p).ohr=str2num(tline(14:15));
       ev(p).omin=str2num(tline(17:18));
       ev(p).osec=str2num(tline(20:24));
       ev(p).lat=str2num(tline(26:31));
       ev(p).lon=str2num(tline(33:39));
       ev(p).z=str2num(tline(41:45));
       clear ind
       end
    end
fclose(fid);

%read event directories
fid=fopen('event_list');
p=1;
while 1
    tline = fgetl(fid);
    if ~ischar(tline), break, end
    ev(p).dir = tline;
    p=p+1;
    end
fclose(fid);

fd=fopen('dt.cc','w');
fcd=fopen('dt_out.cc','w');
origin=0.0;

d_dir='/gaia/data/seisnet/NM/';
%read file containg event associations
fid=fopen('dt.ct');
p=0;
while 1
    tline = fgetl(fid);
    if ~ischar(tline), break, end
    if tline(1) == '#'
       p=p+1;
       fprintf('%i \n',p);
       tl_let=find(tline ~= ' ');
       num_end=find(diff(tl_let) > 1);
       e_1=str2num(tline(tl_let(2):tl_let(num_end(2))));
       e_2=str2num(tline(tl_let(num_end(2)+1):tl_let(length(tl_let))));
       fprintf(fd,'%s %i %i %f \n','#',e_1,e_2,origin);
       fprintf(fcd,'%s %i %i %f %f %f %f %f %f \n','#',e_1,e_2,ev(e_1).lat,ev(e_1).lon,ev(e_1).z,ev(e_2).lat,ev(e_2).lon,ev(e_2).z);
   else
       if tline(4) == ' '
          sta=tline(1:3);
       else
          sta=tline(1:4);
          end
     psec_e1=str2num(tline(10:14));
     psec_e2=str2num(tline(18:23));
     abs_time=psec_e1-psec_e2;
     nn=nextpow2(abs_time*dt)+1;
     if nn > 8
     npts=2^nn;n2=npts/2;
     else
     npts=256;n2=npts/2;
     end
     h=nuttallwin(npts);
     T=(npts-1)*delta;
     t=0:delta:T;

     type=tline(32);
%open file for e_1
     otime=(ev(e_1).ohr*60*60)+(ev(e_1).omin*60)+ev(e_1).osec;
     if type == 'P'
fname = dir([d_dir ev(e_1).dir(1:4) '/Loc/' ev(e_1).dir sta '*HZ.NM']);
        else
fname = dir([d_dir ev(e_1).dir(1:4) '/Loc/' ev(e_1).dir sta '*HE.NM']);
        end
     if length(fname)== 0,continue,end
     name=[d_dir ev(e_1).dir(1:4) '/Loc/' ev(e_1).dir fname.name];
     gname=name;gname(length(gname)-3)='G';
if exist(gname) == 1
     [data,delta,nheader,dum] = g_sac_dg(name,gname);
      else
     [data,dum,nheader,fip] = g_sac(name);
     end
%if dum ~= 0.01,continue,end
     data_mean  = mean (data); data = data - data_mean;
     y=filter (b_lw,a_lw,data);
       data=filter (b_hp,a_hp,y);
       hour = nheader(3); minu = nheader(4); seco = nheader(5) + (nheader(6)/1000);
       htime=(hour*60*60)+(minu*60)+seco;
       off_time=(otime-htime)+psec_e1;
       np=round((off_time)*dt);
%`       if np-n2 < 1 | np-n2 > length(data), continue, end
       if np-n2 < 1 | np-n2 > length(data) | np+n2-1 > length(data), continue, end
       a1=data(np-n2:np+n2-1).*h;

%open file for e_2
     otime=(ev(e_2).ohr*60*60)+(ev(e_2).omin*60)+ev(e_2).osec;
     if type == 'P'
fname = dir([d_dir ev(e_2).dir(1:4) '/Loc/' ev(e_2).dir sta '*HZ.NM']);
        else
fname = dir([d_dir ev(e_2).dir(1:4) '/Loc/' ev(e_2).dir sta '*HE.NM']);
        end
     if length(fname)== 0,continue,end
     name=[d_dir ev(e_2).dir(1:4) '/Loc/' ev(e_2).dir fname.name];
     gname=name;gname(length(gname)-3)='G';
if exist(gname) == 1
     [data,delta,nheader,dum] = g_sac_dg(name,gname);
      else
    [data,dum,nheader,fip] = g_sac(name);
end
%if dum ~= 0.01,continue,end
     data_mean  = mean (data); data = data - data_mean;
     y=filter (b_lw,a_lw,data);
       data=filter (b_hp,a_hp,y);
       hour = nheader(3); minu = nheader(4); seco = nheader(5) + (nheader(6)/1000);
       htime=(hour*60*60)+(minu*60)+seco;
       off_time=(otime-htime)+psec_e1;
       np=round((off_time)*dt);
       if np-n2 < 1 | np-n2 > length(data) | np+n2-1 > length(data), continue, end
       a2=data(np-n2:np+n2-1).*h;
%do corelation
       [acor,lag]=xcorr(a1,a2,n2,'coeff');
       [amax,imax]=max(acor);
       wdel=lag(imax)*delta;
       wt=amax;

%figure(1)
%a1_max=max(a1);a2_max=max(a2);
%scale=a1_max/a2_max;
%subplot(2,1,1);plot(t,a1,'b',t,a2*scale,'r')
%title(name)
%np=round((off_time-wdel)*dt);
%a2=data(np-n2:np+n2-1).*h;
%a1_max=max(a1);a2_max=max(a2);
%scale=a1_max/a2_max;
%subplot(2,1,2);plot(t,a1,'b',t,a2*scale,'r')
%figure(2)
              %plot(lag*delta,acor,'b',lag(imax)*delta,amax,'ro')
              %pause(1)
              %pause
if wt >= 0.7
fprintf(fcd,'%s %s %f %f %f \n',sta,type,abs_time,wdel,wt);
          fprintf(fd,'%s %f %f %s \n',sta,wdel,wt,type);
%          fprintf('%s %f %f %s \n',sta,wdel,wt,type);
end
     end
end
fclose(fd);
fclose(fid);
                                                                                                           eqplot.m                                                                                            000700  000765  000024  00000017223 11005401743 013022  0                                                                                                    ustar 00steve                           staff                           000000  000000                                                                                                                                                                         function[]=eqplot
% Matlab script to read and display hypoDD output files 
% (hypoDD.loc, hypoDDD.reloc, and hypoDD.sta)
%
% eqplot displays 4 subfigures: 
% Distribution of stations used in the relocation, map view of the events
% and two cross sections. 
%
% The parameters listed below may be edited to change the view of the plot. 
% On your mouse, use left click to zoom in, and right click to zoom out.

% PARAMETER DESCRIPTION:
%--- file names:
% file_loc  	hypocenter file name (e.g. hypoDD.loc or hypoDD.reloc)
% file_sta 	station file name (e.g. hypoDD.sta)
% file_line	line file name to display geography 
%                 (lines of 'lon lat'; separators are 'Nan  NaN')

%--- cross sections:
% phiA   	strike of cross section 
% xshift	x-location of center of cross section 
% yshift	y-location of center of cross section 
% box_l 	length of cross section
% box_w 	half width of cross section

%--- event selection:
% axlim  	axis dimension of map view plot in km
% minmag	circle events with mag>minmag
% id=[]		mark events with ID's listed here
% itake=[]	display only events with ID's listed here
% err=1		display errors [0=no,1=yes]

% PARAMETER SETTING:
file_loc='NM.reloc'; 
file_sta='NM.sta'; 
file_line='';
phiA=30; xshift=0; yshift=0; box_l=100.5; box_w=50.2;
axlim=1; minmag=10; id=[]; itake=[]; err=1;



%========== data processing starts here....
%--- read events 
phiAA= phiA; phiB= phiA-90;  phiB= (phiB-90)*pi/180; phiA= (phiA-90)*pi/180; 
mdat= load(file_loc); 
cusp = mdat(:,1); mag= mdat(:,17); lon=mdat(:,3); lat=mdat(:,2);
x = mdat(:,5)/1000; y = mdat(:,6)/1000; z = -mdat(:,4);
ex = mdat(:,8)/1000; ey = mdat(:,9)/1000; ez = mdat(:,10)/1000;
if(sum(ex)==0); ex=ex+1;ey=ey+1;ez=ez+1;end; mag(find(mag==0))= 0.2;
if(length(itake) > 0);
	clear ind; k=1; for i=1:length(cusp); for j=1:length(itake); 
	if(itake(j)==cusp(i)); ind(k)= i; k=k+1; end;end;end;
	x= x(ind); y= y(ind); z= z(ind); lon=lon(ind); lat=lat(ind);
	cusp=cusp(ind);mag=mag(ind);ex=ex(ind);ey=ey(ind);ez=ez(ind);
end;
disp(['# of events = ' num2str(length(cusp))]);
disp(['mean ex = ' num2str(mean(ex))]);
disp(['mean ey = ' num2str(mean(ey))]);
disp(['mean ez = ' num2str(mean(ez))]);
disp(['min mag = ' num2str(min(mag))]);
disp(['max mag = ' num2str(max(mag))]);
%length(cusp(find(z0>-32.3)))'

%--- read stations:
fid1=fopen(file_sta,'r');
for i=1:1000000
        [dum,count]= fscanf(fid1,'%s1/');
        if count == 0 break; end
        sta(i,1:length(dum))= dum;
        slat(i)=fscanf(fid1,'%f1') ; slon(i)=fscanf(fid1,'%f1') ;
        dum=fscanf(fid1,'%f1') ; dum=fscanf(fid1,'%f1') ;
        np(i)=fscanf(fid1,'%d1') ; ns(i)=fscanf(fid1,'%d1') ;
        nnp(i)=fscanf(fid1,'%d1') ; nns(i)=fscanf(fid1,'%d1') ;
        dum=fscanf(fid1,'%f1'); dum=fscanf(fid1,'%f1'); dum=fscanf(fid1,'%d1/');
end
ind= find(np+ns+nnp+nns > 0); slon= slon(ind); slat= slat(ind); sta= sta(ind,:);
disp(['# of stations = ' num2str(length(sta))]);

%--- read lines:
if(length(file_line)>0);border= load(file_line); else; border=[0,0];end;

figure; set(gcf,'clipping','on');

%--- STATION PLOT  (map view)
subplot(2,2,1);hold on; 
plot(border(:,1),border(:,2),'linewidth',0.1,'color',[0.8 0.8 0.8]);
plot(lon,lat,'o','markersize',2,'color','r');
plot(slon,slat,'v','markersize',2); 
for i=1:length(slon); text(slon(i),slat(i),sta(i,:),'fontsize',8);end
axis([min([slon lon']) max([slon lon']) min([slat lat']) max([slat lat'])]); 
title('STATION MAP'); xlabel('longitude'); ylabel('latitude'); 
axis('equal');box('on');

%--- PLOT EVENTS (map view)
subplot(2,2,2);hold on
plot(x,y,'.','markersize',1,'color','r');
if(err==1); for i=1:length(x)
	hold on 
	plot([x(i)-ex(i) x(i)+ex(i)],[y(i) y(i)],'color','r');
	plot([x(i) x(i)],[y(i)-ey(i) y(i)+ey(i)],'color','r'); end; end
if(length(id)>0); for i=1:length(x)
	hold on 
	for k=1:length(id); if(id(k)==cusp(i)); 
		plot(x(i),y(i),'o','markersize',10,'color','g'); end;end;
end;end;
plot(x(find(mag>minmag)),y(find(mag>minmag)),'o','color','r');
axis('equal'); axis([-axlim axlim -axlim axlim]); set(gca,'box','on');
title('MAP VIEW'); xlabel('distance [km]'); ylabel('distance [km]');
hold on

%--- CROSS SECTION  A-A'
%--- plot box location on map 
subplot(2,2,2); hold on
plot([(-box_l/2)*cos(phiA)-box_w*cos(phiB)+xshift (box_l/2)*cos(phiA)-box_w*cos(phiB)+xshift (box_l/2)*cos(phiA)+box_w*cos(phiB)+xshift (-box_l/2)*cos(phiA)+box_w*cos(phiB)+xshift (-box_l/2)*cos(phiA)-box_w*cos(phiB)+xshift],[(box_l/2)*sin(phiA)+box_w*sin(phiB)+yshift (-box_l/2)*sin(phiA)+box_w*sin(phiB)+yshift (-box_l/2)*sin(phiA)-box_w*sin(phiB)+yshift (box_l/2)*sin(phiA)-box_w*sin(phiB)+yshift (box_l/2)*sin(phiA)+box_w*sin(phiB)+yshift]);
text(-box_l/2*cos(phiA)+xshift, box_l/2*sin(phiA)+yshift,'A'); 
text(box_l/2*cos(phiA)+xshift, -box_l/2*sin(phiA)+yshift,'A`'); 

%--- cross section 
subplot(2,2,3); hold on
i= find(abs((x-xshift)*cos(phiB)-(y-yshift)*sin(phiB))<box_w);
if(length(i)>0);
x0=x(i)-xshift;y0=y(i)-yshift;z0=z(i);mag0=mag(i); ex0=ex(i); ey0=ey(i); ez0=ez(i); cusp0=cusp(i);
plot((x0*cos(phiA)-y0*sin(phiA)),z0,'.','markersize',1,'color','r');
if(err== 1); for i=1:length(x0)
	plot([(x0(i)*cos(phiA)-y0(i)*sin(phiA)-ex0(i)) (x0(i)*cos(phiA)-y0(i)*sin(phiA)+ex0(i))],[z0(i) z0(i)],'color','r');
	plot([(x0(i)*cos(phiA)-y0(i)*sin(phiA)) (x0(i)*cos(phiA)-y0(i)*sin(phiA))],[z0(i)-ez0(i) z0(i)+ez0(i)],'color','r'); end;end
if(length(id)>0); for i=1:length(x0);hold on
	for k=1:length(id); if(id(k)==cusp(i)); 
		plot((x0(i)*cos(phiA)-y0(i)*sin(phiA)),z0(i),'o','markersize',10,'color','g'); end;end
end;end
plot((x0(find(mag0>minmag))*cos(phiA)-y0(find(mag0>minmag))*sin(phiA)),z0(find(mag0>minmag)),'o','color','r');
axis('equal');axis([-box_l/2 box_l/2 min((min(z0)-(max(z0)-min(z0)+0.01)/5),mean(z0)-box_l/2) max((max(z0)+(max(z0)-min(z0)+0.01)/5),mean(z0)+box_l/2) ]);
set(gca,'box','on'); title('Cross Section: A-A`'); xlabel('distance [km]'); ylabel('depth [km]'); zoom on;
end;

%--- CROSS SECTION  B-B'
phiA= phiAA+90; tmp= box_w; box_w= box_l/2; box_l= tmp*2; 
phiB= phiA-90;  phiB= (phiB-90)*pi/180; phiA= (phiA-90)*pi/180; 

%--- plot box location on map 
subplot(2,2,2); hold on
plot([(-box_l/2)*cos(phiA)-box_w*cos(phiB)+xshift (box_l/2)*cos(phiA)-box_w*cos(phiB)+xshift (box_l/2)*cos(phiA)+box_w*cos(phiB)+xshift (-box_l/2)*cos(phiA)+box_w*cos(phiB)+xshift (-box_l/2)*cos(phiA)-box_w*cos(phiB)+xshift],[(box_l/2)*sin(phiA)+box_w*sin(phiB)+yshift (-box_l/2)*sin(phiA)+box_w*sin(phiB)+yshift (-box_l/2)*sin(phiA)-box_w*sin(phiB)+yshift (box_l/2)*sin(phiA)-box_w*sin(phiB)+yshift (box_l/2)*sin(phiA)+box_w*sin(phiB)+yshift]);
text(-box_l/2*cos(phiA)+xshift, box_l/2*sin(phiA)+yshift,'B'); 
text(box_l/2*cos(phiA)+xshift, -box_l/2*sin(phiA)+yshift,'B`'); 

%--- cross section 
subplot(2,2,4); hold on
i= find(abs((x-xshift)*cos(phiB)-(y-yshift)*sin(phiB))<box_w);
if(length(i)>0);
x0=x(i)-xshift;y0=y(i)-yshift;z0=z(i);mag0=mag(i); ex0=ex(i); ey0=ey(i); ez0=ez(i); cusp0=cusp(i);
plot((x0*cos(phiA)-y0*sin(phiA)),z0,'.','markersize',1,'color','r');
if(err== 1); for i=1:length(x0)
	plot([(x0(i)*cos(phiA)-y0(i)*sin(phiA)-ex0(i)) (x0(i)*cos(phiA)-y0(i)*sin(phiA)+ex0(i))],[z0(i) z0(i)],'color','r');
	plot([(x0(i)*cos(phiA)-y0(i)*sin(phiA)) (x0(i)*cos(phiA)-y0(i)*sin(phiA))],[z0(i)-ez0(i) z0(i)+ez0(i)],'color','r'); end;end
if(length(id)>0); for i=1:length(x0);hold on
	for k=1:length(id); if(id(k)==cusp(i)); 
		plot((x0(i)*cos(phiA)-y0(i)*sin(phiA)),z0(i),'o','markersize',10,'color','g'); end;end
end;end
plot((x0(find(mag0>minmag))*cos(phiA)-y0(find(mag0>minmag))*sin(phiA)),z0(find(mag0>minmag)),'o','color','r');
axis('equal');axis([-box_l/2 box_l/2 min((min(z0)-(max(z0)-min(z0)+0.01)/5),mean(z0)-box_l/2) max((max(z0)+(max(z0)-min(z0)+0.01)/5),mean(z0)+box_l/2) ]);
set(gca,'box','on'); title('Cross Section: B-B`'); xlabel('distance [km]'); ylabel('depth [km]'); zoom on;
end;

                                                                                                                                                                                                                                                                                                                                                                             plotqk.m                                                                                            000700  000765  000024  00000004027 11054627246 013042  0                                                                                                    ustar 00steve                           staff                           000000  000000                                                                                                                                                                         %datadir='/gaia/data/fdl/MtCarmel/EVENTS/';
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

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         plotsta.m                                                                                           000700  000765  000024  00000001140 11021263524 013174  0                                                                                                    ustar 00steve                           staff                           000000  000000                                                                                                                                                                         lat=38+27.16/60;
lon=-87-53.54/60;
text(lon,lat,'MC1','FontSize',10,'HorizontalAlignment','center');
lat=38+32.62/60;
lon=-87-52.44/60;
text(lon,lat,'MC2','FontSize',10,'HorizontalAlignment','center');
lat=38+21.79/60;
lon=-87-49.81/60;
text(lon,lat,'MC4','FontSize',10,'HorizontalAlignment','center');
lat=38+28.79/60;
lon=-87-45.98/60;
text(lon,lat,'MC5','FontSize',10,'HorizontalAlignment','center');
lat=38+25.79/60;
lon=-87-46.90/60;
text(lon,lat,'WVIL','FontSize',10,'HorizontalAlignment','center');
lat=38+32.49/60;
lon=-88-02.06/60;
text(lon,lat,'IU1','FontSize',10,'HorizontalAlignment','center');

                                                                                                                                                                                                                                                                                                                                                                                                                                plt_DD.m                                                                                            000700  000765  000024  00000000675 11077200623 012672  0                                                                                                    ustar 00steve                           staff                           000000  000000                                                                                                                                                                         % to convert from lat/lon to xy
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




                                                                   pre_ph2dt.m                                                                                         000700  000765  000024  00000005463 07740300520 013412  0                                                                                                    ustar 00steve                           staff                           000000  000000                                                                                                                                                                         % get phase data from arc files for input to ph2dt
datadir='/gaia/home/horton/BARD/dat1/';
fd=fopen('data.pha','w');
fp=fopen('event_list');
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
                                                                                                                                                                                                             pre_ph2dt_IL.m                                                                                      000700  000765  000024  00000006037 11077166625 014012  0                                                                                                    ustar 00steve                           staff                           000000  000000                                                                                                                                                                         % get phase data from arc files for input to ph2dt
%datadir='/gaia/data/seisnet/NM/1999/Reg/';
%datadir='/gaia/data/fdl/MtCarmel/EVENTS/';
datadir='/gaia/data/fdl/MtCarmel/DATA/';
fd=fopen('data.pha','w');
fp=fopen('event_list');
wt=[1.0 0.5 0.2 0.1];

id=0;
while 1
fn=fgetl(fp);
n=length(fn)-1;
if ~ischar(fn), break, end
fname=[datadir fn fn(1:n) '.arc'];
fid=fopen(fname);
if fid == -1, continue, end
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
%if length(tline) ~= 110,length(tline), continue,end
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
       if wt_id > 4,continue,end
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
       if wt_id > 4,continue,end
       fprintf(fd,'%s %6.3f %3.1f S \n',sta,ptt,wt(wt_id));
    end
end
fclose(fid);
end

fclose(fd);
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 pre_ph2dt_NM.m                                                                                      000700  000765  000024  00000005777 11004452253 014013  0                                                                                                    ustar 00steve                           staff                           000000  000000                                                                                                                                                                         % get phase data from arc files for input to ph2dt
%datadir='/gaia/data/seisnet/NM/1999/Reg/';
datadir='/gaia/data/seisnet/NM/2000/Loc/';
fd=fopen('data.pha_2000','w');
fp=fopen('event_list_2000');
wt=[1.0 0.5 0.2 0.1];

id=0;
while 1
fn=fgetl(fp);
n=length(fn)-1;
if ~ischar(fn), break, end
fname=[datadir fn fn(1:n) '.arc'];
fid=fopen(fname);
if fid == -1, continue, end
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
%if length(tline) ~= 110,length(tline), continue,end
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
       if wt_id > 4,continue,end
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
       if wt_id > 4,continue,end
       fprintf(fd,'%s %6.3f %3.1f S \n',sta,ptt,wt(wt_id));
    end
end
fclose(fid);
end

fclose(fd);
 ./._read_archive.m                                                                                  000644  000765  000024  00000000261 13444456517 014527  0                                                                                                    ustar 00steve                           staff                           000000  000000                                                                                                                                                                             Mac OS X            	   2         �                                      ATTR       �   �                     �     com.apple.quarantine q/0001;51c89ecb;Firefox;                                                                                                                                                                                                                                                                                                                                                read_archive.m                                                                                      000644  000765  000024  00000007171 13444456517 014164  0                                                                                                    ustar 00steve                           staff                           000000  000000                                                                                                                                                                         function [evhdr,ev]=read_archive(ddir,fname);
%function to read archive file and store data
%%% evhdr - structure containing event information
%%% ev	  - structure containing station information
%%% ddir  - path to data directory with ceri diretory structure
%           e.g.       ddir='/gaia/data/seisnet/NM/';
%%% fname - archive file name
%%%% READ ARC FILE and store values in structure ev
evhdr.fn=fname;
%for New Madrid use next line
%f_arc= [ddir evhdr.fn(1:4) '/Loc/' evhdr.fn '/' evhdr.fn '.arc'];
%f_arc= [ddir '/' evhdr.fn '/' evhdr.fn '.arc'];
f_arc= [ddir '/' evhdr.fn '/' evhdr.fn '.arc'];
evhdr.datadir=[ddir evhdr.fn(1:4)];

fid=fopen(f_arc);
tline = fgetl(fid); %archive file
%if ~ischar(tline),break,end
%event information
evhdr.event_info=tline(1:47);
%origin time
evhdr.yr=str2num(tline(1:4));
evhdr.mo=str2num(tline(5:6));
evhdr.day=str2num(tline(7:8));
evhdr.hr=str2num(tline(9:10));
evhdr.mn=str2num(tline(11:12));
if tline(15) == ' '
evhdr.sec=0.0;
else
evhdr.sec=str2num([tline(13:14) '.' tline(15:16)]);
end

evhdr.otime=(evhdr.hr*60*60)+(evhdr.mn*60)+evhdr.sec;                %origin time in seconds
% event location
if tline(19) == 'S',lat_sign=-1;else lat_sign=+1;end
if tline(27) == 'W',lon_sign=-1;else lon_sign=+1;end
evhdr.lat=(str2num(tline(17:18))+(str2num([tline(20:21) '.' tline(22:23)])/60.0))*lat_sign;
evhdr.lon=(str2num(tline(24:26))+(str2num([tline(28:29) '.' tline(30:31)])/60.0))*lon_sign;
%if depth not set use negative depth to mark
%if tline(32:34) == '   ' & tline(35:36) == '  '
%if tline(34) == ' ' & tline(35) == ' '
%evhdr.depth=-1;
%else
%if tline(34) == ' ', tline(34) == '0', end
if tline(35) == ' ',tline(35) = '0'; end
evhdr.depth=str2num([tline(32:34) '.' tline(35:36)]);
%end
%event uncertainty
evhdr.eh1=str2num([tline(57:58) '.' tline(59:60)]);
evhdr.eh2=str2num([tline(66:67) '.' tline(68:69)]);
evhdr.eh3=str2num([tline(75:76) '.' tline(77:78)]);
evhdr.eh=max(evhdr.eh1,evhdr.eh2)/1.87;
evhdr.ez=evhdr.eh3/1.87;
if tline(50) == ' ', tline(50) = '0'; end
evhdr.rms=[tline(48:49) '.' tline(50:51)];
%magnitude
%if mag not set use negative mag to mark
%if tline(38) == ' ',mag(3)='-11';
%else
%evhdr.mag=[tline(37) '.' tline(38)];
%end
evhdr.mag=1.0;

%STATION INFO
pp = 0;
while 1
    tline = fgetl(fid);
    if ~ischar(tline), break, end
    if isempty(tline),break,end
    if tline(1:2) == 'C*',continue,end
    if tline(1) == ' ',continue,end
    if tline(23) == ' ',tline(23) ='0';end
    if tline(21) == '.',tline(21) ='0';end
    if tline(35) == ' ',tline(35) ='0';end
    if tline(8) == ' ',continue,end
pp=pp+1;
    sta_temp=tline(1:4);
    ib=isspace(sta_temp);
    ev(pp).sta=sta_temp(~ib);
    newsta(pp)=cellstr(sta_temp(~ib));
    ev(pp).pwt=str2num(tline(8));
    ev(pp).swt=str2num(tline(40));
    hr=tline(16:17);mn=tline(18:19);sc=[tline(21:22) '.' tline(23:24)];
    phr=str2num(hr);pmn=str2num(mn);psec=str2num(sc);
    sc=[tline(32:34) '.' tline(35:36)];ssec=str2num(sc);
    ev(pp).ptime=(phr*60*60)+(pmn*60)+psec;  %ptime in seconds after hour
    ev(pp).stime=(phr*60*60)+(pmn*60)+ssec;
    if psec == 0.0
        ev(pp).pflg=0;
        else
        ev(pp).pflg=1;
        end
     if ssec == 0.0
        ev(pp).sflg=0;
        else
        ev(pp).sflg=1;
        end
    ev(pp).azimuth=str2num(tline(29:31));
    ev(pp).p_inc=str2num(tline(41:43));
    ev(pp).dist=str2num([tline(25:27) '.' tline(28)]);
    if tline(79) == ' ', tline(79) = '0';end
    if tline(79) == '-', tline(79) = '0';tline(78)='-';end
    ev(pp).pres=str2num([tline(76:78) '.' tline(79:80)]);
    ud=tline(7);   % we used column 65 for this information
    ev(pp).ptype=tline(65);
end
evhdr.nsta=pp;
fclose(fid);
%%% FINISHED with ARC file
    
                                                                                                                                                                                                                                                                                                                                                                                                       read_archive1.m                                                                                     000644  000765  000024  00000006453 13444456517 014247  0                                                                                                    ustar 00steve                           staff                           000000  000000                                                                                                                                                                         function [evhdr,ev]=read_archive1(fname);
%function to read archive file and store data
%%% evhdr - structure containing event information
%%% ev	  - structure containing station information
%%% fname - path and archive file name
%%%% READ ARC FILE and store values in structure ev

sss=strread(fname,'%s','delimiter','/');
evhdr.fn=char(sss(length(sss)-1));
f_arc= fname;

fid=fopen(f_arc);
tline = fgetl(fid); %archive file
%if ~ischar(tline),break,end
%event information
evhdr.event_info=tline(1:47);
%origin time
evhdr.yr=str2num(tline(1:4));
evhdr.mo=str2num(tline(5:6));
evhdr.day=str2num(tline(7:8));
evhdr.hr=str2num(tline(9:10));
evhdr.mn=str2num(tline(11:12));
if tline(15) == ' '
evhdr.sec=0.0;
else
evhdr.sec=str2num([tline(13:14) '.' tline(15:16)]);
end

%ohr=str2num(hr);omn=str2num(mn);osec=str2num(sec);
%evhdr.otime=(ohr*60*60)+(omn*60)+osec;                %origin time in seconds
% event location
if tline(19) == 'S',lat_sign=-1;else lat_sign=+1;end
if tline(27) == 'W',lon_sign=-1;else lon_sign=+1;end
evhdr.lat=(str2num(tline(17:18))+(str2num([tline(20:21) '.' tline(22:23)])/60.0))*lat_sign;
evhdr.lon=(str2num(tline(24:26))+(str2num([tline(28:29) '.' tline(30:31)])/60.0))*lon_sign;
%if depth not set use negative depth to mark
%if tline(32:34) == '   ' & tline(35:36) == '  '
if tline(34) == ' ' & tline(35) == ' '
evhdr.depth=-1;
else
evhdr.depth=str2num([tline(32:34) '.' tline(35:36)]);
end
%event uncertainty
evhdr.eh1=str2num([tline(57:58) '.' tline(59:60)]);
evhdr.eh2=str2num([tline(66:67) '.' tline(68:69)]);
evhdr.eh3=str2num([tline(75:76) '.' tline(77:78)]);
evhdr.eh=max(evhdr.eh1,evhdr.eh2)/1.87;
evhdr.ez=evhdr.eh3/1.87;
if tline(50) == ' ', tline(50) = '0'; end
evhdr.rms=[tline(48:49) '.' tline(50:51)];
%magnitude
%if mag not set use negative mag to mark
if tline(38) == ' ',mag(3)='-11';
else
evhdr.mag=[tline(37) '.' tline(38)];
end

%STATION INFO
pp = 0;
while 1
    tline = fgetl(fid);
    if ~ischar(tline), break, end
    if isempty(tline),break,end
    if tline(1:2) == 'C*',continue,end
    if tline(1) == ' ',continue,end
    if tline(23) == ' ',tline(23) ='0';end
    if tline(21) == '.',tline(21) ='0';end
    if tline(35) == ' ',tline(35) ='0';end
    if tline(8) == ' ',continue,end
pp=pp+1;
    sta_temp=tline(1:4);
    ib=isspace(sta_temp);
    ev(pp).sta=sta_temp(~ib);
    newsta(pp)=cellstr(sta_temp(~ib));
    ev(pp).pwt=str2num(tline(8));
    ev(pp).swt=str2num(tline(40));
    hr=tline(16:17);mn=tline(18:19);sec=[tline(21:22) '.' tline(23:24)];
    phr=str2num(hr);pmn=str2num(mn);psec=str2num(sec);
    sec=[tline(32:34) '.' tline(35:36)];ssec=str2num(sec);
    ev(pp).ptime=(phr*60*60)+(pmn*60)+psec;  %ptime in seconds after hour
    ev(pp).stime=(phr*60*60)+(pmn*60)+ssec;
    if psec == 0.0
        ev(pp).pflg=0;
        else
        ev(pp).pflg=1;
        end
     if ssec == 0.0
        ev(pp).sflg=0;
        else
        ev(pp).sflg=1;
        end
    ev(pp).azimuth=str2num(tline(29:31));
    ev(pp).p_inc=str2num(tline(41:43));
    ev(pp).dist=str2num([tline(25:27) '.' tline(28)]);
    if tline(79) == ' ', tline(79) = '0';end
    if tline(79) == '-', tline(79) = '0';tline(78)='-';end
    ev(pp).pres=str2num([tline(76:78) '.' tline(79:80)]);
    ud=tline(7);   % we used column 65 for this information
    ev(pp).ptype=tline(65);
end
evhdr.nsta=pp;
fclose(fid);
%%% FINISHED with ARC file
    
                                                                                                                                                                                                                     read_archive2.m                                                                                     000644  000765  000024  00000006454 13444456517 014251  0                                                                                                    ustar 00steve                           staff                           000000  000000                                                                                                                                                                         function [evhdr,ev]=read_archive2(fname);
%function to read archive file and store data
%%% evhdr - structure containing event information
%%% ev	  - structure containing station information
%%% fname - path and archive file name
%%%% READ ARC FILE and store values in structure ev

sss=strread(fname,'%s','delimiter','/');
%evhdr.fn=char(sss(length(sss)-1));
f_arc= fname;

fid=fopen(f_arc);
tline = fgetl(fid); %archive file
%if ~ischar(tline),break,end
%event information
evhdr.event_info=tline(1:47);
%origin time
evhdr.yr=str2num(tline(1:4));
evhdr.mo=str2num(tline(5:6));
evhdr.day=str2num(tline(7:8));
evhdr.hr=str2num(tline(9:10));
evhdr.mn=str2num(tline(11:12));
if tline(15) == ' '
evhdr.sec=0.0;
else
evhdr.sec=str2num([tline(13:14) '.' tline(15:16)]);
end

%ohr=str2num(hr);omn=str2num(mn);osec=str2num(sec);
%evhdr.otime=(ohr*60*60)+(omn*60)+osec;                %origin time in seconds
% event location
if tline(19) == 'S',lat_sign=-1;else lat_sign=+1;end
if tline(27) == 'W',lon_sign=-1;else lon_sign=+1;end
evhdr.lat=(str2num(tline(17:18))+(str2num([tline(20:21) '.' tline(22:23)])/60.0))*lat_sign;
evhdr.lon=(str2num(tline(24:26))+(str2num([tline(28:29) '.' tline(30:31)])/60.0))*lon_sign;
%if depth not set use negative depth to mark
%if tline(32:34) == '   ' & tline(35:36) == '  '
if tline(34) == ' ' & tline(35) == ' '
evhdr.depth=-1;
else
evhdr.depth=str2num([tline(32:34) '.' tline(35:36)]);
end
%event uncertainty
evhdr.eh1=str2num([tline(57:58) '.' tline(59:60)]);
evhdr.eh2=str2num([tline(66:67) '.' tline(68:69)]);
evhdr.eh3=str2num([tline(75:76) '.' tline(77:78)]);
evhdr.eh=max(evhdr.eh1,evhdr.eh2)/1.87;
evhdr.ez=evhdr.eh3/1.87;
if tline(50) == ' ', tline(50) = '0'; end
evhdr.rms=[tline(48:49) '.' tline(50:51)];
%magnitude
%if mag not set use negative mag to mark
if tline(38) == ' ',mag(3)='-11';
else
evhdr.mag=[tline(37) '.' tline(38)];
end

%STATION INFO
pp = 0;
while 1
    tline = fgetl(fid);
    if ~ischar(tline), break, end
    if isempty(tline),break,end
    if tline(1:2) == 'C*',continue,end
    if tline(1) == ' ',continue,end
    if tline(23) == ' ',tline(23) ='0';end
    if tline(21) == '.',tline(21) ='0';end
    if tline(35) == ' ',tline(35) ='0';end
    if tline(8) == ' ',continue,end
pp=pp+1;
    sta_temp=tline(1:4);
    ib=isspace(sta_temp);
    ev(pp).sta=sta_temp(~ib);
    newsta(pp)=cellstr(sta_temp(~ib));
    ev(pp).pwt=str2num(tline(8));
    ev(pp).swt=str2num(tline(40));
    hr=tline(16:17);mn=tline(18:19);sec=[tline(21:22) '.' tline(23:24)];
    phr=str2num(hr);pmn=str2num(mn);psec=str2num(sec);
    sec=[tline(32:34) '.' tline(35:36)];ssec=str2num(sec);
    ev(pp).ptime=(phr*60*60)+(pmn*60)+psec;  %ptime in seconds after hour
    ev(pp).stime=(phr*60*60)+(pmn*60)+ssec;
    if psec == 0.0
        ev(pp).pflg=0;
        else
        ev(pp).pflg=1;
        end
     if ssec == 0.0
        ev(pp).sflg=0;
        else
        ev(pp).sflg=1;
        end
    ev(pp).azimuth=str2num(tline(29:31));
    ev(pp).p_inc=str2num(tline(41:43));
    ev(pp).dist=str2num([tline(25:27) '.' tline(28)]);
    if tline(79) == ' ', tline(79) = '0';end
    if tline(79) == '-', tline(79) = '0';tline(78)='-';end
    ev(pp).pres=str2num([tline(76:78) '.' tline(79:80)]);
    ud=tline(7);   % we used column 65 for this information
    ev(pp).ptype=tline(65);
end
evhdr.nsta=pp;
fclose(fid);
%%% FINISHED with ARC file
    
                                                                                                                                                                                                                    sect.m                                                                                              000700  000765  000024  00000002615 11057322713 012461  0                                                                                                    ustar 00steve                           staff                           000000  000000                                                                                                                                                                         %phiA is strike of cross section in degrees from north measured clockwise
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

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   