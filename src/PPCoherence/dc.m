function [g, s] = dc(cm, L, frequencies, labels)
%DC plots the point-process coherence for a group of processes.
%   [G, S] = DC(CM, L, FREQUENCIES, LABEL) creates a figure with sublots
%   for each pair of time-series. CM is an upper triangular matrix that
%   contains the pairwise coherency coefficients. L is the number of 
%   intervals used to compute the coefficients. FREQUENCIES is a vector
%   that contains the frequencies for the corresponding CM coefficients. 
%   LABELS is a cell array of labels, one for each time-series. Returns
%   the figure handle G and subplot handles S.
%
%   see ppf, coh, pp_coh_test, xSpectrum

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

[m, n, d] = size(cm);
g = figure; hold on;

if length(frequencies) ~= d
    error('Number of frequency labels wrong');
elseif length(labels) ~= n
    error('Number of unit labels wrong');
end

xMin = frequencies(1);
xMax = frequencies(end); %Add an offset if need to see boundary values clearly
yMin = 0;
yMax = 1;

yL = 1 - 0.05^(1/(L-1));    %Height of the significance line

k = 1;  %Index for subplot

%% Plot as triangular array
for i=1:m-1
    for j=i+1:n
        x = reshape(cm(i,j,:),[1,d,1]); %Remove 3rd axis
        
        cp = (i-1)*(n-1) + (j-1);   %Current subplot position
        s(k) = subplot(m-1,n-1,cp); hold on;
        p(k) = plot(frequencies, x);
        stem(frequencies,x);
        
        li(k) = line([xMin xMax],[yL yL]);   %Display significance line
        
        if i==1
            title([labels{j}],'fontsize',20);
        end

        if j==n
            ylabel([labels{i}],'fontsize',20);
        end
        k = k + 1;
    end
end

set(li,'linestyle',':','linewidth',3,'color','k');
set(s,'xlim',[xMin xMax],'ylim',[yMin yMax],'yaxislocation','right');
