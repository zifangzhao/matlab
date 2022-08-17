%% LAST EDIT: MARCH 21, 2019 BY HA
% replaced all calls to Screen('Flip') with calls to displayScreen; also
% displays input to photodiode and returns time of display
%% LAST EDIT: MARCH 01, 2019 BY HA
% 1. adding joystick functionality
% 2. taking into account whether or not responses are counterbalanced in
% blocks
% 3. only display camera icon if keyboard is used
% 4. IMPORTANT: KbWait does not give accurate reaction times (see
% https://github.com/Psychtoolbox-3/Psychtoolbox-3/wiki/FAQ:-Processing-keyboard-input);
% switching to Kb
%% DEC 29, 2018 BY HA
% randomly select fixation time for trial

function [ Results ] = RunOneTrial( window_handle, dio, is, trial, fixcross, animal_texture, camera_texture )

% trial is a struct which is one element taken from the trials struct array in ProgramTask
% returns a struct, Results, which will become one element of a struct array in ProgramTask

 animal_map = trial.animal_identities;  % the map from abstract animals to concrete animals for this trial
 %% HA EDIT: same for key mapping
 key_map = [trial.transition_key trial.stay_key];
 %% end of HA edit
 
 %% HA EDIT: left vs. right keyboard keys
 if strcmpi(is.response_modality, 'keyboard')
     % allow subject to press any left or right key to respond
     leftKeys =  {'1', '2', '3', '4', '5', ...
                  'q', 'w', 'e', 'r', 't', ...
                  'a', 's', 'd', 'f', 'g', ...
                  'z', 'x', 'c', 'v', 'b', ...
                  'Q', 'W', 'E', 'R', 'T', ...
                  'A', 'S', 'D', 'F', 'G', ...
                  'Z', 'X', 'C', 'V', 'B'};

     rightKeys = {'6', '7', '8', '9', '0', ...
                  'p', 'o', 'i', 'u', 'y', ...
                  ';:', 'l', 'k', 'j', 'h', ...
                  '/?', '.>', ',<', 'm', 'n', ...
                  'P', 'O', 'I', 'U', 'Y', ...
                       'L', 'K', 'J', 'H', ...
                                 'M', 'N'};       
 end
%% end of HA edit     
              
 %% HA EDIT: display beginning-of-block instructions, if this is the first trial in a new block
 if trial.block_start
     if strcmpi(is.response_modality, 'joystick')
         DrawFormattedText(window_handle, ...
             ['For the next block of trials, \n\n' ...
             'please ''' is.key_map{trial.transition_key} '''' ...
             ' to take a picture of a bird,\n\n' ...
             'and ''' is.key_map{trial.stay_key} ''''...
             ' to skip a bird.\n\n'], 'center', 'center');
     else
         DrawFormattedText(window_handle, ...
             ['For the next block of trials, \n\n' ...
             'please press ''' is.key_map{trial.transition_key} '''' ...
             ' to take a picture of a bird,\n\n' ...
             'and press ''' is.key_map{trial.stay_key} ''''...
             ' to skip a bird.\n\n' ...
             'The camera icon at the bottom of the screen reminds you \n\n' ... 
             'which button to use to take a picture.'], 'center', 'center');
             
         % display camera icon
         displayCamera(is.key_map{trial.transition_key}, window_handle, camera_texture, is);
     end

    % send photosensor input + trigger, keep track of block start time
    t_block_start = displayScreenAndSendTrigger(window_handle, is, 0, dio, is.BLOCK_TEXT_ONSET);
    % wait for input
    [response_code, t_block_end] = getInput(is, 0, 1);  % will only return on hitting ESCAPE button, or any keyboard button (if keyboard is input), or joystick button press (if joystick is input)
    if strcmp(response_code, 'ESCAPE') % a way to bail out of PTB
        graceful_exit(is,dio);
    end
    Results.instruction_time = t_block_end - t_block_start;
 end
%% end of HA edits

%% draw program for this trial
i_rule = trial.rule;
rule_text = is.rule_texts{i_rule};
for i_animal = 1:is.n_animals  % replace *n with bird name strings    
    warning('off','MATLAB:strrep:InvalidInputType')    
    %% HA EDIT: simplifying animal-name mapping
%     rule_text = cellfun(@(x) strrep(x, ['*' num2str(i_animal)], is.animal_names{animal_map(mod(i_animal-1,4)+1)+4*floor((i_animal-1)/4)}), rule_text, 'UniformOutput', false);     
    rule_text = cellfun(@(x) strrep(x, ['*' num2str(i_animal)], is.animal_names{animal_map(i_animal)}), rule_text, 'UniformOutput', false);
end

%% HA EDIT: dynamically assign button names (as above)
rule_text = cellfun(@(x) strrep(x, '&1', is.key_map{trial.transition_key}), rule_text, 'UniformOutput', false);
rule_text = cellfun(@(x) strrep(x, '&2', is.key_map{trial.stay_key}), rule_text, 'UniformOutput', false);
%% end of HA edit

Results.rule = i_rule;
Results.animal_map = animal_map;
Results.FSM = is.FSMs{i_rule};
Results.rule_text = rule_text;

%% HA EDITED
% pick a fixation time at random for this trial
is.fixation_time = is.possible_fixation_times(randi(length(is.possible_fixation_times)));
%% END OF HA EDITS

% Screen('TextFont', window_handle, 'Courier New'); 
for i_chunk=1:size(rule_text,1)
    if strcmp(rule_text{i_chunk,1}, 'Red')
        string_color = [255 0 0];
    elseif strcmp(rule_text{i_chunk,1}, 'Green')
        string_color = [0 255 0];
    elseif strcmp(rule_text{i_chunk,1}, 'Blue')
        string_color = [0 0 255];
    elseif strcmp(rule_text{i_chunk,1}, 'Yellow')
        string_color = [220 210 0];
    else
        string_color = [0 0 0];
    end
    DrawFormattedText(window_handle, rule_text{i_chunk,1}, rule_text{i_chunk,2}(1), rule_text{i_chunk,2}(2), string_color);
end
%% HA edit: display camera icon
if strcmpi(is.response_modality, 'keyboard')
    displayCamera(is.key_map{trial.transition_key}, window_handle, camera_texture, is);
end
%% end of HA edit

t_rule_start = displayScreenAndSendTrigger(window_handle, is, 0, dio, is.RULE_TEXT_ONSET);
[response_code, t_rule_end] = getInput(is, 0, 1);

disp('Trial instructions, response code');
disp(response_code);

if strcmp(response_code, 'ESCAPE') % a way to bail out of PTB
    disp('Hit escape after trail instructions');
    disp(response_code);
    graceful_exit(is,dio);
end

Results.instruction_time = t_rule_end - t_rule_start;

state = 1; % start each trial in state 1
correct = 1;
n_steps = trial.len;

for i_step = 1:n_steps  % loop over the steps within a trial
    disp(['step number ' num2str(i_step)]);
    %% draw fixation cross (textures centered by default)
    Screen('DrawTexture', window_handle, fixcross);
    %% HA edit: display camera icon
    if strcmpi(is.response_modality, 'keyboard')
        displayCamera(is.key_map{trial.transition_key}, window_handle, camera_texture, is);
    end
    %% end of HA edit
    t_fixation = displayScreenAndSendTrigger(window_handle, is, 0, dio, is.FIXATION_ONSET);
    disp('end fixation');
    %% run the nominal FSM
    animal_input = trial.animal_sequence(i_step);  % find the abstract animal to show on this step
    new_state = is.FSMs{i_rule}(state,animal_input,1); % get the correct next state
    true_output = is.FSMs{i_rule}(state,animal_input,2); % get the correct output
    
    %% record step info into Results struct
    Results.steps(i_step).abstract_animal = animal_input;
    Results.steps(i_step).concrete_animal = is.animal_names{animal_map(animal_input)};
    Results.steps(i_step).start_state = state;
    Results.steps(i_step).end_state = new_state;
    Results.steps(i_step).true_output = is.key_map{key_map(true_output)};
    
    if strcmpi(is.response_modality,'keyboard')%.............
        %% HA EDITS: also recording the side of the true response
        if ismember(is.key_map{key_map(true_output)}, leftKeys)
            Results.steps(i_step).true_output_left = true;
        elseif ismember(is.key_map{key_map(true_output)}, rightKeys)
            Results.steps(i_step).true_output_left = false;
        else
            disp('ERROR: error in key-mapping left vs. right');
            sca;
            keyboard;
        end
    end
    %% draw the animal for this transition, and wait is.time_per_image, monitoring for a key press
    Screen('DrawTexture', window_handle, animal_texture{animal_map(animal_input)});  % draw animal image
    if i_step == 1
        animal_time = t_fixation + 2*is.fixation_time;  % Matt thought it would be useful to have a slightly longer delay before the first animal
    else
        animal_time = t_fixation + is.fixation_time;
    end
    %% HA edit: display camera icon
    if strcmpi(is.response_modality, 'keyboard')
        displayCamera(is.key_map{trial.transition_key}, window_handle, camera_texture, is);
    end
    %% end of HA edit
    
    %% HA MODIFIED: animal_map(animal_input) to just animal_input
    trigger_code = is.ANIMAL_ONSET(i_rule, state, new_state, animal_input, true_output);
    if isnan(trigger_code)
        disp(['i_rule=' num2str(i_rule) ', state= ' num2str(state) ', new_state= ' num2str(new_state) ', animal_map(animal_input)=' num2str(animal_map(animal_input)) ...
            ', true_output=' num2str(true_output)])
        error('bad trigger code, aborting')
    else
        [~, stimulus_onset_time] = displayScreenAndSendTrigger(window_handle, is, animal_time, dio, trigger_code); % flip to animal after fixation cross was on for is.fixation_time
    end
    % HA: get input. allows any keyboard button (if input modality is
    % keyboard), joystick movement and joystick button press (if input
    % modality is joystick), with timeout is.time_per_image seconds long
    [response_code, response_time] = getInput(is, 1, 1, is.time_per_image);
    %% process input
    %% HA EDITS: for dual-key version, determine which key was pressed
    if ~isnan(response_code)
        Results.steps(i_step).RT = response_time - stimulus_onset_time;  % calculate RT
        if strcmpi(is.response_modality, 'keyboard')
            key_pressed = response_code;
            if ismember(key_pressed, leftKeys)
                key_pressed_index = 1;
            elseif ismember(key_pressed, rightKeys)
                    key_pressed_index = 2;
            else
                    key_pressed_index = 3;
            end
        else    % joystick input
            if length(response_code) == 1
                key_pressed_index = 1;  % button press
            else
                key_pressed_index = 2;  % joystick movement
            end
        end
    end
    %% END OF HA EDITS
    
    Results.steps(i_step).response = '';
    if ~isnan(response_code)  % if the user pressed, display an outline around the animal
        disp('pressed');
        
        Screen('DrawTexture', window_handle, animal_texture{animal_map(animal_input)});  % draw animal image
        Screen('FrameRect', window_handle, [0 0 0], ...
            CenterRectOnPointd([0 0 700 700], is.screen_center(1), is.screen_center(2)), 2)
        %% HA edit: display camera icon
        if strcmpi(is.response_modality, 'keyboard')
            displayCamera(is.key_map{trial.transition_key}, window_handle, camera_texture, is);
        end
        %% end of HA edit
        displayScreenAndSendTrigger(window_handle, is, 0, dio, is.BUTTON_PRESS(key_pressed_index)); % flip to animal after fixation cross was on for is.fixation_time
    end
    %% HA EDIT: don't wait out image display time
%     WaitSecs('UntilTime', t_fixation + is.fixation_time + is.time_per_image); % wait out the rest of the image duration
    %% end of HA edit
    
    %% handle the different possible keyboard events we might have seen
    
    if isnan(response_code)  % no key was pressed
        if is.single_key % FSA outputs 1 and 2 are arbitrarily mapped to mean "no-press" and "spacebar", respectively
            if true_output == 1   % correctly omitted press
                if is.subject_id == 0 || trial.is_practice % debugging output
                    DrawFormattedText(window_handle, 'Correct', 'center', 'center');
                    %% HA edit: display camera icon
                    if strcmpi(is.response_modality, 'keyboard')
                        displayCamera(is.key_map{trial.transition_key}, window_handle, camera_texture, is);
                    end
                    %% end of HA edit
%                     displayScreenAndSendTrigger(window_handle, is, 0, dio, is.FEEDBACK);
                    Screen('Flip', window_handle);
                    WaitSecs(is.debug_msg_time);
                end
                
                Results.steps(i_step).correct = 1;
            else
                %% HA edit: display camera icon
                if strcmpi(is.response_modality, 'keyboard')
                    displayCamera(is.key_map{trial.transition_key}, window_handle, camera_texture, is);
                end
                %% end of HA edit
                if is.subject_id == 0 % debugging output
                    DrawFormattedText(window_handle, ['(debug-wrong: this is state ' num2str(state) ', with animal ' num2str(animal_input) ')'], 'center', 'center');
%                     displayScreenAndSendTrigger(window_handle, is, 0, dio, is.FEEDBACK);
                    Screen('Flip', window_handle);
                    [response_code, ~] = getInput(is, 0, 1, 2); % proceed after 2 seconds if nothing is pressed
                    if ~isnan(response_code) && strcmp(response_code, 'ESCAPE')
                        graceful_exit(is,dio);
                    end
                elseif trial.is_practice
                    DrawFormattedText(window_handle, 'Oops...', 'center', 'center');
%                     displayScreenAndSendTrigger(window_handle, is, 0, dio, is.FEEDBACK);
                    Screen('Flip', window_handle);
                    WaitSecs(is.debug_msg_time);
                end
                %% HA EDIT: abort trial on errors; remove this line to continue trial after error                
                correct = 0;
                Results.steps(i_step).correct = 0;
                break;    
                %% END OF HA EDIT   
            end
        else
            if strcmpi(is.response_modality, 'keyboard')
                DrawFormattedText(window_handle, ['Time out. Please respond faster.\n\n' ...
                '(Press ESCAPE to exit task or any other key to continue)'], 'center', 'center');
            else    % press joystick button to continue
                DrawFormattedText(window_handle, ['Time out. Please respond faster.\n\n' ...
                '(Press ESCAPE to exit task or joystick button to continue)'], 'center', 'center');
            end
            
            %% HA edit: display camera icon
            if strcmpi(is.response_modality, 'keyboard')
                displayCamera(is.key_map{trial.transition_key}, window_handle, camera_texture, is);
            end
            %% end of HA edit
            displayScreenAndSendTrigger(window_handle, is, 0, dio, is.TIMEOUT);
            Results.steps(i_step).response = -1;
            correct = -1;
            %% HA EDIT: after time-out, wait on some button response
            % (so task doesn't keep going and timing out on its own)
%             WaitSecs(is.error_msg_show_time);
            [response_code, ~] = getInput(is, 0, 1);    % only allows escape, any button (if keyboard input), or joystick button (if joystick)
            % allow experimenter to escape task
            if strcmp(response_code, 'ESCAPE')
                graceful_exit(is,dio);
            end
            %% HA: abort trial after time-out
            break;
        end
    else  % a key was pressed
        if strcmp(response_code, 'ESCAPE') % a way to bail out of PTB
            % record this response
            Results.steps(i_step).response = response_code;
            graceful_exit(is,dio);
        end
        %% otherwise, interpret response code from getInput
        if strcmpi(is.response_modality, 'joystick')
            Results.steps(i_step).response = response_code;     % single-value indicates ID of button pressed; two values indicate X and Y coordinates of joystick
            % see if response was correct; FSA state 1: button press (to
            % transition), and FSA state 2: joystick movement (to skip)
            if (length(response_code)==1 && true_output == 1) || (length(response_code)==2 && true_output == 2)
                correct = 1;
                displayFeedback(is, dio, trial, window_handle, camera_texture, 1);
                Results.steps(i_step).correct = 1;
            else
                correct = 0;
                displayFeedback(is, dio, trial, window_handle, camera_texture, 0);
                Results.steps(i_step).correct = 0;
                %% HA: end trial on error
                break;
            end  
        else    % keyboard
            key_pressed = response_code;
            Results.steps(i_step).response = key_pressed;
            % check to see if key pressed was valid
            if ~ismember(key_pressed, [leftKeys rightKeys])  % invalid key was pressed
                displayFeedback(is, dio, trial, window_handle, camera_texture, -1);
                if strcmp(key_pressed, 'ESCAPE')
                    Results.steps(i_step).correct = -1;
                    graceful_exit(is,dio);
                end
                Results.steps(i_step).correct = -1; % code for invalid button press
                correct = -1;
            %% HA EDIT: compare to ALL keys on the correct side (replaced condition; previously "strcmp(key_pressed,is.key_map{true_output})  % correct key was pressed")
            elseif (Results.steps(i_step).true_output_left && ismember(key_pressed, leftKeys)) ...
                   || (~Results.steps(i_step).true_output_left && ismember(key_pressed, rightKeys))
                %% HA EDIT: showing correct feedback even in final version
                % (removed if-statement)
    %             if is.subject_id == 0 || trial.is_practice % debugging output
                %% end of HA edit
                displayFeedback(is, dio, trial, window_handle, camera_texture, 1);
                Results.steps(i_step).correct = 1;
                correct = 1;
            else                                                % incorrect key was pressed
                %% HA EDIT: display camera icon
                displayFeedback(is, dio, trial, window_handle, camera_texture, 0);
                Results.steps(i_step).correct = 0;
                correct = 0;
                %% HA EDIT: abort trial on errors; remove this line to continue trial after error
                break;
                %% END OF HA EDIT
            end
        end 
    end
    state = new_state; % update the state
end

%% draw feedback
Results.correct = correct;
if correct == 1
%% HA EDIT: display "all correct" message whether or not trial is practice
    DrawFormattedText(window_handle, 'All correct, nice job!', 'center', 'center');

    %% HA EDIT: display camera icon
    if strcmpi(is.response_modality, 'keyboard')
        displayCamera(is.key_map{trial.transition_key}, window_handle, camera_texture, is);
    end
    %% end of HA edit
%     displayScreenAndSendTrigger(window_handle, is, 0, dio, is.FEEDBACK);
    Screen('Flip', window_handle);
    WaitSecs(is.feedback_show_time);
%% HA EDIT: no longer need this, since trial aborts after first mistake
% elseif correct == 0
%         DrawFormattedText(window_handle, 'Oops...', 'center', 'center');
%         %% HA EDIT: display camera icon
%         if strcmpi(is.response_modality, 'keyboard')
%             displayCamera(is.key_map{trial.transition_key}, window_handle, camera_texture, is);
%         end
%         %% end of HA edit
%         displayScreen(window_handle, is, 0);
%         SendTrigger(is, dio, is.FEEDBACK);
%         WaitSecs(is.feedback_show_time);
% %     end
end

%% fixation during ITI
Screen(window_handle, 'FillRect');
%% HA EDIT: display camera icon
if strcmpi(is.response_modality, 'keyboard')
    displayCamera(is.key_map{trial.transition_key}, window_handle, camera_texture, is);
end
%% end of HA edit
displayScreenAndSendTrigger(window_handle, is, 0, dio, is.ITI_START);
WaitSecs(is.ITI) % wait for ITI


end

%% HA EDITS: function to display camera icon
function displayCamera(trans_key, window_handle, camera_texture, is)
if strcmp(trans_key, 'w')    % left
    Screen('DrawTexture', window_handle, camera_texture, [], [is.screen_xLeft + 100 is.screen_yBottom - 300, is.screen_xLeft + 200, is.screen_yBottom - 200]);
%         Screen('DrawTexture', window_handle, camera_texture);
else
    Screen('DrawTexture', window_handle, camera_texture, [], [is.screen_xRight - 200 is.screen_yBottom - 300, is.screen_xRight - 100, is.screen_yBottom - 200]);
%         Screen('DrawTexture', window_handle, camera_texture);
end
end

% display feedback: 
% feedbackCode = 1 --> correct, 0 --> error, -1 --> invalid
function displayFeedback(is, dio, trial, window_handle, camera_texture, feedbackCode)
if feedbackCode == 1
    DrawFormattedText(window_handle, 'Correct', 'center', 'center');
    %% HA EDIT: display camera icon
    if strcmpi(is.response_modality, 'keyboard')
        displayCamera(is.key_map{trial.transition_key}, window_handle, camera_texture, is);
    end
    %% end of HA edit
%     displayScreenAndSendTrigger(window_handle, is, 0, dio, is.FEEDBACK);
    Screen('Flip', window_handle);
    WaitSecs(is.debug_msg_time);
elseif feedbackCode == -1
    if is.single_key
        DrawFormattedText(window_handle, ['Invalid button. Please use ' is.key_map{2} '.'], 'center', 'center');
    else
        DrawFormattedText(window_handle, ['Invalid button. Please use ' is.key_map{1} ' and ' is.key_map{2} '.'], 'center', 'center');
    end
    %% HA edit: display camera icon
    if strcmpi(is.response_modality, 'keyboard')
        displayCamera(is.key_map{trial.transition_key}, window_handle, camera_texture, is);
    end
    %% end of HA edit
%     displayScreenAndSendTrigger(window_handle, is, 0, dio, is.FEEDBACK);
    Screen('Flip', window_handle);
    WaitSecs(is.error_msg_show_time);
elseif feedbackCode == 0
    if strcmpi(is.response_modality, 'keyboard')
        displayCamera(is.key_map{trial.transition_key}, window_handle, camera_texture, is);
    end
    %% end of HA edit
    DrawFormattedText(window_handle, 'Oops...', 'center', 'center');
%     displayScreenAndSendTrigger(window_handle, is, 0, dio, is.FEEDBACK);
    Screen('Flip', window_handle);
    WaitSecs(is.debug_msg_time);
end
end