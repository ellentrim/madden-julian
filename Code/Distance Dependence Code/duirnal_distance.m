%Diurnal cycle

%local time (.1 degrees longitude per minute)
clear;
landclosewatcol = zeros(24,1);
net_close_land = zeros(24,1);

landmiddlewatcol = zeros(24,1);
net_middle_land = zeros(24,1);

landfarwatcol = zeros(24,1);
net_far_land = zeros(24,1);

oceanwatcol = zeros(24,1);
net_ocean = zeros(24,1);
coast = load('coast.mat');
%[Z, R] = vec2mtx(coast.lat, coast.long, 1, [-90 90], [-90 270], 'filled');
load distmask_km;

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
    %value = ltln2val(Z, R, Lat, Lon);


    %iterate over each data point (one row)
    for i = 1:size
        
        
        if Prec(i) >= 0 && Lat(i) >= -14.875 && Lat(i) <= 19.875 && Lon(i) >= 90.125 && Lon(i) <= 149.875
        
            rnd_lat = CosToTrmm(Lat(i));
            grid_lat = (rnd_lat + 14.875)*4 + 1;
            
            rnd_lon = CosToTrmm(Lon(i));
            grid_lon = (rnd_lon - 90.125)*4 + 1;
        
            if isnan(distmask_km(grid_lon, grid_lat))
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
                
                if distmask_km(grid_lon, grid_lat) < 38
                
                    lctime = round(local_time(Lon(i),Time(i)));


                    tmp_time = mod(lctime,24);

                    rnd_hour = tmp_time + 1;

                    if net_close_land(rnd_hour) == 0
                        landclosewatcol(rnd_hour,1) = WatCol(i);
                        net_close_land(rnd_hour) = 1;
                    else
                        net_close_land(rnd_hour) = net_close_land(rnd_hour) +1;
                        landclosewatcol(rnd_hour,net_close_land(rnd_hour)) = WatCol(i);

                    end
                else
                    if distmask_km(grid_lon, grid_lat) < 128
                        lctime = round(local_time(Lon(i),Time(i)));


                        tmp_time = mod(lctime,24);

                        rnd_hour = tmp_time + 1;

                        if net_middle_land(rnd_hour) == 0
                            landmiddlewatcol(rnd_hour,1) = WatCol(i);
                            net_middle_land(rnd_hour) = 1;
                        else
                            net_middle_land(rnd_hour) = net_middle_land(rnd_hour) +1;
                            landmiddlewatcol(rnd_hour,net_middle_land(rnd_hour)) = WatCol(i);

                        end
                    else
                        lctime = round(local_time(Lon(i),Time(i)));


                        tmp_time = mod(lctime,24);

                        rnd_hour = tmp_time + 1;

                        if net_far_land(rnd_hour) == 0
                            landfarwatcol(rnd_hour,1) = WatCol(i);
                            net_far_land(rnd_hour) = 1;
                        else
                            net_far_land(rnd_hour) = net_far_land(rnd_hour) +1;
                            landfarwatcol(rnd_hour,net_far_land(rnd_hour)) = WatCol(i);

                        end
                    end
                end
                
            end
        end
        
        
    end
end



oceanwatcol(oceanwatcol == 0)= NaN;
landclosewatcol(landclosewatcol == 0) = NaN;
landmiddlewatcol(landmiddlewatcol == 0) = NaN;
landfarwatcol(landfarwatcol == 0) = NaN;

S = std(oceanwatcol,0,2,'omitnan');
M = nanmean(oceanwatcol,2);

S_close_land = std(landclosewatcol,0,2,'omitnan')/(length(landclosewatcol)^.5);
M_close_land = nanmean(landclosewatcol,2);

S_middle_land = std(landmiddlewatcol,0,2,'omitnan')/(length(landmiddlewatcol)^.5);
M_middle_land = nanmean(landmiddlewatcol,2);

S_far_land = std(landfarwatcol,0,2,'omitnan')/(length(landfarwatcol)^.5);
M_far_land = nanmean(landfarwatcol,2);

S_far_land(25) = S_far_land(1);
S_middle_land(25) = S_middle_land(1);
S_close_land(25) = S_close_land(1);

M_far_land(25) = M_far_land(1);
M_middle_land(25) = M_middle_land(1);
M_close_land(25) = M_close_land(1);

x = [0:24];

figure;
errorbar(x,M_close_land,S_close_land,'k', 'linewidth',1.5);
hold on
errorbar(x,M_middle_land,S_middle_land, 'r','linewidth',1.5);
errorbar(x,M_far_land,S_far_land, 'g','linewidth',1.5);

ax = gca;
ax.XTick = [0:3:24];

set(gca,'xgrid','on') % turn on vertical grid lines 

set(gca,'ygrid','on') % turn on horizontal grid lines 

set(gca,'fontsize',20)

 % removes the box from the legend - improves the look of the figure sometimes

set(gcf,'paperposition',[0.25 2.5 8.0 7.615]) % use this line with your plots to plot figures in a perfect square - again it improves the look of the figure

legend('Land: Close','Land: Middle','Land: Far','Location','Southwest');
legend boxoff

ylabel('Precipitable Water Vapor (mm)');
xlabel('Hours');




