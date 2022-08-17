%% HA EDITED
%% (MARCH 1, 2019)
% added code to turn response-counterbalancing on/off
%% (JAN 8, 2019)
% changed to fit simplified task with only one rule X-->Y
% also changed to run and save trial subsets or load them when detected
% flexibly
%% (JAN 21, 2019)
% code generates blocks of trials with all possible state transitions, one
% block per color combination (order matters) and per key assignment
% this implies only ONE rule; buttons change assignment
%% (JAN 29, 2019)
% add variable for each trial indicating whether this is the start of a new
% key-mapping block (to display instructions for key switch)

function [trials] = GenerateTrialsSimple(is)

TR = [1 1 1 2 2;    % possible transitions for rule 1
      1 1 1 3 2;
      1 1 1 4 2;
      1 1 2 1 1;
      1 2 2 1 2;
      1 2 2 3 2;
      1 2 2 4 2;
      1 2 1 2 1;    
      ];
  
% n_trial_blocks = 24;  % 4 colors, select 2 per rule + order matters = 12 unique color assignments * 2 possible key assignments = 24

if ~exist('trigger_codes_simple.mat', 'file')
    %% HA edit: all permissible transitions according to the one rule in the new simple task
    %% list all distinct transitions
    % column 1: rule (always 1)
    % column 2: from state
    % column 3: to state
    % column 4: by animal
    % column 5: w/ output (button)
    % only generates from_state:to_state:by_animal combinations that are
    % permissible according to the one rule X->Y
    
    trigger_codes = nan(1, 2, 2, 4, 2);
    %% END OF HA EDITS
    
    for i=1:size(TR,1)
        trigger_codes(TR(i,1), TR(i,2), TR(i,3), TR(i,4), TR(i,5)) = i;
    end
    save('trigger_codes_simple', 'trigger_codes')
else
    load('trigger_codes_simple');
end

if ~exist('good_trials_simple.mat', 'file')
    %% HA EDITS: iterate through possible key assignments and color combinations
    if is.response_counterbalance
        n_keys = length(is.key_map);
    else
        n_keys = 1;
    end
    n_colors = 4;
    all_keys = 1:length(is.key_map);
    all_colors = 1:n_colors;
    
    trials = struct([]);
    
%     %% HA DEBUG
%     nBlocks = 0;
%     %% END OF HA DEBUG
    for transition_key = 1:n_keys    % select possible key to transition between states
        for color_x = 1:n_colors       % select possible color X
            for color_y = 1:n_colors      % select possible color y
                if color_x == color_y     % colors can't be the same
                    continue;
                else
                    % leftover colors                
                    other_colors = all_colors(~ismember(all_colors, [color_x, color_y]));
                    % leftover key
                    stay_key = all_keys(~ismember(all_keys, [transition_key]));
                end
                %% run genetic algorithm
                %% genetic algorithm to find a dense initial set of trials
                n_init_trials = 3;  % how many initial trials to have with guaranteed existence of each trial type?
                
                nTT = size(TR,1);  % number of unique transition types
                n_creatures = 50;
                creatures = cell(n_creatures,1); % each creature is a trials struct array
                fitness = zeros(n_creatures, 1);
                winning_creature = [];  

                %% randomly initialize the creatures
                for i_creature = 1:n_creatures
                    for i_trial = 1:n_init_trials % generate random trials
                        creatures{i_creature}(i_trial).rule = randi(is.n_rules);
                        creatures{i_creature}(i_trial).animal_identities = [color_x color_y other_colors(randperm(length(other_colors)))];
                        creatures{i_creature}(i_trial).len = randi([is.min_animals_per_trial is.max_animals_per_trial]);  % number of animals in this trial
                        creatures{i_creature}(i_trial).animal_sequence = randi(is.n_animals, [1 creatures{i_creature}(i_trial).len]);
                        %% HA EDIT; extra identifying information for this trial
                        creatures{i_creature}(i_trial).color_xy = [color_x color_y];
                        creatures{i_creature}(i_trial).transition_key = transition_key;
                        creatures{i_creature}(i_trial).stay_key = stay_key;
                    end
                end

                %% do the evolution loop
                done = false;

                while ~done
                    for i_creature = 1:n_creatures
                        transition_counts = zeros(nTT, 1); % histogram of how many times each transition exists in the trial sequence

                        for i_trial = 1:n_init_trials
                            %% run the FSM, track the transition types encountered
                            state = 1;
                            for step = 1:creatures{i_creature}(i_trial).len
                                abstract_animal = creatures{i_creature}(i_trial).animal_sequence(step);
                                fsm_output = is.FSMs{creatures{i_creature}(i_trial).rule}(state, abstract_animal, 2);
                                new_state = is.FSMs{creatures{i_creature}(i_trial).rule}(state, abstract_animal, 1);
                                
                                %% HA EDIT
