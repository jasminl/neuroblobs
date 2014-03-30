function [fig_handle, sb] = pp_coh_test(timeseries, lambda, L, S, labels)
%PP_COH_TEST computes the Fourier transform and coherency index for spike 
%train pairs and plots the result.
%   [FIG_HANDLE, SB] = PP_COH_TEST(TIMESERIES, LAMBDA, L, S, LABELS) 
%   computes the coherency test described in "Rosenberg, J.R., Amjad, A.M.,
%   Breeze, P., Brillinger, D.R., & Halliday, D.M. (1989). The Fourier 
%   approach to the identification of functional coupling between neuronal 
%   spike trains. Progress in Biophysics and Molecular Biology, 53, 1-31.". 
%   TIMESERIES is a matrix whose first column represent the time axis and 
%   remaining columns are spike trains (column vectors of 0's and 1's). LAMBDA
%   is a vector of frequencies over which to base the Fourier transform 
%   calculations. L is the number of time intervals into which to divide each
%   time series. S is the sampling frequency. LABELS is a cell array of strings
%   representing a label of the corresponding time series (for display purpose 
%   only). Returns a figure handle and subplot handles (one subplot for each 
%   time-series pair). 
%
%   see ppf, coh, dc

% Copyright (c) 2014, Jasmin Leveille (jalev51@gmail.com)
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are
% met:
% 
% 1. Redistributions of source code must retain the above copyright notice,
% this list of conditions and the following disclaimer.
% 
% 2. Redistributions in binary form must reproduce the above copyright
% notice, this list of conditions and the following disclaimer in the
% documentation and/or other materials provided with the distribution.
% 
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
% IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
% THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
% PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
% CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
% EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
% PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
% PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
% LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
% NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
% SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

%% Fourier transform
[d, T, F] = ppf(timeseries, lambda, L, S);

disp(['min/max frequency range ', num2str(F(1)), ' ', num2str(F(end)),' Hz']);

%% Cross-spectrum
f = xSpectrum(d, T);

%% Coherency
[c, cm] = coh(f);

%% Plot results
[fig_handle, sb] = dc(cm, L, F, labels);
