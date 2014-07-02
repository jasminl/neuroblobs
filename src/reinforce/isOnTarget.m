function out = isOnTarget(gdt, bdt, position, sideSize)
%ISONTARGET indicates whether the agent collides with an entity or not.
%   OUT = ISONTARGET(GDT, BDT, POSITION, SIZE) examines the locations of the positive-
%   and negative-valued reinforcers (GDT and BDT), the position POSITION of the agent,
%   scaled by the size of the square 2D lattice (where each side's size is indicated by
%   SIZE), and determines whether the agent collides with an entity. The function respectively
%   returns 0, 1 or 2, if no collision, a collision with a positive, or a collision with a 
%   negative is detected.

linP = sideSize * position(2) + position(1);

q1 = find(gdt);
q2 = find(bdt);

if find(linP == q1)
    out = 1;
elseif find(linP == q2)
    out = 2;
else
    out = 0;
end
