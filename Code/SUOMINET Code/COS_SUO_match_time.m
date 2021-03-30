%Match COSMIC with SUOMINET 


%number of previously identified overlaps 
overlap_size = length(zday_10);

SUO_pwv = [];



for i_orlp = 1:overlap_size
    
    tmp_day = zday_10(i_orlp);
    tmp_min = zmin_10(i_orlp);
    tmp_lat = zlat_10(i_orlp);
    tmp_lon = zlon_10(i_orlp);
    tmp_year = zyear_10(i_orlp);
    tmp_hour = zhour_10(i_orlp);
    
    time = tmp_hour + tmp_min/60;
    %round time to the nearest half hour
    time_rnd = round(time/5,1)*5;
    
    if time_rnd < 23.5
        tm_off = 1 + time_rnd*2;
    else 
        tm_off = 47;
    end
    
    if tm_off > 1 && tm_off < 47
        tm_off_before = tm_off - 1;
        tm_off_after = tm_off + 1;
        
        if tmp_day < 10
            doy = ['00',int2str(tmp_day)];
        else
            if tmp_day < 100
                doy = ['0',int2str(tmp_day)];
            else
                doy = int2str(tmp_day);
            end
        end

        SUOMINETfolder = ['C:\Users\Ellen\Documents\Summer\SUOMINET\',int2str(tmp_year),'\'];
        SUOMINETname = ['GsuPWVd_',int2str(tmp_year),'.',doy,'.00.00.1440_nc'];
        fullname = fullfile(SUOMINETfolder,SUOMINETname);
        %i_orlp

        if exist(fullname, 'file') 

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

            nStation = length(station);


            for i_station = 1:nStation
                if round(SUOMINETlat(i_station),4) == round(zSUOlat_10(i_orlp),4)  
                    SUO_pwv(i_orlp) = pwv(tm_off,i_station);
                    SUO_pwv_before(i_orlp) = pwv(tm_off_before,i_station);
                    SUO_pwv_after(i_orlp) = pwv(tm_off_after,i_station);
                    %i_orlp
                end
            end
            netcdf.close(nc);
        else 
            SUO_pwv(i_orlp) = nan;
            %i_orlp
        end  
    end
end


