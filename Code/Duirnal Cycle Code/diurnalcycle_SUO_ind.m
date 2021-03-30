%Individual day cycles of each station 

%list of stations [lat,lon]
clear;
stations = [15.2297; -12.1883; 13.7359; -12.8437; 13.4332; 1.3458; 14.6357; -12.4246; -10.45; -2.0609; -6.6737];
stations(:,2) = [145.7431; 96.834; 100.5339; 131.1327; 144.8027; 103.68; 121.0777; 130.8916; 105.6885; 147.4253; 146.9932];

nStations = length(stations(:,1));

landwatcol = zeros(11,24);
oceanwatcol = zeros(11,24);
net_land = zeros(11,24);
net_ocean = zeros(11,24);
coast = load('coast.mat');
[Z, R] = vec2mtx(coast.lat, coast.long, 1, [-90 90], [-90 270], 'filled');

folder = '/Users/ellen/Desktop/Summer/SUOMINET_Daily/';


Lon_stat = zeros(nStations);


for i_year = 2007:2015
    %Import data
    filename = ['SUOMINET_',int2str(i_year),'_daily.txt'];
    name = fullfile(folder,filename);
    file = importdata(name);

    


    Prec = file.data(:,7);
    WatCol = file.data(:,6);
    Lon = file.data(:,5);
    Lat = file.data(:,4);
    Hour = file.data(:,3);

    
    Time = Hour;
    
    size = length(Lat);
    value = ltln2val(Z, R, Lat, Lon);


    %iterate over each data point (one row)
    for i_stat = 1:nStations
        
        for i = 1:size


            if fix(Lon(i)) == fix(stations(i_stat,2)) && WatCol(i) > 0
                
                if Lon_stat(nStations) ~= 0
                    
                    Lon_stat(nStations) = Lat(i);
                    
                end

                if value(i) == 2
                    lctime = round(local_time(Lon(i),Time(i)));


                    tmp_time = mod(lctime,24);

                    rnd_hour = tmp_time + 1;

                    if  net_ocean(i_stat,rnd_hour) == 0;
                        oceanwatcol(i_stat,rnd_hour,1) = WatCol(i);
                        net_ocean(i_stat,rnd_hour) = 1;
                    else
                        net_ocean(i_stat,rnd_hour) = net_ocean(i_stat,rnd_hour) +1;
                        oceanwatcol(i_stat,rnd_hour,net_ocean(i_stat,rnd_hour)) = WatCol(i);
                       
                    end
                else 
                    lctime = round(local_time(Lon(i),Time(i)));


                    tmp_time = mod(lctime,24);

                    rnd_hour = tmp_time + 1;

                    if  net_land(i_stat,rnd_hour) == 0;
                        landwatcol(i_stat,rnd_hour,1) = WatCol(i);
                        net_land(i_stat,rnd_hour) = 1;
                    else
                        net_land(i_stat,rnd_hour) = net_land(i_stat,rnd_hour) +1;
                        landwatcol(i_stat,rnd_hour,net_land(i_stat,rnd_hour)) = WatCol(i);
                       
                    end
                end
                
            end
        end
    end
end

oceanwatcol(oceanwatcol == 0)= NaN;
landwatcol(landwatcol == 0) = NaN;

oceanwatcol(:,25,:) = oceanwatcol(:,1,:);
landwatcol(:,25,:) = landwatcol(:,1,:);

x = [0:24];
figure
land = [3,4,6,7,8,10];
ocean = [1,2,5,9];
for i_s = 1:6
    S = std(landwatcol(land(i_s),:,:),0,3,'omitnan')./length(landwatcol(land(i_s),:,:))^.5;
    M = nanmean(landwatcol(land(i_s),:,:),3);

    subplot(2,3,i_s);
    errorbar(x,M,S,'LineWidth',2);
    axis([-1 24 35 60]);
    title(land(i_s)); 
    xlabel('Hours')
    ylabel('PWV (mm)')
    
    ax = gca;
ax.XTick = [0:3:24];

set(gca,'xgrid','on') % turn on vertical grid lines 

set(gca,'ygrid','on') % turn on horizontal grid lines 

set(gca,'fontsize',15)

legend boxoff % removes the box from the legend - improves the look of the figure sometimes

% set(gcf,'paperposition',[0.25 2.5 8.0 7.615]) % use this line with your plots to plot figures in a perfect square - again it improves the look of the figure



end

figure;

for i_s = 1:4
    S = std(oceanwatcol(ocean(i_s),:,:),0,3,'omitnan')./length(oceanwatcol(land(i_s),:,:))^.5;
    M = nanmean(oceanwatcol(ocean(i_s),:,:),3);

    subplot(2,2,i_s);
    errorbar(x,M,S,'LineWidth',2);
    axis([-1 24 35 60]);
    title(ocean(i_s)); 
    xlabel('Hours')
    ylabel('PWV (mm)')
    
    ax = gca;
ax.XTick = [0:3:24];

set(gca,'xgrid','on') % turn on vertical grid lines 

set(gca,'ygrid','on') % turn on horizontal grid lines 

set(gca,'fontsize',15)

legend boxoff % removes the box from the legend - improves the look of the figure sometimes

set(gcf,'paperposition',[0.25 2.5 8.0 7.615]) % use this line with your plots to plot figures in a perfect square - again it improves the look of the figure



end
% 
% 
% figure 
% worldmap([-15 20],[90 150]);
% plotm(stations,'o');
% load coast
% hold on
% plotm(lat, long,'k');

