%% Move COSMIC files into folders with the name of the TRMM file it corresponds to %%



folder  = 'C:\Users\Ellen\Documents\Summer\COSMIC\2015\ecmPrf\';


    %file = 'yes';
    %list of the folders that have COSMIC files in them 
    list_folder = dir(folder);
    nFolder = length(list_folder);

    for k = 3:nFolder
        %what are the files in this folder
        list_file = dir(fullfile(folder,list_folder(k).name));
        %what is that length
        nFile = length(list_file);
        sec_folder = list_folder(k).name;
        for j = 3:nFile
            %name of the file being iterated
          filename = list_file(j).name;
          
          %components of the name of the file
          banana = strsplit(filename,'.');
          iyear = str2num(cell2mat(banana(2)));
          iday = str2num(cell2mat(banana(3)));
          ihour = str2num(cell2mat(banana(4)));
          imin = str2num(cell2mat(banana(5)));
            
          %Change the COSMIC time profile to the gridded TRMM one
          %(00,03,06,09,12,15,18,21)
          [trmmhour,tmp_day,trmmyear] = CosToTrmmTime(iyear,iday,ihour,imin);
          %change Day of Year to Date (day, month)
          [trmmday,trmmmonth] = DoyToDate(tmp_day, trmmyear);
            
          %put it in the right form (a string of 2 characters)
          if trmmmonth < 10
             finmonth = ['0',int2str(trmmmonth)];
          else
              finmonth = [int2str(trmmmonth)];  
          end

          if trmmday < 10
              finday = ['0',int2str(trmmday)];
          else
              finday = [int2str(trmmday)];
          end

          if trmmhour < 10
              finhour = ['0',int2str(trmmhour)];
          else
              finhour = [int2str(trmmhour)];
          end

            %Put together the name of the TRMM file that corresponds to the
            %COMSMIC file 
          foldername = ['3B42.',int2str(trmmyear),finmonth,finday,'.',finhour,'.7.nc'];
            %Name  + location for the file
          finalfolder = ['C:\Users\Ellen\Documents\Summer\COSMIC\2015\sorted\',foldername];
            %See if the file folder already exists, make it if not
          if exist(finalfolder,'dir')== 0
              mkdir(finalfolder);
          end
        %move the COSMIC file into the folder labeled for the TRMM file it
        %corresponds to
          movefile(fullfile(folder,sec_folder,filename),finalfolder);
        end
    end
    
%load handel %plays the messiah so you know the code is finished running
%sound(y,Fs)
