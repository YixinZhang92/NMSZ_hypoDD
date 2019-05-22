function [evhdr,ev]=read_archive(ddir,fname);
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
    
