%{ 
Written by Ellen Robo (ellentrimrobo@gmai.com)
Purpose: Takes folders of _nc files to find corrupt ones and writes them
into a txt file
%}

folder  = 'C:\Users\Ellen\Documents\Summer\COSMIC\2011\final';
list_folder = dir(folder);
nFolder   = length(list_folder);

for k = 3:nFolder
  
  list_file  = dir(fullfile(folder,list_folder(k).name,'*.3520_nc'));
  nFile = length(list_file);
  for j_clean = 3:nFile
      file = list_file(j_clean).name;
      try
        nc = netcdf.open(fullfile(folder,list_folder(k).name,file),'NC_NOWRITE');
        success(k) = true;
        netcdf.close(nc);
      catch
        fprintf('failed: %s\n', file);
      end
  end
end