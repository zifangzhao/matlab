%% HA EDITED (JAN 8, 2019)
% changed to fit simplified task with only one rule X-->Y
% also changed to run and save trial subsets or load them when detected
% flexibly
function [trials] = GenerateTrialsSimple(is)

TR = [1 1 1 2 2;    % possible transitions for rule 1
      1 1 1 3 2;
      1 1 1 4 2;
      1 1 2 1 1;
      1 2 2 1 2;
      1 2 2 3 2;
      1 2 2 4 2;
      1 2 1 2 1;    
      2 1 1 2 1;    % possible transitions for rule 2
      2 1 1 3 1;
      2 1 1 4 1;
      2 1 2 1 2;
      2 2 2 1 1;
      2 2 2 3 1;
      2 2 2 4 1;
      2 2 1 2 2;    
      ];
 n_trial_blocks = 5;  % total: 128 trials, each with all 16 transitions above   
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
    
    trigger_codes = nan(2, 2, 2, 4, 2);
    %% END OF HA EDITS
    
    for i=1:size(TR,1)
        trigger_codes(TR(i,1), TR(i,2), TR(i,3), TR(i,4), TR(i,5)) = i;
    end
    save('trigger_codes_simple', 'trigger_codes')
else
    load('trigger_codes_simple');
end

if ~exist('good_trials_simple.mat', 'file')
    %% genetic algorithm to find a dense initial set of trials
    n_init_trials = 16;  % how many initial trials to have with guaranteed existence of each trial type?
    trials = struct([]);
    for run_count = 1:n_trial_blocks
        nTT = size(TR,1);  % number of unique transition types
        n_creatures = 50;
        creatures = cell(n_creatures,1); % each creature is a trials struct array
        fitness = zeros(n_creatures, 1);
        winning_creature = [];  
        
        %% randomly initialize the creatures
        for i_creature = 1:n_creatures
            for i_trial = 1:n_init_trials % generate random trials
                creatures{i_creature}(i_trial).rule = randi(is.n_rules);
                creatures{i_creature}(i_trial).animal_identities = randperm(is.n_animals);
                creatures{i_creature}(i_trial).len = randi([is.min_animals_per_trial is.max_animals_per_trial]);  % number of animals in this trial
                creatures{i_creature}(i_trial).animal_sequence = randi(is.n_animals, [1 creatures{i_creature}(i_trial).len]);
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
                        
                        transition_type = TR(:,1) == creatures{i_creature}(i_trial).rule & TR(:,2) == state & TR(:,3) == new_state ...
                            & TR(:,4) == creatures{i_creature}(i_trial).animal_identities(abstract_animal) & TR(:,5) == fsm_output;
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
        
        trialSubset = winning_creature;
        for i=1:length(trialSubset), trialSubset(i).is_practice = false; end
        trials = [trials trialSubset];
%         save(['good_trials_simple_subset' num2str(randi([0 9999],1,1))], 'trials')
    end
    save('good_trials_simple', 'trials');
else
    load('good_trials_simple');
    %% HA MODIFIED: shuffle each half of the dataset; each half has 4 iteration of the 16 transitions
    n_init_trials = length(trials) /2;
    trials_firstHalf = trials(1:end/2);
    trials_secondHalf = trials(end/2+1:end);
    trials = [trials_firstHalf(randperm(n_init_trials)) trials_secondHalf(randperm(n_init_trials))];
end
end


