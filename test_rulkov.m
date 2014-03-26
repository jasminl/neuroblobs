%This script is to test the Rulkov model

%% Setup
clear;

T = 1000;
n = 1;
x = -ones(n, T);
y = -3;

%% Parameters
mu    = 0.001;
beta  = 0.1;
sigma = 0.01;
alpha = 4;

%% Simulate constant external input

for t=1:T-1
    [x(:,t+1), y(:,t+1)] = rulkov(x(:,t), y(:,t), mu, beta, sigma, alpha);
end

%% Plot
f = figure;
subplot(2,1,1);
plot(1:T, x, 'b', 'linewidth', 2);
ylabel('Fast dynamics');

subplot(2,1,2);
plot(1:T, y, 'b', 'linewidth', 2);
ylabel('Slow dynamics');
xlabel('Time step');