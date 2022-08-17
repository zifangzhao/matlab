function varargout = stat_fig(varargin)
% STAT_FIG MATLAB code for stat_fig.fig
%      STAT_FIG, by itself, creates a new STAT_FIG or raises the existing
%      singleton*.
%
%      H = STAT_FIG returns the handle to a new STAT_FIG or the handle to
%      the existing singleton*.
%
%      STAT_FIG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STAT_FIG.M with the given input arguments.
%
%      STAT_FIG('Property','Value',...) creates a new STAT_FIG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before stat_fig_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to stat_fig_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help stat_fig

% Last Modified by GUIDE v2.5 20-Mar-2012 16:59:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @stat_fig_OpeningFcn, ...
                   'gui_OutputFcn',  @stat_fig_OutputFcn, ...
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


% --- Executes just before stat_fig is made visible.
function stat_fig_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to stat_fig (see VARARGIN)

% Choose default command line output for stat_fig
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes stat_fig wait for user response (see UIRESUME)

global map_all selected_attr;
map_all=varargin{1};
selected_attr=1;
set(handles.slider1,'Max',size(map_all,2)-1.1);
% set(handles.slider1,'Min',0);
set(handles.listbox1,'String',map_all{selected_attr}');
set(handles.listbox1,'Max',size(map_all{selected_attr},2));
uiwait(handles.figure1);
% --- Outputs from this function are returned to the command line.
function varargout = stat_fig_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
global selected_attr selected_index;
varargout{1}=[];%handles.output;
varargout{2}=selected_attr;
varargout{3}=selected_index;

% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global map_all selected_attr;
% len=size(map_all,1);
selected_attr=round(get(handles.slider1,'value')+1);
set(handles.listbox1,'String',map_all{selected_attr}');
set(handles.listbox1,'Max',size(map_all{selected_attr},2)-1);

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1
global selected_index;
selected_index=get(handles.listbox1,'Value');

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
uiresume(handles.figure1);
global selected_attr selected_index;
varargout{2}=selected_attr;
varargout{3}=selected_index;

close 
