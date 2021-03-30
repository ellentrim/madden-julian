function [ output ] = CosToTrmm( input )
%This function takes any lattitude and longitude measurements and rounds
%them to 0.125, 0.375, 0.625, 0.875 so that it can match the TRMM data.  
%   Detailed explanation goes here
    r_input = round(input, 2);
    dec_input = mod(r_input,1);
    int_input = floor(r_input);

    if dec_input >= .5
        if dec_input <= 0.74
           output = int_input + 0.6250;
        else
           output = int_input + 0.8750;
        end
    else
        if dec_input >= 0.25 
            output = int_input + 0.3750;
        else
            output = int_input + 0.125;
        end
    end
end

