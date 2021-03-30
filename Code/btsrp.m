%%Bootstrapping the data to test intervals%%
%Written by Ellen Robo (ellentrimrobo@gmail.com)
%


landsize = length(landprec);       %number of land data points
oceansize = length(oceanprec);     %number of ocean data points

prc = .2;                               %percent of data points to bootsrap
sub_land = round(prc*landsize);         %num of data points make up the percent
sub_ocean = round(prc*oceansize);

num_btsrp = 1000;                       %number of times to remove and replace

group_oceanmean = [];
group_landmean = [];

figure

for k = 1:num_btsrp
        
        tmp_landprec = landprec;
        tmp_oceanprec = oceanprec;
        tmp_landwatcol = landwatcol;
        tmp_oceanwatcol = oceanwatcol;
    
        rndmat_land = randi([1 landsize],2,sub_land);   %two sets of random numbers, one to take out and the other to replace
        rndmat_ocean = randi([1 oceansize],2,sub_ocean);

        for i_num = 1:sub_land

            remove = rndmat_land(1,i_num);
            replace = rndmat_land(2,i_num);
            tmp_landprec(remove) = tmp_landprec(replace);
            tmp_landwatcol(remove) = tmp_landwatcol(replace);    

        end

        for i_num = 1:sub_ocean

            remove = rndmat_ocean(1,i_num);
            replace = rndmat_ocean(2,i_num);
            tmp_oceanprec(remove) = tmp_oceanprec(replace);
            tmp_oceanwatcol(remove) = tmp_oceanwatcol(replace);    

        end
        
              
        %initializing the variables
        binned_oceanprec = [];
        net_ocean = zeros(80,1);
        Prc_ocean = [];
        
        binned_landprec = [];
        net_land = zeros(80,1);
        Prc_land = [];
        % 
        for i = 1:oceansize
            rnd_watcol = round(tmp_oceanwatcol(i),0);
            net_ocean(rnd_watcol) = 1 + net_ocean(rnd_watcol);
            binned_oceanprec(rnd_watcol,net_ocean(rnd_watcol)) = tmp_oceanprec(i);
        end

        for i = 1:landsize
            rnd_watcol = round(tmp_landwatcol(i),0);
            net_land(rnd_watcol) = 1 + net_land(rnd_watcol);
            binned_landprec(rnd_watcol,net_land(rnd_watcol)) = tmp_landprec(i);
        end


        mean_ocean = [];
        mean_land = [];

        for j = 15:65
            tmp_ocean = [binned_oceanprec(j,1:net_ocean(j))];
            mean_ocean(j) = mean(tmp_ocean);

            tmp_land = [binned_landprec(j,1:net_land(j))];
            mean_land(j) = mean(tmp_land);

        end
         
        group_landmean = [group_landmean;mean_land];
        group_oceanmean = [group_oceanmean;mean_ocean];
        
        hold on
        plot(mean_land,'b');
        plot(mean_ocean, 'k');

end


% hold on 
% 
% figure
% boxplot(group_landmean);
% boxplot(group_oceanmean);
% 
% for jup = 1:1000
%     
%    hold on 
%    plot(group_landmean(jup,:),'k');
%    plot(group_oceanmean(jup,:),'b');
%     
% end
Prc_ocean = [];
Prc_land = [];

for num = 15:65    
    Prc_ocean_tmp = prctile(group_oceanmean(:,num), [5, 50, 95]);
    Prc_ocean =[Prc_ocean;Prc_ocean_tmp];
    
    Prc_land_tmp = prctile(group_landmean(:,num), [5, 50, 95]);
    Prc_land = [Prc_land;Prc_land_tmp];
end

x = 15:65;
x_three = [x;x;x];

figure
plot(x,Prc_land, 'linewidth',1.5)
hold on
plot(x,Prc_ocean, 'linewidth',1.5)
legend('Land 5%','Land 50%','Land 95%','Ocean 5%','Ocean 50%','Ocean 95%','Location','Southwest');


% load handel
% sound(y,Fs)

set(gca,'xgrid','on') % turn on vertical grid lines 

set(gca,'ygrid','on') % turn on horizontal grid lines 

set(gca,'fontsize',20) % font for the figure on the whole - can be used instead of 1) and 2) above


ax = gca;
c = ax.XTick;

ax.XTick = [15:10:65];

ax = gca;
d = ax.YTick;

ax.YTick = [0:.25:1.5];

legend boxoff % removes the box from the legend - improves the look of the figure sometimes

set(gcf,'paperposition',[0.25 2.5 8.0 7.615]) % use this line with your plots to plot figures in a perfect square - again it improves the look of the figure

xlabel('Precipitable Water Vapor (mm)')
ylabel('Precipitation (mm/hr)')
title('9-Hour');
