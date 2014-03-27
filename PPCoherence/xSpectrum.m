function f = xSpectrum(d,T)
%XSPECTRUM calculates the cross-spectrum for a set of processes.
%   F = XSPECTRUM(D,L,T) takes as input a 3-dimensional matrix D
%   representing Fourier coefficients for different time-periods (organized along the
%   first dimension (vertical)), processes (along the 2nd dimension (horizontal)) and
%   frequencies (along the third dimension (depth)). T represents the
%   real-time duration of each period. Note that the total duration of each
%   process should be L*T. D is assumed to be obatined from PPF. Results
%   are stored as a structure array where each structure contains the
%   coefficient for a particular pair for all frequencies.
%
%   See also: ppf, coh

%% 0. Setup
[m,n,p] = size(d);
L = m;

%% 2. Cross-correlation (all frequencies simultaneously)

if n>=2
    %Requires at least 2 time-series
    
    q = nchoosek(1:n,2);    %Returns all pairs of records
    qL = size(q,1);
    

    for i=1:qL

        t1 = reshape(d(:,q(i,1),:),[m,p,1]);
        t2 = reshape(d(:,q(i,2),:),[m,p,1]);

        f(i).pair = q(i,:);
        f(i).xs   = 1 / (2*pi*L*T) * diag(t1' * t2); %The complex product, keeping only same freqs
    end
else
    %signifies there is a single time-series
    qL = 0;
end

%% 3. Auto-correlation (all frequencies simultaneously)
for i=1:n
    t1 = reshape(d(:,i,:),[m,p,1]);;
    t2 = t1;

    f(qL+i).pair = [i i];
    f(qL+i).xs   = 1 / (2*pi*L*T) * diag(t1' * t2);
end

