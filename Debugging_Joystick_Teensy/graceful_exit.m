function graceful_exit(is, dio)
% exit gracefully
ShowCursor; sca; 
if strcmpi(is.response_modality, 'joystick')
    clear JoyMEX;
else
    ListenChar(0);
    KbQueueRelease();
end
if is.recording_flag
    %% HA EDIT: close Teensy port (PE'S CODE)
    IOPort('Close',dio);
    fprintf('Port Closed!\n')
    %% END OF PE'S CODE
end
% error('Escape pressed -- exiting')
Screen('Preference', 'VisualDebuglevel', 3);
disp('Escape pressed -- exiting');
end