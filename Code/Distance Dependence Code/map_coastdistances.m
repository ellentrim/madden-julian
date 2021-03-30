% %% Map distances from the coast 
% 
% % -15 to 20 (35x4=140) and 90 to 150 (60x4=240)
% 
% lat = (-14.875:0.25:19.875);
% lon = (90.125:0.25:149.875);
% 
% [lat_grid,lon_grid] = meshgrid(lat,lon);
% tmp_grid = cat(2,lat_grid',lon_grid');
% latlon = reshape(tmp_grid,[],2);
% 
% fin_lat = latlon(:,1);
% fin_lon = latlon(:,2);
% 
% coast = load('coast.mat');
% [Z, R] = vec2mtx(coast.lat, coast.long, 10, [-90 90], [-90 270],'filled');
% value = ltln2val(Z, R, fin_lat,fin_lon);
% 
% landlat = fin_lat(value ~= 2);
% landlon = fin_lon(value ~= 2);
% 
% distvalue = dist_from_coast(landlat,landlon, 'great_circle');
% % 
% % distvalue_km = distvalue./1000;
% % 
% % closelat = landlat(distvalue_km < 38);
% % middlelat = landlat(distvalue_km >= 38 & distvalue_km < 128);
% % farlat = landlat(distvalue_km >= 128);
% % 
% % closelon = landlon(distvalue_km < 38);
% % middlelon = landlon(distvalue_km >= 38 & distvalue_km < 128);
% % farlon = landlon(distvalue_km >= 128);
% % 
% 
% % figure;
% % worldmap([-15 20],[90 150]);
% % load coast.mat;
% % plotm(lat,long);
% %  
% % plotm(closelat,closelon,'.b','MarkerSize',13);
% % plotm(middlelat,middlelon,'.m','MarkerSize',13);
% % plotm(farlat,farlon,'.g','MarkerSize',13);
% 
% 
% % landmask = reshape(value,length(lat),length(lon));
% % landmask = transpose(landmask);
% % figure
% % worldmap
% % geoshow(lat_grid,lon_grid,landmask)
% % 
% % timezone = tranpose(local_time(lon,0));
% % 



for i = 1:140
    for j = 1:240 
        
        tmp_lat = (i/4) - 15.125;
        tmp_lon = (j/4) + 89.875;
        
        
        tmp_dist = distvalue(landlat == tmp_lat & landlon == tmp_lon);
        if tmp_dist >= 0
            distancemask(j,i) = tmp_dist;
        else
            distancemask(j,i) = nan;
        end
        
    end
end

distmask_km = distancemask./1000;



latvec = (-90:90);
lonvec = (-180:180);
figure
%hourly = average_pcp*24;
[longrid,latgrid] = meshgrid(lonvec,latvec);

%worldmap('World');
geoshow(latgrid,longrid,topo,'DisplayType','texturemap')





