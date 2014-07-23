%This script demonstrates the WKL rule. The WKL is described in:
%
% Fukushima, K. (2010). Neocognitron trained with winner-kill-loser rule. Neural Network, 
% 23, 926-938.

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
clear;
NbPts = 1000;
theta = 0.995;

%% Generate points 
x = 0.5 + 0.3 * randn(NbPts, 2);   %Non-uniform distribution

%% Show input distribution
figure;
sb1 = subplot(3,2,1);hold on; axis image;
xPlot = scatter(x(:,1),x(:,2),3,'b');
set(gca,'xlim',mean(x) + [-1.5 1.5],'ylim',mean(x) + [-1.5 1.5],'box','on');
title('Input distribution');

%% Pre-normalize inputs
xNorm = sqrt(diag(x*x'));
x = x./[xNorm xNorm];
xAngle = atan2(x(:,2),x(:,1));

%% WKL
w = rand(1,2);
change = zeros(NbPts, 1);
nbW = zeros(NbPts, 1);

for i = 1:NbPts
    wNorm = sqrt(diag(w*w')); %Compute w-norm

    s = w * x(i,:)' ./ wNorm; %Compute similarity s using pre-normalized x's
    
    [v, winner] = max(s); %Get winnner
    candidates = find(s > theta); %Get losers
    
    if ~isempty(candidates)
        losers = setdiff(candidates, winner(1)); %Compare to winner (always only the first one)
        w(winner,:) = w(winner,:) + x(i,:); %Learn winner node
        w(losers,:) = []; %Remove losers
        change(i) = length(losers); %Keep track of loser removals
    else
        w = [w ; x(i,:)]; %Add new node centered on current pattern
    end
    
    nbW(i) = size(w, 1); %Keep track of number of nodes
end

%% Plot results
wNorm = sqrt(diag(w*w')); %Compute w-norm
w = w ./[wNorm wNorm];
wAngle = atan2(w(:,2),w(:,1));

sb2 = subplot(3,2,2);hold on;axis image;
sPlot = scatter(x(:,1),x(:,2),3,'b');
set(gca,'xlim',[-1.2 1.2],'ylim',[-1.2 1.2],'box','on');

areaRadius = acos(theta);
for i = 1 : size(w,1)
    wPlot(i) = rectangle('position', ...
               [w(i,1)-areaRadius,w(i,2)-areaRadius,2*areaRadius,2*areaRadius], ...
               'curvature',[1 1]);
end
title('Space covering');

sb3 = subplot(3,2,3:4);hold on;
binEdge = linspace(-pi,pi,20);
xBinFreq = histc(xAngle,binEdge);
bar(binEdge,xBinFreq);
set(gca,'ylim',[0 max(xBinFreq)+10],'box','on');
title('Input angular distribution');

sb4 = subplot(3,2,5:6);hold on;
wBinFreq = histc(wAngle,binEdge);
bar(binEdge,wBinFreq);
set(gca,'xlim',get(sb3,'xlim'),'ylim',[0 max(wBinFreq)+1],'box','on');
title('Weight distribution');
xlabel('Angle');
ylabel('Counts');

figure;subplot(2,1,1);
plot(cumsum(change));title('Loser removals');
subplot(2,1,2);
plot(nbW); title('Basis set size');
xlabel('Time');
ylabel('Number of units');
