%Written by Ellen Robo (ellentrimrobo@gmail.com)
%Same as normal datatotxt_sorted expect this takes the TRMM prec
%measurements before and after as well
%NEED file_before.m and file_after.m functions for this to run

clear;clc;
%%initializing variables 
e_sat = [];
rel_hum = [];




%Name of the file the data will be read into (w = write and elimate whats
%before, a = add onto what already there)
fileID = fopen('2006_9hour_total.txt', 'w');

%Header of the file
fprintf(fileID, '%12s %12s %12s %12s %12s %12s %12s %12s %12s\r\n','Year', 'Day', 'Hour', 'Min', 'Lat', 'Lon', 'Wat Col', 'Prec', 'Temp'); 

%File for the TRMM files that are not present as a safe gaurd on the code
fileID2 = fopen('miss files 2006.txt', 'a');

%%
%folder for the COSMIC folders sorted to match the TRMM format (3 hour
%blocks)
COSMICfolder = 'C:\Users\Ellen\Documents\Summer\COSMIC\2006\sorted\';
%List of all of the COSMIC folders 
listCOSMIC = dir(fullfile(COSMICfolder)); 
%listTRMM = dir(fullfile('*.nc'));

%size of the list of folders
nFileCOSMIC   = length(listCOSMIC);

%interate through each folder 
 for k = 3:nFileCOSMIC
     %prints the number every 200 to keep track of how far the code has run
     if mod(k,200) == 0
         k
     end
      %name of the COSMIC folder being used in this interation
      foldername = listCOSMIC(k).name;
      
      %list of the files within the folder being itereated 
      list_of_folderCOSMIC = dir((fullfile(COSMICfolder,listCOSMIC(k).name)));
      %location of the COMSIC files 
      COSMICfullfolder = fullfile(COSMICfolder,listCOSMIC(k).name);
      %number of files in this folder
      sizeFolder = length(list_of_folderCOSMIC);
      

        %Folder with the TRMM files  
        trmmfolder = 'C:\Users\Ellen\Documents\Summer\TRMM\2006\';
        %tmp_trmmname = ['3B42.',int2str(trmmyear),finmonth,finday,'.','.7.nc'];
        
        
        %name and loation of the trmm file 
        tmp_trmmname = ['3b42.',foldername(6:16),'.7a.nc'];
        tmp_trmmname2 = [tmp_trmmname(1:18),tmp_trmmname(19:21)];
        trmmname = fullfile(trmmfolder, tmp_trmmname);
        tmp_trmmname_before = file_before(tmp_trmmname);
        tmp_trmmname_before2 = ['3b42.',tmp_trmmname_before(6:16),'.7a.nc'];
        trmmname_before = fullfile(trmmfolder, tmp_trmmname_before2);
        tmp_trmmname_after = file_after(tmp_trmmname);
        tmp_trmmname_after2 = ['3b42.',tmp_trmmname_after(6:16),'.7a.nc'];
        trmmname_after = fullfile(trmmfolder, tmp_trmmname_after2);
       
        

      
      
    %check to make sure the TRMM file exists 
    if exist(trmmname, 'file') && exist(trmmname_before, 'file') && exist(trmmname_after, 'file')
        %retrieve the information from the TRMM file
        pc = netcdf.open(trmmname,'NC_NOWRITE');
        pc_before = netcdf.open(trmmname_before,'NC_NOWRITE');
        pc_after = netcdf.open(trmmname_after,'NC_NOWRITE');
