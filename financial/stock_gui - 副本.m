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

% Last Modified by GUIDE v2.5 01-Jun-2013 01:25:11

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
global stock para_sel ix column data_analysis_ori selected_para fft_day predict_avg
try
    cwd=['E:\stock'];
    cd(cwd);
end
stock=stock_read_v2;
para_sel=find([get(handles.checkbox1,'Value') get(handles.checkbox2,'Value') get(handles.checkbox3,'Value')...
        get(handles.checkbox4,'Value') get(handles.checkbox5,'Value') get(handles.checkbox6,'Value')]);
    
for stock_idx=1:length(stock);
%     clear('data_analysis')
    data_current=stock{stock_idx}.data;
    % data_current=data_current./repmat(sum(data_current,1),size(data_current,1),[]);
    
%     d_idx=1;
    
    data_analysis=zeros(size(data_current,1),length(para_sel));
    for d_idx=1:length(para_sel)
        switch para_sel(d_idx)
            case 1
                data_analysis(:,d_idx)=data_current(:,4)./sum(data_current(:,4));column{d_idx}=' 标化收盘价';%d_idx=d_idx+1;  %normailized end price
            case 2
                data_analysis(:,d_idx)=(data_current(:,4)-data_current(:,1))./data_current(:,1);column{d_idx}=' 标化增长率';%d_idx=d_idx+1; %increase rate
            case 3
                data_analysis(:,d_idx)=(data_current(:,2)-data_current(:,1))./data_current(:,1);column{d_idx}=' 标化最高';%d_idx=d_idx+1; %max rate
            case 4
                data_analysis(:,d_idx)=(data_current(:,3)-data_current(:,1))./data_current(:,1);column{d_idx}=' 标化最低';%d_idx=d_idx+1; %min rate
            case 5
                data_analysis(:,d_idx)=data_current(:,5)./sum(data_current(:,5));column{d_idx}=' 标化量';%d_idx=d_idx+1;   %normalized volume
            case 6
                data_analysis(:,d_idx)=data_current(:,6)./sum(data_current(:,6));column{d_idx}=' 标化额';%d_idx=d_idx+1;   %normalized amount
        end
    end
    days=str2double(get(handles.edit1,'String'));  %Days to analysis
    
    data_analysis=data_analysis(end-days:end,:);
    % data_analysis=data_analysis';
    data_analysis=mapminmax(data_analysis',0,1);
    fft_day=ceil(str2double(get(handles.edit2,'String'))*days);
    selected_para=1:size(data_analysis,1);
    N=ceil(fft_day+1)*size(data_analysis,1)*size(data_analysis,1);
    create_fcn=@(NVARS,FitnessFcn,options) stock_ga_create(NVARS,FitnessFcn,options,data_analysis);
    plot_fcn=@(options,state,flag) stock_ga_plot(options,state,flag,data_analysis,fft_day,[stock{stock_idx}.name ' ' num2str(stock_idx) '/' num2str(length(stock)) ' '],selected_para,column);
    % plot_fcn=@stock_ga_plot_simple;
    %setting up the GA
    options=gaoptimset('PopulationType','custom','PopInitRange',[1;N]);
    options=gaoptimset(options,'CreationFcn',create_fcn,...
        'CrossoverFcn',@stock_ga_crossover,...
        'MutationFcn',@stock_ga_mutation,...%'PlotFcn',plot_fcn,...
        'PlotInterval',50,...
        'Generations',str2double(get(handles.edit5,'String')),'PopulationSize',str2double(get(handles.edit6,'String')),...
        'StallGenLimit',200,'Vectorized','on',...
        'UseParallel','always',...
        'FitnessLimit',-Inf,...
        'TolCon',str2double(get(handles.edit7,'String')),...
        'TolFun',str2double(get(handles.edit7,'String')));
    data_analysis_ori=data_analysis;
    stock{stock_idx}.data_analysis=data_analysis;
end
stock_temp=stock;
% if matlabpool('size')==0
%     matlabpool
% end
day_predict=str2double(get(handles.edit3,'String'));
fft_day_temp=fft_day;
selected_para_temp=selected_para;
column_temp=column;
finished=zeros(length(stock_temp),1);

sch=parcluster();
for idx=1:length(sch.Jobs)
    sch.Jobs(1).delete;
end

stock_cnt=1;
% k=parallel.gpu.CUDAKernel('stock_accelerate.ptx','stock_accelerate.cu');
% fitnessfcn=@(x) stock_ga_fitness_gpu(x,data_analysis,fft_day_temp,selected_para_temp,k);


seg=30;
calculated=0;

multiWaitbar('总进度:',0,'color',[0.3 0.6 0.4]);
while calculated<length(stock_temp)
    
    
    multiWaitbar('正在分配任务:','Reset','color',[0.2 0.4 0.8]);
    multiWaitbar('检查状态:','Reset','color',[0.2 0.4 0.4]);
    
    if length(stock_temp)-calculated>=seg
        cal=seg;
    else
        cal=length(stock_temp)-calculated;
    end
%     jh=zeros(length(cal),1);
    for stock_idx=1:cal;
        batch(sch,@stock_ga_gpu_start,1,{stock_temp{stock_idx}.data_analysis,fft_day_temp,selected_para_temp,N,options});
        multiWaitbar('正在分配任务:',stock_idx/cal,'color',[0.2 0.4 0.8]);
    end
    for idx=1:length(cal)
        wait(sch.Jobs(idx));
        multiWaitbar('检查状态:',idx/length(cal),'color',[0.2 0.4 0.4]);
    end
    for stock_idx=1:cal;
        %GA start
        %     try
        
        %     catch
        %         if matlabpool('size')==0
        %             matlabpool
        %         end
        %         fitnessfcn=@(x) stock_ga_fitness(x,data_analysis,fft_day,selected_para);
        %     end
        %     [x,fval,reason,output]=ga(fitnessfcn,N,options);
        %     stock_temp{stock_idx}.x=x;
        %Data to predict
        %     hold on;
        
        r=fetchOutputs(sch.Jobs(idx));
        x=r{1};
        stock_temp{calculated+stock_idx}.x=x;
        
        stock_temp{calculated+stock_idx}.predict=stock_predict(stock_temp{calculated+stock_idx}.x,stock_temp{calculated+stock_idx}.data_analysis,fft_day_temp,day_predict,selected_para_temp,stock_temp{calculated+stock_idx}.name,column_temp,0);
        predict_avg_temp(calculated+stock_idx)=median(stock_temp{calculated+stock_idx}.predict);
        %     k.delete;
        %     finished(stock_idx)=1;
        %     multiWaitbar('完成度',(finished)/length(stock));
    end
    for idx=1:length(sch.Jobs)
        sch.Jobs(1).delete;
    end
    calculated=calculated+cal;
    multiWaitbar('总进度:',calculated/length(stock_temp),'color',[0.3 0.6 0.4]);
end
predict_avg=predict_avg_temp;
multiWaitbar('Close all')
stock=stock_temp;
[~,ix]=sort(predict_avg_temp,'descend');
stock_output=cell(length(stock)+1,2);
stock_output{1,1}='名称';
stock_output{1,2}='预测平均值（标准化后）';
for idx=1:length(stock)
    stock_output{idx+1,1}=stock{ix(idx)}.name;
    stock_output{idx+1,2}=median(stock{ix(idx)}.predict(:,1));
end
set(handles.uitable1,'Data',stock_output);

save('stock');
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
global current_selected_row stock ix column data_analysis_ori selected_para fft_day
if strcmp('space',eventdata.Key);
    day_predict=str2double(get(handles.edit3,'String'));
    stock_current=stock{ix(current_selected_row-1)};
    figure(2);
%     stock_predict(stock_current.x,data_analysis_ori,fft_day,day_predict,selected_para,stock_current.name,column);
    stock_predict(stock_current.x,stock_current.data_analysis,fft_day,day_predict,selected_para,stock_current.name,column);

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
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global stock para_sel ix column data_analysis_ori selected_para fft_day predict_avg
uiopen();
[~,ix]=sort(predict_avg,'descend');
for idx=1:length(stock)
    stock_output{idx+1,1}=stock{ix(idx)}.name;
    stock_output{idx+1,2}=mean(stock{ix(idx)}.predict(:,1));
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
function pushbutton4_Callback(hObject, eventdata, handles)
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
    stock_predict(stock_current.x,stock_current.data_analysis,fft_day,day_predict,selected_para,stock_current.name,column);
else
    msgbox('没有找到结果');
end