%                                 transition_type = TR(:,1) == creatures{i_creature}(i_trial).rule & TR(:,2) == state & TR(:,3) == new_state ...
%                                     & TR(:,4) == creatures{i_creature}(i_trial).animal_identities(abstract_animal) & TR(:,5) == fsm_output;
                                transition_type = TR(:,1) == creatures{i_creature}(i_trial).rule & TR(:,2) == state & TR(:,3) == new_state ...
                                    & TR(:,4) == abstract_animal & TR(:,5) == fsm_output;
                                %% END OF HA EDIT
                                transition_counts(transition_type) = transition_counts(transition_type) + 1;
                                

                                state = new_state;
                            end
                        end

                        fitness(i_creature) = sum(transition_counts ~= 0);
                        %% end when all unique transitions exist in the trial sequence
                        if all(transition_counts ~= 0)
                            winning_creature = creatures{i_creature};
                            done = true;
                        end        
                    end

                    disp(['max=' num2str(max(fitness)) ', mean=' num2str(mean(fitness))])

                    %% kill each creature with a probability proportional to its fitness rank
                    [b, ix] = sort(fitness); z = 1:n_creatures; fRank(ix) = z;  % get the fitness rank of each creature
                    pDeath = 1-fRank/n_creatures; deathRand = rand([n_creatures, 1]); death = deathRand < pDeath';  % decide on death for each creature
                    %% for each dead creature, randomly choose two survivors to be its parents
                    notDead = find(~death);
                    for iDead = (find(death))'
                        mom = notDead(randi([1 length(notDead)]));
                        dad = notDead(randi([1 length(notDead)]));  % they could be the same, that's ok
                        creatures{iDead} = crossover(is, creatures{mom}, creatures{dad});
                    end
                end

                trialBlock = winning_creature;
                for i=1:length(trialBlock), trialBlock(i).is_practice = false; end
                trials = [trials trialBlock];
%                 %% HA DEBUG
%                 nBlocks = nBlocks + 1;
%                 disp(['***************************** FOUND ' num2str(nBlocks) ' BLOCKS']);
%                 %% END OF DEBUG
            end
        end
    end
    save('good_trials_simple', 'trials');
else
    load('good_trials_simple');
end

%% shuffle trials
totalTrials = length(trials);
if is.response_counterbalance
    % first, split trials by key-mapping
    keyMapBlock1 = trials(1:floor(totalTrials/2));              % first key-mapping
    keyMapBlock2 = trials(floor(totalTrials/2)+1:totalTrials);  % second key-mapping
    % then, shuffle trials within each consistently-key-mapped block
    keyMapBlock1 = keyMapBlock1(randperm(length(keyMapBlock1)));
    keyMapBlock2 = keyMapBlock2(randperm(length(keyMapBlock2)));

    % if in debug mode, create smaller set of trials
    if is.subject_id == 0     % indicates we're in debug mode
        keyMapBlock1_1 = keyMapBlock1(1:2);
        keyMapBlock1_2 = keyMapBlock1(3:4);
        keyMapBlock2 = keyMapBlock2(1:3);
    else    
        % now, divide key-mapped blocks such that there are three alternating
        % blocks
        keyMapBlock1_1 = keyMapBlock1(1:floor(length(keyMapBlock1)/2));       % 1/2 of 1st key-mapping
        keyMapBlock1_2 = keyMapBlock1(floor(length(keyMapBlock1)/2)+1:end);   % 1/2 of 1st key-mapping
    end

    % make sure the start of each block is indicated with a variable
    % block_start = 1 (all other trials = 0)
    keyMapBlock1_1(1).block_start = true; 
    for ix = 2:length(keyMapBlock1_1) 
        keyMapBlock1_1(ix).block_start = false;
    end
    keyMapBlock1_2(1).block_start = true; 
    for ix = 2:length(keyMapBlock1_2)
        keyMapBlock1_2(ix).block_start = false;
    end
    keyMapBlock2(1).block_start = true;
    for ix = 2:length(keyMapBlock2)
        keyMapBlock2(ix).block_start = false;
    end

    % concatenate blocks such that there's a short block of the first mapping, followed
    % by a long block of the second mapping, followed by a short block of the
    % first mapping
    trials = [keyMapBlock1_1 keyMapBlock2 keyMapBlock1_2];
else    % only one "block" of trials
    % shuffle these trials
    trials = trials(randperm(length(trials)));
    % label first trial as block start
    trials(1).block_start = true;
    for ix = 2:length(trials)
        trials(ix).block_start = false;
    end
    
end

%% note: no need to randomize block order because key-mapping is randomized across subjects
%% save this subject's trial randomization with their subject ID and date/time-stamp
timestamp = datestr(now, 'dd-mmm-yyyy_HH-MM');
save(['good_trials_simple_' num2str(is.subject_id) '_' timestamp], 'trials');
end


