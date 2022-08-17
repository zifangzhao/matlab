function varargout = nevSpikeDisp(varargin)
% NEVSPIKEDISP MATLAB code for nevSpikeDisp.fig
%      NEVSPIKEDISP, by itself, creates a new NEVSPIKEDISP or raises the existing
%      singleton*.
%
%      H = NEVSPIKEDISP returns the handle to a new NEVSPIKEDISP or the handle to
%      the existing singleton*.
%
%      NEVSPIKEDISP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NEVSPIKEDISP.M with the given input arguments.
%
%      NEVSPIKEDISP('Property','Value',...) creates a new NEVSPIKEDISP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before nevSpikeDisp_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to nevSpikeDisp_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help nevSpikeDisp

% Last Modified by GUIDE v2.5 01-Dec-2015 15:49:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @nevSpikeDisp_OpeningFcn, ...
                   'gui_OutputFcn',  @nevSpikeDisp_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before nevSpikeDisp is made visible.
function nevSpikeDisp_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to nevSpikeDisp (see VARARGIN)

% Choose default command line output for nevSpikeDisp
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes nevSpikeDisp wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = nevSpikeDisp_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1
global NEV CH filename h
ch_sel=CH(get(hObject,'value'));
AllUnits=NEV.Data.Spikes.Electrode==ch_sel;
if sum(AllUnits)
    unit_num=double(max(NEV.Data.Spikes.Unit(AllUnits)))+1;
    
    Fc=300;
    Fs=NEV.MetaTags.TimeRes;
    [b,a]=butter(3,2*Fc/Fs,'high');
    t=(1:size(NEV.Data.Spikes.Waveform,1))/Fs*1000;
    try
        figure(h);
    catch
        h=figure('Name','Unit Plot Window','NumberTitle','off','NextPlot','replace');
    end
    clf(h);
    set(h,'Name',[filename ' CH:' num2str(ch_sel)],'NumberTitle','off');
    m=round(double(unit_num)^0.5);
    n=ceil(double(unit_num)^0.5);
    m(m<2)=2;
    n(n<2)=2;
    for idx=1:unit_num
        subplot(m,n,idx)
        unit_sel=AllUnits&(NEV.Data.Spikes.Unit==(idx-1));
        wave=double(NEV.Data.Spikes.Waveform(:,find(unit_sel))');
        wave=filtfilt(b,a,wave')';
        shadedErrorBar(t,wave,{@mean,@std});
        xlabel('ms');
        ylabel('uV')
        axis tight
        title(['CH:' num2str(ch_sel) ' UNIT:' num2str(idx-1) ' FR:' num2str(sum(unit_sel)/NEV.MetaTags.DataDurationSec) 'Hz']);
    end
end
% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global filename NEV CH rat_montage
[f p]=uigetfile('.mat','Open NEV matlab file');
filename=[p f];
cd(p);
set(handles.text2,'String',filename);
NEV=importdata(filename,'-struct');
CH=unique(NEV.Data.Spikes.Electrode');
set(handles.listbox1,'String',num2str(CH));
set(handles.pushbutton2,'Enable','On');
rat_montage=[];
set(handles.text4,'String','No montage will be applied');
% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global rat_montage CH
[f p]=uigetfile('.mtg','Load montage file');
rat_montage=importdata([p f]);
set(handles.text4,'String',{'current montage: ',[p f]});
allIdx=cell2mat(cellfun(@(x) x.channelNo,rat_montage,'UniformOutput',0));
allCH=cell2mat(cellfun(@(x) x.channel,rat_montage,'UniformOutput',0));
comm_idx=(double(CH)*ones(1,length(allCH)))'==allCH'*ones(1,length(CH));
idx_in=find(sum(comm_idx,2));
CH=allCH(idx_in)';
str=num2str(CH);
current_end=size(str,2);
for idx=1:size(str,1);
    currentIdx=num2str(allIdx(idx_in(idx))-1);
    str(idx,current_end+1:current_end+2+length(currentIdx))=['(' currentIdx ')'];
end
set(handles.listbox1,'String',str);
