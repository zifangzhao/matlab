%% input to photodiode
function [actualOnsetTime, stimulusOnsetTime] = displayScreen(window_handle, is, setOnsetTime)
squareWidth = 100;
squareDisplayTime = 0.1;  % s
% display black square in bottom-right corner (while keeping the rest of
% the screen intact)
Screen('FillRect', window_handle, BlackIndex(window_handle), CenterRectOnPointd([0 0 squareWidth squareWidth], is.screen_xRight, is.screen_yBottom));
[actualOnsetTime, stimulusOnsetTime] = Screen('Flip', window_handle, setOnsetTime, 1);
% keep on
% WaitSecs(squareDisplayTime);
% replace with a white square (to keep the rest of the screen intact)
Screen('FillRect', window_handle, WhiteIndex(window_handle), CenterRectOnPointd([0 0 squareWidth squareWidth], is.screen_xRight, is.screen_yBottom));
Screen('Flip', window_handle, stimulusOnsetTime+squareDisplayTime);
end