%         tmp_id = netcdf.inqVarID(pc,'longitude');
%         lon = netcdf.getVar(pc,tmp_id);
%         tmp_id = netcdf.inqVarID(pc,'latitude');
%         lat = netcdf.getVar(pc,tmp_id);

        tmp_id = netcdf.inqVarID(pc,'pcp');
        pcp_now(1,:,:) = netcdf.getVar(pc,tmp_id);
        tmp_id = netcdf.inqVarID(pc,'pcp');
        pcp_before(1,:,:) = netcdf.getVar(pc_before,tmp_id);
        tmp_id = netcdf.inqVarID(pc,'pcp');
        pcp_after(1,:,:) = netcdf.getVar(pc_after,tmp_id);
        
             
           %interate through each COSMIC file (they all correspond to the same TRMM file)             
           for j = 3:sizeFolder  
                
                %initialize the variables
                wat_col = 0;
                tmp_lat = 0;
                tmp_lon = 0;
                
                %pull COSMIC info from the NETCDF file 
                nc = netcdf.open(fullfile(COSMICfullfolder,list_of_folderCOSMIC(j).name),'NC_NOWRITE');
                tmp_id = netcdf.inqVarID(nc,'Temp');
                temp = netcdf.getVar(nc,tmp_id);
                tmp_id = netcdf.inqVarID(nc, 'Lon');
                lon = netcdf.getVar(nc, tmp_id); 
                tmp_id = netcdf.inqVarID(nc, 'Lat');
                lat = netcdf.getVar(nc, tmp_id);
                tmp_id = netcdf.inqVarID(nc, 'Vp');
                wat_vap = netcdf.getVar(nc, tmp_id);
                tmp_id = netcdf.inqVarID(nc, 'MSL_alt');
                height = netcdf.getVar(nc, tmp_id);
                tmp_id = netcdf.inqVarID(nc, 'Pres');
                pressure = netcdf.getVar(nc, tmp_id);
                    
                        
                    %make sure the location of the cosmic data is within
                    %the range of TRMM 
                      if (lon(1) > -179 && lon(1) < 179) && (lat(1) > -48.3 && lat(1) < 48.3)

                        %pressure(1)
                        %finding relative humidty for each point going up
                        %in the water column
                        e_sat = 6.11.*10.^((7.5*temp)./(237.3+temp));
                        rel_hum = wat_vap./e_sat;

                        %B is the ratio between molecular weight of water to
                        %molecular weight of gas [g/kg]
                        B = 621.9907;
                        mix_ratio = B.*wat_vap./(pressure-wat_vap);

                        %number of kilograms per mbar
                        air_mass_per_mbar = 10.2;

                        %density of water [1000 kg/m^3]
                        den_water = 1000;

                        %top pressure height I integrate over (300mbars) 
                        pre_lev = 10;

                        %interate over each pressure level
                        for i = 1:pre_lev

                            %difference between the two pressure surfaces
                            tmp_pres_diff = pressure(i)-pressure(1+i);

                            %mass of the air between the two pressure surfaces
                            tmp_air_mass = air_mass_per_mbar*tmp_pres_diff;
                            %average mixing ratio of the two pressure surfaces [g/kg]
                            tmp_av_mix_ratio = (mix_ratio(i)+ mix_ratio(i+1))/2;
                            %the mass of the water between the two pressure surfaces [kg]
                            tmp_water_mass = tmp_av_mix_ratio*tmp_air_mass;
                            %height this mass translates into [mm]
                            tmp_water_height = tmp_water_mass/den_water;

                            wat_col = wat_col + tmp_water_height;

                            %sum lat and lon in order to average
                            tmp_lon = tmp_lon + lon(i);
                            tmp_lat = tmp_lat + lat(i);

                        end

                        av_lon = tmp_lon/pre_lev;
                        av_lat = tmp_lat/pre_lev;
                        %wat_col


                       
                        
                        %converting lon and lat to compare to trmm data
                        pre_lon = CosToTrmm(av_lon);
                        
                        %if using daily files need this part.  Otherwise
                        %comment out
                        
                        %Trmm Hourly Lon: -179.8750 = index(1) and
                        %179.8750 = index(1440)
                        
%                         if pre_lon > 0 
%                             pre2_lon = pre_lon;
%                         else
%                             pre2_lon = pre_lon + 360;
%                         end
                        %Convert from longitude and lattitude to the indexes used in TRMM
                        trmm_lon = (pre_lon + 180.1250)*4;
                        pre_lat = CosToTrmm(av_lat);
                        pre2_lat = 50.125 + pre_lat;
                        trmm_lat = pre2_lat*4;
                        
                        
                        %call up the precipitation for the cosmic point
                        %from the TRMM data
                        
                        pcp_hour = pcp_now(1,trmm_lon,trmm_lat);
                        pcp_hour_before = pcp_before(1,trmm_lon,trmm_lat);
                        pcp_hour_after = pcp_after(1,trmm_lon,trmm_lat);
                        pcp_tmp = [];
                        if pcp_hour_before >= 0
                            pcp_tmp = [pcp_tmp;pcp_hour_before];
                        end
                        if pcp_hour >= 0
                            pcp_tmp = [pcp_tmp;pcp_hour];
                        end
                        if pcp_hour_after >= 0
                            pcp_tmp = [pcp_tmp;pcp_hour_after];
                        end
                        
                        pcp_mean = mean(pcp_tmp);
                        
                        %getting day and time info
                        
                        cosmic_file_name = list_of_folderCOSMIC(j).name;
                        iyear = cosmic_file_name(13:16);
                        iday = cosmic_file_name(18:20);
                        ihour = cosmic_file_name(22:23);
                        imin = cosmic_file_name(25:26);

                         %Columns: year, day, hour, min, lat, lon, water col
                        fprintf(fileID, '%12s %12s %12s %12s %12.4f %12.4f %12.4f %12.4f %12.4f\r\n',iyear, iday, ihour, imin, av_lat, av_lon, wat_col, pcp_mean, temp(1));

                    
                    
                    
                     end
                    netcdf.close(nc);
           end
                    netcdf.close(pc);
                    netcdf.close(pc_before);
                    netcdf.close(pc_after);
                    
    else
        fprintf(fileID2, '%50s\r\n', trmmname);
        
    end
      
end
 





fclose(fileID);
%%
