function [ n_pt ] = PracticeOneRuleType(window_handle, dio, practice_is, practice_trial, fixcross, animal_texture, results_file, practice_sequences, n_pt )

n_trials = length(practice_sequences);

for i_trial = 1:n_trials  % repeat as many times as we specified sequences
    practice_trial.animal_identities = randperm(4);
    practice_trial.animal_sequence = practice_sequences{i_trial};
    practice_trial.len = length(practice_trial.animal_sequence);         
    trials_completed = RunOnePracticeTrial(window_handle, dio, practice_is, practice_trial, fixcross, animal_texture); 
    len_TC = length(trials_completed);
    Results.practice_trials(n_pt:(n_pt+len_TC-1)) = trials_completed;  % RunOnePracticeTrial can return an array of trials, if the subject doesn't get it correct the first time.
    n_pt = n_pt + len_TC;
    save(results_file, 'Results', 'practice_is')  % write results file frequently, in case we crash
end % end trial loop


end

