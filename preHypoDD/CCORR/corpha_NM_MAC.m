% Code to do Wave cross-correlation

dt=100.0; delta=0.01; % sample rate 

%%%%%%%%%%%%%%%% Input files
% data.phase
% dt.ct
% all_event.list 
%%%%%%%%%%%%%%%% Output files
% dt.cc
% dt_out.cc




%npts=128;n2=npts/2; nfft=n2+1; df=1.0/(delta*npts);
%npts=256;n2=npts/2;
%T=(npts-1)*delta;
%t=0:delta:T;
%h=hann(npts); the nuttall window clobbers the ends best
%h=nuttallwin(npts);
%define filter stuff

lp = 2.0*30.0/dt; hp = 2.0*0.6/dt; % low pass; high pass
% Set the filter parameters

[b_lw,a_lw] = butter (4,lp);
[b_hp,a_hp] = butter (4,hp,'high');

fid=fopen('data.phase');
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
fid=fopen('2000.txt');
p=1;
while 1
    tline = fgetl(fid);
    if ~ischar(tline), break, end
    ev(p).dir = [tline '/'];
    p=p+1;
end
fclose(fid);

fd=fopen('dt.cc','w');
fcd=fopen('dt_out.cc','w');
origin=0.0;

%d_dir='/gaia/data/seisnet/NM/';
d_dir='/Volumes/Untitled/Data/';
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
        e_1=str2num(tline(tl_let(2):tl_let(num_end(2))));      % event1
        e_2=str2num(tline(tl_let(num_end(2)+1):tl_let(length(tl_let)))); % event2
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
        
        if wt >= 0.7   %wt=amax correlation coef. has to be greater than 0.7 to keep.
%             figure(1)
%             a1_max=max(a1);a2_max=max(a2);
%             scale=a1_max/a2_max;
%             subplot(2,1,1);plot(t,a1,'b',t,a2*scale,'r')
%             title(name)
%             np=round((off_time-wdel)*dt);
%             a2=data(np-n2:np+n2-1).*h;
%             a1_max=max(a1);a2_max=max(a2);
%             scale=a1_max/a2_max;
%             subplot(2,1,2);plot(t,a1,'b',t,a2*scale,'r')
%             figure(2)
%             plot(lag*delta,acor,'b',lag(imax)*delta,amax,'ro')
%             pause(1)
            %              pause
            %if wt >= 0.7   %wt=amax correlation coef. has to be greater than 0.7 to keep.
            fprintf(fcd,'%s %s %f %f %f \n',sta,type,abs_time,wdel,wt);
            fprintf(fd,'%s %f %f %s \n',sta,wdel,wt,type);
            %          fprintf('%s %f %f %s \n',sta,wdel,wt,type);
        end
    end
end
fclose(fd);
fclose(fid);
