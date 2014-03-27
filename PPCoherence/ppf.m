function [d, T, F]= ppf(x,lambda,L,S)
%Fourier transform for point-process
%   E = PPF(X,LAMBDA,L) returns the Fourier transform for a number of
%   point processes stored as columns of matrix X, at frequencies specified
%   in vector LAMBDA, and by dividing the point processes in L intervals.
%   The length of each interval is length(X)/L. The output for each point
%   process and interval is returned columnwise and rowwise respectively.
%   Note the first column of X represents time. The sampling rate of the signal 
%   is assumed to be 1000Hz.

%% 0. Setup

[m,n] = size(x);
k = length(lambda);
tv = x(:,1);               %The first column always represents time
T = (x(end,1) - x(1,1))/L; %Duration of intervals, based on measurement time

w(1,1,1:k) = 2*pi*lambda/T;       %This is a convenient form to keep lambda

%% 1. Determine pulse times
v = x(:,2:end).*repmat(tv,1,n-1);

%% 2. Subdivide and calculate separately for L sequences

e = linspace(x(1,1),x(end,1),L+1);

c = histc(x(:,1),e);

%c(end-1) = c(end-1)+c(end); %Here eliminate last bin which is always 1
%c(end) =[];

q = 1;

d = zeros(L,n-1,k);
 
for j=1:L
    
   if c(j)==0
       %Nothing is in this bin       
       d(j,:,1:k) = zeros(1,n-1,k);
       continue;
   else
       %This bin contains some spikes at least for some processes
       p = v(q:q + c(j)-1,:);   %Temporary matrix
       
       [mp,np] = size(p);  %Dont take into account time column
       
       r = repmat(p,[1,1,k]).*repmat(w,[mp,np,1]);  %Exponent matrix

       %Remove contribution from zeros
       s  = sum(x(q:q + c(j)-1,2:end),1);  %Find how many nonzero elements
       c0 = repmat(size(p,1) - s,[1,1,k]);               %Count nb of zeros

       er = exp(-i * r);  %Complex exponential
       d(j,:,1:k) = sum(er,1) - c0;  %Sum along columns and remove sum of zeros

       q = q + c(j);  %Update counter for position
   end
   
end

%% 3. Calculate Frequency resolution
F = 1000*lambda/T;