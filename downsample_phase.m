function downsampled_signal = downsample_phase (Input_signal,begin_sampling,samples_left,down_sampling_rate)
    %%this function downsampled the input signal 
    %%Input_signal : the signal to be downsampled
    %%begin_sampling : beginnging the sampling from this sample
    %%samples_left : number of samples to be left at the end
    %%down_sampling_rate : downsampling rate Hz
    Length_input_signal = length (Input_signal) ;
    index = begin_sampling:down_sampling_rate:Length_input_signal-samples_left;
    downsampled_signal = Input_signal(index);
end