function noisy_output = Add_AWGN (Input_signal , EbNo)
    %%This function takes input signal and add to it additive gaussian
    %%noise with EbNo value that passed to the function
    noisy_output = awgn(Input_signal,EbNo);
end