% % Precipitation Duirnal Cycle 
% 
% %take trmm all data and make
% %convert to local time 
% %make a mask of land ocean at a 0.25 resolution for that area 
% 
% load landmask.mat;
% load distmask_km;
% 
% mainlat = (-14.875:0.25:19.875);
% mainlon = (90.125:0.25:149.875);
% land_prec_close = zeros(8,1);
% land_prec_middle = zeros(8,1);
% land_prec_far = zeros(8,1);
% 
% ocean_prec = zeros(8,1);
% 
% net_land_close = zeros(8);
% net_land_middle = zeros(8);
% net_land_far = zeros(8);
% 
% net_ocean = zeros(8);
% 
% for i_year = 2008:2014
%     
%     trmmfolder = ['/Users/ellen/Desktop/Summer/TRMM/',int2str(i_year),'/'];
%     
%     listTRMM = dir(trmmfolder);
%     sizeTRMM = length(listTRMM);
%     
%     for i_file = 4:sizeTRMM
%         nc = netcdf.open(fullfile(trmmfolder,listTRMM(i_file).name),'NC_NOWRITE');
%         
%         tmp_id = netcdf.inqVarID(nc,'pcp');
%         prec_total = netcdf.getVar(nc,tmp_id);
%         
%         prec_area = prec_total(1081:1320,141:280);
%         
%         
%         landmaskdim(:,:) = landmask;
%         
%         time = str2double(listTRMM(i_file).name(15:16)); %get the time (3 hour block) from the file name       
%         lctm = local_time(mainlon,time); %convert to local time based on the longitude
%         
%         rnd_lctm = round(lctm); %round to hours
%         groups = fix((rnd_lctm./3)+1); % convert to one of the 8 three hour blocks (0-2 = 1, 3-5 = 2 .... 21-23 = 8)
%         [X,time_grid] = meshgrid(mainlat,groups); %make the localtimes extend the full length of the matrix
%         
%         
%         
%         
%         for i_time = 1:8
%             
%             tmp_var_land_close = prec_area(landmaskdim ~= 2 & time_grid == i_time & distmask_km < 38); %collect all the values not ocean (~= 2) and during the 3 hour block
%             tmp_var_land_middle = prec_area(landmaskdim ~= 2 & time_grid == i_time & distmask_km >= 38 & distmask_km < 128);
%             tmp_var_land_far = prec_area(landmaskdim ~= 2 & time_grid == i_time & distmask_km >= 128);
%             
%             tmp_var_ocean = prec_area(landmaskdim ==2 & time_grid == i_time); %same but for ocean 
%             
%             tmpland_size_close = length(tmp_var_land_close); %number of land values for this block
%             currentland_size_close = net_land_close(i_time); %current number of points in the matrix for this block
%             startland_close = currentland_size_close + 1; %first entry in the matrix for this iteration
%             stopland_close = currentland_size_close + tmpland_size_close; %last entry 
%             land_prec_close(i_time,startland_close:stopland_close) = tmp_var_land_close; %place them in the matrix
%             
%             tmpland_size_middle = length(tmp_var_land_middle); %number of land values for this block
%             currentland_size_middle = net_land_middle(i_time); %current number of points in the matrix for this block
%             startland_middle = currentland_size_middle + 1; %first entry in the matrix for this iteration
%             stopland_middle = currentland_size_middle + tmpland_size_middle; %last entry 
%             land_prec_middle(i_time,startland_middle:stopland_middle) = tmp_var_land_middle; %place them in the matrix
%             
%             tmpland_size_far = length(tmp_var_land_far); %number of land values for this block
%             currentland_size_far = net_land_far(i_time); %current number of points in the matrix for this block
%             startland_far = currentland_size_far + 1; %first entry in the matrix for this iteration
%             stopland_far = currentland_size_far + tmpland_size_far; %last entry 
%             land_prec_far(i_time,startland_far:stopland_far) = tmp_var_land_far; %place them in the matrix
%             
%             tmpocean_size = length(tmp_var_ocean); %same as above but for ocean values 
%             currentocean_size = net_ocean(i_time);
%             startocean = currentocean_size + 1;
%             stopocean = currentocean_size + tmpocean_size;
%             ocean_prec(i_time,startocean:stopocean) = tmp_var_ocean;
%             
%             net_land_close(i_time) = stopland_close; %set the last value in the land block 
%             net_land_middle(i_time) = stopland_middle;
%             net_land_far(i_time) = stopland_far;
%             
%             net_ocean(i_time) = stopocean; %same for ocean
%             
%             
%             
%         end
%         
%         
%         netcdf.close(nc);
%     end
%     
% end
% land_prec_close(land_prec_close < 0) = nan;
% land_prec_middle(land_prec_middle < 0) = nan;
% land_prec_far(land_prec_far < 0) = nan;
% %take out the -999 values and replace with nan values
% ocean_prec(ocean_prec < 0) = nan; 

mean_ocean = [];
mean_land_close = [];
mean_land_middle = [];
mean_land_far = [];
for j = 1:8
     
    mean_land_close(j) = nanmean(land_prec_close(j,1:net_land_close(j)),2);
    err_land_close(j) = (std(land_prec_close(j,1:net_land_close(j)),'omitnan'))/(net_land_close(j)^.5);
    
    mean_land_middle(j) = nanmean(land_prec_middle(j,1:net_land_middle(j)),2);
    err_land_middle(j) = (std(land_prec_middle(j,1:net_land_middle(j)),'omitnan'))/(net_land_middle(j)^.5);
    
    mean_land_far(j) = nanmean(land_prec_far(j,1:net_land_far(j)),2);
    err_land_far(j) = (std(land_prec_far(j,1:net_land_far(j)),'omitnan'))/(net_land_far(j)^.5);
    

    %take the mean of the 
    mean_ocean(j) = nanmean(ocean_prec(j,1:net_ocean(j)),2);
    err_ocean(j) = (std(ocean_prec(j,1:net_ocean(j)),'omitnan'))/(net_ocean(j)^.5);

end

mean_ocean(9) = mean_ocean(1);
mean_land_close(9) = mean_land_close(1);
mean_land_middle(9) = mean_land_middle(1);
mean_land_far(9) = mean_land_far(1);

err_ocean(9) = err_ocean(1);
err_land_close(9) = err_land_close(1);
err_land_middle(9) = err_land_middle(1);
err_land_far(9) = err_land_far(1);




x = [0:3:24];

figure;
errorbar(x,mean_ocean,err_ocean,'b','linewidth',1.5);
hold on
errorbar(x,mean_land_close,err_land_close,'k','linewidth',1.5);
errorbar(x,mean_land_middle,err_land_middle,'r','linewidth',1.5);
errorbar(x,mean_land_far,err_land_far,'g','linewidth',1.5);
legend('Ocean','Land: Close','Land: Middle','Land: Far','Location','Southwest');

ax = gca;
ax.XTick = [0:3:24];

set(gca,'xgrid','on') % turn on vertical grid lines 

set(gca,'ygrid','on') % turn on horizontal grid lines 

set(gca,'fontsize',20)

legend boxoff % removes the box from the legend - improves the look of the figure sometimes

set(gcf,'paperposition',[0.25 2.5 8.0 7.615]) % use this line with your plots to plot figures in a perfect square - again it improves the look of the figure



ylabel('Precipitation (mm/hr)');
xlabel('Hours');


