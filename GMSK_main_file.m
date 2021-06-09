samples = 7; %up
Tb = 1; % bit duration
SamplePeriod = Tb*(1/samples); 
Berr =[];
 %for EbNo = (0:1:25)
    message = randsrc(1,20); % produces random -1's and 1's
    t1 = 0:SamplePeriod:(length(message)*Tb); % define timeline
    t1(:, length(t1)) = []; % get rid of extra column in timeline
    stem(message);title('represneting the message');xlabel('Time - seconds');ylabel('Amplitude');
    % GMSK Modulation -
    % the following loop, converts message into a series of unipolar NRZ data.
    rect = kron(message,ones(1,samples)); % use the kron function to upsample the bits.
    figure;plot(t1,rect);title('represneting the message NRZ');xlabel('Time - seconds');ylabel('Amplitude');
    %% transmitter
    % create gaussian low pass filter(defined in the gaussian_filter.m)
    gaussfilter = gussian_filter(Tb,samples);
    figure;plot(gaussfilter);title('Impulse response of gaussian filters when Bandwidth = 0.3');xlabel('samples');ylabel('Magnitude');
    % pass message signal through Gaussian LPF
    conv_rect_gaus = conv(rect,gaussfilter,'same');
    figure;plot(conv_rect_gaus);title('Result of convulation between the gaussian filter and the rect');xlabel('samples');ylabel('amplitude');
    conv_rect_gaus_integrated = cumsum(conv_rect_gaus); 
    figure;plot(conv_rect_gaus_integrated);title(' NRZ data after filtering and integration');xlabel('samples');ylabel('amplitude');
    m_filtered2_real = cos(conv_rect_gaus_integrated);
    m_filtered2_imag = sin(conv_rect_gaus_integrated);
    m_filtered2 = m_filtered2_real + 1i*m_filtered2_imag;
    figure;plot(m_filtered2_real);title('Q channels of modulated NRZ');xlabel('Time');ylabel('Amplitude');
    hold on ;plot(m_filtered2_imag,'r');title('I channels of modulated NRZ');xlabel('Time');ylabel('Amplitude');hold off;
    %% Channel
    % 1-Raleigh channel
    rayleighchan = comm.RayleighChannel('SampleRate',200e3,'MaximumDopplerShift',30);
    m_filtered2_real=rayleighchan(m_filtered2_real');
    m_filtered2_imag=rayleighchan(m_filtered2_imag');
    % 2-Rician channel
    ricianchan = comm.RicianChannel('SampleRate',200e3,'MaximumDopplerShift',130);
    m_filtered2_real=ricianchan(m_filtered2_real);
    m_filtered2_imag=ricianchan(m_filtered2_imag);
    % 3-AWGN
    noisy_real = awgn(m_filtered2_real', (15),'measured'); % apply noise to I-channel
    noisy_imag = awgn(m_filtered2_imag', (15),'measured'); % apply noise to Q-channel
    %% Reciver
    Matched_Filter = Demodulation_Matched_Filter (Tb,samples);
    filt_noisy_real = conv(noisy_real,Matched_Filter,'same');
    filt_noisy_imag = conv(noisy_imag,Matched_Filter,'same');
    figure;plot(Matched_Filter);title('matched filter when bandwidth = 0.5 and sampling rate is 7 Hz');xlabel('samples');ylabel('Amplitude');
    figure;plot(filt_noisy_real);title('result from conv. between in phase and matched filter (with noise)');xlabel('samples');ylabel('Amplitude');
    figure;plot(filt_noisy_imag);title('result from conv. between quadrature and matched filter (with noise)');xlabel('samples');ylabel('Amplitude');
    phase_recieved = unwrap(angle(filt_noisy_real+filt_noisy_imag*j));
    figure;plot(phase_recieved);title('phase of recieved signal after matched filter');xlabel('samples');ylabel('magnitude');
    opposite_integrated = diff(phase_recieved);
    opposite_integrated = [phase_recieved(1) opposite_integrated];
    figure;plot(opposite_integrated);title('differntiation of phase of recieved signal');xlabel('samples');ylabel('amplitude');
    downsampled_signal = downsample_phase(opposite_integrated,1,0,samples);
    figure;plot(downsampled_signal);title('downsampled signal');xlabel('samples');ylabel('amplitude');
    recieved_signal = Analog_digital_conversion(downsampled_signal);
    figure;stem(recieved_signal);title('recieved signal');xlabel('time');ylabel('amplitude');
    [num,rate] = symerr(message,recieved_signal);
    
    %store Pe values
    %Berr = [Berr rate];
 %end 
%EbNo_temp = 0:1:25;
%semilogy(EbNo_temp,Berr,'*');title('BERR plotting between sent message and recieved message for 20K bits theory Vs estimated');hold on
