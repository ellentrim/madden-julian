%% Read Suominet files and TRMM files and compare them %%

clear;

TRMM_hours = ['00' '03' '06' '09' '12' '15' '18' '21'];


%Name of the file the data will be read into (w = write and elimate whats
%before, a = add onto what already there)
fileID = fopen('SUOMINET_2007_daily.txt', 'w');

%Header of the file
fprintf(fileID, '%12s %12s %12s %12s %12s %12s %12s\r\n','Year', 'Day', 'Hour', 'Lat', 'Lon', 'Wat Col', 'Prec'); 

%File for the TRMM files that are not present as a safe gaurd on the code
fileID2 = fopen('miss files suominet.txt', 'a');
%%

%file locations 
SUOMINETfolder = 'C:\Users\Ellen\Documents\Summer\SUOMINET\2007\';

SUOMINETlist = dir(fullfile(SUOMINETfolder,'*.1440_nc'));
%size of the list of folders
nFileSUOMINET   = length(SUOMINETlist);

for k = 1:nFileSUOMINET
    
    %name of file
    SUOMINETname = SUOMINETlist(k).name;
    
    %open netcdf file
    %OPEN FILE NC
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
    trmmfolder = 'C:\Users\Ellen\Documents\Summer\TRMM\2007\';
        
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
           
           for i_TRMM = 1:8
                first_hour = 1 + (i_TRMM-1)*2;
                second_hour = first_hour +1;
                hour = TRMM_hours(first_hour:second_hour);
                tmp_trmmname = ['3B42.',finyear,finmonth,finday,'.',hour,'.7A.nc'];
                trmmname = fullfile(trmmfolder, tmp_trmmname); 

                if exist(trmmname, 'file') 
                    %retrieve the information from the TRMM file
                    pc = netcdf.open(trmmname,'NC_NOWRITE');

                    tmp_id = netcdf.inqVarID(pc,'pcp');
                    pcp_daily(:,:,i_TRMM) = netcdf.getVar(pc,tmp_id);
                    netcdf.close(pc);
                end

           end
            
           nTime = length(time_offset);
               
           for iSUO = 1:nTime

               

              
               
            


            %name and loation of the trmm file 
            %Example TRMM file: 3B42.20070101.18.7A.nc
            %tmp_trmmname = ['3B42.',finyear,finmonth,finday,'.',fintime,'.7.nc'];
            %
            %trmmname = fullfile(trmmfolder, tmp_trmmname);



                %check to make sure the TRMM file exists 
                if exist(trmmname, 'file')
                     pcp_daily(pcp_daily<0) = nan;

                    %retrieve the information from the TRMM file
                   
                    %call up the precipitation for the cosmic point
                    %from the TRMM data
                    
                    pcp = nanmean(pcp_daily(trmm_lon,trmm_lat,:));
                    if pcp > -1

                        %Find the range of reading within the three hours
                        %(1.5 hours before and after)

                        pwv_spec =  pwv(iSUO,j);
                        
                        iyear = year;
                        iday = doy;
                        
                        %get the time of when the SOU measurement was taken
                        time = (iSUO - 1)/2;
                        ihour = time;


                        %Columns: year, day, hour, min, lat, lon, water col
                        fprintf(fileID, '%12s %12s %12.1f %12.4f %12.4f %12.4f %12.4f\r\n',iyear, iday, ihour, SUOMINETlat(j), SUOMINETlon(j), pwv_spec, pcp);



                        
                    end
                end
            end
        end    
    end         
    netcdf.close(nc); 
    close all;
end







