function [xNew, y] = rulkov(x, y, mu, beta, sigma, alpha)
%RULKOV Implements one iteration of the map-based spiking neuron of Rulkov. 
%See Rulkov, N.F. (2002). Physical Review E, 65, 041922.
%   [XNew, XNew] = rulkov(X, Y, MU, BETA, SIGMA, ALPHA) computes one
%   iteration of the map, where X and Y are vectors representing the values 
%   of the fast and slow variables, and the remaining parameters (MU, BETA,
%   SIGMA and ALPHA) are scalars representing the rate of the slow
%   variable, external inputs (for BETA and SIGMA) and a control parameter
%   of the map.

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


xNew = f(x, y+beta, alpha);
y = y - mu*(x+1) + mu*sigma;

%% Auxiliary function (Eq.2)
function z = f(x, y, alpha)

z = x;

p = find(x <= 0);
if ~isempty(p)
    z(p) = alpha./(1 - x(p)) + y(p);
end

q1 = find(0 < x);
q2 = find(x < alpha + y);
q = intersect(q1, q2);

if ~isempty(q) 
    z(q) = alpha + y(q);
    disp(['b ', num2str(x),' vs ', num2str(alpha + y)]);
end

u = unique([p; q]);
k = setdiff(1:length(x), u);
z(k) = -1;
