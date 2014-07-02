function [d, T, F] = ppf(x, lambda, L, S)
%Fourier transform for point-process
%   [D, T, F] = PPF(X, LAMBDA, L, S) returns the Fourier transform for a
%   number of point processes (binary 0-1 time-series), stored as columns
%   of matrix X (other than the first column, which contains the sampling
%   times), at fundamental frequencies specified in vector LAMBDA, and by 
%   dividing the point processes in L intervals. S represents the sampling 
%   rate. The length of each interval is length(X)/L. The output D for each
%   point process and interval is returned column-wise and row-wise respectively. 
%   T is the duration of each interval (in number of sample points), and F is
%   the actual frequencies for the corresponding coefficients. Details about the 
%   method can be found in "Rosenberg, J.R., Amjad, A.M.,
%   Breeze, P., Brillinger, D.R., & Halliday, D.M. (1989). The Fourier 
%   approach to the identification of functional coupling between neuronal 
%   spike trains. Progress in Biophysics and Molecular Biology, 53, 1-31.". 
%
%   see coh, dc, pp_coh_test, xSpectrum

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

%% Setup
[m, n] = size(x);
k = length(lambda);
T = (x(end, 1) - x(1, 1)) / L; %Duration of intervals, based on first/last sample times
w(1, 1, 1:k) = 2 * pi * lambda / T;

%% Determine pulse times by element-wise multiplying spike trains with sample times
v = x(:, 2:end) .* repmat(x(:, 1), 1, n - 1);

%% Subdivide and calculate separately for L sequences
e = linspace(x(1, 1), x(end, 1), L + 1); 
c = histc(x(:, 1), e);

%Iterate over each segment L. Note this neglects the last bin of c, which always is 1. 
q = 1;
d = zeros(L, n-1, k);
for j = 1:L
   if c(j) == 0
       %Nothing is in this bin       
       d(j, :, 1:k) = zeros(1, n-1, k);
       continue;
   else
       %This bin contains some spikes at least for some processes
       p = v(q:q + c(j) - 1, :); %Temporary buffer
       
       [mp, np] = size(p); %Note this does not take time column into account
       
       r = repmat(p, [1, 1, k]) .* repmat(w, [mp, np, 1]); %Exponent matrix

       %Remove contribution from zeros
       s  = sum(x(q:q + c(j) - 1, 2:end), 1); %Find how many nonzero elements
       c0 = repmat(size(p, 1) - s, [1, 1, k]); %Count number of zeros

       er = exp(-i * r); %Complex exponential
       d(j, :, 1:k) = sum(er, 1) - c0; %Sum along columns and remove sum of zeros

       q = q + c(j); %Update counter for position
   end
end

%% Calculate Frequency resolution
F = S * lambda / T;
