%% HA EDIT: function now sends triggers to Teensy system
function [  ] = SendTrigger( is, dio, trigger_value )
% set dio to the trigger value, pause, and set back to zero.

if is.recording_flag
    %% HA EDIT
%     putvalue(dio,[dec2binvec(trigger_value,8) 1]); % This sends the strobe bit and the 8-bit code to the DAQ
%     pause(.005); % This waits for 5 ms to allow matlab enough time to send the codes and move on
%     putvalue(dio,[dec2binvec(0,8) 0]); % This resets the digital outputs to 0
    %% PE'S CODE
    IOPort('Write', dio, uint8(trigger_value));% This is the main line of code that sends the 8 bit length data
    %% END OF PE'S CODE
    pause(0.1);   % wait 100 ms for matlab to send codes and move on; as above
    IOPort('Write', dio, uint8(0));% This is the main line of code that sends the 8 bit length data
    %% END OF HA EDIT
else
    disp(['trigger ' num2str(trigger_value) ' at ' datestr(rem(now,1), 'HH:MM:SS:FFF')])
end


end

