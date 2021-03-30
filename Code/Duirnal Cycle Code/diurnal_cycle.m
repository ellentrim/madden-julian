%Diurnal cycle

%local time (.1 degrees longitude per minute)
clear;
landwatcol = zeros(24,1);
net_land = zeros(24,1);
oceanwatcol = zeros(24,1);
net_ocean = zeros(24,1);
coast = load('coast.mat');
[Z, R] = vec2mtx(coast.lat, coast.long, 1, [-90 90], [-90 270], 'filled');

folder = '/Users/ellen/Desktop/Summer/Daily/';

for i_year = 2006:2015
    %Import data
    filename = [int2str(i_year),'_daily.txt'];
    name = fullfile(folder,filename);
    file = importdata(name);

    


    Prec = file.data(:,8);
    WatCol = file.data(:,7);
    Lon = file.data(:,6);
    Lat = file.data(:,5);
    Hour = file.data(:,3);
    Min = file.data(:,4);
    
    Time = Hour + Min./60;
    
    size = length(Lat);
    value = ltln2val(Z, R, Lat, Lon);


    %iterate over each data point (one row)
    for i = 1:size
        
        
        if Prec(i) >= 0 && Lat(i) >= -15 && Lat(i) <= 20 && Lon(i) >= 90 && Lon(i) <= 150
        
        
            if value(i) == 2
                lctime = round(local_time(Lon(i),Time(i)));
               
                
                tmp_time = mod(lctime,24);
                
                rnd_hour = tmp_time + 1;
                
                if net_ocean(rnd_hour) == 0
                    oceanwatcol(rnd_hour,1) = WatCol(i);
                    net_ocean(rnd_hour) = 1;
                else
                    net_ocean(rnd_hour) = net_ocean(rnd_hour) +1;
                    oceanwatcol(rnd_hour,net_ocean(rnd_hour)) = WatCol(i);
                    
                end
                
            else
                lctime = round(local_time(Lon(i),Time(i)));
               
                
                tmp_time = mod(lctime,24);
                
                rnd_hour = tmp_time + 1;
                
                if net_land(rnd_hour) == 0
                    landwatcol(rnd_hour,1) = WatCol(i);
                    net_land(rnd_hour) = 1;
                else
                    net_land(rnd_hour) = net_land(rnd_hour) +1;
                    landwatcol(rnd_hour,net_land(rnd_hour)) = WatCol(i);
                    
                end
                
            end
        end
        
        
    end
end

oceanwatcol(oceanwatcol == 0)= NaN;
landwatcol(landwatcol == 0) = NaN;

S_ocean = std(oceanwatcol,0,2,'omitnan')./length(oceanwatcol)^.5;
M_ocean = nanmean(oceanwatcol,2);

S_land = std(landwatcol,0,2,'omitnan')./length(landwatcol)^.5;
M_land = nanmean(landwatcol,2);


S_land(25) = S_land(1);
S_ocean(25) = S_ocean(1);
M_land(25) = M_land(1);
M_ocean(25) = M_ocean(1);

x = [0:24];

figure;
errorbar(x,M_ocean,S_ocean,'b','linewidth',1.5);
hold on
errorbar(x,M_land,S_land,'k','linewidth',1.5);
legend('Ocean','Land','Location','Southwest');

ax = gca;
ax.XTick = [0:3:24];

set(gca,'xgrid','on') % turn on vertical grid lines 

set(gca,'ygrid','on') % turn on horizontal grid lines 

set(gca,'fontsize',20)

legend boxoff % removes the box from the legend - improves the look of the figure sometimes

set(gcf,'paperposition',[0.25 2.5 8.0 7.615]) % use this line with your plots to plot figures in a perfect square - again it improves the look of the figure



ylabel('Precipitable Water Vapor (mm)');
xlabel('Hours');


