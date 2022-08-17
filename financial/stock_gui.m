function varargout = stock_gui(varargin)
% STOCK_GUI MATLAB code for stock_gui.fig
%      STOCK_GUI, by itself, creates a new STOCK_GUI or raises the existing
%      singleton*.
%
%      H = STOCK_GUI returns the handle to a new STOCK_GUI or the handle to
%      the existing singleton*.
%
%      STOCK_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STOCK_GUI.M with the given input arguments.
%
%      STOCK_GUI('Property','Value',...) creates a new STOCK_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before stock_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to stock_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help stock_gui

% Last Modified by GUIDE v2.5 09-Jul-2013 17:27:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @stock_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @stock_gui_OutputFcn, ...
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


% --- Executes just before stock_gui is made visible.
function stock_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to stock_gui (see VARARGIN)

% Choose default command line output for stock_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes stock_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);
% global stock
try
    cwd=['E:\stock'];
    cd(cwd);
end
set(handles.text8,'String',pwd);

% --- Outputs from this function are returned to the command line.
function varargout = stock_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



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



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


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



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
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
try
    cwd=['E:\stock'];
    cd(cwd);
end
cd(uigetdir(pwd));
set(handles.text8,'String',pwd);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global stock stock_ori para_sel ix column selected_para fft_day predict_avg
% try
%     cwd=['E:\stock'];
%     cd(cwd);
% end
para_sel=find([get(handles.checkbox1,'Value') get(handles.checkbox2,'Value') get(handles.checkbox3,'Value')...
        get(handles.checkbox4,'Value') get(handles.checkbox5,'Value') get(handles.checkbox6,'Value') get(handles.checkbox7,'Value')]);
days=str2double(get(handles.edit1,'String'));  %Days to analysis
fft_day_ratio=str2double(get(handles.edit2,'String'));    
gen=str2double(get(handles.edit5,'String'));
popu=str2double(get(handles.edit6,'String'));
tol=str2double(get(handles.edit7,'String'));
day_predict=str2double(get(handles.edit3,'String'));
fft_day=ceil(fft_day_ratio*days);
day_pre=1;
levels=30;
[stock predict_avg column selected_para]=stock_script_ga_all_profit(days,fft_day,day_predict,day_pre,gen,popu,tol,0,levels);
save(['stock' date],'stock','predict_avg','column','selected_para','fft_day','para_sel');
stock_ori=stock;
market_num=(get(handles.edit11,'String'));
if ~isempty(market_num)
    stock_on_market_idx=find(cellfun(@(x) strcmp(x.name(1:length(market_num{1})),market_num),stock));
else
    stock_on_market_idx=1:length(stock);
end
[~,ix]=sort(max(predict_avg(stock_on_market_idx,:),[],2),'descend');
stock_output=cell(length(stock_on_market_idx)+1,3);
stock_output{1,1}='名称';
stock_output{1,2}='预测最大值';
stock_output{1,3}='预测平均值';
stock=stock(stock_on_market_idx);
for idx=1:length(stock)
    stock_output{idx+1,1}=stock{ix(idx)}.name;
    stock_output{idx+1,2}=max(stock{ix(idx)}.predict(:,1));
    stock_output{idx+1,3}=mean(stock{ix(idx)}.predict(:,1));
end
set(handles.uitable1,'Data',stock_output);

% save(['stock' date],'stock','predict_avg','column','selected_para','stock_ori','ix','fft_day','para_sel');
% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3


% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox4


% --- Executes on button press in checkbox5.
function checkbox5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox5


% --- Executes on button press in checkbox6.
function checkbox6_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox6


% --- Executes on key press with focus on uitable1 and none of its controls.
function uitable1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
global current_selected_row stock ix column  selected_para fft_day
if strcmp('space',eventdata.Key);
    day_predict=str2double(get(handles.edit3,'String'));
    stock_current=stock{ix(current_selected_row-1)};
    figure(2);
