function varargout = result_selection(varargin)
%test_result快捷结果显示GUI
%2012-4-17 created by Zifang Zhao

% RESULT_SELECTION MATLAB code for result_selection.fig
%      RESULT_SELECTION, by itself, creates a new RESULT_SELECTION or raises the existing
%      singleton*.
%
%      H = RESULT_SELECTION returns the handle to a new RESULT_SELECTION or the handle to
%      the existing singleton*.
%
%      RESULT_SELECTION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RESULT_SELECTION.M with the given input arguments.
%
%      RESULT_SELECTION('Property','Value',...) creates a new RESULT_SELECTION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before result_selection_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to result_selection_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help result_selection

% Last Modified by GUIDE v2.5 17-Apr-2012 23:51:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @result_selection_OpeningFcn, ...
                   'gui_OutputFcn',  @result_selection_OutputFcn, ...
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


% --- Executes just before result_selection is made visible.
function result_selection_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to result_selection (see VARARGIN)

% Choose default command line output for result_selection
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes result_selection wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = result_selection_OutputFcn(hObject, eventdata, handles) 
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


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)% load matfile & create attr map 
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global test_result map_attr_allA map_attr_allB map_attr_groupedA map_attr_groupedB map_regionA map_regionB
[filename pathname]=uigetfile('*.mat','Select test result mat-file');
m=load([pathname filename]);    %grouped
test_result=m.test_result;
%显示可选子集
fld_temp=fieldnames(test_result{1});
fld=[];
for idx=1:length(fld_temp)
    if ~isempty(strfind(fld_temp{idx},'test'))
        fld=[fld fld_temp(idx)];
    end
