%% HA EDITS: functions to detect input and classify as correct / incorrect
% to make sense of both joystick and keyboard inputs
% INPUTS:
% is: just the 'is' struct passed to this function
% joystickMove: flag indicating whether joystick move is accepted
% joystickButton: flag indicating whehtehr joystick button is accepted
% timeOut: how long to wait for a response (wait duration, in seconds)
% OUTPUTS:
% response: ID of escape key if pressed, otherwise if keyboard is used, ID
% of pressed key is returned, otherwise if joystick is used: either a
% single number indicating the button pressed, or a 1x2 vector indicating
% the (X,Y) position of the joystick (if it moved beyond the movement
% threshold)
% reponseTime: time of response; currently using GetSecs for joystick
% timestamps; improve upon this if you know a better way!
% this function will only return upon detecting an "acceptable" input: this
% is the ESCAPE button (at any point of the trial), any keyboard button (if
% the input modality is the keyboard), a joystick movement (if input modality is joystick and joystickMove
% = 1), or a joystick button press (if input modality is joystick and joystickButton = 1)
%% EDITED: now accepts input either from the keyboard or the joystick exclusively (issues on the Baylor end)
%% WARNING: these same issues mean the keyboard input won't work at Baylor. 
function [response, responseTime] = getInput(is, joystickMove, joystickButton, timeOut)
JOYSTICK_ESCAPEBUTTON = 11; % designated escape button ID
bufferDelay = 0.3;  % s; to prevent input from carrying over to the next call of this function; KEEP THIS AS LOW AS POSSIBLE
response = NaN;
responseTime = NaN;
if ~exist('timeOut', 'var')
    timeOut = Inf;  % no timeout specified; wait forever
end
escapeKeyIx = KbName('ESCAPE');
%% split into two while loops to speed both up
if strcmpi(is.response_modality, 'keyboard')
    % create and start keyboard queue
    KbQueueCreate();
    KbQueueStart();
    
    startTime = GetSecs;
    while isnan(response)
        if (GetSecs - startTime) > timeOut
            break;
        end
        %% check keyboard queue for key presses
        % pressed: boolean, 1 for index of pressed key
        % firstPress: time each key was pressed, 0 if not
        [pressed, firstPress] = KbQueueCheck();

        %% check for key press
        if pressed 
            if firstPress(escapeKeyIx) > 0
                response = 'ESCAPE';
                responseTime = firstPress(escapeKeyIx);
                break;
            else
                % get the first key pressed
                response = KbName(find(firstPress>0,1));
                responseTime = firstPress(find(firstPress>0,1));
                break;
            end
        end
    end
    KbQueueRelease();
else                            %% joystick
    startTime = GetSecs;
    while isnan(response)
        if (GetSecs - startTime) > timeOut
            break;
        end
%         %% check keyboard queue for key presses (mainly for escape key)
%         % pressed: boolean, 1 for index of pressed key
%         % firstPress: time each key was pressed, 0 if not
%         [pressed, firstPress] = KbQueueCheck();

%         %% check for escape key
%         if pressed
%             response = 'ESCAPE';
%             responseTime = firstPress(escapeKeyIx);
%             break;
%         end
        
        %% check for joystick input
        [stick,button] = JoyMEX(is.joystick_id);
        timeStamp = GetSecs;
        if joystickButton && sum(button) > 0
            response = find(button==1,1);
            responseTime = timeStamp;
            if response == JOYSTICK_ESCAPEBUTTON
                response = 'ESCAPE';
            end
        elseif joystickMove && abs(stick(1)) >= is.movement_threshold || abs(stick(2)) >= is.movement_threshold
            responseTime = timeStamp;
            response = [stick(1) stick(2)];
        end
    end
    WaitSecs(bufferDelay);
end
end