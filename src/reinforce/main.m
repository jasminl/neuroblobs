% This is the main script to demonstrate reinforcement learning following the paradigm
% of Montague, P. R., Dayan, P., Person, C. and Sejnowski, T. J. (1995). Bee
% foraging in uncertain environments using predictive Hebbian learning. Nature,
% 377, 725-728.
 
clear;

%% Parameters
sideSize   = 100;        %Length of side of box (always square)
nbgood     = 2;          %Nb of prays
nbbad      = 2;          %Nb of traps
sourceSize = 5;          %Diameter of source elements
distfct    = 'gaussian'; %The type of odour distribution
distsize   = 51;         %The diameter of the odor distribution
distsigma  = 7.2;        %The sigma parameter for gaussian distribution
stepinc    = 2;          %The distance walked in a single step
stepbounds = 180;        %The angle bound for changing direction
nbit       = 400;        %The number of iterations
nbtrials   = 300;        %The number of trials of execution
NNInitW    = 1.0;        %The initial value for the weights
vG         = 4;          %The value of hitting a prey
vB         = 0;          %The value of hitting a trap
m          = 12;         %Slope for the decision to turn function
b          = 0.58;       %Intercept for the decision to turn function
lambda     = 0.1;        %The learning rate
mindistance= 40;         %The minimum distance betwee sources
framerate  = 100;        %How many frames to run per second

%% Create 2D lattice world
 
[gdloc, bdloc]   = makeloc(sideSize, nbgood, nbbad, mindistance);

gdarea = conv2(gdloc, ones(sourceSize), 'same');
bdarea = conv2(bdloc, ones(sourceSize), 'same');

%% Createes value signals 
map = fspecial(distfct, distsize, distsigma);
gdodorloc = odour(sideSize, gdloc, map);
bdodorloc = odour(sideSize, bdloc, map);

%% Draw the lattice
h = figure(1); clf; hold on; 
 
%% Create individual
change = 1;                    %Indicates whether direction must be changed
w = repmat(NNInitW, 2, 1);     %Neural network weights;

%Random positions
tee = repmat(randperm(sideSize)', ceil(nbtrials/sideSize), 1);
tee2 = repmat(randperm(sideSize)', ceil(nbtrials/sideSize), 1);
ee = [tee tee2]; 
ee(nbtrials + 1:end, :) = [];

initialposition(1) = ee(1,1);
initialposition(2) = ee(1,2);

%% Iterate over multiple steps
tw(1,:) = w;
for j = 1:nbtrials
    position = ee(j,:);
    direction  = round(rand(1) * 360);
    cumulP = [position direction]; %Keeps track of the displacement
   
    clear v;
    
    %Initialize V
    v(1) = w(1) * gdodorloc(position(1), position(2)) + w(2) * bdodorloc(position(1), position(2));
       
    for i = 1:nbit
        %Update position
        [position, direction] = step(position, direction, stepinc, stepbounds, sideSize, change);
        cumulP(end+1,:) = [position direction];
        draw(gdloc, bdloc, sourceSize, h, position, direction, cumulP);
        pause(1/framerate);
        
        %Calculate turning probability
        v(i + 1) = w(1) * gdodorloc(position(1), position(2)) + w(2) * bdodorloc(position(1), position(2));
        n = isOnTarget(gdarea, bdarea, position, sideSize);

        if n
            disp(['On Target ',num2str(n)]);
            tn(j) = n;
            switch n
                case 1,
                    r = vG;
                case 2,
                    r = vB;
            end
        else
            r = 0;
        end

        dt = delta(r, v);
        if 1 / (1 + exp(dt * m + b)) >= rand(1)
            change = 0;
        else
            change = 1;
        end
               
        %Learning
        if n
            disp(['delta ', num2str(dt)]);
            t = [gdodorloc(position(1), position(2)) bdodorloc(position(1), position(2))]';
           
            w = learn(w, v, t, r, lambda);
            disp(['Weights ', num2str(w')]);
            break;
        end
        tw(j + 1, :) = w;
    end
end

%% Display results of training
figure; subplot(1, 2, 1); hold on;
limit = 20;

mq1 = length(find(tn(1:limit) == 1));
mq2 = length(find(tn(1:limit) == 2));

mq3 = length(find(tn(end-limit+1:end) == 1));
mq4 = length(find(tn(end-limit+1:end) == 2));

center = round(length(tn)/2);
mq5 = length(find(tn(center-limit:center+limit)== 1));
mq6 = length(find(tn(center-limit:center+limit)== 2));

h1 = bar([mq1/mq2 ; mq5/mq6 ; mq3/mq4]);
h2 = get(h1,'Parent');
set(h2,'FontSize',20);
set(h2,'XTick',[1 2 3]);
set(h2,'XTickLabel',['initial'; 'during ';' final ']);
h3 = xlabel('Epoch');
set(h3,'FontSize',24);
h4 = ylabel('Good/Bad flower visits ratio');
set(h4,'FontSize',24);

hold off;
subplot(1,2,2);hold on;

%These three lines remove spurious zeros
pp = find(tw==0);   
tw(pp)= tw(pp-1);
h5 = plot(tw);
set(h5,'LineWidth',2);
h6 = get(h5(1),'Parent');
set(h6,'FontSize',20);
h7 = xlabel('Timestep');
set(h7,'FontSize',24);
h8 = xlabel('Weight strength');
set(h8,'FontSize',24);

legend('Good flower','bad flower');
