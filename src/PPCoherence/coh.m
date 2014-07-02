function [r, rm] = coh(f)
%COH Calculates the coherency function and associated magnitude.
%   [R, RM] = coh(F) calculates the coherency functions and their 
%   magnitude. F is a structure array returned by XSPECTRUM. Coherency 
%   functions are stored in R as a 3-dimensional upper triangular matrix
%   such that row and columns index the process and the depth indexes 
%   frequencies. The associated magnitudes are similarly stored in RM. 
%   For details on the coherency measure, see "Rosenberg, J.R., Amjad, A.M.,
%   Breeze, P., Brillinger, D.R., & Halliday, D.M. (1989). The Fourier 
%   approach to the identification of functional coupling between neuronal 
%   spike trains. Progress in Biophysics and Molecular Biology, 53, 1-31.".
%
%   See also: ppf, pp_coh_test, dc, xSpectrum

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
m = length(f);

nbe = f(end).pair(1);   %Indicates how many records there are

q = nchoosek(1:nbe,2);    %Returns all pairs of records
qL = size(q,1);

d = ones(nbe,nbe,length(f(end).xs));    %Assures there is no division by 0 at step 4

%% Pre-calculate denominator
v = f(end-nbe+1:end);

for i=1:qL
    %Cross
    d(q(i,1),q(i,2),:) = sqrt(v(q(i,1)).xs .* v(q(i,2)).xs);
end

for i=1:nbe
    %Auto
    d(i,i,:) = sqrt(v(i).xs .* v(i).xs);
end

%% Re-arrange numerator
for i=1:m
   n(f(i).pair(1),f(i).pair(2),:) = f(i).xs;
end

%% Coherency functions
r = n ./ d;

%% Magnitude of coherency functions (square)
rm = r.* conj(r);
