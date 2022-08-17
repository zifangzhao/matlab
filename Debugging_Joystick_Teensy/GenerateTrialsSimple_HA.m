%% HA (Jan 7, 2019)
% generates trials for simplified version of task with one rule only X-->Y

function [trials] = GenerateTrialsSimple_HA()

%% generate list of all distinct conditions
% column 1: rule (always 1)
% column 2: from state
% column 3: to state
% column 4: by animal
% column 5: w/ output (button)
% only generates from_state:to_state:by_animal combinations that are
% permissible according to the one rule X->Y
TR = [1 1 2 1;
      1 1 3 1;
      1 1 4 1;
      1 1 2 2;
      1 1 3 2;
      1 1 4 2;
      1 2 1 1;
      1 2 1 2;
      2 2 1 1;
      2 2 3 1;
      2 2 4 1;
      2 2 1 2;
      2 2 3 2;
      2 2 4 2;
      2 1 2 1;
      2 1 2 2];
  
keyboard;
  


end