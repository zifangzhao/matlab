
%% Characterize an LED using live current and voltage measurements
% 
% This example uses MATLAB® to connect to an ADALM1000 source-measurement unit, 
% configure it, and make current and voltage measurements to characterize an LED.

%%
% Copyright 2015-2017 The MathWorks, Inc.

%% Introduction
% Using functionality in toolboxes such as Data Acquisition Toolbox™ and 
% Instrument Control Toolbox™, MATLAB can connect to, configure, and control 
% hardware to setup experiments and retrieve data. You can use the measured data 
% for signal processing, visualization, and algorithm design using the 
% rich set of functions in MATLAB and its toolboxes.

%% Discover supported data acquisition devices connected to your system 
daq.getDevices

%% Create a session using the ADALM1000 device.
ADISession = daq.createSession('adi');

%% Add voltage source and current measurement channels 
% The ADALM1000 device is capable of sourcing voltage and measuring current
% drawn on a specified channel. Set up the device in this mode.

% Add an analog output channel with device ID SMU1 and channel ID A, 
% and set its measurement type to Voltage.
addAnalogOutputChannel(ADISession,'smu1','a','Voltage');

% Add an analog input channel with device ID SMU1 and channel ID A,
% and set its measurement type to Current. 
addAnalogInputChannel(ADISession,'smu1','a','Current');

% Confirm the configuration of the session
ADISession

Voltage=3.7;
scan_interval=1/10e3;
max_length=7200;%in second
N=max_length/scan_interval;

result=zeros(round(N),2);
outputSingleScan(ADISession,Voltage); 
tic;
te=0;
iLoop=0;
while(te<max_length)
    iLoop=iLoop+1;
    % Turn on LED by sending an output of 5V
    te=toc;
    result(iLoop,1)=te;
    result(iLoop,2)=inputSingleScan(ADISession);
    %pause(scan_interval);
    % Turn on LED by sending an output of 0V
    disp(['ChannelA Voltage=' num2str(Voltage) 'V, Current=' sprintf('%05.1f',result(iLoop,2)*1000) 'mA, Time=' num2str(round(te)) 's']);

result=zeros(N,1);
outputSingleScan(ADISession,Voltage); 
for iLoop = 1:N
    % Turn on LED by sending an output of 5V
    result(iLoop)=inputSingleScan(ADISession);
    pause(scan_interval);
    % Turn on LED by sending an output of 0V
    disp(['CH_A: Voltage:' num2str(Voltage) 'V,Current=' num2str(result(iLoop)*1000) 'mA'])
end
result=result(1:iLoop,:);

%% Turn the LED off and clear the session
outputSingleScan(ADISession,0);
clear ADISession
