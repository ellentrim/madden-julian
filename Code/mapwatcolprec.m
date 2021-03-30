%% Written by Ellen Robo (ellentrimrobo@gmail.com)
% Purpose: create world map of average precipitation and wat col


watcolmatrix = zeros(180,360); %set variable sizes
precmatrix = zeros(180,360);
net = zeros(180,360);

%location of data
folder = '/Volumes/Macintosh HD/Users/ellenrobo/Desktop/Users/ellen/Desktop/Summer/daily/'; 

%iterate through years
for k = 2006:2015
    filename = [int2str(k),'_daily.txt']; %name of year file
    name = fullfile(folder,filename);
    file = importdata(name);

    tmp_prec = file.data(:,8);
    tmp_watcol = file.data(:,7);
    tmp_lon = file.data(:,6);
    tmp_lat = file.data(:,5);
    tmp_day = file.data(:,2);
    
    size = length(tmp_lat); %determine number of data points in file
    
        for i = 1:size %iterate through all of them
            
           lat_rnd = round(tmp_lat(i))+ 90; %calculate lattiude for data point

           lon_rnd = round(tmp_lon(i)) + 180; %calculate lon
            

            if (tmp_prec(i)>=0 && lon_rnd>0 && lat_rnd>0) %weed out bad data points (TRMM precipitation is -9999 when no data)
                
                %&& ((tmp_day(i)>=335) || (tmp_day(i)<=59)) %add above if
                %want to look at only one season/time of year (currently winter)
                
                
                %checking if data point is first in the degree square
                if watcolmatrix(lat_rnd,lon_rnd) == 0 
                    watcolmatrix(lat_rnd,lon_rnd) = tmp_watcol(i);
                    precmatrix(lat_rnd,lon_rnd) = tmp_prec(i);
                    net(lat_rnd,lon_rnd) = 1;
                
                else
                    n = net(lat_rnd,lon_rnd);

                    orginal_watcol = watcolmatrix(lat_rnd,lon_rnd);
                    new_watcol = (orginal_watcol*n + tmp_watcol(i))/(n+1);
                    watcolmatrix(lat_rnd,lon_rnd) = new_watcol;

                    orginal_prec = precmatrix(lat_rnd,lon_rnd);
                    new_prec = (orginal_prec*n + tmp_prec(i))/(n+1);
                    precmatrix(lat_rnd,lon_rnd) = new_prec;

                    net(lat_rnd,lon_rnd) = n+1;
                end
            end
        end
end





figure
load coast
worldmap('World');
geoshow(net,[1,90,180],'DisplayType','texturemap') %replace net with watcolmatrix or precmatrix
%[1,90,180] = [cells/degree, north lat limit, west lon limit]
plotm(lat,long,'k')

