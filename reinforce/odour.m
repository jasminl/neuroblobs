function lc = odour(sideSize, loc, map)
%ODOUR distributes sensory input on the 2D lattice.
%   LC = ODOUR(SIZE, LOC, MAP) distributes sensory input on a 2D lattice of size
%   SIZE * SIZE at locations LOC with spatial decay specified in MAP.  

[q1,q2] = find(loc);
[h,w] = size(loc);
lc = zeros(2 * h, 2 * w);
lc(h/2+1:h/2+h,w/2+1:w/2+w) = loc;   %Makes it big so we don't care about truncature

[fh,fw] = size(map);

if fh/2 == 0
    warning('Kernel size is not odd: truncating...');
    map(:,1) = [];
    map(1,:) = [];
    fh = fh - 1;
    fw = fw - 1;
end

voffset = floor(fh/2);
hoffset = floor(fw/2);

[q1,q2] = find(lc);

lc = zeros(size(lc));
for i = 1:length(q1)
    for j = 1:fh
       lc(q1(i) - voffset + j-1,q2(i) - hoffset:q2(i) + hoffset) = ...
       lc(q1(i) - voffset + j-1,q2(i) - hoffset:q2(i) + hoffset) ...
       + map(j,:);
    end
end
 
lc = lc(h/2+1:h/2+h,w/2+1:w/2+w);   %Keep only cropped values

% Weight odours to 1
fact = 1/max(max(lc));
lc = 1.0*lc*fact;
