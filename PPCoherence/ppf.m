function [d, T, F] = ppf(x, lambda, L, S)
%Fourier transform for point-process
%   [D, T, F] = PPF(X, LAMBDA, L, S) returns the Fourier transform for a number of
%   point processes (binary 0-1 time-series), stored as columns of matrix 
%   X (other than the first column, which contains the sampling times), at fundamental
%   frequencies specified in vector LAMBDA, and by dividing the point processes 
%   in L intervals. S represents the sampling rate. The length of each interval 
%   is length(X)/L. The output D for each point process and interval is returned
%   column-wise and row-wise respectively. T is the duration of each interval (in number
%   of sample points), and F is the actual frequencies for the corresponding coefficients.

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
