function output = Analog_digital_conversion (Input_signal)
    stream=[];
    for i = 1:1:length (Input_signal)
        if(Input_signal(i)<0)       
            stream(i) = -1;
        elseif(Input_signal(i)>0)    
            stream(i) = 1;
        elseif(Input_signal(i)==0)   
            stream(i) = -1;
        end
        
    end
    
    output = stream ;
         
end

