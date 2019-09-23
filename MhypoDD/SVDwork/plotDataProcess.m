%%%%%%%% How data deleted or shifted %%%%%%%%%

% original data set that contains all events
ori = load('xyz_all.ind_loc'); 
% partitioned data set, clusters that contains only one event were deleted
clus = load('xyz_clustered.ind_loc'); 
% events that is not fitted in my parameter settings are deleted by hypoDD
loc = load('xyz_SVDcat.ind_loc');
% events deleted in the process of hypoDD, reasons can be: 
%   RMS residual droped below the noise level of the data (iteration stopped)
%   relocated hypocenters are above the ground (to solve: increase damping or geometrical control)
reloc = load('xyz_SVDcat.ind_reloc');

ind_ori = ismember(ori(:,1),clus(:,1));
ind_clus = ismember(clus(:,1),loc(:,1));
ind_loc = ismember(loc(:,1),reloc(:,1));

% plot area
axis_latmin = -100;
axis_latmax = 100;
axis_lonmin = -100;
axis_lonmax = 100;

figure('Name','Data Processing'); set(gcf,'clipping','off');

dotsize = 2;

% plot(border(:,1),border(:,2),'linewidth',0.1,'color',[0.8 0.8 0.8]);
a = 0; b = 0; c = 0; d = 0;
for i = 1:length(ind_ori)
    if ind_ori(i) == 0
        a = a+1;
        ori_plot(a,1) = ori(i,2);
        ori_plot(a,2) = ori(i,3);
        ori_plot(a,3) = ori(i,4);
    end
end

for i = 1:length(ind_clus)
    if ind_clus(i) == 0
        b = b+1;
        clus_plot(b,1) = clus(i,2);
        clus_plot(b,2) = clus(i,3);
        clus_plot(b,3) = clus(i,4);
    end
end

for i = 1:length(ind_loc)
    if ind_ori(i) == 0
        c = c+1;
        loc_plot(c,1) = loc(i,2);
        loc_plot(c,2) = loc(i,3);
        loc_plot(c,3) = loc(i,4);
    end
end

for i = 1:length(ind_loc)
    if ind_ori(i) == 1
        d = d+1;
        locr_plot(d,1) = loc(i,2);
        locr_plot(d,2) = loc(i,3);
        locr_plot(d,3) = loc(i,4);
    end
end

plot3(ori_plot(:,1), ori_plot(:,2), ori_plot(:,3), 'o','markersize',dotsize,'color',[1,0,0])
        hold on;
plot3(clus_plot(:,1), clus_plot(:,2), clus_plot(:,3), 'o','markersize',dotsize,'color',[1,0.5,0])
        
plot3(loc_plot(:,1), loc_plot(:,2), loc_plot(:,3), 'o','markersize',dotsize,'color',[0.5,0.5,0])
        
plot3(locr_plot(:,1), locr_plot(:,2), locr_plot(:,3), 'o','markersize',dotsize,'color',[0.5,1,0])
        
plot3(reloc(:,2), reloc(:,3), reloc(:,4), 'o','markersize',dotsize,'color','b')

title('Relocation Map'); 
xlabel('x'); 
ylabel('y');
axis('equal');box('on');
ylim([axis_latmin axis_latmax])
xlim([axis_lonmin axis_lonmax])

axis normal

legend({'original location','deleted manually','deleted by hypoDD','location before hypoDD','relocated location'},'FontSize',14)


