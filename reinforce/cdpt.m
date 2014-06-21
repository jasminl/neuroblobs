function pt = cdpt(nb, side, mind)
%CDPT determines positions that satisfy a distance requirement.
%   PT = CDPT(NB, SIDE, MIND) randomly determines NB points on a 2D lattice of 
%   size SIZE * SIZE that are at least MIND distant. Returns a set of points that
%   satisfy this requirement.

remain = 0;

%Initial point
acc = floor(rand(2,1)*side);
%Remove bad 0 and put them at side instead
lo = find(acc == 0);
acc(lo) = side;
nb = nb -1;

while ~remain

    candidate = floor(rand(2,1) * side);
    
    %Remove bad 0 and put them at side instead
    lo = find(candidate == 0);
    candidate(lo) = side;

    ds = L2_distance(candidate,acc);
    
    n = find(ds <= mind);
    
    if isempty(n)
        acc = [acc candidate];
        nb = nb - 1;
        
        if nb == 0
            break;
        else
            continue;
        end
    end 
end

pt = acc;
