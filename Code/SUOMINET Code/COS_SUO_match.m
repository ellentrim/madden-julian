%Match COSMIC with SUOMINET 


%number of previously identified overlaps 
overlap_size = length(all_day);

SUO_pwv = [];



for i_orlp = 1:overlap_size
    
    tmp_day = all_day(i_orlp);
    tmp_min = all_min(i_orlp);
    tmp_lat = all_lat(i_orlp);
    tmp_lon = all_lon(i_orlp);
    tmp_year = all_year(i_orlp);
    tmp_hour = all_hour(i_orlp);
    
    time = tmp_hour + tmp_min/60;
    %round time to the nearest half hour
    time_rnd = round(time/5,1)*5;
    
    if time_rnd < 23.5
        tm_off = 1 + time_rnd*2;
    else 
        tm_off = 47;
    end
    
    
    
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
            if round(SUOMINETlat(i_station),4) == round(S_lat(1,i_orlp),4)  
                SUO_pwv(i_orlp) = pwv(tm_off,i_station);
                %i_orlp
            end
        end
        netcdf.close(nc);
    else 
        SUO_pwv(i_orlp) = nan;
        %i_orlp
    end  
end

SUO_pwv(2632:2649) = nan;
SUO_pwv = transpose(SUO_pwv);

clean_SUOpwv = SUO_pwv((SUO_pwv > 0) & (~isnan(all_watcol)));
clean_COSpwv = all_watcol((SUO_pwv > 0) & (~isnan(all_watcol)));
clean_COSlat = all_lat((SUO_pwv > 0) & (~isnan(all_watcol)));
clean_SUOlat = S_lat((SUO_pwv > 0) & (~isnan(all_watcol)));
clean_SUOlon = S_lon((SUO_pwv > 0) & (~isnan(all_watcol)));
clean_COSlon = all_lon((SUO_pwv > 0) & (~isnan(all_watcol)));
clean_COShour = all_hour((SUO_pwv > 0) & (~isnan(all_watcol)));
clean_COSday = all_day((SUO_pwv > 0) & (~isnan(all_watcol)));
clean_COSmin = all_min((SUO_pwv > 0) & (~isnan(all_watcol)));
clean_COSyear = all_year((SUO_pwv > 0) & (~isnan(all_watcol)));

diff = clean_SUOpwv - clean_COSpwv;
clean_SUOlon = transpose(clean_SUOlon);
clean_SUOlat = transpose(clean_SUOlat);
lat_diff = clean_SUOlat - clean_COSlat;
lon_diff = clean_SUOlon - clean_COSlon;
distance = (lat_diff.^2 + lon_diff.^2).^.5;

diff_abs = abs(diff);

zlon_10 = clean_COSlon(diff_abs >= 10);
zlat_10 = clean_COSlat(diff_abs >= 10);
zyear_10 = clean_COSyear(diff_abs >= 10);
zmin_10 = clean_COSmin(diff_abs >= 10);
zday_10 = clean_COSday(diff_abs >= 10);
zhour_10 = clean_COShour(diff_abs >= 10);
zSUOlat_10 = clean_SUOlat(diff_abs >=10);
zSUOlon_10 = clean_SUOlon(diff_abs >=10);
zSUOwatcol_10 = clean_SUOpwv(diff_abs >=10);
zCOSwatcol_10 = clean_COSpwv(diff_abs >=10);

percent_diff = diff_abs./clean_COSpwv;
