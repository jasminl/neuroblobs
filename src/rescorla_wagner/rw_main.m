% This script implements various demonstrations of learning with the 
% Rescorla-Wagner model, including simple acquisition, extinction, blocking,
% conditioned inhibition and overshadowing. See below for descriptions for 
% the respective experiments.

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

%% 1. Acquisition of a single CS-US association
% A single stimulus is paired with the unconditional stimulus for a number 
% of iterations. Thus, there is no competition in this paradigm. The Rescorla-
% Wagner model predicts that the association strength of the unconditional 
% stimulus will increase until it reaches the maximum possible value λ

maxt = 100; %Maximum number of iterations
alphaa = 1; %Salience of stimulus A
betaa = 0.1;%Learning rate (for stimulus A)
va=0;       %Association strength for stimulus A
lambda = 1; %Maximum association strength for the US

%Simulation
for i = 1:maxt
    va(end+1) = rw(alphaa, betaa, lambda, va(end), va(end));
end

%Display results
figure; hold on;
h = plot(va);
set(h, 'LineWidth', 1);
h = xlabel('Timestep');
set(h, 'FontSize', 24);
h = ylabel('Association Strength');
set(h, 'FontSize', 24);
h = title('Simple acquisition');
set(h, 'FontSize', 26);

%% 2. Extinction
% A conditional stimulus with initial high association strength to an
% unconditional stimulus is presented for several iterations without the
% unconditional stimulus. The Rescorla-Wagner model predicts that the
% previously high association value will decrease to zero.

va(1)= va(end); %Set initial association strength to final value
va(2:end) = [];
lambda = 0;
 
%Simulation
for i = 1:maxt
     va(end+1) = rw(alphaa, betaa, lambda, va(end), va(end));
end

%Display results
figure;hold on;
h = plot(va);
set(h, 'LineWidth', 1);
h = xlabel('Timestep');
set(h, 'FontSize', 24);
h = ylabel('Association Strength');
set(h, 'FontSize', 24);
h = title('Extinction');
set(h, 'FontSize', 26);

%% 3. Blocking
% This experiment concerns blocking of the development of an association
% between a conditional stimulus and an unconditional stimulus by another 
% conditional stimulus. Here, an initial high association value is developed 
% via simple acquisition for one conditional stimulus without presentation
% of the other one. Then the second conditional stimulus is presented for several
% iterations together with the formerly associated conditioned stimulus and 
% the unconditional stimulus. The model predicts that the association strength 
% for the second stimulus will remain low due to competition.

vx = 0;      %Association strength of stimulus X
betax = 0.1; %Learning rate (for stimulus X)
alphax = 1;  %Salience of stimulus X
lambda = 1;  

va = 0;
maxt1 = 30; %Duration of initial period
maxt2 = 50; %Duration of second period

%Simulation
%a) Only stimulus A is paired to the US
for i = 1:maxt1
    va(end+1) = rw(alphaa, betaa, lambda, va(end), va(end));
    vx(end+1) = 0;
end

%b) Stimuli A and X are paired with the US
for i = 1:maxt2
    va(end+1) = rw(alphaa, betaa, lambda, va(end), va(end) + vx(end));
    vx(end+1) = rw(alphax, betax, lambda, vx(end), va(end) + vx(end));
end

%Display results
figure;hold on;
h = plot(1 : maxt1 + maxt2 + 1, va, 1 : maxt1 + maxt2 + 1, vx, 'r');
set(h, 'LineWidth', 1);
h = line([maxt1 + 1 maxt1 + 1], [0 max(va)]);
set(h, 'LineStyle', ':', 'Color', 'k');
h = legend('Stimulus A', 'Stimulus X');
set(h, 'FontSize', 24);
h = xlabel('Timestep');
set(h, 'FontSize', 24);
h = ylabel('Association Strength');
set(h, 'FontSize', 24);
h = title('Blocking');
set(h, 'FontSize', 26);

%% 4. Conditioned Inhibition
% In this protocol, an initial high association value is developed via simple
% acquisition for one conditional stimulus without presentation of the other one. 
% Then a second conditional stimulus is introduced and the unconditional stimulus
% removed for a number of additional iterations. The model predicts that the second
% stimulus will develop a negative association strength with the unconditional stimulus.
% That is, the second stimulus will inhibit the conditional response.

va = 0;
vx = 0;
maxt1 = 30;
maxt2 = 50;

%Initial period
for i = 1:maxt1
    va(end+1) = rw(alphaa, betaa, lambda, va(end), va(end));
    vx(end+1) = 0;
end

%Second period where the US is removed
lambda = 0; %Reset lambda to 0
for i = 1:maxt2
    va(end+1) = rw(alphaa, betaa, lambda, va(end), va(end) + vx(end));
    vx(end+1) = rw(alphax, betax, lambda, vx(end), va(end) + vx(end));
end

%Display results
figure; hold on;
h = plot(1 : maxt1 + maxt2 + 1, va, 1 : maxt1 + maxt2 + 1, vx, 'r');
set(h, 'LineWidth', 1);
h = line([maxt1 + 1 maxt1 + 1], [0 max(va)]);
set(h, 'LineStyle', ':', 'Color', 'k');
h = legend('Stimulus A', 'Stimulus X');
set(h, 'FontSize', 24);
h = xlabel('Timestep');
set(h, 'FontSize', 24);
h = ylabel('Association Strength');
set(h, 'FontSize', 24);
h = title('Conditioned Inhibition');
set(h, 'FontSize', 26);

%% 5. Overshadowing
% This experiment implements overshadowing of a conditional stimulus by
% another one. In this experiment, both conditional stimuli are paired with
% the unconditional one for several iterations. However, one of the stimuli has
% a much higher saliency value than the other one. The Rescorla-Wagner model 
% predicts in this case that the association value for the highly salient 
% stimulus will increase more than that of the less salient stimulus.

alphaa = 1;
betaa = 0.1;
va = 0;
lambda = 1;

alphax = 0.1; %The salience of stimulus X is much smaller than that of stimulus A
betax  = 0.1;
vx     = 0;

%Simulate both stimuli paired with the US
for i = 1:maxt
    va(end+1) = rw(alphaa, betaa, lambda, va(end), va(end) + vx(end));
    vx(end+1) = rw(alphax, betax, lambda, vx(end), va(end) + vx(end));
end

%Display results
figure;hold on;
h = plot(1 : maxt + 1, va, 1 : maxt + 1, vx, 'r');
set(h, 'LineWidth', 1);
h = legend('Stimulus A', 'Stimulus X');
set(h, 'FontSize', 24);
h = xlabel('Timestep');
set(h, 'FontSize', 24);
h = ylabel('Association Strength');
set(h, 'FontSize', 24);
h = title('Overshadowing');
set(h, 'FontSize', 26);
