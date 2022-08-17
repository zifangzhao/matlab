%% input to photodiode
function [actualOnsetTime, stimulusOnsetTime] = displayScreenAndSendTrigger(window_handle, is, setOnsetTime, dio, trigger_value)
squareWidth = 300;
squareDisplayTime = 0.1;  % s
% display black square in bottom-right corner (while keeping the rest of
% the screen intact)

Screen('FillRect', window_handle, BlackIndex(window_handle), CenterRectOnPointd([0 0 squareWidth squareWidth], is.screen_xRight, is.screen_yBottom));
[actualOnsetTime, stimulusOnsetTime] = Screen('Flip', window_handle, setOnsetTime, 1);

% trigger code
if is.recording_flag && ~isnan(trigger_value)
    %% Teensy
    IOPort('Write', dio, uint8(trigger_value));% This is the main line of code that sends the 8 bit length data
    %% Analog triggers
    soundsignal(trigger_value,8);
end

% keep on
% WaitSecs(squareDisplayTime);
% replace with a white square (to keep the rest of the screen intact)
Screen('FillRect', window_handle, WhiteIndex(window_handle), CenterRectOnPointd([0 0 squareWidth squareWidth], is.screen_xRight, is.screen_yBottom));
Screen('Flip', window_handle, stimulusOnsetTime+squareDisplayTime);

if is.recording_flag && ~isnan(trigger_value)
    %% Teensy
    IOPort('Write', dio, uint8(0));% This is the main line of code that sends the 8 bit length data
    %% Analog triggers
    soundsignal(0,8);
end
end