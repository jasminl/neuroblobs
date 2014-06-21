function handle = draw(gdloc, bdloc, sourceSize, handle, agent, direction, cumulP)
%DRAW displays the 2D lattice, the agent's position and trajectory, and the reinforcers.
%   HANDLE = DRAW(GD, BD, GDOD, BDOD, SIZE, HANDLE, AGENT, DIR, CUMUL) takes the figure axis defined 
%   in HANDLE, overlays the positive- and negative-valued reinforcers at locations GD and BD, and the 
%   learning agent at location AGENT, with head oriented in direction DIR. All entities are drawn with
%   circles of radius SIZE. The trajectory of the agent up to this point is also drawn using the time-
%   series coordinates in CUMUL. The function returns the handle to the current axis.

clf; hold on;

set(get(handle,'CurrentAxes'), 'XLim', [1 length(gdloc)]);
set(get(handle,'CurrentAxes'), 'yLim', [1 length(gdloc)]);

[q1, q2] = find(gdloc);
for i = 1:length(q1)
   g = rectangle('Position', [q1(i) - sourceSize/2 q2(i) - sourceSize/2, sourceSize, sourceSize], 'Curvature', [1,1]);
   set(g, 'FaceColor', [0 1 0], 'linestyle', 'none');
end

[q1,q2] = find(bdloc);
for i=1:length(q1)
    g =rectangle('Position',[q1(i)-sourceSize/2 q2(i)-sourceSize/2, sourceSize,sourceSize],'Curvature',[1,1]);
    set(g, 'FaceColor', [1 0 0], 'linestyle', 'none');
end

%% Draw the agent
g = rectangle('Position', [agent(1) - sourceSize/2 agent(2) - sourceSize/2, sourceSize, sourceSize], 'Curvature', [1,1]); 
set(g, 'FaceColor', [0 0 0], 'LineWidth', 2.0);

%% Draw the nose
g = rectangle('Position', [cosd(direction) * sourceSize/2 + agent(1) - sourceSize/4 sind(direction) * sourceSize/2 - sourceSize/4 + ...
 agent(2), sourceSize/2, sourceSize/2], 'Curvature',[1,1]); 
set(g,'FaceColor', [0 0 0], 'LineWidth', 2.0);

%% Draw the path
plot(cumulP(:,1), cumulP(:,2), 'LineWidth', 2);

axis off
axis image
