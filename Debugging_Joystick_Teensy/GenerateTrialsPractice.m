%% HA CREATED: FEBRUARY 12, 2019; COPIED AND MODIFIED FROM GenarateTrialsSimple.m

function [trials] = GenerateTrialsPractice(is)
%% list all distinct transitions
% column 1: rule (always 1)
% column 2: from state
% column 3: to state
% column 4: by animal
% column 5: w/ output (button)
% only generates from_state:to_state:by_animal combinations that are
% permissible according to the practice rules (see SetUpFSMs.m)
    
TR = [1 1 1 1 1; ...
      1 1 1 2 2; ...
      1 1 1 3 2; ...
      1 1 1 4 2; ...    % end of possible transitions for rule #1
      2 1 1 1 2; ...
      2 1 1 2 1; ...
      2 1 1 3 1; ...
      2 1 1 4 1; ...    % end of possible transitions for rule #2
      3 1 2 1 2; ...
      3 1 1 2 2; ...
      3 1 1 3 2; ...
      3 1 1 4 2; ...
      3 2 2 1 1; ...
      3 2 1 2 2; ...
      3 2 1 3 2; ...
      3 2 1 4 2];       % end of possible transitions for rule #3
  
% n_trial_blocks = 24;  % 4 colors, one per rule, 3 rules = 12 unique rules x 2 response assignments = 24 blocks

if ~exist('trigger_codes_practice.mat', 'file') 
    trigger_codes = nan(3, 2, 2, 4, 2);
    
    for i=1:size(TR,1)
        trigger_codes(TR(i,1), TR(i,2), TR(i,3), TR(i,4), TR(i,5)) = i;
    end
    save('trigger_codes_practice', 'trigger_codes')
else
    load('trigger_codes_practice');
end

if ~exist('good_trials_practice.mat', 'file')
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
    
    for transition_key = 1:n_keys    % select possible key to transition between states
        for color_x = 1:n_colors       % select possible color X
            % leftover colors                
            other_colors = all_colors(~ismember(all_colors, color_x));
            % leftover key
            stay_key = all_keys(~ismember(all_keys, [transition_key]));
            %% run genetic algorithm
            %% genetic algorithm to find a dense initial set of trials
            n_init_trials = 4;  % how many initial trials to have with guaranteed existence of each transition type?

            nTT = size(TR,1);  % number of unique transition types
            n_creatures = 50;
            creatures = cell(n_creatures,1); % each creature is a trials struct array
            fitness = zeros(n_creatures, 1);
            winning_creature = [];  

            %% randomly initialize the creatures
            for i_creature = 1:n_creatures
                for i_trial = 1:n_init_trials % generate random trials
                    creatures{i_creature}(i_trial).rule = randi(is.n_rules);
                    creatures{i_creature}(i_trial).animal_identities = [color_x other_colors(randperm(length(other_colors)))];
                    creatures{i_creature}(i_trial).len = randi([is.min_animals_per_trial is.max_animals_per_trial]);  % number of animals in this trial
                    creatures{i_creature}(i_trial).animal_sequence = randi(is.n_animals, [1 creatures{i_creature}(i_trial).len]);
                    %% HA EDIT; extra identifying information for this trial
                    creatures{i_creature}(i_trial).color_x = color_x;
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
%                             transition_type = TR(:,1) == creatures{i_creature}(i_trial).rule & TR(:,2) == state & TR(:,3) == new_state ...
%                                 & TR(:,4) == creatures{i_creature}(i_trial).animal_identities(abstract_animal) & TR(:,5) == fsm_output;
                            transition_type = TR(:,1) == creatures{i_creature}(i_trial).rule & TR(:,2) == state & TR(:,3) == new_state ...
                                & TR(:,4) == abstract_animal & TR(:,5) == fsm_output;
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
            for i=1:length(trialBlock), trialBlock(i).is_practice = true; end
            trials = [trials trialBlock];

        end
    end
    %% now, sort trials
    totalTrials = length(trials);
    
    if is.response_counterbalance
        % first, split trials by key-mapping
        keyMapBlock1 = trials(1:floor(totalTrials/2));              % first key-mapping
        keyMapBlock2 = trials(floor(totalTrials/2)+1:totalTrials);  % second key-mapping

        % then, shuffle trials so color rules are shuffled
        keyMapBlock1 = keyMapBlock1(randperm(length(keyMapBlock1)));
        keyMapBlock2 = keyMapBlock2(randperm(length(keyMapBlock2)));

        % next, sort trials by rules (to create blocks with the same rule within each
        % key-mapping)
        %% WARNING: will only work on Matlab 2013+
        tbl1 = struct2table(keyMapBlock1);
        tbl1 = sortrows(tbl1,'rule');
        keyMapBlock1 = table2struct(tbl1)';
        tbl2 = struct2table(keyMapBlock2);
        tbl2 = sortrows(tbl2,'rule');
        keyMapBlock2 = table2struct(tbl2)';

        % make sure the start of each block is indicated with a variable
        % block_start = 1 (all other trials = 0)
        keyMapBlock1(1).block_start = true; 
        for ix = 2:length(keyMapBlock1) 
            keyMapBlock1(ix).block_start = false;
        end
        keyMapBlock2(1).block_start = true;
        for ix = 2:length(keyMapBlock2)
            keyMapBlock2(ix).block_start = false;
        end

        % concatenate blocks
        trials = [keyMapBlock1 keyMapBlock2];
    else        % only one "block" of trials
        % sort trials by rule
        %% WARNING: will only work on Matlab 2013+
        tbl = struct2table(trials);
        tbl = sortrows(tbl, 'rule');
        trials = table2struct(tbl);
        % label first trial as block start
        trials(1).block_start = true;
        for ix = 2:length(trials)
            trials(ix).block_start = false;
        end
        
    end
        
    %% save
    save('good_trials_practice', 'trials');
else
    load('good_trials_practice');
end

end


