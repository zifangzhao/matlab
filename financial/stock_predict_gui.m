function varargout = stock_predict_gui(varargin)
% STOCK_PREDICT_GUI MATLAB code for stock_predict_gui.fig
%      STOCK_PREDICT_GUI, by itself, creates a new STOCK_PREDICT_GUI or raises the existing
%      singleton*.
%
%      H = STOCK_PREDICT_GUI returns the handle to a new STOCK_PREDICT_GUI or the handle to
%      the existing singleton*.
%
%      STOCK_PREDICT_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STOCK_PREDICT_GUI.M with the given input arguments.
%
%      STOCK_PREDICT_GUI('Property','Value',...) creates a new STOCK_PREDICT_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before stock_predict_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to stock_predict_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help stock_predict_gui

% Last Modified by GUIDE v2.5 08-Aug-2016 09:20:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @stock_predict_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @stock_predict_gui_OutputFcn, ...
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


% --- Executes just before stock_predict_gui is made visible.
function stock_predict_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to stock_predict_gui (see VARARGIN)

% Choose default command line output for stock_predict_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes stock_predict_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = stock_predict_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data ix
idx=get(handles.popupmenu2,'value');
if idx==1
    ix=1:length(data.predicted_filled);
else
   [~, ix]=sort(data.evaluate_mat{idx-1},'descend');
end
sel_idx=cellfun(@(x) ~isempty(strfind(x.name,get(handles.edit1,'string'))),data.predicted_filled(ix));
ix=ix(sel_idx);
dispStock(handles);
% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global filename data ix
[f,p]=uigetfile('*.mat','选择已经分析完成的matlab文件');
filename=[p f];
set(handles.text3,'String',filename);
data=load(filename);
ix=1:length(data.predicted_filled);
days=data.days;
lgd=cell(length(days)+1,1);
lgd{1}='股票编号';
for d_idx=1:length(days);
    lgd{d_idx+1}=['预测' num2str(days(d_idx)) '天'];
end
set(handles.popupmenu2,'string',lgd);

dispStock(handles);

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data
stock_analysis_tsne_day;
data=load;

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ix data
idx=get(handles.popupmenu2,'value');
if idx==1
    ix=1:length(data.predicted_filled);
else
   [~, ix]=sort(data.evaluate_mat{idx-1},'descend');
end
dispStock(handles);

% --- Executes when selected cell(s) is changed in uitable1.
function uitable1_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
global sel_index
try
    sel_index=eventdata.Indices(1);
    set(handles.pushbutton5,'enable','on');
end
% --------------------------------------------------------------------
function uitable1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% hold on;


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2

global ix data
idx=get(hObject,'value');
if idx==1
    ix=1:length(data.predicted_filled);
else
   [~, ix]=sort(data.evaluate_mat{idx-1},'descend');
end
dispStock(handles);

% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sel_index data ix
% ix=data.ix;
% axes(handles.axes1);
% cla(handles.axes1);
sel=ix(sel_index);
tag=data.predicted_filled{sel}.data;
tag_fitted=data.predicted_filled{sel}.fitted;
days=data.days;
plot_day=str2double(get(handles.edit2,'string'));
start_idx=length(tag)-plot_day+1;
start_idx(start_idx-days(end)<1)=1+days(end);
p_idx=1;

% hold on;
p_clr={'r','g','b','a','c'};
lgd{1}='原始值';
for d_idx=1:length(days);
    subplot(length(days),1,p_idx,'parent',handles.uipanel3);p_idx=p_idx+1;
    
    p_day=days(d_idx);
    plot(tag(start_idx:end),'k');hold on;
    plot(tag_fitted{d_idx}(start_idx-p_day:end),p_clr{d_idx});
   title([data.predicted_filled{sel}.name ' 预测' num2str(days(d_idx)) '天']);
    axis tight
    hold off;
end

function dispStock(handles)
global filename data ix
days=data.days;
lgd=cell(length(days)+1,1);
lgd{1}='股票编号';
for d_idx=1:length(days);
    lgd{d_idx+1}=['预测' num2str(days(d_idx)) '天'];
end

set(handles.uitable1,'ColumnName',lgd);
dispMat=cell(length(data.evaluate_mat{1}(ix)),4);
for idx=2:4
    dispMat(:,idx)=arrayfun(@(x) [num2str(100*x) '%'],data.evaluate_mat{idx-1}(ix),'UniformOutput',0);
end
dispMat(:,1)=data.rate_predict_name(ix);
set(handles.uitable1,'Data',dispMat);
set(handles.pushbutton5,'enable','off');



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double
 pushbutton5_Callback(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
