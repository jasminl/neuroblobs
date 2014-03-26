function [xNew, y] = rulkov(x, y, mu, beta, sigma, alpha)
%RULKOV Implements one iteration of the map-based spiking neuron of Rulkov. 
%See Rulkov, N.F. (2002). Physical Review E, 65, 041922.
%   [XNew, XNew] = rulkov(X, Y, MU, BETA, SIGMA, ALPHA) computes one
%   iteration of the map, where X and Y are vectors representing the values 
%   of the fast and slow variables, and the remaining parameters (MU, BETA,
%   SIGMA and ALPHA) are scalars representing the rate of the slow
%   variable, external inputs (for BETA and SIGMA) and a control parameter
%   of the map.

xNew = f(x, y+beta, alpha);
y = y - mu*(x+1) + mu*sigma;

%% Auxiliary function (Eq.2)
function z = f(x, y, alpha)

z = x;

p = find(x <= 0);
if ~isempty(p)
    z(p) = alpha./(1 - x(p)) + y(p);
end

q1 = find(0 < x);
q2 = find(x < alpha + y);
q = intersect(q1, q2);

if ~isempty(q) 
    z(q) = alpha + y(q);
    disp(['b ', num2str(x),' vs ', num2str(alpha + y)]);
end

u = unique([p; q]);
k = setdiff(1:length(x), u);
z(k) = -1;
