% correlate earthquake data for input to hypoDD
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
