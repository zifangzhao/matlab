%% HA MODIFIED THIS (Jan 7, 2019)
% re-defining the simple task to include only one rule of the form X-->Y
% i.e. if you see an X, press for that X, then press when you see a Y. Once
% you see a Y, press for that Y, and then press when you see an X.
% Alternate between pressing for X and Y, pressing for one of each. 

function [ is, trials ] = SetUpFSMs( is )

%% text-formatting variables
xc = is.screen_center(1)-200; yc = is.screen_center(2)-200; 
xSc = 20; ySc = 20; % xScale and yScale are the approximate width and height of a character
verticalSpacing = 40;   % to determine vertical position of each line
colorWordLength = 8;
if strcmp(is.task_mode, 'simple_task') || strcmp(is.task_mode, 'full_task')
    %% HA EDITS: new simple task
    % set up FSM to represent the rule above (X-->Y). First page (:,:,1)
    % for state transitions; second page (:,:,2) for button presses. Column
    % indicates stimulus seen, row indicates current state.
    is.FSMs = cell(1,1);
    is.FSMs{1} = cat(3, [2 1 1 1;  ...
                         2 1 2 2], ...
                         [1 2 2 2; ...
                         2 1 2 2]);     % press for one X, then one Y, keep alternating
    is.n_rules = length(is.FSMs);
    trials = GenerateTrialsSimple(is);
    is.n_trials = length(trials); % how many trials in the experiment
    %% HA: modify values in brackets / move text around here for accurate display
    if strcmpi(is.response_modality, 'joystick')
        is.rule_texts{1} = [{'INSTRUCTIONS:', [xc yc-3*verticalSpacing]}
                            {'''&1'' to take a picture,', [xc yc-verticalSpacing]}
                            {'and ''&2'' to skip this bird.', [xc yc]}
                            {'Wait for the first ', [xc yc+2*verticalSpacing]}
                            {'*1', [xc+19*xSc yc+2*verticalSpacing]}
                            {' bird,', [xc+25*xSc yc+2*verticalSpacing]}
                            {'then take a picture of it.', [xc yc+3*verticalSpacing]}
                            {'Then wait for the first ', [xc yc+4*verticalSpacing]}
                            {'*2', [xc+23*xSc yc+4*verticalSpacing]}
                            {' bird,', [xc+29*xSc yc+4*verticalSpacing]}
                            {'and take a picture of it.', [xc yc+5*verticalSpacing]}
                            {'Alternate taking pictures of one ', [xc yc+6*verticalSpacing]}
                            {'*1', [xc yc+7*verticalSpacing]}
                            {' bird and one ', [xc+6*xSc yc+7*verticalSpacing]}
                            {'*2', [xc+20*xSc yc+7*verticalSpacing]}
                            {' bird.', [xc+26*xSc yc+7*verticalSpacing]}
                            {'(Press any key to begin)', [xc yc+9*verticalSpacing]}];
    else
        is.rule_texts{1} = [{'INSTRUCTIONS:', [xc yc-3*verticalSpacing]}
                            {'Press ''&1'' to take a picture,', [xc yc-verticalSpacing]}
                            {'and press ''&2'' to skip this bird.', [xc yc]}
                            {'Wait for the first ', [xc yc+2*verticalSpacing]}
                            {'*1', [xc+19*xSc yc+2*verticalSpacing]}
                            {' bird,', [xc+25*xSc yc+2*verticalSpacing]}
                            {'then take a picture of it.', [xc yc+3*verticalSpacing]}
                            {'Then wait for the first ', [xc yc+4*verticalSpacing]}
                            {'*2', [xc+23*xSc yc+4*verticalSpacing]}
                            {' bird,', [xc+29*xSc yc+4*verticalSpacing]}
                            {'and take a picture of it.', [xc yc+5*verticalSpacing]}
                            {'Alternate taking pictures of one ', [xc yc+6*verticalSpacing]}
                            {'*1', [xc yc+7*verticalSpacing]}
                            {' bird and one ', [xc+6*xSc yc+7*verticalSpacing]}
                            {'*2', [xc+20*xSc yc+7*verticalSpacing]}
                            {' bird.', [xc+26*xSc yc+7*verticalSpacing]}
                            {'(Press any key to begin)', [xc yc+9*verticalSpacing]}];
    end
 %% end of new simple task                 
%% END OF HA EDITS

elseif strcmp(is.task_mode, 'practice') || strcmp(is.task_mode, 'refresher')
%% HA EDITS: new practice task; code adopted from Zeb's old simple_task code
    %% Set up the three simple FSMs. First page (:,:,1) of each cell is the new state. Second page (:,:,2) of each cell is the correct output.
    is.FSMs = cell(3,1);
    is.FSMs{1} = cat(3, [1 1 1 1], ...
                        [1 2 2 2]);     % "press for every X"
    is.FSMs{2} = cat(3, [1 1 1 1], ...
                        [2 1 1 1]);     % "press for all except X"
    is.FSMs{3} = cat(3, [2 1 1 1;  ...
                         2 1 1 1], ...
                        [2 2 2 2;  ...
                         1 2 2 2]);     % "press for two X in a row"
    is.n_rules = length(is.FSMs);
    trials = GenerateTrialsPractice(is);
    is.n_trials = length(trials); % how many trials in the experiment
    % generate rule text depending on response modality
    if strcmpi(is.response_modality, 'joystick')
        is.rule_texts{1} = [{'INSTRUCTIONS:', [xc yc-3*verticalSpacing]}
                            {'''&1'' to take a picture,', [xc yc-verticalSpacing]}
                            {'and ''&2'' to skip this bird.', [xc yc]}
                            {'Take a picture of every ', [xc yc+2*verticalSpacing]}
                            {'*1' [xc yc+3*verticalSpacing]}
                            {' bird you see, and ', [xc+colorWordLength*xSc yc+3*verticalSpacing]}
                            {'skip all other birds.', [xc yc+4*verticalSpacing]};
                            {'(Press any key to begin)', [xc yc+6*verticalSpacing]}];
        is.rule_texts{2} = [{'INSTRUCTIONS:', [xc yc-3*verticalSpacing]}
                            {'''&1'' to take a picture,', [xc yc-verticalSpacing]}
                            {'and ''&2'' to skip this bird.', [xc yc]}
                            {'Take a picture of every bird you see', [xc yc+2*verticalSpacing]}
                            {'except ' [xc yc+3*verticalSpacing]}
                            {'*1' [xc+8*xSc yc+3*verticalSpacing]}
                            {' birds.' [xc+(colorWordLength+8)*xSc yc+3*verticalSpacing]}
                            {'When you see a ' [xc yc+4*verticalSpacing]}
                            {'*1' [xc+15*xSc yc+4*verticalSpacing]}
                            {' bird, press the skip button.' [xc+(15+colorWordLength)*xSc yc+4*verticalSpacing]}
                            {'(Press any key to begin)', [xc yc+6*verticalSpacing]}];
        is.rule_texts{3} = [{'INSTRUCTIONS:', [xc yc-3*verticalSpacing]}
                            {'''&1'' to take a picture,', [xc yc-verticalSpacing]}
                            {'and ''&2'' to skip this bird.', [xc yc]}
                            {'If you see a ', [xc yc+2*verticalSpacing]}
                            {'*1', [xc+13*xSc yc+2*verticalSpacing]}
                            {'bird, take a picture of the', [xc+20*xSc yc+2*verticalSpacing]}
                            {'next bird if it is also ', [xc yc+3*verticalSpacing]}
                            {'*1', [xc+24*xSc yc+3*verticalSpacing]}
                            {'.', [xc+31*xSc yc+3*verticalSpacing]}
                            {'Skip all other birds.' [xc yc+4*verticalSpacing]}
                            {'(Press any key to begin)', [xc yc+6*verticalSpacing]}];
    else
        is.rule_texts{1} = [{'INSTRUCTIONS:', [xc yc-60]}
                            {'Press ''&1'' to take a picture,', [xc yc-30]}
                            {'and press ''&2'' to skip this bird.', [xc yc]}
                            {'Take a picture of every ', [xc yc+60]}
                            {'*1' [xc yc+90]}
                            {' bird you see, and ', [xc+colorWordLength*xSc yc+90]}
                            {'skip all other birds.', [xc yc+120]};
                            {'(Press any key to begin)', [xc yc+180]}];
        is.rule_texts{2} = [{'INSTRUCTIONS:', [xc yc-60]}
                            {'Press ''&1'' to take a picture,', [xc yc-30]}
                            {'and press ''&2'' to skip this bird.', [xc yc]}
                            {'Take a picture of every bird you see', [xc yc+60]}
                            {'except ' [xc yc+90]}
                            {'*1' [xc+8*xSc yc+90]}
                            {' birds.' [xc+(colorWordLength+8)*xSc yc+90]}
                            {'When you see a ' [xc yc+120]}
                            {'*1' [xc+15*xSc yc+120]}
                            {' bird, press the skip button.' [xc+(15+colorWordLength)*xSc yc+120]}
                            {'(Press any key to begin)', [xc yc+180]}];
        is.rule_texts{3} = [{'INSTRUCTIONS:', [xc yc-60]}
                            {'Press ''&1'' to take a picture,', [xc yc-30]}
                            {'and press ''&2'' to skip this bird.', [xc yc]}
                            {'If you see a ', [xc yc+60]}
                            {'*1', [xc+13*xSc yc+60]}
                            {' bird, take a picture of the', [xc+20*xSc yc+60]}
                            {'next bird if it is also ', [xc yc+90]}
                            {'*1', [xc+24*xSc yc+90]}
                            {'.', [xc+31*xSc yc+90]}
                            {'Skip all other birds.' [xc yc+120]}
                            {'(Press any key to begin)', [xc yc+180]}];
    end
%% end of new practice task
end


end

