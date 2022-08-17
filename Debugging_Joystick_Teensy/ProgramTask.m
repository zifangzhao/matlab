%% last update: March 1, 2019 by Habiba Azab
% 1. create variable in code to turn on/off the response-counterbalancing
% (i.e. key-switching in blocks) option
% 2. create variable in code to switch input between keyboard and joystick
% 3. only display the camera icon if the keyboard is used
% 4. initialize joystick on start and clear on end (if it's being used)
%% Feb 22, 2019 by Habiba Azab
% integrating some of Musa's + Mark Yates' comments
%% NOTE: editing is.font_size can sometimes prevent text from appearing jumbled (40 works for Musa's setup)
%% Dec 29, 2018 by Habiba Azab
% - increased min/max number of animals to 5/10
% - added possible fixation times (i.e. time fixation cross appears between
%   birds); program selects from these at random for each bird (to avoid
%   mindless pressing)
%   NOTE: this only affects real trials, not practice ones (i.e. all trials
%   calling RunOneTrial)
% - switched from single key to dual key version of task


function ProgramTask(subject_id, task_mode, response_modality, recording_flag, dev_string, use_debug_timings, starting_trial)
%
% Last updated July 2018
% Zeb Kurth-Nelson, Matt Botvinick
% Participant observes the inputs (animals) to a finie state machine specified in natural
% language, and tries to match the correct output on each transition.
%
% subject_id is a unique numeric subject identifier of any length. If
%   subject_id is 0, debug messages will be shown. Mandatory argument.
% task_mode is a string which must be either 'practice', 'refresher',
%   'simple_task', or 'full_task'. Practice starts with very simple rules
%   and works up to the most complicated rules, and takes about 30 minutes.
%   Refresher takes about five minutes and is available in case patients
%   want a quick refresher right before doing the full_task experiment.
%   Simple_task is a version of the main experiment with simplified rules.
%   Full_task is the original experiment with the most complex rules.
%   Mandatory argument.
% recording_flag is a boolean flag indicating whether to attempt to send
%   triggers to the nidaq. If it is false, timestamped trigger values will 
%   be written to the console instead for debugging. Defaults to false. 
% dev_string should be either 'Dev1' or 'Dev2', depending on the system
%   the script is being run on. Defaults to 'Dev1'.
% use_debug_timings is a boolean flag indicating whether to use much faster
%   trial events for quick debugging. Defaults to false.
% starting_trial is a positive integer specifying which trial index to
%   start on. usually 1, 34, or 67, for full_task. Defaults to 1.
%% INITIAL SETUP
% close any open ports / free in-use devices
clear JoyMEX;
try
    IOPort('Close', dio);
catch
    disp('could not close dio');
end
%% Unify keyboard names (needed even if joystick is used)
KbName('UnifyKeyNames'); % makes KbName accept same key names on all OSs

%% HIGH-LEVEL PARAMETERS
is.task_version = 2; % Version 2 adds a cover story with colored birds, a practice regime, an optional refresher, and a simplified task mode for the main experiment. 
%% HA EDIT: variable to turn response counterbalancing on/off
is.response_counterbalance = false; % true: key assignments switch between blocks; false: key mappings remain constant
%% HA EDIT: variable to switch input between keyboard/joystick
is.response_modality = response_modality;    % 'joystick' or 'keyboard'
is.joystick_id = 1;     % depends on the joystick; should be included with joystick specifications somewhere
is.movement_threshold = 0.2;      % minimum = 0 (very sensitive), maximum = 1 (max. movement required)

% if joystick is used, initialize it
if strcmpi(is.response_modality, 'joystick')
    addpath('./JoyMEX/');
    addpath('./JoyMEX/MATLAB/');
    JoyMEX('init', is.joystick_id);
    %% set movement threshold
    % threshold indicates how far the joystick has to move up/down/left/right
    % to count as a movement; if subject exhibits trembling and too many false
    % movements, increase this threshold; otherwise, if subject is too weak to
    % move the joystick far enough, may want to decrease the threshold
end
%% END OF HA EDIT

%% Seed random number generator
a = ver('Matlab'); mVersion = str2num(a.Version);  % find Matlab version number
is.rSeed = sum(1000*clock);  % save the seed for replication
if mVersion >= 7.12   % the way to seed changed at Matlab version 7.12
    rng(is.rSeed);
else
    RandStream.setDefaultStream(RandStream('mt19937ar','seed',is.rSeed));
end

%% Process input arguments, and set defaults for optional arguments
is.subject_id = subject_id;
is.task_mode = task_mode;
assert(strcmp(is.task_mode, 'practice') || strcmp(is.task_mode, 'refresher') || strcmp(is.task_mode, 'simple_task') || strcmp(is.task_mode, 'full_task'), ...
    'Second argument to ProgramTask should be ''practice'', ''refresher'', ''simple_task'' or ''full_task''')
%% HA EDIT: add is.practice field
is.practice = strcmp(is.task_mode, 'practice');
%% END OF HA EDIT

%% HA EDIT: change default recording flag to true
if nargin <= 3
    is.recording_flag = true;
else
    is.recording_flag = recording_flag;
end

if nargin <= 4
    is.dev_string = 'Dev1';
else
    is.dev_string = dev_string;
end

if nargin <= 5
    is.use_debug_timings = false;
else
    is.use_debug_timings = use_debug_timings;
end

if nargin <= 6
    is.starting_trial = 1;
else
    is.starting_trial = starting_trial;
end

%% Parameters. 'is' (InfoStruct) contains all the information about the experiment.
%% Task structure parameters
%% HA EDITED
% switched from true to false
is.single_key = false; % should we use a single key (spacebar), or two keys (p and q)?
%% END OF HA EDITS
%% HA EDITED
% switched min from 3 to 5
is.min_animals_per_trial = 5; % shortest trial
% switched max from 6 to 12
is.max_animals_per_trial = 12; % longest trial (uniformly sample between these inclusive endpoints)
%% END OF HA EDITS
is.n_animals = 4; % how many distinct animals in the experiment

%% Timing parameters
is.time_per_image = 5;  % how long to show each animal
%% HA EDITED
% randomize time between birds, to avoid mindless pressing
% (only one option; decided not to jitter fixation time)
is.possible_fixation_times = 1;  % possible fixation times; select one of these at random for each bird
%% END OF HA EDITS
is.error_msg_show_time = 1.5; % duration for displaying button press error messages within a trial
is.feedback_show_time = 1;  % duration for displaying correct/incorrect feedback at the end of a trial
is.debug_msg_time = 0.5; % time to show simple debug message
is.ITI = 2; % inter-trial interval

%% Debug timing parameters to run much faster (should normally be commented)
if is.use_debug_timings
    is.time_per_image = 1;  % how long to show each animal
    is.fixation_time = 0.25; % time for fixation cross before each animal appears
    is.ITI = 0.5; % inter-trial interval
end

%% Cosmetic parameters
is.font_size = 30;  %% HA: was 24
is.fullscreen = true;

%% HA REMOVED TRIGGER CODES SETUP CODE FROM HERE
% allows SetUpFSMs.m (using GenerateTrialsSimple.m) to generate trigger_codes_simple.mat if it's
% not already created; load it otherwise

%% Set up PTB
%% HA DEBUG: make screen translucent for debugging
if is.subject_id == 0
    PsychDebugWindowConfiguration
else
    clear Screen
end
%% end of HA debug
fs = filesep;
AssertOpenGL;  % check graphics
Screen('Preference', 'SkipSyncTests', 1); % Force disable sync tests (Workaround for strange synchronization failure despite apparently correctly calculating the refresh time.)

%% Set up digital triggers
if is.recording_flag
    %% HA EDIT: modify for Teensy
%     dio = digitalio('nidaq', is.dev_string); % This instantiates the digital IO object
%     hline = addline(dio, 0:7, 0, 'Out'); % This adds the 8-bit marker line to the IO object
%     hline2 = addline(dio, 1, 1, 'Out'); % This adds the strobe bit line to the IO object
%     putvalue(dio,[dec2binvec(0,8) 0]); % This initializes all of the bits on both lines to 0
    %% PE'S CODE
    baudRate = 115200;
    portSettings = sprintf('BaudRate=%i',baudRate);
    dio = IOPort('OpenSerialPort', 'COM3', portSettings);
    IOPort('Write', dio, uint8(0));% This is the main line of code that sends the 8 bit length data
    %% END OF PE'S CODE

else
    dio = [];
end

%% Set up results file
assert(strcmp(pwd, fileparts(mfilename('fullpath'))), 'Error -- Path of running .m file isn''t the same as current path') % end the program if the current path isn't the same as where this script is located.
already_loaded_randomization = false;
suffix = 0; done = false;
if ~exist('Results', 'dir'), mkdir('Results'), end % create Results folder at current path if it doesn't already exist
while ~done  % Increment suffix until filename is available
    results_file = ['Results' fs 'ProgramTask_Results_sj' num2str(is.subject_id, '%04d') '_' is.task_mode '_' num2str(suffix, '%02d') '.mat'];
    if exist(results_file,'file')
        suffix = suffix + 1;
        already_loaded_randomization = true;  % preserve the randomization for this subject id (to avoid being confusing)
        S = load(results_file, 'is', 'practice_is');
        if isfield(S, 'is')
            is.key_map = S.is.key_map;
        else
            is.key_map = S.practice_is.key_map;
        end
    else
        done = true;
    end
end

%% Set up randomization, if not loaded from a pre-existing file for this subject id
%% HA EDIT: set-up mapping for joystick vs. keyboard
% note: joystick responses are not randomized across subjects; swiping
% always indicates "skip" and button-press always indicates "take picture"
if strcmpi(is.response_modality, 'joystick')
    is.key_map = {'press the button', 'move the joystick'};
else
    if is.single_key
        is.key_map = {'', 'space'};
    else
        is.key_map = {'w', 'o'}; is.key_map = is.key_map(randperm(2)); % randomize the response keymap between subjects.
    end
end

%% Pre-load the animal image files
is.animal_names = {'Blue', 'Green', 'Red', 'Yellow'};
animal_images = {imread(['Media' fs 'bird-blue.png']) imread(['Media' fs 'bird-green.png']) imread(['Media' fs 'bird-red.png']) imread(['Media' fs 'bird-yellow.png'])}; % 'nt' is with transparency rendered to white background
%% HA edit: also pre-load camera icon file
camera_icon = imread(['Media' fs 'camera_icon.png']);
%% end of HA edit


try % 'try/catch' prevents getting stuck in full screen mode in case of exception
    if strcmpi(is.response_modality, 'keyboard')
        %% Set up keyboard/mouse
         KbCheck; % allow matlab to do some caching to improve timings later
%          ListenChar(2); % disable keypresses getting to matlab. ctrl-c will re-enable.
        %% HA EDIT: Musa's edit; allow mouse cursor to control other things on the screen
    %     HideCursor;  % disable mouse cursor
    end
    
    %% Set up display
    olddebuglevel=Screen('Preference', 'VisualDebuglevel', 3);  % reduce debug messages
    screens=Screen('Screens'); screen_number=max(screens); % will be 0 for single display setup

    if is.fullscreen
        Screen('Preference', 'ConserveVRAM', 64);  % workaround for linux opengl issue
        [window_handle,window_rect]=Screen('OpenWindow',screen_number); % default = white full screen
    else
        Screen('Preference', 'ConserveVRAM', 64);  % workaround for linux opengl issue
        [window_handle,window_rect]=Screen('OpenWindow',screen_number,[],[0 0 1024 768]); % windowed
    end
    Screen('TextSize', window_handle, is.font_size);  % set font size
    is.screen_center = nan(2,1); [is.screen_center(1), is.screen_center(2)] = RectCenter(window_rect);
    %% HA EDIT: also keep track of total size of screen (to place camera icon)
    is.screen_xLeft = window_rect(1);
    is.screen_yTop = window_rect(2);
    is.screen_xRight = window_rect(3);
    is.screen_yBottom = window_rect(4);
    %% end of HA edit
    
    Screen('TextStyle', window_handle, 1)
    
    %% Set up the FSMs, including the transitions and the rule texts
    [is, trials] = SetUpFSMs(is);
    
    %% HA: INSERTED TRIGGER CODES SETUP CODE HERE
    %% Trigger codes (in decimal)
    is.BLOCK_TEXT_ONSET = 115;   % onset of block instructions
    is.RULE_TEXT_ONSET = 116; % onset of rule text display
    is.FIXATION_ONSET = 117;
    is.ITI_START = 118;
    %% HA EDIT: trigger codes for simple and practice tasks
    % simple and full task considered the same
    if strcmp(is.task_mode, 'simple_task') || strcmp(is.task_mode, 'full_task')
        load('trigger_codes_simple') % get the trigger_codes variables
    elseif strcmp(is.task_mode, 'practice')
        load('trigger_codes_practice');
%     else
%         load('trigger_codes') % get the trigger_codes variables
    end
    is.ANIMAL_ONSET = trigger_codes;
%     is.PRACTICE_ANIMAL = 120;  % the code for any animal onset during a practice trial. (we don't use trigger_codes in practice trials because the semantics of the transitions are different.)
    
    is.BUTTON_PRESS = [119 120 121];    % left keys, right keys, invalid OR joystick button, joystick movement, invalid
    is.FEEDBACK = 122;
    is.TIMEOUT = 123;
    %% END OF TRIGGER CODES SETUP CODE

    %% Prepare textures for drawing later
    FixCr=ones(20,20)*255; FixCr(10:11,:)=0; FixCr(:,10:11)=0;
    fixcross = Screen('MakeTexture',window_handle,FixCr);
    animal_texture = cell(4,1);
    for i_animal=1:4
        animal_texture{i_animal} = Screen('MakeTexture',window_handle,animal_images{i_animal});
    end
    %% HA EDIT: same for camera icon
    camera_texture = Screen('MakeTexture', window_handle, camera_icon);
    %% end of HA edit

    %% Go through task instructions
    img_sizes = cell2mat(cellfun(@(x) size(x)', animal_images, 'UniformOutput', false))';
    TaskInstructions(window_handle, is, dio, animal_texture, img_sizes)

    %% HA EDIT
    % use RunOneTrial to run both practice and simple task trials
%     if strcmp(is.task_mode, 'practice') || strcmp(is.task_mode, 'refresher')   % RunPracticeTrials will look at the is.task_mode flag to decide which to do
%         %% Run practice trials
%         RunPracticeTrials(window_handle, dio, is, fixcross, animal_texture, results_file)  % this will modify Results.practice_trials
%     elseif strcmp(is.task_mode, 'simple_task') || strcmp(is.task_mode, 'full_task')
    %% Do the real experiment.
    Results.datetime = datestr(now);
    for i_trial = is.starting_trial:is.n_trials  % loop over trials
        Results.trials(i_trial) = RunOneTrial(window_handle, dio, is, trials(i_trial), fixcross, animal_texture, camera_texture);
        save(results_file, 'Results', 'is', 'trials')  % overwrite results file on every trial, in case we crash
    end % end trial loop
        
        %% Calculate and display performance feedback
        DrawFormattedText(window_handle, 'Thank you for participating!', 'center', 'center');
        Screen('Flip', window_handle);
        getInput(is, 0, 1, 2);
%         KbWait([], 2); %wait for keystroke
%     end
    %% END OF HA EDIT
    
    %% Clean up before exit
    graceful_exit(is,dio);
%     ShowCursor; sca; ListenChar(0); clear JoyMEX; Screen('Preference', 'VisualDebuglevel', olddebuglevel);
    
catch  % In case of an error in the main experiment
    graceful_exit(is,dio);
%     ShowCursor; sca; ListenChar(0); Screen('Preference', 'VisualDebuglevel', olddebuglevel);
    psychrethrow(psychlasterror);  % can disable this if we don't want to see the red error text when we press Escape
end
