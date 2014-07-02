function out = delta(r, v)
%DELTA computes the output of the linear comparison unit
out = r + v(end) - v(end-1);
