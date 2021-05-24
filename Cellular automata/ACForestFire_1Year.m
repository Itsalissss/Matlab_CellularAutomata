% ACForestFire_1Year.m - A cellular automaton to model forest fires.
%
% Required functions : BurningNeighbors.m, FireProgression.m
%
% Original version: Sonia Kefi
% 2014 revision: Patrick Bogaart
% (c) Utrecht University

%% 1. Setup

clear all;

% Define model parameters
m  = 100;  % Size of the CA: total number of cells = m*m
pv = 0.5;  % Initial proportion of vegetated cells.
f0 = 0.5;  % Parameter for flammability model
c  = 0.01; % idem
n  = 5;    % Number of lightning strikes per year

% Define an appropriate color map for visualisation
white      = [1 1 1];     % State 1: Empty
lightgreen = [0.5 1 0.5]; % State 2: Young vegetation
green      = [0 0.8 0];   % State 3: Mature vegetation
darkgreen  = [0 0.5 0.5]; % State 4: Old vegetation
red        = [1 0 0];     % State 5: Fire
mycolors   = [white; lightgreen; green; darkgreen; red];

% Loop to calculate probability for 50 repetitions
TotSim = 50;

% Loop over different f0  
f0 = linspace(0,0.45,20);
for Loopf = 1:20  
   
% Loop over different n
% n = linspace(1,20,20);  
% for Loopn = 1:20
    
    Firestarted = zeros(1,TotSim);
    BurnedArea = zeros(1,TotSim);

    for r = 1:TotSim


        %% 2. Create state matrix

        M = zeros(m,m);

        % The first and last rows and columns are empty (1)
        M(:,1) = 1;
        M(1,:) = 1;
        M(:,m) = 1;
        M(m,:) = 1;


        % Otther cells are (randomly) empty, or occupied by young vegetation
        R = rand(m,m);
        for i=2:m-1
            for j = 2:m-1
                if R(i,j) < pv
                    M(i,j) = 2 ; % Young vegetation
                else
                    M(i,j) = 1 ; % Empty
                end
            end
        end

        % Count number of vegetated cells
        Vegetation = sum(sum(M==2 | M==3 | M==4));


        %% 3. Initial lightning strikes
        for k = 1 : n  %for loop for the f0 loop
%         for k = 1 : n %for loop for the n loop
            % Randomly select a grid cell (but exclude the first/last rows and
            % columns)
            i = randi(m-2)+1; % random row in range 2..nrow-1
            j = randi(m-2)+1; % Random column in range 2..ncol-1

            % If there is vegetation on that cell, compute flammability and test
            % if it is unlucky enough to catch fire.
            if M(i,j) == 2 || M(i,j) == 3 || M(i,j) == 4
                f = f0(Loopf) + c*exp(M(i,j)); %for the f0 loop    % Probability of burning of the cell
                f = f0 + c*exp(M(i,j)); %for the n loop
                if rand < f % compare random number with flamability
                    M(i,j) = 5 ; % Unlucky, the cells starts to burns
                end
            end
        end

        % Count number of initially burning cells
        BurningIni = sum(sum(M==5));

        if(BurningIni>0) 
        Firestarted(r) = 1;
        end

        %% 4. Visualisation of initial state (inc. lighning)

        % figure(1); clf;
        % colormap(mycolors);
        % 
        % image(M);
        % axis equal; axis tight; axis off; % Tight & square
        % title('Just before fire propagation')
        % drawnow;

        %% 5. Fire propagation

    %         figure(2); clf;
    %         colormap(mycolors);

        % Matrix V keeps track of the number of burning neigbours of each grid cell.
        V = BurningNeighbors(M);

        % Compute the spreading of fires from the lighning strike sites.
        % The propagation goes step by step. We keep on trying to expand the
        % fires, until it stopped growing.
        %
        % Catching fire is a stochastic process. We draw random numbers ONCE to
        % guarantee that individual grid cells have a fixed chance of getting
        % burned.
        R = rand(m,m);

        FireGrowing = BurningIni>0; % We went from 0 to >0 fires...
        while FireGrowing

            % Then try to expand the current fire
            [M,V,NewBurned] = FireProgressionSync(M,V,R, f0,c); % spread fire

            % Draw map of updated states
        %     image(M);
        %     axis equal; axis tight; axis off; % Tight & square
        %     title('After fire propagation')
        %     drawnow;

            % Do we need to go for another round of fire expansion?
            FireGrowing = NewBurned > 0;


        end
         Burning = sum(sum(M==5));

         BurnedArea(r) = Burning;
        %% 6. Vegetation growth

        for i = 2 : m-1
            for j = 2 : m-1
                if     M(i,j)==1, M(i,j)=2; % Empty -> Young
                elseif M(i,j)==2, M(i,j)=3; % Young -> Mature
                elseif M(i,j)==3, M(i,j)=4; % Mature -> Old
                elseif M(i,j)==5, M(i,j)=1; % Burning -> Empty
                end
            end
        end
        Vegetation = sum(sum(M==2 | M==3 | M==4)); % Count

        % figure(3); clf;
        % colormap(mycolors);
        % 
        % image(M);
        % axis equal; axis tight; axis off; % Tight & square
        % title('Vegetation after growth')
        % drawnow;



    end
SimWithFire = sum(Firestarted);
FinalBurnedArea = sum(BurnedArea);

ProbaF(Loopf) = SimWithFire/TotSim;
AvSizeF(Loopf) = FinalBurnedArea/SimWithFire;

% ProbaF(Loopn) = SimWithFire/TotSim;
% AvSizeF(Loopn) = FinalBurnedArea/SimWithFire;
end

figure(1);
plot(f0, ProbaF);
xlabel('Flammability f0');
ylabel('Probability of fire');
title('Probability of fire as a function of flammability with n=5');

% figure(1);
% plot(n, ProbaF);
% xlabel('Number of lightning strikes');
% ylabel('Probability of fire');
% title('Probability of fire as a function of the yearly number of strikes with f0=0.5');

%% 7. End of program

 
