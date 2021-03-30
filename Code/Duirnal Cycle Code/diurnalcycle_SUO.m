%Diurnal cycle

%local time (.1 degrees longitude per minute)
clear;
landwatcol = zeros(24,1);
net = zeros(24,1);
coast = load('coast.mat');
[Z, R] = vec2mtx(coast.lat, coast.long, 1, [-90 90], [-90 270], 'filled');

folder = '/Users/ellen/Desktop/Summer/SUOMINET_Daily/';

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
    for i = 1:size
        
        
        if Prec(i) >= 0 && Lat(i) >= -15 && Lat(i) <= 20 && Lon(i) >= 90 && Lon(i) <= 150 && WatCol(i) > 0
        
        
            if value(i) ~= 2
                lctime = round(local_time(Lon(i),Time(i)));
               
                
                tmp_time = mod(lctime,24);
                
                rnd_hour = tmp_time + 1;
                
                if landwatcol(rnd_hour) == 0
                    landwatcol(rnd_hour) = WatCol(i);
                    net(rnd_hour) = 1;
                else
                    landwatcol(rnd_hour) = (WatCol(i) + landwatcol(rnd_hour)*net(rnd_hour))/(net(rnd_hour)+1);
                    net(rnd_hour) = net(rnd_hour) +1;
                end
            end
        end
        
        
    end
end