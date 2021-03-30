% % Percentile for each water column percipitation 


%Size of the ocean 
size_ocean = length(oceanwatcol);
%initializing the variables
binned_oceanprec = [];
net_ocean = zeros(500,1);

%size of the land
size_close_land = length(close_landwatcol);
binned_close_landprec = [];
net_close_land = zeros(500,1);

size_middle_land = length(middle_landwatcol);
binned_middle_landprec = [];
net_middle_land = zeros(500,1);

size_far_land = length(far_landwatcol);
binned_far_landprec = [];
net_far_land = zeros(500,1);

% size_far_far_land = length(far_far_landwatcol);
% binned_far_far_landprec = [];
% net_far_far_land = zeros(500,1);


Prc_ocean = [];
Prc_land = [];
% 
for i = 1:size_ocean
    
        rnd_watcol = round(oceanwatcol(i),0);
        net_ocean(rnd_watcol) = 1 + net_ocean(rnd_watcol);
        binned_oceanprec(rnd_watcol,net_ocean(rnd_watcol)) = oceanprec(i);
    
end

for i = 1:size_close_land
   
        rnd_watcol = round(close_landwatcol(i),0);
        net_close_land(rnd_watcol) = 1 + net_close_land(rnd_watcol);
        binned_close_landprec(rnd_watcol,net_close_land(rnd_watcol)) = close_landprec(i);
    
end

for i = 1:size_middle_land
   
        rnd_watcol = round(middle_landwatcol(i),0);
        net_middle_land(rnd_watcol) = 1 + net_middle_land(rnd_watcol);
        binned_middle_landprec(rnd_watcol,net_middle_land(rnd_watcol)) = middle_landprec(i);
    
end

for i = 1:size_far_land
   
        rnd_watcol = round(far_landwatcol(i),0);
        net_far_land(rnd_watcol) = 1 + net_far_land(rnd_watcol);
        binned_far_landprec(rnd_watcol,net_far_land(rnd_watcol)) = far_landprec(i);
    
end

% for i = 1:size_far_far_land
%    
%         rnd_watcol = round(far_far_landwatcol(i),0);
%         net_far_far_land(rnd_watcol) = 1 + net_far_far_land(rnd_watcol);
%         binned_far_far_landprec(rnd_watcol,net_far_far_land(rnd_watcol)) = far_far_landprec(i);
%     
% end


mean_ocean = [];
mean_close_land = [];
mean_middle_land = [];
mean_far_land = [];
% mean_far_far_land = [];

h = [];
p = [];



for j = 15:65
    tmp_ocean = [binned_oceanprec(j,1:net_ocean(j))];
    mean_ocean(j) = mean(tmp_ocean);
    
    tmp_land = [binned_close_landprec(j,1:net_close_land(j))];
    mean_close_land(j) = mean(tmp_land);
    
    tmp_land = [binned_middle_landprec(j,1:net_middle_land(j))];
    mean_middle_land(j) = mean(tmp_land);
    
    tmp_land = [binned_far_landprec(j,1:net_far_land(j))];
    mean_far_land(j) = mean(tmp_land);
    
%     tmp_land = [binned_far_far_landprec(j,1:net_far_far_land(j))];
%     mean_far_far_land(j) = mean(tmp_land);
    
%     Prc_ocean_tmp = prctile(tmp_ocean, [25, 50, 75]);
%     Prc_ocean =[Prc_ocean;Prc_ocean_tmp];
%     
%     Prc_land_tmp = prctile(tmp_land, [25, 50, 75]);
%     Prc_land = [Prc_land;Prc_land_tmp];
    
    %[h(j),p(j)] = ttest2(tmp_ocean, tmp_land);
   
end


x = 15:65;
% 
figure
hold on
plot(x,mean_ocean(15:65), 'b','linewidth',1.5);
plot(x,mean_close_land(15:65),'r','linewidth',1.5)
plot(x,mean_middle_land(15:65),'m','linewidth',1.5)
plot(x,mean_far_land(15:65),'g','linewidth',1.5)
% plot(mean_far_far_land,'k','linewidth',1.5)
legend('Ocean','Land: Close','Land: Middle','Land: Far', 'Location','Southwest');
xlabel('Precipitable Water (mm)');
ylabel('Precipitation (mm/hour)');

x_three = [x;x;x];


%legend('Land 5%','Land 50%','Land 95%','Ocean 5%','Ocean 50%','Ocean 95%','Location','Southwest');


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
% 
 set(gcf,'paperposition',[0.25 2.5 8.0 7.615]) % use this line with your plots to plot figures in a perfect square - again it improves the look of the figure
% 
xlabel('Precipitable Water Vapor (mm)')
ylabel('Precipitation (mm/hr)')




% 
% xlabel('Precipitable Water (mm)');
% ylabel('Precip (mm/hour)');
% legend('ocean','land')
% title('Daily Averaged Precipitation vs SUOMINET Precipitable Water (2006-2015)');
% 
% load handel
% sound(y,Fs)




