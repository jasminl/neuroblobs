function [r, rm] = coh(f)
%COH Calculates the coherency function and associated magnitude.
%   [R, RM] = COH(f) calculates the coherency functions and their
%   magnitude. f is a structure array returned by XSPECTRUM.
%   Coherency functions are stored in R as a 3-dimensional upper triandular matrix such that 
%   row and columns index the process and the depth indexes frequencies.
%   The associated magnitudes are similarly stored in RM.
%
%   See also: ppf, XSPECTRUM

%% 0. Setup

m = length(f);

nbe = f(end).pair(1);   %Indicates how many records there are

q = nchoosek(1:nbe,2);    %Returns all pairs of records
qL = size(q,1);

d = ones(nbe,nbe,length(f(end).xs));    %Assures there is no division by 0 at step 4

%% 1. Pre-calculate denominator

v = f(end-nbe+1:end);

for i=1:qL
    %Cross
    d(q(i,1),q(i,2),:) = sqrt(v(q(i,1)).xs .* v(q(i,2)).xs);
end

for i=1:nbe
    %Auto
    d(i,i,:) = sqrt(v(i).xs .* v(i).xs);
end

%% 2. Re-arrange numerator

for i=1:m
   n(f(i).pair(1),f(i).pair(2),:) = f(i).xs;
end

%% 3. Coherency functions

r = n ./ d;

%% 4. Magnitude of coherency functions (square)

rm = r.* conj(r);
