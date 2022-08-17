%% DAT triggered event wavelet analysis
[f p]=uigetfile('*.dat');
disp('File load successful,looking for evt file');
f_evt=dir([f(1:end-9) '*.evt']);
if ~isempty(f_evt)
    str=arrayfun(@(x) x.name,f_evt,'UniformOutput',0);
    [s,~] = listdlg('PromptString','Select event file',...
    'SelectionMode','single',...
    'ListString',str);
    evt=LoadEvents(f_evt(s).name);
    st_time=evt(1:3:end); %start time for each event
    
else
    disp(['Corresponding EVT file is not found!'])
end
