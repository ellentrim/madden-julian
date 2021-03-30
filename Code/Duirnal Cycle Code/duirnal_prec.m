% Precipitation Duirnal Cycle 

%take trmm all data and make
%convert to local time 
%make a mask of land ocean at a 0.25 resolution for that area 

load landmask.mat;

mainlat = (-14.875:0.25:19.875);
mainlon = (90.125:0.25:149.875);
land_prec = zeros(8,1);
ocean_prec = zeros(8,1);

net_land = zeros(8);
net_ocean = zeros(8);

for i_year = 2008:2014
    
    trmmfolder = ['/Users/ellen/Desktop/Summer/TRMM/',int2str(i_year),'/'];
    
    listTRMM = dir(trmmfolder);
    sizeTRMM = length(listTRMM);
    
    for i_file = 4:sizeTRMM
        nc = netcdf.open(fullfile(trmmfolder,listTRMM(i_file).name),'NC_NOWRITE');
        
        tmp_id = netcdf.inqVarID(nc,'pcp');
        prec_total = netcdf.getVar(nc,tmp_id);
        
        prec_area = prec_total(1081:1320,141:280);
        
        
        landmaskdim(:,:) = landmask;
        
        time = str2double(listTRMM(i_file).name(15:16)); %get the time (3 hour block) from the file name       
        lctm = local_time(mainlon,time); %convert to local time based on the longitude
        
        rnd_lctm = round(lctm); %round to hours
        groups = fix((rnd_lctm./3)+1); % convert to one of the 8 three hour blocks (0-2 = 1, 3-5 = 2 .... 21-23 = 8)
        [X,time_grid] = meshgrid(mainlat,groups); %make the localtimes extend the full length of the matrix
        
        
        
        
        for i_time = 1:8
            
            tmp_var_land = prec_area(landmaskdim ~= 2 & time_grid == i_time); %collect all the values not ocean (~= 2) and during the 3 hour block
            tmp_var_ocean = prec_area(landmaskdim ==2 & time_grid == i_time); %same but for ocean 
            
            tmpland_size = length(tmp_var_land); %number of land values for this block
            currentland_size = net_land(i_time); %current number of points in the matrix for this block
            startland = currentland_size + 1; %first entry in the matrix for this iteration
            stopland = currentland_size + tmpland_size; %last entry 
            land_prec(i_time,startland:stopland) = tmp_var_land; %place them in the matrix
            
            tmpocean_size = length(tmp_var_ocean); %same as above but for ocean values 
            currentocean_size = net_ocean(i_time);
            startocean = currentocean_size + 1;
            stopocean = currentocean_size + tmpocean_size;
            ocean_prec(i_time,startocean:stopocean) = tmp_var_ocean;
            
            net_land(i_time) = stopland; %set the last value in the land block 
            net_ocean(i_time) = stopocean; %same for ocean
            
            
            
        end
        
        
        netcdf.close(nc);
    end
    
end
land_prec(land_prec < 0) = nan;
ocean_prec(ocean_prec < 0) = nan; 
for j = 1:8
     %take out the -999 values and replace with nan values
    mean_land(j) = nanmean(land_prec(j,1:net_land(j)),2);
    err_land(j) = (std(land_prec(j,1:net_land(j)),'omitnan'))/(net_land(j)^.5);
    

    %take the mean of the 
    mean_ocean(j) = nanmean(ocean_prec(j,1:net_ocean(j)),2);
    err_ocean(j) = (std(ocean_prec(j,1:net_ocean(j)),'omitnan'))/(net_ocean(j)^.5);

end

mean_ocean(9) = mean_ocean(1);
mean_land(9) = mean_land(1);
err_ocean(9) = err_ocean(1);
err_land(9) = err_land(1);

x = [0:3:24];

figure;
errorbar(x,mean_ocean,err_ocean,'b','linewidth',1.5);
hold on
errorbar(x,mean_land,err_land,'k','linewidth',1.5);
legend('Ocean','Land','Location','Southwest');

ax = gca;
ax.XTick = [0:3:24];

set(gca,'xgrid','on') % turn on vertical grid lines 

set(gca,'ygrid','on') % turn on horizontal grid lines 

set(gca,'fontsize',20)

legend boxoff % removes the box from the legend - improves the look of the figure sometimes

set(gcf,'paperposition',[0.25 2.5 8.0 7.615]) % use this line with your plots to plot figures in a perfect square - again it improves the look of the figure



ylabel('Precipitation (mm/hr)');
xlabel('Hours');