end
set(handles.listbox6,'String',fld);
set(handles.listbox6,'Enable','on');
%% 做出分组名称地图 map_attr_all A,B map_region A,B
map_attr_tempA=cellfun(@(x) x.attrname{1}',test_result,'UniformOutput',false); %作出分组名称列表
map_attr_allA=[map_attr_tempA{:}];
map_attr_groupedA=cell(1,size(map_attr_allA,1));
for m=1:size(map_attr_allA,1)
    map_attr_groupedA{m}=unique([map_attr_allA{m,:}]);
end
map_attr_tempB=cellfun(@(x) x.attrname{2}',test_result,'UniformOutput',false); %作出分组名称列表
map_attr_allB=[map_attr_tempB{:}];
map_attr_groupedB=cell(1,size(map_attr_allB,1));
for m=1:size(map_attr_allB,1)
    map_attr_groupedB{m}=unique([map_attr_allB{m,:}]);
end
map_regionA=cellfun(@(x) x.region(1),test_result,'UniformOutput',false); %作出分组名称列表
map_regionA=[map_regionA{:}];

map_region_groupedA=unique(map_regionA);

map_regionB=cellfun(@(x) x.region(2),test_result,'UniformOutput',false); %作出分组名称列表
map_regionB=[map_regionB{:}];

map_region_groupedB=unique(map_regionB);



%% 向控件里设置相应的值
%listbox2,listbox3->两个region选择框
set(handles.listbox2,'String',map_region_groupedA);
set(handles.listbox3,'String',map_region_groupedB);
set(handles.listbox2,'Enable','on');
set(handles.listbox3,'Enable','on');
%listbox5->选择需要对比的legend标签级别
str=cellfun(@(x,y) [[x{:}] ' vs ' [y{:}]],map_attr_groupedA(:),map_attr_groupedB(:),'UniformOutput',0);
set(handles.listbox5,'String',str);
set(handles.listbox5,'Enable','on');
% [s,v] = listdlg('PromptString','选择需要进行结果对比的标签集',...
%     'SelectionMode','single',...
%     'ListString',str);
% compareset_idx=s;


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2


% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox3.
function listbox3_Callback(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox3


% --- Executes during object creation, after setting all properties.
function listbox3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles) %遴选数据
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global test_result map_attr_allA map_attr_allB map_regionA map_regionB
%开启数据显示 uitable1
set(handles.uitable1,'Enable','On');

%从输入中提取标签
label_manual_A=attr_extracter(get(handles.edit1,'String'),' '); %人工输入标签A
% label_manual_B=attr_extracter(get(handles.edit3,'String'),' '); %人工输入标签B
temp=get(handles.listbox1,'String');
label_compare_A=temp(get(handles.listbox1,'Value'));            %对比标签
temp=get(handles.listbox2,'String');
label_region_A=temp(get(handles.listbox2,'Value'));             %脑区标签A
temp=get(handles.listbox3,'String');
label_region_B=temp(get(handles.listbox3,'Value'));             %脑区标签B
temp=get(handles.listbox6,'String');
test_type=temp(get(handles.listbox6,'Value'));                  %检验种类 
temp=get(handles.listbox4,'String');
sub_type=temp(get(handles.listbox4,'Value'));                   %测试类型分类

labelA=[label_manual_A,label_compare_A];
labelB=[label_manual_A];
label_compare_B=get(handles.uitable1,'ColumnName');
locA=ones(1,size(map_attr_allA,2));



locRA=(cell2mat(cellfun(@(x) (strcmp(x,label_region_A)),map_regionA,'UniformOutput',0)));
locRB=(cell2mat(cellfun(@(x) (strcmp(x,label_region_B)),map_regionB,'UniformOutput',0)));
for idx=1:length(labelA)
    locA=locA&sum(cell2mat(cellfun(@(x) sum(strcmp(x,labelA(idx))),map_attr_allA,'UniformOutput',0)));
end
loc=cell(1,length(label_compare_B));
for idx1=1:length(label_compare_B)
    labelB_current=[labelB label_compare_B(idx1)];
    locB=ones(1,size(map_attr_allB,2));
    for idx2=1:length(labelB_current)
        locB=locB&sum(cell2mat(cellfun(@(x) sum(strcmp(x,labelB_current(idx2))),map_attr_allB,'UniformOutput',0)));    
    end
    loc{idx1}=locA&locB&locRA&locRB;
end
selected_result=nan(max(cell2mat(cellfun(@(x) length(find(x)),loc,'UniformOutput',0))),length(label_compare_B));
for idx1=1:length(label_compare_B)
    eval(['temp=cell2mat(cellfun(@(x) x.' test_type{1} '.' sub_type{1} ',test_result(loc{idx1}),''UniformOutput'',0));']);
    selected_result(1:length(temp),idx1)=temp';
end
set(handles.uitable1,'Data',selected_result);
% --- Executes on selection change in listbox4.
function listbox4_Callback(hObject, eventdata, handles)
% hObject    handle to listbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox4


% --- Executes during object creation, after setting all properties.
function listbox4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over pushbutton1.
function pushbutton1_ButtonDownFcn(hObject, eventdata, handles)  
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on selection change in listbox5.
function listbox5_Callback(hObject, eventdata, handles) %选择用于对比的标签列表，刷新对比标签
% hObject    handle to listbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox5
global map_attr_groupedA map_attr_groupedB
%打开对比标签A选择
set(handles.listbox1,'Enable','on');
group_idx=get(handles.listbox5,'Value'); %提取所需属性的列表位置
%向listbox1中输入可选的属性A列表
set(handles.listbox1,'Value',1); 
set(handles.listbox1,'String',map_attr_groupedA{group_idx});
set(handles.uitable1,'ColumnName',map_attr_groupedB{group_idx});
% --- Executes during object creation, after setting all properties.
function listbox5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox6.
function listbox6_Callback(hObject, eventdata, handles) %刷新结果子集标签->listbox4
% hObject    handle to listbox6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox6 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox6
global test_result
fld=get(handles.listbox6,'String');
fld_idx=get(handles.listbox6,'Value');
eval(['subfld=fieldnames(test_result{1}.' fld{fld_idx} ');']);
set(handles.listbox4,'String',subfld);
set(handles.listbox4,'Enable','on');

% --- Executes during object creation, after setting all properties.
function listbox6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
