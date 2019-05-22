function [evhdr,ev]=r_hyp0(f_hyp);
% program to read hyp file
%does not read a station with only an S_arrival (no P_arrival)
%%% !!! This read a station with only an S_arrival !!!!
% f_hyp='/Volumes/seisnet/NM/2015/Loc/20150105_022229/20150105_022229.hyp';
%f_hyp='/Volumes/seisnet/NM/2015/Loc/20150110_040847/20150110_040847.hyp';

%% Commented to test
aline = textread(f_hyp,'%s','delimiter','\n','whitespace','');
nl=length(aline);

%process first line
tline=char(aline(1));

%% Test
% fid = fopen(f_hyp,'r');
% tline = fgetl(fid);

%% Continue
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
% event location
if tline(19) == 'S',lat_sign=-1;else lat_sign=+1;end
if tline(27) == 'E',lon_sign=+1;else lon_sign=-1;end
evhdr.lat=(str2num(tline(17:18))+(str2num([tline(20:21) '.' tline(22:23)])/60.0))*lat_sign;
evhdr.lon=(str2num(tline(24:26))+(str2num([tline(28:29) '.' tline(30:31)])/60.0))*lon_sign;
%if depth not set use negative depth to mark
if tline(35) == ' ', tline(35) = '0';end
evhdr.depth=str2num([tline(32:34) '.' tline(35:36)]);
%event uncertainty
evhdr.eh=str2num([tline(86:87) '.' tline(88:89)]);
evhdr.ez=str2num([tline(90:91) '.' tline(92:93)]);
if tline(51) == ' ',tline(51) = '0'; end
evhdr.rms=str2num([tline(49:50) '.' tline(51:52)]);
%magnitude
evhdr.mag=[tline(71) '.' tline(72:73)];


for i=2:nl-1     %the last line of the hyp file is not station data
    sta_n{i-1}=char(aline{i}(1:4));
    CMP{i-1}=char(aline{i}(12));
    SMP{i-1}=char(aline{i}(48));
end

inP=find(strcmp(CMP,'Z') == 1);
np=length(inP);
inS=find(strcmp(SMP,'S') == 1);
ns=length(inS);
for pp=1:np
    tline=char(aline(inP(pp)+1));
    sta_n{pp}=tline(1:4);
    ev(pp).sta=tline(1:4);
    sta_n{pp}=tline(1:4);
    if tline(33) == ' ',tline(33) ='0';end
    if tline(31) == '.',tline(31) ='0';end
    ev(pp).premark = tline(14:15);
    ev(pp).pfm=tline(16);
    ev(pp).pwt=str2num(tline(17));
    hr=tline(26:27);mn=tline(28:29);seco=[tline(30:32) '.' tline(33:34)];
    %fprintf('%s %s %s\n',hr,mn,sec)
    phr=str2num(hr);pmn=str2num(mn);psec=str2num(seco);
    ev(pp).ptime=(phr*60*60)+(pmn*60)+psec;  %ptime in seconds after day start
    if psec == 0.0
        ev(pp).pflg=0;
    else
        ev(pp).pflg=1;
    end
    ev(pp).azimuth=str2num(tline(92:94));
    %    ev(pp).p_inc=str2num(tline(41:43));
    ev(pp).dist=str2num([tline(75:78)])/10.0;
    ev(pp).pres=str2num([tline(36:37) '.' tline(38:39)]);
    %  fprintf('%s %1d %f\n',ev(pp).sta,ev(pp).pwt,ev(pp).ptime)
end

evhdr.nsta=np;
i_new=np;
for p = 1:ns
    tline=char(aline(inS(p)+1));
    stap=tline(1:4);
    index=find((strcmp(sta_n,stap) == 1),1,'first');
    %    if isempty(index) == 1, continue, end
    if isempty(index) == 0
        pp=index;
        hr=tline(26:27);mn=tline(28:29);
        sc=[tline(42:44) '.' tline(45:46)];ssec=str2num(sc);
        shr=str2num(hr);smn=str2num(mn);
        ev(pp).stime=(shr*60*60)+(smn*60)+ssec;
        if ssec == 0.0
            ev(pp).sflg=0;
        else
            ev(pp).sflg=1;
        end
        if tline(53) == ' ', tline(53) = '0';end
        if tline(53) == '-', tline(53) = '0';tline(52)='-';end
        ev(pp).sres=str2num([tline(51:52) '.' tline(53:54)]);
        ev(pp).swt=str2num(tline(50));
    elseif isempty(index) == 1
        i_new=i_new+1;
        pp=i_new;
        ev(pp).sta=stap;
        ev(pp).pflg=0;
        ev(pp).azimuth=str2num(tline(92:94));
        ev(pp).dist=str2num([tline(75:78)])/10.0;
        hr=tline(26:27);mn=tline(28:29);
        sc=[tline(42:44) '.' tline(45:46)];ssec=str2num(sc);
        shr=str2num(hr);smn=str2num(mn);
        
        ev(pp).stime=(shr*60*60)+(smn*60)+ssec;
        if ssec == 0.0
            ev(pp).sflg=0;
        else
            ev(pp).sflg=1;
        end
        if tline(53) == ' ', tline(53) = '0';end
        if tline(53) == '-', tline(53) = '0';tline(52)='-';end
        ev(pp).sres=str2num([tline(51:52) '.' tline(53:54)]);
        ev(pp).swt=str2num(tline(50));
    end
    
    
    %    fprintf('%s %d\n',stap,index)
end
