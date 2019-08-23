clear all;
% PARAMETER DESCRIPTION:
%--- file names:
% file_reloc    hypocenter file after relocation (hypoDD.reloc)
% file_loc      hypocenter file before relocation (hypoDD.loc)
% file_sta      station file (hypoDD.sta)
% file_line     line file to display geography
%                 (lines of lon, lat; separators are Nan, NaN)

%--- cross section:
% phiA          strike of cross section
% xshift        x-location
% yshift        y-location
% box_l         length
% box_w         half width

%--- event selection:
% axlim         axis dimension of map view plot
% minmag        circle events with mag>minmag
% id=[]         mark these events
% itake=[]      display only these events
% err=1         display errors [0,1]

% PARAMETER SETTING:
file_reloc='../hypoDD.reloc'; file_loc='../hypoDD.loc'; file_sta='../hypoDD.sta'; 
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
depth1 = mdat1(:,4); 

for i = 1:length(mdat1(:,22))
    if mdat1(i,22) == -9 & mdat1(i,23) ~= -9 
        rms(i) = mdat1(i,23);
    elseif mdat1(i,22) == -9 & mdat1(i,23) ~= -9
        rms(i) = mdat1(i,22);
    elseif mdat1(i,22) ~= -9 & mdat1(i,23) ~= -9
        rms(i) = mean(mdat1(i,23)+mdat1(i,22));
    end
end


% x1 = mdat1(:,5)/1000; y1 = mdat1(:,6)/1000; z1 = -mdat1(:,4);
% ex1 = mdat1(:,8)/1000; ey1 = mdat1(:,9)/1000; ez1 = mdat1(:,10)/1000;

lon2=mdat2(:,3); lat2=mdat2(:,2); depth2 = mdat2(:,4); 
% x2 = mdat2(:,5)/1000; y2 = mdat2(:,6)/1000; z2 = -mdat2(:,4);
% ex2 = mdat2(:,8)/1000; ey2 = mdat2(:,9)/1000; ez2 = mdat2(:,10)/1000;

% if(sum(ex1)==0); ex1=ex1+1;ey1=ey1+1;ez1=ez1+1;end; 
mag(find(mag==0))= 0.2; % Need explaination

% To specify some events
% if(length(itake) > 0);
%     clear ind; k=1; 
%     for i=1:length(cusp); 
%         for j=1:length(itake);
%             if(itake(j)==cusp(i)); ind(k)= i; k=k+1; end;
%         end;
%     end;
%     x1= x1(ind); y1= y1(ind); z1= z1(ind); lon1=lon1(ind); lat1=lat1(ind);
%     cusp=cusp(ind);mag=mag(ind);ex1=ex1(ind);ey1=ey1(ind);ez1=ez1(ind);
% end;

disp(['# of events = ' num2str(length(cusp))]);
disp(['mean rms = ' num2str(mean(rms))]);

