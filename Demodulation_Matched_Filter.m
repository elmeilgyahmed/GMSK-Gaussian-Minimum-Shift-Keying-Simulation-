function output_GMSK_Matched_Filter = Demodulation_Matched_Filter(Tb,sampling_rate)
    %%the input of this function is the Tb and sampling rate in Hz
    %%We want to change the impulse response of the matched filter, to be
    %%changed by a phase pi/2 for each bit change
    %%W is as variable , to be tuned later
    W = 0.5 ;
    t = (-Tb:Tb/sampling_rate:Tb); 
    time_domain_impulse_response = (W.*sqrt((2*pi)/log(2))).*exp((-1*(((2*pi^2)*(W.^2))).*t.^2)./log(2));
    %scale the imulse response by phase pi/2
    phase_change = pi/2 / sum (time_domain_impulse_response);
    phase_changed_impulse_response = time_domain_impulse_response * phase_change  ;
    %%normalization of the phased changed impulse response by divided it
    %%over the square of its sum
    Normalized_factor = sqrt(sum(phase_changed_impulse_response));
    output_GMSK_Matched_Filter = phase_changed_impulse_response./Normalized_factor;
    
end