%         stock_predict(stock_current.x,data_analysis_ori,fft_day,day_predict,selected_para,stock_current.name,column);
%         stock_predict_v2(stock_current.x,stock_current.data_analysis,fft_day,day_predict,...
%             selected_para,stock_current.name,column,1,stock_current.maxs,stock_current.mins,...
%             stock_current.profit,length(selected_para),...
%             stock_current.st_h(end-stock_current.offset-size(stock_current.data_analysis,2)+1:end-stock_current.offset,:),...
%             stock_current.bias_full');
%         figure(3);
    stock_predict_v3(stock_current,selected_para,day_predict,1);
end


% --- Executes when selected cell(s) is changed in uitable1.
function uitable1_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
global current_selected_row
if ~isempty(eventdata.Indices)
    current_selected_row=eventdata.Indices(1);
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)  %读取旧文件
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global stock stock_ori para_sel ix column  selected_para fft_day predict_avg
uiopen();
stock_ori=stock;
market_num{1}=(get(handles.edit11,'String'));
if ~isempty(market_num)
    stock_on_market_idx=find(cellfun(@(x) strcmp(x.name(1:length(market_num{1})),market_num),stock));
else
    stock_on_market_idx=1:length(stock);
end

[~,ix]=sort(max(predict_avg(stock_on_market_idx,:),[],2),'descend');

stock_output=cell(length(stock_on_market_idx)+1,3);
stock_output{1,1}='名称';
stock_output{1,2}='预测最大值';
stock_output{1,3}='预测平均值';
stock=stock(stock_on_market_idx);
for idx=1:length(stock)
    stock_output{idx+1,1}=stock{ix(idx)}.name;
    stock_output{idx+1,2}=max(stock{ix(idx)}.predict(:,1));
    stock_output{idx+1,3}=mean(stock{ix(idx)}.predict(:,1));
end
set(handles.uitable1,'Data',stock_output);


% save('stock');



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles) %找特定股票
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global stock para_sel ix column data_analysis_ori selected_para fft_day
searchname=get(handles.edit8,'String');
stock_output=get(handles.uitable1,'Data');
idx=find(cellfun(@(x) ~isempty(strfind(x,searchname)),stock_output(:,1)));
if ~isempty(idx);
    idx=idx(1)-1;
    day_predict=str2double(get(handles.edit3,'String'));
    stock_current=stock{ix(idx)};
    figure(2);
    stock_predict_v3(stock_current,selected_para,day_predict,1);
%     stock_predict_v2(stock_current.x,stock_current.data_analysis,fft_day,day_predict,...
%         selected_para,stock_current.name,column,1,stock_current.maxs,stock_current.mins,...
%         stock_current.profit,length(selected_para),...
%         stock_current.st_h(end-stock_current.offset-size(stock_current.data_analysis,2)+1:end-stock_current.offset,:),...
%         stock_current.bias_full');
else
    msgbox('没有找到结果');
end


% --- Executes on button press in checkbox7.
function checkbox7_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox7



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)%筛选键
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global stock stock_ori para_sel ix column  selected_para fft_day predict_avg
% uiopen();
stock=stock_ori;
market_num{1}=(get(handles.edit11,'String'));
if ~isempty(market_num)
    stock_on_market_idx=find(cellfun(@(x) strcmp(x.name(1:length(market_num{1})),market_num),stock));
else
    stock_on_market_idx=1:length(stock);
end

[~,ix]=sort(max(predict_avg(stock_on_market_idx,:),[],2),'descend');

stock_output=cell(length(stock_on_market_idx)+1,3);
stock_output{1,1}='名称';
stock_output{1,2}='预测最大值';
stock_output{1,3}='预测平均值';
stock=stock(stock_on_market_idx);
for idx=1:length(stock)
    stock_output{idx+1,1}=stock{ix(idx)}.name;
    stock_output{idx+1,2}=max(stock{ix(idx)}.predict(:,1));
    stock_output{idx+1,3}=mean(stock{ix(idx)}.predict(:,1));
end
set(handles.uitable1,'Data',stock_output);



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


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global current_selected_row stock ix column  selected_para fft_day
if strcmp('space',eventdata.Key);
    day_predict=str2double(get(handles.edit3,'String'));
    stock_current=stock{ix(current_selected_row-1)};
    figure(2);
%         stock_predict(stock_current.x,data_analysis_ori,fft_day,day_predict,selected_para,stock_current.name,column);
%         stock_predict_v2(stock_current.x,stock_current.data_analysis,fft_day,day_predict,...
%             selected_para,stock_current.name,column,1,stock_current.maxs,stock_current.mins,...
%             stock_current.profit,length(selected_para),...
%             stock_current.st_h(end-stock_current.offset-size(stock_current.data_analysis,2)+1:end-stock_current.offset,:),...
%             stock_current.bias_full');
%         figure(3);
    stock_predict_v3(stock_current,selected_para,day_predict,1);
end
