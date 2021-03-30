

hold on
unit = 55;
for i_num = unit:unit:100
    
    
    boundry = prctile(landdist_km,[0, 50]);

   
    tmp_landprec = landprec(landdist_km < boundry(2) & landdist_km >= boundry(1));
    tmp_landwatcol = landwatcol(landdist_km < boundry(2) & landdist_km >= boundry(1));

    %size of the land
    size_land = length(tmp_landwatcol);
    binned_landprec = [];
    net_land = zeros(500,1);
    
    for i = 1:size_land
   
        rnd_watcol = round(tmp_landwatcol(i),0);
        net_land(rnd_watcol) = 1 + net_land(rnd_watcol);
        binned_landprec(rnd_watcol,net_land(rnd_watcol)) = tmp_landprec(i);
    
    end
    mean_land = [];
    
    for j = 10:68
        
        tmp_land = [binned_landprec(j,1:net_land(j))];
        mean_land(j) = mean(tmp_land);

        
    end

    plot(mean_land);
 
end
