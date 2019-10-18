%%%%%% For redoing Meredith's work %%%%%%

% Cluster all events into XX clusters
close all;
clear all;
% step1: find index of events in each cluster 
% find those events in reloc file 
% plot loc with mat and not match

% Read cluster files
cList = dir('cluster*.txt');
% line 1: length, width, strike, dip, lamda

%--- cross section:
% pc*          strike of cross section
% xshift        x-location
% yshift        y-location
% box_l         length
% box_w         half width
% Plot cross sections
pc{1} = [];% c1: vertical 
pc{2} = [];
pc{3} = -110+20;
pc{4} = -19+65+90+180;
pc{5} = 80.747+180;
pc{6} = [];
pc{7} = [];

% map area
d_range{1} = [0,8];
d_range{2} = [5,30];
d_range{3} = [-20,0];
d_range{4} = [-15,0];
d_range{5} = [-20,0];
d_range{6} = [-50,-20];
d_range{7} = [-90,-40];
x_range{1} = [10,40];
x_range{2} = [25,50];

x_range{3} = [20,70];

x_range{4} = [35,60];
x_range{5} = [30,70];
x_range{6} = [0,50];
x_range{7} = [-60,20];

% Read location file
file_ind_ori = load('xyz_all.ind_loc');
% file_ind_loc = load('xyz_SVDcat.ind_loc');
file_ind_reloc = load('xyz_SVDcat.ind_reloc');

ind_ori = file_ind_ori(:,1);
lon_ori = file_ind_ori(:,2);
lat_ori = file_ind_ori(:,3);
depth_ori = file_ind_ori(:,4);

ind_reloc = file_ind_reloc(:,1);
lon_reloc = file_ind_reloc(:,2);
lat_reloc = file_ind_reloc(:,3);
depth_reloc = file_ind_reloc(:,4);

for i = 1:length(cList)
    cloc{i} = load(cList(i).name);
    % Set parameters
    lon = cloc{i}(:,1);
    lat = cloc{i}(:,2);
    depth = cloc{i}(:,3);
    ind = zeros(length(lon),1);

    for j = 1:size(cloc{i},1)
        a = find(abs(file_ind_ori - lon(j)) < 0.001) - length(file_ind_ori);
        b = find(abs(file_ind_ori - lat(j)) < 0.001) - 2*length(file_ind_ori);
        c = find(abs(file_ind_ori - depth(j)) < 0.001) - 3*length(file_ind_ori);
        temp_ind = intersect(a,intersect(b,c)); % this is the index in origin_file
        if length(temp_ind) == 1
            ind(j) = file_ind_ori(temp_ind,1);
        elseif length(temp_ind) == 0
        else
            if ismember(file_ind_ori(temp_ind(1),1), ind) == 0
                ind(j) = file_ind_ori(temp_ind(1),1);
            else
                k = 1;
                while ismember(file_ind_ori(temp_ind(k),1), ind) == 1
                    k = k+1;
                end
                ind(j) = file_ind_ori(temp_ind(k),1);
            end
        end
    end
    
    m = 0;
    n = 0;
    for l = 1:length(lon)
        if ismember(ind(l), ind_reloc)
            m = m+1;
            pd_loc{i}(m,:) = [lon(l),lat(l),depth(l)];
            
            idr = find(file_ind_reloc == ind(l));
            pd_reloc{i}(m,:) = [file_ind_reloc(idr,2),file_ind_reloc(idr,3),...
                file_ind_reloc(idr,4)];
        else
            n = n+1;
            pd_extra{i}(n,:) = [lon(l),lat(l),depth(l)];
        end
    end
        
end

for o = 1%1:length(cList)
    
    figure('Name',cList(o).name)
    set(gcf,'clipping','off');
    
    dotsize = 2;
    title(cList(o).name)
    if isempty(pc{o}) == 0
        theta = (-pc{o})/180*pi;
        subplot(1,2,1)
        plot(pd_loc{o}(:,1)*sin(theta)-pd_loc{o}(:,2)*cos(theta),...
            pd_loc{o}(:,3),'o','markersize',dotsize,'color',[0,0,0]);
        hold on;
        plot(pd_extra{o}(:,1)*sin(theta)-pd_extra{o}(:,2)*cos(theta),...
            pd_extra{o}(:,3),'o','markersize',dotsize,'color',[0.6,0.6,0.6]);
        xlabel('distance (km)');
        ylabel('depth (km)');
        xlim(x_range{o});
        ylim(d_range{o});
%         annotation('textbox',[0.75,0.1,.1,.1],'String',['Azimuth = ' ...
%             num2str(90-(pc{o}-180)+180)],'FitBoxToText','on');
        subplot(1,2,2)
        plot(pd_reloc{o}(:,1)*sin(theta)-pd_reloc{o}(:,2)*cos(theta),...
            pd_reloc{o}(:,3),'o','markersize',dotsize,'color',[0,0,0]);
        xlabel('distance (km)');
        ylabel('depth (km)');
        xlim(x_range{o});
        ylim(d_range{o});
%         annotation('textbox',[0.80,0.1,.1,.1],'String',['Azimuth = ' ...
%             num2str(180-(pc{o}-180)+180)],'FitBoxToText','on');
        annotation('textbox',[0.80,0.1,.1,.1],'String',['Azimuth = ' ...
            num2str(pc{o}+90+180)],'FitBoxToText','on');
        
    elseif isempty(pc{o}) == 1
        subplot(1,2,1)
        plot(pd_loc{o}(:,1),pd_loc{o}(:,2),'o','markersize',...
            dotsize,'color',[0,0,0]);
        hold on;
        plot(pd_extra{o}(:,1),pd_extra{o}(:,2),'o','markersize',...
            dotsize,'color',[0.6,0.6,0.6]);
        xlabel('longitude (km)');
        ylabel('latitude (km)');
        xlim(x_range{o});
        ylim(d_range{o});
        subplot(1,2,2)
        plot(pd_reloc{o}(:,1),pd_reloc{o}(:,2),'o','markersize',...
            dotsize,'color',[0,0,0]);
        xlabel('longitude (km)');
        ylabel('latitude (km)');
        xlim(x_range{o});
        ylim(d_range{o});
        annotation('textbox',[0.8,0.1,.1,.1],'String','Mapview','FitBoxToText','on');
    end
    
    figure
%     plot(border(:,1),border(:,2),'linewidth',0.1,'color',[0.8 0.8 0.8]);
    subplot(1,2,1)
    plot3(pd_loc{o}(:,1),pd_loc{o}(:,2),pd_loc{o}(:,3),'o','markersize',...
        dotsize,'color',[0,0,0]);
    hold on;
    plot3(pd_extra{o}(:,1),pd_extra{o}(:,2),pd_extra{o}(:,3),'o',...
        'markersize',dotsize,'color',[0.6,0.6,0.6]);
    xlabel('x in km (lon)');
    ylabel('y in km (lat)');
    zlabel('depth in km');
    
    subplot(1,2,2)
    plot3(pd_reloc{o}(:,1),pd_reloc{o}(:,2),pd_reloc{o}(:,3),'o',...
        'markersize',dotsize,'color',[0,0,0]);
    zlim([-18,0])
    xlabel('x in km (lon)');
    ylabel('y in km (lat)');
    zlabel('depth in km');
    
end





