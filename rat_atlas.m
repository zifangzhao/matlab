function varargout = rat_atlas(varargin)
% RAT_ATLAS MATLAB code for rat_atlas.fig
%      RAT_ATLAS, by itself, creates a new RAT_ATLAS or raises the existing
%      singleton*.
%
%      H = RAT_ATLAS returns the handle to a new RAT_ATLAS or the handle to
%      the existing singleton*.
%
%      RAT_ATLAS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RAT_ATLAS.M with the given input arguments.
%
%      RAT_ATLAS('Property','Value',...) creates a new RAT_ATLAS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before rat_atlas_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to rat_atlas_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help rat_atlas

% Last Modified by GUIDE v2.5 31-Mar-2017 09:59:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @rat_atlas_OpeningFcn, ...
                   'gui_OutputFcn',  @rat_atlas_OutputFcn, ...
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


% --- Executes just before rat_atlas is made visible.
function rat_atlas_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to rat_atlas (see VARARGIN)

% Choose default command line output for rat_atlas
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
global file_info
namebase='s:\Lab data\rat atlas\atlas_页面_';
start_idx=44;
end_idxc=204;
end_idxs=223;
end_idxt=250;
file_info=cell(end_idxt-start_idx+1,1);
c_list=start_idx:end_idxc;
for idx=1:length(c_list)
    file_info{idx}=dlmread([namebase num2str(c_list(idx),'%03d') '.txt'],' ');
end
h=figure('Name','Coronal Plane','NumberTitle','off');
im=imread('s:\Lab data\rat atlas\atlas_页面_044.tif');

c_scale=157.9; %pixel to mm
x_tick=((1:size(im,2))-file_info{1}(1))/c_scale+file_info{1}(4);
y_tick=((1:size(im,1))-file_info{1}(2))/c_scale+file_info{1}(5);
image(x_tick,y_tick,im);
xlabel('Lateral/mm')
ylabel('Depth/mm')
h=figure('Name','Sagital Plane','NumberTitle','off');
image(imread('s:\Lab data\rat atlas\atlas_页面_162.tif'));
h=figure('Name','Transverse Plane','NumberTitle','off');
image(imread('s:\Lab data\rat atlas\atlas_页面_181.tif'));
% UIWAIT makes rat_atlas wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = rat_atlas_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
