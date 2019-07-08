%%% plot with clusters

% cluster 1: 36.45N ~36.75N; 90.1W~89.7W
% cluster 2: 36.6N ~37.1N; 89.7W~89W
% cluster 3: 36.33N ~36.6N; 89.7W~89.4W
% cluster 4: 36.03N ~36.33N; 89.6W~89.33W
% cluster 5: 35.5N ~36.25N; 90.5W~89.55W

%% Define map margin and file terms
file_reloc='hypoDD.reloc'; file_loc='hypoDD.loc'; file_sta='hypoDD.sta'; 
file_line=''; 
axis_latmin = 35.5;
axis_latmax = 37.5;
axis_lonmin = -90.5;
axis_lonmax = -88.5;

%% load files and define parameters

mdat1=load(file_reloc); 
mdat2=load(file_loc); 

cusp1 = mdat1(:,1);lon1=mdat1(:,3); lat1=mdat1(:,2); depth1 = mdat1(:,4); rms = mdat1(:,23);
cusp2 = mdat2(:,1);lon2=mdat2(:,3); lat2=mdat2(:,2); depth2 = mdat2(:,4); 

%% put events into clusters

% cluster 1
ind1 = find(lon1 >-90.1 & lon1 <-89.7 & lat1 >36.45 & lat1 < 36.75); 
% cluster 2
ind2 = find(lon1 >-89.7 & lon1 <-89 & lat1 >36.6 & lat1 < 37.1); 
% cluster 1
ind3 = find(lon1 >-89.7 & lon1 <-89.4 & lat1 >36.33 & lat1 < 36.6); 
% cluster 1
ind4 = find(lon1 >-89.6 & lon1 <-89.33 & lat1 >36.03 & lat1 < 36.33); 
% cluster 1
ind5 = find(lon1 >-90.5 & lon1 <-89.55 & lat1 >35.5 & lat1 < 36.25); 

%% plot horizontal map

if(length(file_line)>0);border=load(file_line); else; border=[0,0];end;

figure('Name','Relocation_clusters'); set(gcf,'clipping','off');
plot(border(:,1),border(:,2),'linewidth',0.1,'color',[0.8 0.8 0.8]);

for i=1:length(lon2)
    plot(lon2,lat2,'o','markersize',1,'color','b');
end

title('Relocation Map'); 
xlabel('longitude'); 
ylabel('latitude');
axis('equal');box('on');
ylim([axis_latmin axis_latmax])
xlim([axis_lonmin axis_lonmax])

axis normal

hold on


plot(lon1(ind1),lat1(ind1),'o','markersize',0.5,'color','r');
plot(lon1(ind2),lat1(ind2),'o','markersize',0.5,'color','g');
plot(lon1(ind3),lat1(ind3),'o','markersize',0.5,'color','c');
plot(lon1(ind4),lat1(ind4),'o','markersize',0.5,'color','m');
plot(lon1(ind5),lat1(ind5),'o','markersize',0.5,'color','g');




legend({'origin location','relocation c1','relocation c2',...
    'relocation c3','relocation c4','relocation c5'},'FontSize',14)

for i = length(ind1)
    temp_shft_lat_c1(i) = lat1(ind1(i))-lat2(find(cusp2 == cusp1(ind1(i))));
    temp_shft_lon_c1(i) = mean(lon1(ind1(i))-lon2(find(cusp2 == cusp1(ind1(i)))));
    temp_shft_depth_c1(i) = mean(depth1(ind1(i))-depth2(find(cusp2 == cusp1(ind1(i)))));
end

for i = length(ind2)
    temp_shft_lat_c2 = mean(lat1(ind2(i))-lat2(find(cusp2 == cusp1(ind2(i)))));
    temp_shft_lon_c2 = mean(lon1(ind2(i))-lon2(find(cusp2 == cusp1(ind2(i)))));
    temp_shft_depth_c2 = mean(depth1(ind2(i))-depth2(find(cusp2 == cusp1(ind2(i)))));
end

for i = length(ind3)
    temp_shft_lat_c3 = mean(lat1(ind3(i))-lat2(find(cusp2 == cusp1(ind3(i)))));
    temp_shft_lon_c3 = mean(lon1(ind3(i))-lon2(find(cusp2 == cusp1(ind3(i)))));
    temp_shft_depth_c3 = mean(depth1(ind3(i))-depth2(find(cusp2 == cusp1(ind3(i)))));
end

for i = length(ind4)
    temp_shft_lat_c4 = mean(lat1(ind4(i))-lat2(find(cusp2 == cusp1(ind4(i)))));
    temp_shft_lon_c4 = mean(lon1(ind4(i))-lon2(find(cusp2 == cusp1(ind4(i)))));
    temp_shft_depth_c4 = mean(depth1(ind4(i))-depth2(find(cusp2 == cusp1(ind4(i)))));
end

for i = length(ind5)
    temp_shft_lat_c5 = mean(lat1(ind5(i))-lat2(find(cusp2 == cusp1(ind5(i)))));
    temp_shft_lon_c5 = mean(lon1(ind5(i))-lon2(find(cusp2 == cusp1(ind5(i)))));
    temp_shft_depth_c5 = mean(depth1(ind5(i))-depth2(find(cusp2 == cusp1(ind5(i)))));
end


disp(['latitude of cluster1 shift = ' num2str(mean(temp_shft_lat_c1))]);
disp(['longitude of cluster1 shift = ' num2str(mean(temp_shft_lon_c1))]);
disp(['depth of cluster1 shift = ' num2str(mean(temp_shft_depth_c1))]);

disp(['latitude of cluster2 shift = ' num2str(mean(temp_shft_lat_c2))]);
disp(['longitude of cluster2 shift = ' num2str(mean(temp_shft_lon_c2))]);
disp(['depth of cluster2 shift = ' num2str(mean(temp_shft_depth_c2))]);

disp(['latitude of cluster3 shift = ' num2str(mean(temp_shft_lat_c3))]);
disp(['longitude of cluster3 shift = ' num2str(mean(temp_shft_lon_c3))]);
disp(['depth of cluster3 shift = ' num2str(mean(temp_shft_depth_c3))]);

disp(['latitude of cluster4 shift = ' num2str(mean(temp_shft_lat_c4))]);
disp(['longitude of cluster4 shift = ' num2str(mean(temp_shft_lon_c4))]);
disp(['depth of cluster4 shift = ' num2str(mean(temp_shft_depth_c4))]);

disp(['latitude of cluster5 shift = ' num2str(mean(temp_shft_lat_c5))]);
disp(['longitude of cluster5 shift = ' num2str(mean(temp_shft_lon_c5))]);
disp(['depth of cluster5 shift = ' num2str(mean(temp_shft_depth_c5))]);








