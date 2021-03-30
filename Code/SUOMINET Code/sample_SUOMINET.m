SUOMINETfolder = ['C:\Users\Ellen\Documents\Summer\SUOMINET\2006\'];
    SUOMINETname = ['GsuPWVd_2006.277.00.00.1440_nc'];
    fullname = fullfile(SUOMINETfolder,SUOMINETname);
    %i_orlp
    
    
        
        nc = netcdf.open(fullname,'NC_NOWRITE');

        %longitude
        tmp_id = netcdf.inqVarID(nc,'lon');
        SUOMINETlon = netcdf.getVar(nc,tmp_id);
        %lattitude
        tmp_id = netcdf.inqVarID(nc,'lat');
        SUOMINETlat = netcdf.getVar(nc,tmp_id);
        %percipitable water vapor
        tmp_id = netcdf.inqVarID(nc,'pwv');
        pwv = netcdf.getVar(nc,tmp_id);
        %name of the stations
        tmp_id = netcdf.inqVarID(nc,'station');
        station = netcdf.getVar(nc,tmp_id);
        %time 
        tmp_id = netcdf.inqVarID(nc,'time_offset');
        time_offset = netcdf.getVar(nc,tmp_id);
        
        tm_off = 36;

%         nStation = length(station);
% 
% 
%         for i_station = 1:nStation
%             if round(SUOMINETlat(i_station),4) == round(S_lat(1,i_orlp),4)  
%                 SUO_pwv(i_orlp) = pwv(tm_off,i_station);
%                 %i_orlp
%             end
%         end