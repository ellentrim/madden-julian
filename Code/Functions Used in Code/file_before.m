function [ BeforeFile ] = file_before( real_file )
%
%   

hour = str2num(real_file(15:16));
year = str2num(real_file(6:9));
month = str2num(real_file(10:11));
day = str2num(real_file(12:13));
before_year = year;
before_month = month;
before_day = day;

if hour > 0
    before_hour = hour - 3;
    
else 
    if day > 1
        before_hour = 21;
        before_day = day - 1;
    else
         before_hour = 21;
         if month > 1 
            before_month = month - 1;
            if before_month == 1 || before_month == 3 || before_month == 5 || before_month == 7 || before_month == 8 || before_month == 10 || before_month == 12
                before_day = 31;
            else
                if before_month == 4 || before_month == 6 || before_month == 9 || before_month == 11
                    before_day = 30;
                else 
                    before_day = 28;
                end
            end
         else
            before_month = 12;
            before_day = 31; 
            before_year = year - 1;
         end
    end
    
end

      if before_month < 10
         finmonth = ['0',int2str(before_month)];
      else
          finmonth = [int2str(before_month)];  
      end
      
      if before_day < 10
          finday = ['0',int2str(before_day)];
      else
          finday = [int2str(before_day)];
      end
      
      if before_hour < 10
          finhour = ['0',int2str(before_hour)];
      else
          finhour = [int2str(before_hour)];
      end

BeforeFile = ['3B42.',int2str(before_year),finmonth,finday,'.',finhour,'.7.nc'];
end

