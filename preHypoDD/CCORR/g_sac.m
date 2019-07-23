function [data,delta,nheader,fid] = g_sac(name)
filename = name;
%[fid,message] = fopen(filename);
%[fid,message] = fopen(filename,'r','l');
[fid,message] = fopen(filename,'r','b');
if fid ~= -1
  [fheader,count] = fread(fid,70,'float');
  [nheader,count] = fread(fid,35,'long');
  [lheader,count] = fread(fid,5,'long');
  [kheader,count] = fread(fid,[8,24],'char');

  npts = nheader(10);
  delta = fheader(1);
  date = nheader(1:2);
  hour = nheader(3);
  minu = nheader(4);
  seco = nheader(5) + (nheader(6)/1000);
  data = zeros(npts,1);
  [data,count] = fread(fid,npts,'float');

%
  close_stat = fclose(fid);
else
  disp(message)
  clear file path filename message
end
