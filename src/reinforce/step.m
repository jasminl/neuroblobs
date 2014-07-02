function [nextPos, nextDir] = step(position, direction, increment, anglemax, sideSize, change)
%STEP makes the agent perform on iteration of updates.
%   [NEXTPOS, NEXTDIR] = STEP(POSITION, DIRECTION, INCREMENT, ANGLEMAX, SIZE, CHANGE) updates
%   the agent's POSITION and DIRECTION given a displacement specified by INCREMENT, a maximum
%   turning angle of ANGLEMAX, and whether or not directional change is allowed (CHANGE = 1 if 
%   direction change is allowed, otherwise CHANGE = 0). The resulting POSITION and DIRECTION are
%   are cropped to the 2D lattice dimensions, specified by SIZE, and then returned by this function.

oldpos = position;

if change == 0
   %Go same direction 
   range = [-anglemax:1:anglemax];
   %direction = direction + range(round(rand(1)*length(range)));
   o = randperm(length(range));
   direction = direction + range(o(1));
else
   %Go different direction
   position(1) = position(1) + round(cosd(direction) * increment);
   position(2) = position(2) + round(sind(direction) * increment);

   if position(1) > sideSize
       position = oldpos;
       direction = 180;
   elseif position(1) < 1
       position = oldpos;
       direction = 0;
   elseif position(2) > sideSize
       position = oldpos;
       direction = 270;
   elseif position(2) < 1
       position = oldpos;
       direction = 90;       
   end
end

nextPos = position;
nextDir = direction;
