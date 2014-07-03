%% Shows point-process coherence in a sample of trade files

%% Setup

addpath('../PPCoherence');
sep = [':', '/', ','];

sampling_rate = 1000;
lambda = 1:50000:500000;
L = 10;

%% Load data
cd '../../share/SampleEquityData_US/Trades/';
CPRN_40218 = dlmread('CPRN_40218.asc', sep);
GLP_27667  = dlmread('GLP_27667.asc', sep);
ITT_14081  = dlmread('ITT_14081.asc', sep);
NTLS_28082 = dlmread('NTLS_28082.asc', sep);
CWSA_40752 = dlmread('CWSA_40752.asc', sep);  
IEF_23870  = dlmread('IEF_23870.asc', sep);  
ITUB_23444 = dlmread('ITUB_23444.asc', sep);
cd ../../../src/stocktrade

labels = {'CPRN','GLP','ITT','NTLS','CWSA','IEF','ITUB'};

%% Format data
a = format_time_series(CPRN_40218);
b = format_time_series(GLP_27667);
c = format_time_series(ITT_14081);
d = format_time_series(NTLS_28082);
e = format_time_series(CWSA_40752);
f = format_time_series(IEF_23870);
g = format_time_series(ITUB_23444);
time_series = {a, b, c, d, e, f, g};

%% Measure coherence

[d_cell, T, F] = ppft(time_series, lambda, L, sampling_rate);

csize = size(d_cell{1});
d = zeros(csize(1), numel(time_series), csize(3));
for idx = 1:numel(time_series)
	d(:, idx, :) = d_cell{idx};
end
%disp(['min/max frequency range ', num2str(F(1)), ' ', num2str(F(end)),' Hz']);

%% Cross-spectrum
f = xSpectrum(d, T);

%% Coherency
[c, cm] = coh(f);

%% Plot results
[fig_handle, sb] = dc(cm, L, F, labels);

save("stock_coherence_example.mat", "-V7");
