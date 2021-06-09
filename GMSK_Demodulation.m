function Demodulated_GMSK_signal = GMSK_Demodulation (output_from_matched_filter,In_phase,Quadrature)
    Inphase_filtered = conv (output_from_matched_filter,In_phase);
    Quadrature_filtered = conv (output_from_matched_filter,Quadrature);
    %%Adding extra samples to the end of both Inphase_filtered and Quadrature_filtered
    Inphase_filtered_sampled = [Inphase_filtered Inphase_filtered(length(Inphase_filtered))];
    Quadrature_filtered_sampled = [Quadrature_filtered Quadrature_filtered(length(Quadrature_filtered))];
    %%calcualtion of the phase of recieved signal
    %%next step is to find the phase of each sample of the recieved signal
    phase_recieved_signal = angle(Inphase_filtered_sampled+Quadrature_filtered_sampled*j);
    correction_phase_recieved_signal = unwrap(phase_recieved_signal);
    %%third step is differentiation (the opposite of integrator that we did in the modulator step)
    differentiated_phase = diff(correction_phase_recieved_signal);
    differentiated_phase_sampled = [correction_phase_recieved_signal(1) differentiated_phase]; 
    %%down sampling the signal 
   downsampled_the_phase = downsample_phase(differentiated_phase_sampled,70,71,36);
    Demodulated_GMSK_signal = Analog_digital_conversion (downsampled_the_phase) ;
    
end