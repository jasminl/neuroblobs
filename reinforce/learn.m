function weights = learn(w,v,xprev,r,lambda)
%LEARN computes predictive Hebbian weight updates.
%   W = LEARN(W, V, X, R, LAMBDA) returns the Hebbian-updated weights W given input X, previous
%   reward R, output V and learning rate LAMBDA. 

[m,n] = size(v);
%w = w + lambda * xprev.* ((v(end) - v(end-1))'+ r);
w = w + lambda * xprev.* ((0 - v(end-1))'+ r);
weights = w;
