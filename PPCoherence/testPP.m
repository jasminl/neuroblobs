%This script is used to test the pp functions
clear

addpath('/students/jasminl/mfiles/synchrony/AmjadEtAl_1997');
% %% Setup for random time-series (comment next section)
% t = [0.05:0.05:10000]';
% m = length(t);
% n = 7;
% x = rand(m,n)>0.8;
% x = [t x];

%% Setup to test Fourier transform
% 
% x = zeros(1000*100,1);
% x(10:50:1000*100) = 1;
% % 
% % x = x + rand(length(x),1)>0.9;  %Inject some noise
% % x(find(x)) = 1;
% 
% %Sampling
% t = 1:1:length(x);
% %t = t/1000;
% 
% x = [t' x];

%% Setup for structured time-series (comment previous section)
%t = [0.05:0.05:1000]';
%m = length(t);
%n = 3;

%A) Exactly same time-series (should give coefficients of 1): works great
%x = rand(m,1)>0.8;
%x = repmat(x,1,n);    
%x = [t x];

%B) A silent unit and an active unit: NaN (due to formula 2.5)
%x = [ones(m,1) zeros(m,1)];
%x = [t x];

%C) Anti-symmetric series: gives relatively high estimates
%x = rand(m,1)<=0.5;
%x = [t x 1-x];

%D) Slow anti-symmetric series: gives exactly 0 as expected (given bin
%size=100)
%x = 1:length(t)<=length(t)/2;
%x = [t x' 1-x'];

%E) Bipole output without noise: gives what is expected
%cd '/mnt/localhd/Data/Results/';
%x = load('Layer23Pyramidal axon.dat');
cd '/mnt/localhd/Data/Results/28/noisy/p22_23_24_25_26_27_28_29_30_50_r5_2500'
%cd '/mnt/localhd/Data/Results/28/noisy/p22_23_24_28_29_30_50_r5_2500'
%cd '/mnt/localhd/Data/Results/singerData/'
x = load('Layer23Pyramidal axon.dat');

pos = 24:30;
pos2 = [24 30];
posFar = [23:31];
pos1 = [24 27 30];

labels = {'23','24','25','26','27','28','29'};
labels2 = {'23','29'};
labelsFar = {'22','23','24','25','26','27','28','29','30'};
labels1 = {'23','26','29'};

curPos = pos;
curLabels = labels;

x = [x(:,1) x(:,curPos)];

%% Parameters

L = 50;
lambda = 1:100;

%% Execution

%1. Fourier
[d,T,F] = ppf(x,lambda,L);

%2. cross-spectrum
f =  xSpectrum(d,T);

%%2b. Plot spectrum
% figure;
% plot(F,f(1).xs);

%3. Coherency function
[c, cm] = coh(f);

%4. Plot results

yMax = 1;
[g sb]= dc(cm,L,F,curLabels,yMax,'n');

set(sb,'xlim',[0 80])
saveas(g,'SyncTest','png');

%% Difference of coherence

v = diffCoh(cm,L,lambda);

%% Generate average curve 

for i=lambda
  
    %For each frequency separately
    af(i) = sum(sum(triu(cm(:,:,i),1)))/nchoosek(length(curPos),2);
    
end

yL = 1 - 0.05^(1/(L-1));    %Height of the significance line

%Plot this average curve
fh = figure;hold on;
pa = plot(F,af,'linewidth',2);

li = line([lambda(1) lambda(end)],[yL yL]);   %Display significance line
        
set(gca,'xlim',[F(1) F(end)],'ylim',[0 1]);

saveas(fh,'averageF','png');
