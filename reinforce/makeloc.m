function [gd, bd] = makeloc(size, nbgd, nbbd, mindist)
%MAKELOC assigns elements to locations
%   [GD, BD] = MAKELOC(SIZE, NBGD, NBBD, MINDIST) allocates NBGD positive-valued and NBBD
%   negative-valued reinforcers on a square 2D lattice of size SIZE * SIZE, and at least 
%   MINDIST apart. Returns the generated locations for positive- and negative-valued 
%   reinforcers in GD and BD, respectively.
%
%   see CDPT

valid = [];
remain = nbgd + nbbd;

nbpos = 0;

valid = cdpt(nbgd + nbbd, size, mindist);
valid = valid(1,:) * size + valid(2,:);

%Permute order of new locations
order = rand(length(valid), 1);
[q1, q2] = sort(order);

valid(q2) = valid;

gdl = valid(1:nbgd);
bdl = valid(nbgd + 1:end);

gd = zeros(size * size, 1);
gd(gdl) = 1;

gd = reshape(gd, size, size);
bd = zeros(size * size, 1);
bd(bdl) = 1;
bd = reshape(bd, size, size);
