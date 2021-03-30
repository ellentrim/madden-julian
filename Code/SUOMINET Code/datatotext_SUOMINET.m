%% Read Suominet files and TRMM files and compare them %%

clear;clc;

%Name of the file the data will be read into (w = write and elimate whats
%before, a = add onto what already there)
fileID = fopen('SUOMINET_2014_total.txt', 'w');

%Header of the file
fprintf(fileID, '%12s %12s %12s %12s %12s %12s %12s\r\n','Year', 'Day', 'Hour', 'Lat', 'Lon', 'Wat Col', 'Prec'); 

%File for the TRMM files that are not present as a safe gaurd on the code
fileID2 = fopen('miss files suominet.txt', 'a');
%%

%file locations 
SUOMINETfolder = 'C:\Users\Ellen\Documents\Summer\SUOMINET\2014\';

SUOMINETlist = dir(fullfile(SUOMINETfolder,'*.1440_nc'));
%size of the list of folders
nFileSUOMINET   = length(SUOMINETlist);

for k = 1:nFileSUOMINET
    %nFileSUOMINET
    
    %name of file
    SUOMINETname = SUOMINETlist(k).name;
    
    %open netcdf file
    nc = netcdf.open(fullfile(SUOMINETfolder,SUOMINETname),'NC_NOWRITE');
    
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
    
    nSTATION = size(SUOMINETlon);
    
    
    
    
    %Folder with the TRMM files  
    trmmfolder = 'C:\Users\Ellen\Documents\Summer\TRMM\2014\';
        
        %Folder with the TRMM files  
    
        %tmp_trmmname = ['3B42.',int2str(trmmyear),finmonth,finday,'.','.7.nc'];
        
        % Example file: GsPWVd_2005.003.00.00.1440_nc
        
        
        year = SUOMINETname(9:12);
        doy = SUOMINETname(14:16);
        
        [day,month] = doy2date(str2num(doy), str2num(year));
        %iterate through the stations to find the ones in the appropriate area 
        for j = 1:nSTATION
            if SUOMINETlat(j) >= -15 && SUOMINETlat(j) <= 20 && SUOMINETlon(j) >= 90 && SUOMINETlon(j) <= 150
                
                
                
                %converting lon and lat to compare to trmm data
                pre_lon = CosToTrmm(SUOMINETlon(j));

                
                %Convert from longitude and lattitude to the indexes used in TRMM
                trmm_lon = (pre_lon + 180.1250)*4;
                pre_lat = CosToTrmm(SUOMINETlat(j));
                trmm_lat = (50.125 + pre_lat)*4;         
        
                %iterate through hours 3 to 21
               for iTRMM = 1:7

                   time = iTRMM*3;

                   if time < 10
                      fintime = ['0',int2str(time)];
                  else
                      fintime = [int2str(time)];
                   end

                   if month < 10
                      finmonth = ['0',int2str(month)];
                  else
                      finmonth = [int2str(month)];
                   end

                   if day < 10
                      finday = ['0',int2str(day)];
                   else
                      finday = [int2str(day)];
                   end

                   finyear = year;



                %name and loation of the trmm file 
                %Example TRMM file: 3B42.20140101.18.7A.nc
                tmp_trmmname = ['3B42.',finyear,finmonth,finday,'.',fintime,'.7.nc'];
                trmmname = fullfile(trmmfolder, tmp_trmmname);

                

                    %check to make sure the TRMM file exists 
                    if exist(trmmname, 'file')
                        
                        %retrieve the information from the TRMM file
                        pc = netcdf.open(trmmname,'NC_NOWRITE');
                        
                        tmp_id = netcdf.inqVarID(pc,'pcp');
                        pcp_tmp(1,:,:) = netcdf.getVar(pc,tmp_id);
                        
                        %call up the precipitation for the cosmic point
                        %from the TRMM data
                        pcp = pcp_tmp(1,trmm_lon,trmm_lat);
                    if pcp > -1

                        %Find the range of reading within the three hours
                        %(1.5 hours before and after)
                        first_reading = 4 + (iTRMM-1)*6;
                        last_reading = first_reading + 6;
                        
                        %initialize variables
                        
                        n_readings = 0; %number of readings non negative
                        pwv_sum = 0; %sum of the readings of pwv
                        
                        for i_read = first_reading:last_reading
                           if pwv(i_read,j) > 0 
                               pwv_sum = pwv_sum + pwv(i_read,j);
                               n_readings = n_readings + 1;
                           end                            
                        end
                        
                        pwv_average = pwv_sum/n_readings;
                        
                        iyear = year;
                        iday = doy;
                        ihour = time;
                       
                        
                        %Columns: year, day, hour, min, lat, lon, water col
                        fprintf(fileID, '%12s %12s %12.1f %12.4f %12.4f %12.4f %12.4f\r\n',iyear, iday, ihour, SUOMINETlat(j), SUOMINETlon(j), pwv_average, pcp);

                    
                        
                
                        netcdf.close(pc);
                    end
                end

           end
                
                %% what to do with hour 00
                
                
                
                SUOMINETname_before = SUOMINETlist(k).name;
    
                bc = netcdf.open(fullfile(SUOMINETfolder,SUOMINETname_before),'NC_NOWRITE');

                tmp_id = netcdf.inqVarID(bc,'lon');
                SUOMINETlon_before = netcdf.getVar(bc,tmp_id);
                tmp_id = netcdf.inqVarID(bc,'lat');
                SUOMINETlat_before = netcdf.getVar(bc,tmp_id);

                tmp_id = netcdf.inqVarID(bc,'pwv');
                pwv_before = netcdf.getVar(bc,tmp_id);

                tmp_id = netcdf.inqVarID(bc,'station');
                station_before = netcdf.getVar(bc,tmp_id);

                tmp_id = netcdf.inqVarID(bc,'time_offset');
                time_offset_before = netcdf.getVar(bc,tmp_id);

                nSTATION_before = size(SUOMINETlon_before);
                
                % get the info for the TRMM file 
                tmp_trmmname = ['3b42.',finyear,finmonth,finday,'.00.7.nc'];
                trmmname = fullfile(trmmfolder, tmp_trmmname);
            if exist(trmmname, 'file') 
                
                tc = netcdf.open(trmmname,'NC_NOWRITE');
                
                tmp_id = netcdf.inqVarID(tc,'pcp');
                pcp_tmp_00(1,:,:) = netcdf.getVar(tc,tmp_id);

                %call up the precipitation for the cosmic point
                %from the TRMM data
                pcp_00 = pcp_tmp_00(1,trmm_lon,trmm_lat);
            if pcp_00 > -1 
                %check to make sure the station is still the same number 
                if SUOMINETlat_before(j) == SUOMINETlat(j) && SUOMINETlon_before(j) == SUOMINETlon(j)
                    
                    %numbers that correspond to readings for 00: 46 and 47
                    %from 'before' and 1,2, and 3 from this file 
                    
                    n_readings_00 = 0; %number of readings non negative
                    pwv_sum_00 = 0; %sum of the readings of pwv
                    
                    
                    for i_before = 46:47
                    
                       if pwv_before(i_before,j) > 0 
                           pwv_sum_00 = pwv_sum_00 + pwv_before(i_before,j);
                           n_readings_00 = n_readings_00 + 1;
                       end                            
                    end
                    
                    for i_read_00 = 1:3
                       if pwv(i_read_00,j) > 0 
                           pwv_sum_00 = pwv_sum_00 + pwv(i_read_00,j);
                           n_readings_00 = n_readings_00 + 1;
                       end                            
                    end

                    pwv_average_00 = pwv_sum_00/n_readings_00;
                    
                    iyear = year;
                    iday = doy;
                    ihour = 0;


                    %Columns: year, day, hour, min, lat, lon, water col
                    fprintf(fileID, '%12s %12s %12.1f %12.4f %12.4f %12.4f %12.4f\r\n',iyear, iday, ihour, SUOMINETlat(j), SUOMINETlon(j), pwv_average_00, pcp_00);

                    
                else
                    
                    for i_stations = 1:nSTATION_before 
                        if SUOMINETlat_before(i_stations) == SUOMINETlat(j) && SUOMINETlon_before(i_stations) == SUOMINETlon(j)
                    
                            %numbers that correspond to readings for 00: 46 and 47
                            %from 'before' and 1,2, and 3 from this file 

                            n_readings_00 = 0; %number of readings non negative
                            pwv_sum_00 = 0; %sum of the readings of pwv


                            for i_before = 46:47

                               if pwv_before(j,i_before) > 0 
                                   pwv_sum_00 = pwv_sum_00 + pwv_before(j,i_before);
                                   n_readings_00 = n_readings_00 + 1;
                               end                            
                            end

                            for i_read_00 = 1:3
                               if pwv(j,i_read_00) > 0 
                                   pwv_sum_00 = pwv_sum_00 + pwv(j,i_read_00);
                                   n_readings_00 = n_readings_00 + 1;
                               end                            
                            end

                            pwv_average_00 = pwv_sum_00/n_readings_00;  
                            
                            iyear = year;
                            iday = doy;
                            ihour = 0;


                            %Columns: year, day, hour, min, lat, lon, water col
                            fprintf(fileID, '%12s %12s %12s %12.4f %12.4f %12.4f %12.4f\r\n',iyear, iday, ihour, av_lat, av_lon, pwv_average_00, pcp_00);

                            
                            
                        end
                    end
                end
                netcdf.close(bc);
                netcdf.close(tc);
                close all;
            end
        end
                
           
                
            end
    
    end
    
    netcdf.close(nc); 
    close all;
end







