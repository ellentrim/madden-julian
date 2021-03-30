%%Graphing data land vs ocean%%
clear;

%creating the matrix of land to test values against
coast = load('coast.mat');
[Z, R] = vec2mtx(coast.lat, coast.long, 10, [-90 90], [-90 270],'filled');

oceanwatcol = [];
landwatcol = [];
oceanprec = [];
landprec = [];
landdist = [];
landlat = [];
landlon = [];
folder = '/Users/ellen/Desktop/Summer/3 hours/';

for i_year = 2006:2015
    %Import data
    filename = [int2str(i_year),'.txt'];
    name = fullfile(folder,filename);
    file = importdata(name);

    

    %COS CONFIGURATION: Year	Day     Hour	Min     Lat     Lon     WatCol     Prec     Temp


    Prec = file.data(:,8);
    WatCol = file.data(:,7);
    Lon = file.data(:,6);
    Lat = file.data(:,5);

    size = length(Lat);

    value = ltln2val(Z, R, Lat, Lon);
    
    tmp_oceanwatcol = WatCol(Prec >= 0 & Lat >= -15 & Lat <= 20 & Lon >= 90 & Lon <= 150 & value == 2);
    tmp_oceanprec = Prec(Prec >= 0 & Lat >= -15 & Lat <= 20 & Lon >= 90 & Lon <= 150 & value == 2);
    oceanwatcol = [oceanwatcol;tmp_oceanwatcol];
    oceanprec = [oceanprec;tmp_oceanprec];
    
    tmp_landwatcol = WatCol(Prec >= 0 & Lat >= -15 & Lat <= 20 & Lon >= 90 & Lon <= 150 & value ~= 2); 
    tmp_landprec = Prec(Prec >= 0 & Lat >= -15 & Lat <= 20 & Lon>= 90 & Lon <= 150 & value ~= 2);
    landwatcol = [landwatcol;tmp_landwatcol];
    landprec = [landprec;tmp_landprec];
    
                   
    tmp_landlat = Lat(Prec >= 0 & Lat >= -15 & Lat <= 20 & Lon >= 90 & Lon <= 150 & value ~= 2);
    tmp_landlon = Lon(Prec >= 0 & Lat >= -15 & Lat <= 20 & Lon >= 90 & Lon <= 150 & value ~= 2);
    landlat = [landlat;tmp_landlat];
    landlon = [landlon;tmp_landlon];
    
    distcoast = dist_from_coast(tmp_landlat,tmp_landlon,'great_circle');
    landdist = [landdist; distcoast];
    
    
    %iterate over each data point (one row)
%     for i = 1:size
% 
%             %limits it to data within the tropical pacific area I am looking at
%             if Prec(i) >= 0 & Lat(i) >= -15 & Lat(i) <= 20 & Lon(i) >= 90 & Lon(i) <= 150
% 
%                 %using the coast matrix from above, it decides whether ocean or
%                 %land (2 = ocean, 1 = land)
%                 value = ltln2val(Z, R, Lat(i), Lon(i));
%                 
% 
% 
%                 if value == 2
%                     %creating a variable of all the ocean wat col and prec
%                     oceanwatcol = [oceanwatcol; WatCol(i)];
%                     oceanprec = [oceanprec; Prec(i)];
%                 else
%                     %creating a variable of all the land watcol and prec
%                     distcoast = dist_from_coast(Lat(i),Lon(i),'great_circle');
%                     
%                     landwatcol = [landwatcol; WatCol(i)];
%                     landprec = [landprec; Prec(i)];
%                     landdist = [landdist; distcoast];
%                     landlat = landlat
%                 end
%             end
%     end
    

end
load handel
sound(y,Fs)

landdist_km = landdist./1000;

close_landdist = landdist_km(landdist_km < 38.3771);
close_landprec = landprec(landdist_km < 38.3771);
close_landwatcol = landwatcol(landdist_km < 38.3771);

middle_landdist = landdist_km(landdist_km >= 38.3771 & landdist_km < 128.2484);
middle_landprec = landprec(landdist_km >= 38.3771 & landdist_km < 128.2484);
middle_landwatcol = landwatcol(landdist_km >= 38.3771 & landdist_km < 128.2484);

far_landdist = landdist_km(landdist_km >= 128.2484);
far_landprec = landprec(landdist_km >= 128.2484);
far_landwatcol = landwatcol(landdist_km >= 128.2484);

far_far_landdist = landdist_km(landdist_km >= 250);
far_far_landprec = landprec(landdist_km >= 250);
far_far_landwatcol = landwatcol(landdist_km >= 250);
