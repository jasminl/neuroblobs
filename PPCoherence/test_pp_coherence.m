%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% test_pp_coherence.m                                                    %
% Author: Jasmin Leveille (jalev51@gmail.com)                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script illustrates the use of functions to compute the coherence  %
% across pairs of point processes. Details of the method implemented can %
% be found in:                                                           %
%     Rosenberg, J.R., Amjad, A.M., Breeze, P., Brillinger, D.R., &      %
%     Halliday, D.M. (1989). The Fourier approach to the identification  %
%     of functional coupling between neuronal spike trains. Progress in  %
%     Biophysics and Molecular Biology, 53, 1-31.                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Setup 

clear;

S = 1000; %Sampling rate (in milliseconds)
T = 20; %Length of interval (in seconds)

L = T; %Number of intervals over which to divide the time-series
lambda = 1:100; %Fundamental frequency

%Note the smallest and largest frequencies over which coherence can be computed are given by
% S/(T*S/L) * lambda(1) and S/(T*S/L) * lambda(end), respectively.

%% Generate data (3 spike trains with smallest common multiple freq. of 50Hz
% and random phases and noise, thresholded to yield spike trains)

t = [0:1/S:T]';    %Time axis
m = [0:1:S * T]';  %Time points of samples
freq = [10 25 50]; %Spike trains at 10, 25 and 50Hz
phase = [0 10 20]; %Random phases

x = cos(2 * pi * repmat(freq,[numel(t), 1]) .* repmat(t,[1, 3]) + ...
repmat(phase, [numel(t), 1])) + rand(numel(t), 3) - 0.5 > 0.95; 

labels = {'10Hz','25Hz','50Hz'};  %Labels to give the simulated electrodes

%% Run test and plot graph
pp_coh_test([m x], lambda, L, S, labels);
