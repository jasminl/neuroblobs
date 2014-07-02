function f = xSpectrum(d, T)
%XSPECTRUM calculates the cross-spectrum for a set of processes.
%   F = XSPECTRUM(D, L, T) takes as input a 3-dimensional matrix D
%   representing Fourier coefficients for different time-periods (organized 
%   along the first dimension), processes (along the 2nd dimension) and
%   frequencies (along the third dimension). T represents the
%   sample number duration of each period. Note that the total duration of each
%   process should be L*T. D is assumed to be obtained from PPF. Results
%   are stored as a structure array where each structure contains the
%   coefficient for a particular pair for all frequencies. Details about the 
%   method can be found in "Rosenberg, J.R., Amjad, A.M.,
%   Breeze, P., Brillinger, D.R., & Halliday, D.M. (1989). The Fourier 
%   approach to the identification of functional coupling between neuronal 
%   spike trains. Progress in Biophysics and Molecular Biology, 53, 1-31.".
%
%   See also: ppf, coh, pp_coh_test, dc

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
[m, n, p] = size(d);
L = m;

%% Cross-correlation

if n >= 2
    %Requires at least 2 time-series
    q = nchoosek(1:n, 2); %Returns all pairs of records
    qL = size(q, 1);
    for i = 1:qL
        t1 = reshape(d(:, q(i,1), :), [m, p, 1]);
        t2 = reshape(d(:, q(i,2), :), [m, p, 1]);
        f(i).pair = q(i, :);
        f(i).xs   = 1 / (2 * pi * L * T) * diag(t1' * t2); %The complex product, keeping only same freqs
    end
else
    %signifies there is a single time-series
    qL = 0;
end

%% Auto-correlation
for i = 1:n
    t1 = reshape(d(:, i, :), [m, p, 1]);;
    t2 = t1;
    f(qL+i).pair = [i i];
    f(qL+i).xs   = 1 / (2 * pi * L * T) * diag(t1' * t2);
end
