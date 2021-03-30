%What does the day cycle look like over 

landwatcol = zeros(24);
net = zeros(24);
size = length(Lat_2008);
coast = load('coast.mat');
[Z, R] = vec2mtx(coast.lat, coast.long, 1, [-90 90], [-90 270], 'filled');

for i = 1:size
    if Prec_2008(i) >= 0 && Lat_2008(i) >= -15 && Lat_2008(i) <= 20 && Lon_2008(i) >= 90 && Lon_2008(i) <= 150
        value = ltln2val(Z, R, Lat_2008(i), Lon_2008(i));
        
        if value == 2
            lctime = local_time(Lon_2008(i),Hour_2008(i));
            rnd_hour = round(lctime) + 1;
            if landwatcol(rnd_hour) == 0
                landwatcol(rnd_hour) = WatCol_2008(i);
                net(rnd_hour) = 1;
            else
                landwatcol(rnd_hour) = (WatCol_2008(i) + landwatcol(rnd_hour)*net(rnd_hour))/(net(rnd_hour)+1);
                net(rnd_hour) = net(rnd_hour) +1;
            end
        end
    end
end

