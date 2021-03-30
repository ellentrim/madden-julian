function [ AfterFile ] = file_after( real_file )
%
%   

hour = str2num(real_file(15:16));
year = str2num(real_file(6:9));
month = str2num(real_file(10:11));
day = str2num(real_file(12:13));
after_year = year;
after_month = month;
after_day = day;

if hour < 21
    after_hour = hour + 3;
    
else 
    if after_day < 28
        after_hour = 0;
        after_day = day + 1;
    else
         if after_month == 1 || after_month == 3 || after_month == 5 || after_month == 7 || after_month == 8 || after_month == 10 || after_month == 12
                if after_day < 31
                    after_hour = 0;
                    after_day = day + 1;
                else
                    after_hour = 0;
                    after_day = 1;
                    if after_month == 12
                        after_year = year + 1;
                        after_month = 1;
                    else
                        after_month = month + 1;
                    end
                end
         else
             if after_month == 4 || after_month == 6 || after_month == 9 || after_month == 11
                 if after_day < 30
                    after_hour = 0;
                    after_day = day + 1;
                else
                    after_hour = 0;
                    after_day = 1;
                    after_month = month + 1;
                 end
             else
                 after_hour = 0;
                 after_day = 1;
                 after_month = month + 1;
             end
         end
    end
end
  
      if after_month < 10
         finmonth = ['0',int2str(after_month)];
      else
          finmonth = [int2str(after_month)];  
      end
      
      if after_day < 10
          finday = ['0',int2str(after_day)];
      else
          finday = [int2str(after_day)];
      end
      
      if after_hour < 10
          finhour = ['0',int2str(after_hour)];
      else
          finhour = [int2str(after_hour)];
      end

AfterFile = ['3B42.',int2str(after_year),finmonth,finday,'.',finhour,'.7.nc'];
end



