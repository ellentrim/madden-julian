%%Written by Ellen Robo (ellentrimrobo@gmail.com)
%Purpose: to take previously created data point text files and seperate the
%data into land and ocean points.  Creates 4 variables wat col and prec for
%land and ocean


clear;

%creating the matrix of land to test values against
coast = load('coast.mat');
[Z, R] = vec2mtx(coast.lat, coast.long, 10, [-90 90], [-90 270],'filled');

oceanwatcol = [];
landwatcol = [];
oceanprec = [];
landprec = [];
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

    size = length(Lat);
    value = ltln2val(Z, R, Lat, Lon);
    
    land_lat = Lat(value ~= 2);
    land_lon = Lon(value ~= 2);
    
    ocean_lat = Lat(value ~= 2);
    ocean_lon = Lon(value ~= 2);


    %iterate over each data point (one row)
    for i = 1:size

            %limits it to data within the tropical pacific area 
            if Prec(i) >= 0 && Lat(i) >= -30 && Lat(i) <= 30 
                %&& Lon(i) >= 90 && Lon(i) <= 150

                %using the coast matrix from above, it decides whether ocean or
                %land (2 = ocean, 1 = land)
                value = ltln2val(Z, R, Lat(i), Lon(i));


                if value == 2
                    %creating a variable of all the ocean wat col and prec
                    oceanwatcol = [oceanwatcol; WatCol(i)];
                    oceanprec = [oceanprec; Prec(i)];
                else
                    %creating a variable of all the land watcol and prec
                    landwatcol = [landwatcol; WatCol(i)];
                    landprec = [landprec; Prec(i)];
                end
            end
    end
    

end

