function [ trmmhour, trmmday, trmmyear ] = CosToTrmmTime(year,day, hour, min )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
time = hour + min/60;
trmmyear = year;
trmmday = day;
if time >= 10.5
    if time >=16.5
        if time >= 19.5 
            if time >= 22.5
                trmmhour = 0;
                if mod(year,4)==0
                    if day == 365
                        trmmyear = year+1;
                        trmmday = 0;
                    else
                        trmmday = day+1;
                    end
                else
                    if day == 364;
                        trmmyear = year+1;
                        trmmday = 0;
                    else
                        trmmday = day+1;
                    end
                end
                        
                    
            else
                trmmhour = 21;
                trmmday = day;
            end
        else
            trmmhour = 18;
            trmmday = day;
        end
    else
        if time >= 13.5
            trmmhour = 15;
            trmmday = day;
        else
            trmmhour = 12;
            trmmday = day;
        end
    end
else
    if time >= 4.5
        if time >= 7.5
            trmmhour = 9;
            trmmday = day;
        else
            trmmhour = 6;
            trmmday = day;
        end
    else
        if time >= 1.5
            trmmhour = 3;
            trmmday = day;
        else
            trmmhour = 0;
            trmmday = day;
        end
    end
end




