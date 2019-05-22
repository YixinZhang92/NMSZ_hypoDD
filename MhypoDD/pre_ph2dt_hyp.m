function []=pre_ph2dat_hyp(target_year)
% get phase data from arc files for input to ph2dt
% target_year = '2017';
datadir=['/Volumes/Untitled/Data/' target_year '/Loc/'];   %path on MAC
% fd=fopen('data.pha_2017','w')
fd=fopen(['/Users/yixinzhang/Desktop/test_HYPODD/Output/' target_year ...
    '/data.phase'],'w');     %output data file
wt=[1.0 0.5 0.2 0.1];

%get event list
elist=dir([datadir '2*']);
ne=length(elist);
for i=1:ne
%for i=1:2
%header information
    fn=char(elist(i).name);
    fname=[datadir fn '/' fn '.hyp']; % .hyp file name
    fprintf('%s\n',fname);
    [evhdr,ev]=r_hyp0(fname);
    yr=evhdr.yr;mo=evhdr.mo;day=evhdr.day;hr=evhdr.hr;mn=evhdr.mn;sec=evhdr.sec;
    lat=evhdr.lat;lon=evhdr.lon;depth=evhdr.depth;
    mag=evhdr.mag;eh=evhdr.eh;ez=evhdr.ez;rms=evhdr.rms;
    id=i;
fprintf(fd,'# %02d %02d %02d %02d %02d %05.2f %6.3f %6.3f %5.2f ',yr,mo,day,hr,mn,sec,lat,lon,depth);
fprintf(fd,'%s %4.2f %4.2f %s %d \n',mag,eh,ez,rms,id);

    otime=(hr*60*60)+(mn*60)+sec;                %origin time in seconds

%station
    for j=1:evhdr.nsta
        sta=ev(j).sta;
        if ev(j).pflg == 1
           ptt=ev(j).ptime-otime;
           if ptt < 0.0, continue,end
           wt_id=ev(j).pwt+1;
           if wt_id > 4,continue,end
           fprintf(fd,'%s %6.3f %3.1f P \n',sta,ptt,wt(wt_id));
           end
        if ev(j).sflg == 1
           ptt=ev(j).stime-otime;
           if ptt < 0.0, continue,end
           wt_id=ev(j).swt+1;
           if wt_id > 4,continue,end
           fprintf(fd,'%s %6.3f %3.1f S \n',sta,ptt,wt(wt_id));
           end
        end
   clear ev evhdr
end
fclose(fd);






