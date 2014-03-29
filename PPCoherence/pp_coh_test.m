function [fig_handle, sb] = pp_coh_test(timeseries, lambda, L, S, labels)
%Computes the Fourier transform and coherency index for spike train pairs and plots the result
%   [FIG_HANDLE, SB] = PP_COH_TEST(TIMESERIES, LAMBDA, L, S, LABELS) computes the coherency test 
%   described in "Rosenberg, J.R., Amjad, A.M., Breeze, P., Brillinger, D.R., & Halliday, D.M.
%   (1989). The Fourier approach to the identification of functional coupling between neuronal 
%   spike trains. Progress in Biophysics and Molecular Biology, 53, 1-31.". TIMESERIES is a 
%   matrix whose first column represent the time axis and remaining columns are spike trains 
%   (column vectors of 0's and 1's). LAMBDA is a vector of frequencies over which to base the 
%   Fourier transform calculations. L is the number of time intervals into which to divide each
%   time series. S is the sampling frequency. LABELS is a cell array of strings representing a
%   label of the corresponding time series (for display purpose only). Returns a figure
%   handle and subplot handles (one subplot for each time-series pair). 

%% Fourier transform
[d, T, F] = ppf(timeseries, lambda, L, S);

disp(['min/max frequency range ', num2str(F(1)), ' ', num2str(F(end)),' Hz']);

%% Cross-spectrum
f = xSpectrum(d, T);

%% Coherency
[c, cm] = coh(f);

%% Plot results
[fig_handle, sb] = dc(cm, L, F, labels);
