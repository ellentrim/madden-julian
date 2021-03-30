function [day, month] = DoyToDate( doy, year )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
%1 Leap Years
if mod(year,4) == 0
    %2 Jan thru June
    if doy < 183
        %3 Jan thru March
        if doy < 92
            %4 Jan and Feb
            if doy < 61
                %5 Jan
                if doy <= 31
                    month = 1;
                    day = doy;
                %5 Feb
                else
                    month = 2;
                    day = doy - 31;
                %5
                end
            %4 March
            else
                month = 3;
                day = doy-60;
            %4
            end
        
        %3 April thru June    
        else
            %April and May
            if doy < 153
                %April
                if doy < 122
                    month = 4;
                    day = doy - 91;
                %May
                else
                    month = 5;
                    day = doy - 121;
                end
            %June
            else
                month = 6;
                day = doy - 152;
            end
        %3    
        end
    %2 July thru Dec
    else
        
        %July thru Sept
        if doy < 275
            %July and Aug
            if doy < 245
                %July
                if doy < 214
                    month = 7;
                    day = doy - 182;
                %Aug
                else
                    month = 8;
                    day = doy - 213;
                end
            %Sept    
            else
                month = 9;
                day = doy - 244;
            end
        
        %Oct thru Dec
        else
            %Oct and Nov
            if doy < 336
                %Oct
                if doy < 306
                    month = 10;
                    day = doy - 274;
                %Nov
                else
                    month = 11;
                    day = doy - 305;
                end
            %Dec    
            else
                month = 12;
                day = doy -335;
            end
        end
    end
    %2    

%Not Leap Years
else
    %2 Jan thru June
    if doy < 182
        %3 Jan thru March
        if doy < 91
            %4 Jan and Feb
            if doy < 60
                %5 Jan
                if doy < 32
                    month = 1;
                    day = doy;
                %5 Feb
                else
                    month = 2;
                    day = doy - 31;
                %5
                end
            %4 March
            else
                month = 3;
                day = doy - 59;
            %4
            end
        
        %3 April thru June    
        else
            %April and May
            if doy < 152
                %April
                if doy < 121
                    month = 4;
                    day = doy - 90;
                %May
                else
                    month = 5;
                    day = doy - 120;
                end
            %June
            else
                month = 6;
                day = doy - 151;
            end
        %3    
        end
    %2 July thru Dec
    else
        
        %July thru Sept
        if doy < 274
            %July and Aug
            if doy < 244
                %July
                if doy < 213
                    month = 7;
                    day = doy - 181;
                %Aug
                else
                    month = 8;
                    day = doy - 212;
                end
            %Sept    
            else
                month = 9;
                day = doy - 243;
            end
        
        %Oct thru Dec
        else
            %Oct and Nov
            if doy < 335
                %Oct
                if doy < 305
                    month = 10;
                    day = doy - 273;
                %Nov
                else
                    month = 11;
                    day = doy - 304;
                end
            %Dec    
            else
                month = 12;
                day = doy -334;
            end
        end
    end
    %2  
end

