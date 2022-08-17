[f,p]=uigetfile('*.clu.*'); %Select file
cd(p);  %Change directory 
[units,waveform]=neurosuite_loadunits([p,f]); %Load spike time to units, waveform to waveform
neurosuite_plotUnits(units,waveform);