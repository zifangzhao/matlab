%% HA EDIT: don't randomly permute defining features of creature
% i.e. first (two) element(s) in animal_identities is the target color we want this
% rule to be about; necessary to ensure a complete set of rules is achieved
function [ child ] = crossover( is, mom, dad )
% mom, dad, and child are all "trials" struct arrays

n = size(mom);

mom_inds = rand(n) < 0.5;
child(mom_inds) = mom(mom_inds);
child(~mom_inds) = dad(~mom_inds);

if rand < 0.05
    child = child(randperm(max(n)));
end

child(randi(n)).rule = randi(is.n_rules); % randomly mutate one rule
%% HA EDIT: only permute colors not critical to current rule
temp_i = randi(n);
if is.practice      % permute last three colors only
    fixedColors = child(temp_i).animal_identities(1);
    randColors = child(temp_i).animal_identities(2:end);
else                % permute last two colors only
    fixedColors = child(temp_i).animal_identities(1:2);
    randColors = child(temp_i).animal_identities(3:4);
end
child(temp_i).animal_identities = [fixedColors randColors(randperm(length(randColors)))];
%% END OF HA EDIT
temp_i = randi(n);
child(temp_i).len = randi([is.min_animals_per_trial is.max_animals_per_trial]);  % randomly mutate one animal sequence
child(temp_i).animal_sequence = randi(is.n_animals, [1 child(temp_i).len]);
end

