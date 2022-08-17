function varargout = N_stat(varargin)
% N_STAT MATLAB code for N_stat.fig
%      N_STAT, by itself, creates a new N_STAT or raises the existing
%      singleton*.
%
%      H = N_STAT returns the handle to a new N_STAT or the handle to
%      the existing singleton*.
%
%      N_STAT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in N_STAT.M with the given input arguments.
%
%      N_STAT('Property','Value',...) creates a new N_STAT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before N_stat_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to N_stat_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help N_stat

% Last Modified by GUIDE v2.5 19-Apr-2015 13:20:48
%2013-4-3   修正trial_count数，增加通道配对的个数
%2012-12-27 修正hist为count/trial,修正整合时的trial_count
%2012-12-7 将所有函数重新排序，整合数据读取功能到同一个函数内（Pre_process）,修改出图函数为两维
%2012-10-31 修正整合标签问题，此前增加了多项数据输出的功能
%2012-9-22 完成标签分类
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @N_stat_OpeningFcn, ...
                   'gui_OutputFcn',  @N_stat_OutputFcn, ...
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


% --- Executes just before N_stat is made visible.
function N_stat_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to N_stat (see VARARGIN)

% Choose default command line output for N_stat
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes N_stat wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = N_stat_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

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

% --- Executes during object creation, after setting all properties.
function listbox7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function listbox8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

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
function pushbutton1_Callback(hObject, eventdata, handles)  %%load file
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global grouped_data  map_attr_grouped map_attr map_attr_selected map_attr_ori  grouped_data_ori
%载入grouped_file文件
[filename pathname]=uigetfile('*.mat','Select grouped data mat-file');
load([pathname filename]);    %grouped_data
set(handles.text1,'String',['Current file: ' filename]);
cd(pathname);
%显示可选子集
% fld_temp=fieldnames(grouped_data{1});
fld=fieldnames(grouped_data{1}.data);
set(handles.listbox8,'String',fld);
set(handles.listbox8,'Enable','on');
%% 进行标签分组
map_attr_temp=cellfun(@(x) x.attrname',grouped_data,'UniformOutput',false); %作出分组名称列表
map_attr=[map_attr_temp{:}];%map_attr_all=[map_attr_temp2{:}];
% map_attr_all=unique(map_attr_all);   %unique tags

map_attr_grouped=cell(length(grouped_data{1}.attrname),1);
str_group=cell(length(grouped_data{1}.attrname),1);
for idx=1:length(grouped_data{1}.attrname)
    map_attr_grouped{idx}=unique([map_attr{idx,:}]);
    str_temp=[];
    for idx2=1:length(map_attr_grouped{idx})
        str_temp=[str_temp map_attr_grouped{idx}{idx2} ' '];
    end
    str_group{idx}=str_temp;
end
map_attr_selected=map_attr_grouped;
grouped_data_ori=grouped_data;
map_attr_ori=map_attr;
%% 控件参数设置
%listbox1->选择需要对比的legend标签级别
% str=cellfun(@(x,y) [[x{:}] ' vs ' [y{:}]],map_attr_groupedA(:),map_attr_groupedB(:),'UniformOutput',0);
set(handles.listbox1,'String',str_group);
set(handles.listbox1,'Enable','on');

compare_idx=get(handles.listbox1,'Value');
set(handles.listbox5,'Value',1);
set(handles.listbox6,'Value',1);
set(handles.listbox5,'String',map_attr_selected{compare_idx});
set(handles.listbox6,'String',map_attr_selected{compare_idx});

%load montage
pushbutton5_Callback(hObject,eventdata,handles);  

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles) %选择比较标签
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 选择比较的标签大类，并将选择的结果更新到其他控件中，如果在这里没有选择的标签，将在比较中合为一类
global rat_montage map_attr_grouped map_attr_selected map_attr grouped_data grouped_data_ori map_attr_ori

attr_page=length(map_attr_grouped);
% comp_page=get(handles.listbox1,'Value');
% ex_page=1:attr_page;
% % ex_page(ex_page==comp_page)=[];
map_attr_selected=cell(attr_page,1);
% str_group=cell(attr_page,1);
cnt=1;
for idx=1:attr_page
    str=map_attr_grouped{idx};
    [s,~] = listdlg('PromptString',['Select Attributes:' num2str(idx) '/' num2str(attr_page)],...
        'SelectionMode','multiple',...
        'ListString',str);
    if ~isempty(s)
        map_attr_selected{idx}=map_attr_grouped{idx}(s);
        str_temp=[];
        for idx2=1:length(map_attr_selected{idx})
            str_temp=[str_temp map_attr_selected{idx}{idx2} ' '];
        end
        str_group{cnt}=str_temp;
        cnt=cnt+1;
    end
    clear('str','s');
end

%% convert to adaptive format
group_idx=1;
not_empty=[];
for idx=1:attr_page
    if ~isempty(map_attr_selected{idx})
        temp_selected{group_idx}=map_attr_selected{idx};
        not_empty=[not_empty idx]; 
        group_idx=group_idx+1;
    end
end
map_attr=map_attr_ori(not_empty,:);
map_attr_selected=temp_selected';
grouping=map_attr_selected;
%% 为grouped_data产生所有可能选择的类别
length_all=1;

for idxg=1:length(grouping)
    length_all=length_all*(length(grouping{idxg}));
end
grouped_data=cell(1,length_all);
for group_idx=1:length_all;
    grouped_data{group_idx}.attr=zeros(length(grouping),1);
    mod_temp=group_idx;
    grouped_data{group_idx}.attrname=[];
    for idxg=length(grouping):-1:1
        grouped_data{group_idx}.attr(idxg)=1+mod(ceil(mod_temp)-1,length(grouping{idxg}));

            grouped_data{group_idx}.attrname{idxg}=grouping{idxg}(grouped_data{group_idx}.attr(idxg));
        
        mod_temp=(mod_temp/(length(grouping{idxg})));
        
    end
end
%% 选择需要的数据
str = fieldnames(grouped_data_ori{1}.data);
[s,v] = listdlg('PromptString','Select data fieldnames',...
    'SelectionMode','multiple',...
    'ListString',str);
selected_attr=str(s);
clear('str','s','v');


%% 整合数据
mer_mode=get_merging_mode(handles);
channel_all=[];
for m=1:length(rat_montage)
    channel_all=[channel_all rat_montage{m}.channel];
end
for group_idx=1:length_all;
    multiWaitbar('Merging:',group_idx/length_all,'color',[0.5 0.8 0.3]);
    equal_temp=ones(1,length(grouped_data_ori));
    for idxg=1:length(grouping)
        equal_temp=equal_temp.*strcmp([map_attr_ori{not_empty(idxg),:}],grouped_data{group_idx}.attrname{idxg}{1}); %根据当前处理的分组标签从原始数据中找出符合条件的数据集
    end
    locs=find(equal_temp);
    trial_num_new=0;
    for attr_idx=1:length(selected_attr);
        eval(['grouped_data{group_idx}.data.' selected_attr{attr_idx} '=cell(length(channel_all));']); %初始化data
        for loc=1:length(locs)
                eval(['grouped_data{group_idx}.data.' selected_attr{attr_idx} '=cellfun(@(x,y) mat_v_merge(x,y,mer_mode),grouped_data{group_idx}.data.'...
                    selected_attr{attr_idx} ',grouped_data_ori{locs(loc)}.data.' selected_attr{attr_idx} ',''UniformOutput'',false);']);
           trial_num_new=trial_num_new+grouped_data_ori{locs(loc)}.trial_num; 
        end
    end
    if mer_mode==1
        eval(['grouped_data{group_idx}.data.' selected_attr{attr_idx} '=grouped_data{group_idx}.data.' selected_attr{attr_idx} '/trial_num_new;']);  %修正如果是直接矩阵叠加情况的值，将累加值变为均值
    end
    if ~isempty(locs)
        fld_sample=fieldnames(grouped_data_ori{locs(1)});
        for fld_idx=1:length(fld_sample)
            if ~(strcmp(fld_sample{fld_idx},'data')||strcmp(fld_sample{fld_idx},'attrname')||strcmp(fld_sample{fld_idx},'attr'))
                eval(['grouped_data{group_idx}.' fld_sample{fld_idx} '=(grouped_data_ori{locs(1)}.' fld_sample{fld_idx} ');']);
                %                 if isnumeric(getfield(grouped_data_ori{locs(1)},fld_sample{fld_idx}))
                %                     eval(['grouped_data{group_idx}.' fld_sample{fld_idx} '=unique(cell2mat(arrayfun(@(x) x.' fld_sample{fld_idx} ',[grouped_data_ori{locs}],''UniformOutput'',0)));']);
                %                 else
                %                     eval(['grouped_data{group_idx}.' fld_sample{fld_idx} '=(arrayfun(@(x) x.' fld_sample{fld_idx} ',[grouped_data_ori{locs}],''UniformOutput'',0));']);
                %                 end
            end
        end
        grouped_data{group_idx}.trial_num=trial_num_new;
    end
end
multiWaitbar('close all');
%% 进行标签分组
map_attr_temp=cellfun(@(x) x.attrname',grouped_data,'UniformOutput',false); %作出分组名称列表
map_attr=[map_attr_temp{:}];%map_attr_all=[map_attr_temp2{:}];
set(handles.listbox5,'Value',1);
set(handles.listbox6,'Value',1);
set(handles.listbox5,'String',map_attr_selected{1});
set(handles.listbox6,'String',map_attr_selected{1});

% map_attr_selected=map_attr_grouped;
%% 控件参数设置
%listbox1->选择需要对比的legend标签级别
% str=cellfun(@(x,y) [[x{:}] ' vs ' [y{:}]],map_attr_groupedA(:),map_attr_groupedB(:),'UniformOutput',0);
set(handles.listbox1,'String',str_group);
button=questdlg('Do you want to save this workspace?','Save current workspace?');
switch button
    case 'Yes'
        uisave({'grouped_data','map_attr'},'current setup');
    case 'No'
        return
    case 'Cancel'
        return
end

function M_merge=mat_v_merge(matA,matB,Mer_mode)
if Mer_mode==0
    M_merge=[matA; matB];
else
    M_merge=matA+matB;
end
% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)  %load montage
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global rat_montage
[filename pathname]=uigetfile('*.mtg','Select rat_montage definition');
if((filename)==0)
    warndlg('Please select a rat_montage file!','!! Warning !!')
    return
else
    load([pathname filename],'-mat');
end
set(handles.text9,'String',['Current montage: ' filename]);

str_mtg=cellfun(@(x) x.name,rat_montage,'UniformOutput',0);
set(handles.listbox3,'String',str_mtg);
set(handles.listbox4,'String',str_mtg);

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)  %Calculate
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global grouped_data rat_montage map_attr map_attr_grouped compare_set map_attr_selected min_I min_percent
mer_mode=get_merging_mode(handles);
compare_idx=get(handles.listbox1,'Value');
compare_tagA=get(handles.listbox5,'String');temp_idx=get(handles.listbox5,'Value');compare_tagA=compare_tagA{temp_idx};
compare_tagB=get(handles.listbox6,'String');temp_idx=get(handles.listbox6,'Value');compare_tagB=compare_tagB{temp_idx};
idx_A=reshape(cell2mat(cellfun(@(x) strcmp(x,compare_tagA),map_attr(compare_idx,:),'UniformOutput',0)),1,[]);%先确定A，再根据A的每一项确定相应的B
idx_A=find(idx_A);
count=0;
compare_set_temp=[];
for count_A=1:length(idx_A)
    tags_B=map_attr(:,idx_A(count_A)); %找到A的标签
    tags_B{compare_idx}={compare_tagB};
    idx_B=ones(1,length(map_attr(compare_idx,:)));
    for idx_tg=1:length(tags_B)
        idx_B=idx_B.*reshape(cell2mat(cellfun(@(x) strcmp(x,tags_B{idx_tg}{1}),map_attr(idx_tg,:),'UniformOutput',0)),1,[]);
    end
    idx_B=find(idx_B);
    for count_B=1:length(idx_B)
        count=count+1;
        compare_set_temp{count}.A=idx_A(count_A);
        compare_set_temp{count}.B=idx_B(count_B);
    end
end
compare_set=compare_set_temp;
 
%处理电极分组
region_idxA=get(handles.listbox3,'Value');
region_idxB=get(handles.listbox4,'Value');
channel_A=rat_montage{region_idxA}.channelNo;
channel_B=rat_montage{region_idxB}.channelNo;
data_type=get(handles.listbox8,'String');temp_idx=get(handles.listbox8,'Value');data_type=data_type{temp_idx};
stat_output=[];
print_cnt=1;
def={'0.2'...
    '95'};
answer=inputdlg({'thersold level(0-1)' ...
    'min percent(0-100%)'},'Cluster parameters',1,def);
idx=1;
min_I=str2double(answer{idx});idx=idx+1;
min_percent=str2double(answer{idx});idx=idx+1;
for count=1:length(compare_set)
    A=grouped_data{compare_set{count}.A};    
    B=grouped_data{compare_set{count}.B};
    dataA_temp=getfield(A.data,data_type);
    dataA=cell2mat2(dataA_temp(channel_A,channel_B),mer_mode);
    dataB_temp=getfield(B.data,data_type);
    dataB=cell2mat2(dataB_temp(channel_A,channel_B),mer_mode);
    
    %here will calculate the most prominent points in the synchronization matrix


    clear('answer','groupingidx');
    if mer_mode==1
        dataA_clu=loc_find_shell(dataA,min_I,min_percent,diff(A.startpoint(1:2)),A.startpoint(1),A.delay(1));
        dataB_clu=loc_find_shell(dataB,min_I,min_percent,diff(B.startpoint(1:2)),B.startpoint(1),B.delay(1));
    else
        dataA_clu=dataA;
        dataB_clu=dataB;
    end
    if get(handles.checkbox1,'value')
        dataA=dataA';
        dataB=dataB';
    end
    if (~isempty(dataA))&&(~isempty(dataB))
        A_name=cell2mat(cellfun(@(x) [x{:} ' '],A.attrname,'UniformOutput',0));
        B_name=cell2mat(cellfun(@(x) [x{:} ' '],B.attrname,'UniformOutput',0));
        stat_output{print_cnt,1}=[A_name ' vs ' B_name];
        stat_output{print_cnt,2}=num2str(mean(dataA_clu,1));
        stat_output{print_cnt,3}=num2str(std(dataA_clu,0,1));
        stat_output{print_cnt,4}=num2str(mean(dataB_clu,1));
        stat_output{print_cnt,5}=num2str(std(dataB_clu,0,1));
        if ~isempty(dataA_clu)&&~isempty(dataB_clu)
            [t_p,t_v,k_p,k_v]=stat_column(dataA_clu,dataB_clu);
            stat_output{print_cnt,6}=num2str(t_p);
            stat_output{print_cnt,7}=num2str(t_v);
            stat_output{print_cnt,8}=num2str(k_p);
            stat_output{print_cnt,9}=num2str(k_v);
        end
        print_cnt=print_cnt+1;
    end
end
set(handles.uitable1,'Data',stat_output);

% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)   %save all figures
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% save all figures
global rat_montage grouped_data compare_set min_I min_percent
mer_mode=get_merging_mode(handles);
sch = findResource('scheduler','configuration',  defaultParallelConfig);%find parallel worker 
if(isempty(sch.jobs))
else
    destroy(sch.jobs);
end
jh=[]; %jobhandle
pathname=uigetdir(pwd,'Select the output directory');
cd(pathname);
% h=figure();
%
ts_count=1;
%处理电极分组
for region_idxA=1:length(rat_montage)
    for region_idxB=1:length(rat_montage)
%         region_idxA=get(handles.listbox3,'Value');
%         region_idxB=get(handles.listbox4,'Value');
        channel_A=rat_montage{region_idxA}.channelNo;
        channel_B=rat_montage{region_idxB}.channelNo;
        data_type=get(handles.listbox8,'String');temp_idx=get(handles.listbox8,'Value');data_type=data_type{temp_idx};
%         diff_sum=zeros(length(compare_set),size((getfield(grouped_data{1}.data,data_type)),2));
%         diff_sum=cell(count,1);
        for count=1:length(compare_set)
            A=grouped_data{compare_set{count}.A};
            B=grouped_data{compare_set{count}.B};
            [dataA,dataB,cntA,cntB,stps,delay,a_stp,a_delay,b_stp,b_delay,a_stp_s,a_delay_s,b_stp_s,b_delay_s,c_stp,c_delay,filename,A_name,B_name]=...
                pre_process(A,B,channel_A,channel_B,data_type,rat_montage,region_idxA,region_idxB,get(handles.checkbox1,'Value'),get(handles.edit1,'Value'));
            diff_sum{count,1}=filename;
            temp=[sum(abs(b_delay_s-a_delay_s))*100 ;  sum(abs(b_stp_s-a_stp_s))*100];
            
            for n=1:length(temp);
                diff_sum{count,1+n}=temp(n);
            end
            %             ylim([-0.5 0.5]);
            %             plot_fig(stps,delay,a_stp,a_delay,b_stp,b_delay,c_stp,c_delay,dataA,dataB,temp,A_name,B_name,filename,pathname)
            jh=[jh batch(sch,@plot_fig,0,{stps,delay,cntA,cntB,a_stp,a_delay,b_stp,b_delay,c_stp,c_delay,dataA_clu,dataB_clu,temp,A_name,B_name,filename,pathname,mer_mode,min_I,min_percent})];


            multiWaitbar('Processing:',ts_count/(length(rat_montage)^2*length(compare_set)),'color',[0.2 0.4 0.8]);
            ts_count=ts_count+1;
            % set (h,'Position',[100,100,900,700], 'color','w')
%             saveas(h,[pathname '\' filename],'fig')
%             print(h,'-djpeg','-r300','-zbuffer',[pathname '\' filename]);
        end
        xlswrite('result',diff_sum,[rat_montage{region_idxA}.name '_' rat_montage{region_idxB}.name]);
    end
end
for idx=1:length(jh)
    wait(jh(idx));
    multiWaitbar('Wait jobs to complete:',idx/(length(jh)),'color',[0.8 0.4 0.2]);
end
    
if(isempty(sch.jobs))
else
    destroy(sch.jobs);
end
multiWaitbar('Close all');
% close(h)
% if isempty(jh)
% else
%     wait(jh(end));
% end

% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles) %% Output timeseries
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global rat_montage grouped_data compare_set
% isOpen = matlabpool('size') ;
% if isOpen< 2
%     matlabpool
% end
% sch = findResource('scheduler','configuration',  defaultParallelConfig);%find parallel worker 
mer_mode=get_merging_mode(handles);
sch=parcluster();
jh=[]; %jobhandle
pathname=uigetdir(pwd,'Select the output directory');
cd(pathname);
% h=figure();
%
ts_count=1;
% time_series=cell(length(rat_montage)^2*length(compare_set),1);
time_series=cell(length(compare_set)*(length(rat_montage)*(1+length(rat_montage))/2),1);
% time_series=cell(length(rat_montage)*length(rat_montage)*length(compare_set),1);
%处理电极分组
for region_idxA=1:length(rat_montage)
    for region_idxB=region_idxA:length(rat_montage)
%         region_idxA=get(handles.listbox3,'Value');
%         region_idxB=get(handles.listbox4,'Value');
        channel_A=rat_montage{region_idxA}.channelNo;
        channel_B=rat_montage{region_idxB}.channelNo;
        data_type=get(handles.listbox8,'String');temp_idx=get(handles.listbox8,'Value');data_type=data_type{temp_idx};
%         diff_sum=zeros(length(compare_set),size((getfield(grouped_data{1}.data,data_type)),2));
%         diff_sum=cell(count,1);
        for count=1:length(compare_set)
            A=grouped_data{compare_set{count}.A};
            B=grouped_data{compare_set{count}.B};
%             [a,b,c,d,e,f,g,h]=bundle(A,B,channel_A,channel_B,data_type,rat_montage,region_idxA,region_idxB,get(handles.checkbox1,'Value'),get(handles.edit1,'Value'));
            jh=[jh batch(sch,@bundle,8,{A,B,channel_A,channel_B,data_type,rat_montage,region_idxA,region_idxB,get(handles.checkbox1,'Value'),get(handles.edit1,'Value'),mer_mode})];
            multiWaitbar('Batching jobs:',ts_count/(length(compare_set)*(length(rat_montage)*(1+length(rat_montage))/2)),'color',[0.2 0.4 0.8]);
            ts_count=ts_count+1;
        end
    end
end
for idx=1:length(jh)
wait(jh(idx));
multiWaitbar('Checking job status:',idx/length(jh),'color',[0.2 0.4 0.4]);
end
ts_count=1;
bad_c=[];
for region_idxA=1:length(rat_montage)
    for region_idxB=region_idxA:length(rat_montage)
%         region_idxA=get(handles.listbox3,'Value');
%         region_idxB=get(handles.listbox4,'Value');
%         channel_A=rat_montage{region_idxA}.channelNo;
%         channel_B=rat_montage{region_idxB}.channelNo;
%         data_type=get(handles.listbox8,'String');temp_idx=get(handles.listbox8,'Value');data_type=data_type{temp_idx};
%         diff_sum=zeros(length(compare_set),size((getfield(grouped_data{1}.data,data_type)),2));
%         diff_sum=cell(count,1);
        for count=1:length(compare_set)
%             A=grouped_data{compare_set{count}.A};
%             B=grouped_data{compare_set{count}.B};
%             [dataA,dataB,stps,delay,a_stp,a_delay,b_stp,b_delay,a_stp_s,a_delay_s,b_stp_s,b_delay_s,c_stp,c_delay,filename,A_name,B_name]=...
%                 pre_process(A,B,channel_A,channel_B,data_type,rat_montage,region_idxA,region_idxB,handles);
% %             diff_sum{count,1}=filename;
% %             temp=[sum(abs(b_delay_s-a_delay_s))*100 ;  sum(abs(b_stp_s-a_stp_s))*100];
%             
% %             for n=1:length(temp);
% %                 diff_sum{count,1+n}=temp(n);
% %             end
%             [dataA_map,dataB_map,dataA_map_weighted,dataB_map_weighted]=map_generater(stps,delay,dataA,dataB);
%             %             ylim([-0.5 0.5]);
%             %             plot_fig(x,a,b,c,dataA,dataB,temp,A_name,B_name,filename,pathname)
% %             jh=[jh batch(sch,@plot_fig,0,{x,a,b,c,dataA,dataB,temp,A_name,B_name,filename,pathname})];
%             ts_count=(region_idxA-1)*length(rat_montage)*length(compare_set)+(region_idxB-1)*length(compare_set)+count;
            r=fetchOutputs(jh(ts_count));
            dataA_map=r{1};
            dataB_map=r{2};
            dataA_map_weighted=r{3};
            dataB_map_weighted=r{4};
            A_name=r{5};
            B_name=r{6};
            stp=r{7};  
            dly=r{8};
            if isnan(dataA_map)  %bad count handling
                bad_c=[bad_c ts_count];
            else
                time_series{ts_count}.dataA=dataA_map;  %x_delay,y_stp
                time_series{ts_count}.dataA_weighted=dataA_map_weighted;
                time_series{ts_count}.dataB=dataB_map;  %x_delay,y_stp
                time_series{ts_count}.dataB_weighted=dataB_map_weighted;
                time_series{ts_count}.tagA=[A_name rat_montage{region_idxA}.name '_' rat_montage{region_idxB}.name];
                time_series{ts_count}.startpoint=stp';
                time_series{ts_count}.delay=dly';
                %             time_series{ts_count}.w1=x;
                %             ts_count=ts_count+1;
                %             time_series{ts_count}.dataB1=dataB1_map;
                %             time_series{ts_count}.dataB1_weighted=dataB1_map_weighted;
                %             time_series{ts_count}.dataB2=dataB2_map;
                %             time_series{ts_count}.dataB2_weighted=dataB2_map_weighted;
                time_series{ts_count}.tagB=[B_name rat_montage{region_idxA}.name '_' rat_montage{region_idxB}.name];
            end
            multiWaitbar('Fetching results:',ts_count/(length(compare_set)*(length(rat_montage)*(1+length(rat_montage))/2)),'color',[0.2 0.8 0.4]);
            ts_count=ts_count+1;
            % set (h,'Position',[100,100,900,700], 'color','w')
            %             saveas(h,[pathname '\' filename],'fig')
            %             print(h,'-djpeg','-r300','-zbuffer',[pathname '\' filename]);
            
        end
        %         xlswrite('result',diff_sum,[rat_montage{region_idxA}.name '_' rat_montage{region_idxB}.name]);
    end
end
time_series(bad_c)=[];
delete(sch.Jobs);
% for idx=length(jh)
% % destroy(jh(idx));
% delete(
% multiWaitbar('Destroying jobs:',idx/(length(rat_montage)^2*length(compare_set)),'color',[0.7 0.2 0.4]);
% end
% time_series=reshape(time_series,[],1);
multiWaitbar('Close all');
uisave('time_series','time_series');

function pushbutton9_Callback(hObject, eventdata, handles)  %% pairwise figures
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% pairwise figures
global rat_montage grouped_data compare_set
mer_mode=get_merging_mode(handles);
sch=parcluster();
% sch = findResource('scheduler','configuration',  defaultParallelConfig);%find parallel worker 
if(isempty(sch.Jobs))
else
    destroy(sch.Jobs);
end
jh=[]; %jobhandle
pathname=uigetdir(pwd,'Select the output directory');
cd(pathname);
% h=figure();
%
ts_count=1;
%处理电极分组
% diff_sum=cell();
for region_idxA=1:length(rat_montage)
    for region_idxB=region_idxA:length(rat_montage)
%         region_idxA=get(handles.listbox3,'Value');
%         region_idxB=get(handles.listbox4,'Value');
        channel_A=rat_montage{region_idxA}.channelNo;
        channel_B=rat_montage{region_idxB}.channelNo;
        data_type=get(handles.listbox8,'String');temp_idx=get(handles.listbox8,'Value');data_type=data_type{temp_idx};
%         diff_sum=zeros(length(compare_set),size((getfield(grouped_data{1}.data,data_type)),2));
%         diff_sum=cell(count,1);
        for count=1:length(compare_set)
            A=grouped_data{compare_set{count}.A};
            B=grouped_data{compare_set{count}.B};
            if A.trial_num>0 && B.trial_num>0
                [dataA1,dataB1,cntA1,cntB1,stps,delay,a_stp,a_delay,b_stp,b_delay,a_stp_s,a_delay_s,b_stp_s,b_delay_s,c_stp,c_delay,filename,A_name,B_name]=...
                    pre_process(A,B,channel_A,channel_B,data_type,rat_montage,region_idxA,region_idxB,get(handles.checkbox1,'Value'),get(handles.edit1,'Value'),mer_mode);
                [dataA2,dataB2,cntA2,cntB2,~,~,~,~,~,~,~,~,~,~,~,~,FF,AA,BB]=...
                    pre_process(A,B,channel_B,channel_A,data_type,rat_montage,region_idxB,region_idxA,get(handles.checkbox1,'Value'),get(handles.edit1,'Value'),mer_mode);
                if isempty(dataA1) || isempty(dataB1) || isempty(dataA2) || isempty(dataB2)
                else
                    diff_sum{count,1}=filename;
                    temp=[sum(abs(b_delay_s-a_delay_s))*100 ;  sum(abs(b_stp_s-a_stp_s))*100];
                    if isequal(A,B)
                        jh=[jh batch(sch,@plot_fig_pair_single,0,{stps,delay,cntA1,cntA2,dataA1,dataA2,A_name,filename,pathname,mer_mode})];
%                         plot_fig_pair_single                                           (stps,delay,cntA1,cntA2,dataA1,dataA2,A_name,filename,pathname)
                    else
                        %
                        %                 for n=1:length(temp);
                        %                     diff_sum{count,1+n}=temp(n);
                        %                 end
                        %             ylim([-0.5 0.5]);
                        %             plot_fig_pair(stps,delay,cntA1,cntB1,cntA2,cntB2,a_stp,a_delay,b_stp,b_delay,c_stp,c_delay,dataA1,dataB1,dataA2,dataB2,temp,A_name,B_name,filename,pathname)
                        jh=[jh batch(sch,@plot_fig_pair,0,{stps,delay,cntA1,cntB1,cntA2,cntB2,a_stp,a_delay,b_stp,b_delay,c_stp,c_delay,dataA1,dataB1,dataA2,dataB2,temp,A_name,B_name,filename,pathname,mer_mode})];
                    end
                end
            end
            multiWaitbar('Processing:',ts_count/(length(compare_set)*(length(rat_montage)*(1+length(rat_montage))/2)),'color',[0.2 0.4 0.8]);
            ts_count=ts_count+1;
            % set (h,'Position',[100,100,900,700], 'color','w')
%             saveas(h,[pathname '\' filename],'fig')
%             print(h,'-djpeg','-r300','-zbuffer',[pathname '\' filename]);
        end
%         xlswrite('result',diff_sum,[rat_montage{region_idxA}.name '_' rat_montage{region_idxB}.name]);
    end
end
for idx=1:length(jh)
    wait(jh(idx));
    multiWaitbar('Wait jobs to complete:',idx/(length(jh)),'color',[0.8 0.4 0.2]);
end
    
if(isempty(sch.jobs))
else
    destroy(sch.jobs);
end
multiWaitbar('Close all');

% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1
global map_attr_selected
compare_idx=get(hObject,'Value');
set(handles.listbox5,'Value',1);
set(handles.listbox6,'Value',1);
set(handles.listbox5,'String',map_attr_selected{compare_idx});
set(handles.listbox6,'String',map_attr_selected{compare_idx});

% --- Executes on selection change in listbox3.
function listbox3_Callback(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox3

% --- Executes on selection change in listbox4.
function listbox4_Callback(hObject, eventdata, handles)
% hObject    handle to listbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox4

% --- Executes on selection change in listbox5.
function listbox5_Callback(hObject, eventdata, handles)
% hObject    handle to listbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox5

% --- Executes on selection change in listbox6.
function listbox6_Callback(hObject, eventdata, handles)
% hObject    handle to listbox6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox6 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox6

% --- Executes on selection change in listbox7.
function listbox7_Callback(hObject, eventdata, handles)
% hObject    handle to listbox7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox7 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox7

% --- Executes on selection change in listbox8.
function listbox8_Callback(hObject, eventdata, handles)
% hObject    handle to listbox8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox8 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox8

% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (seie GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1

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

% --- Executes on key press with focus on uitable1 and none of its controls.
function uitable1_KeyPressFcn(hObject, eventdata, handles)  %plot selected figure
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
global current_selected_row rat_montage grouped_data compare_set min_I min_percent
mer_mode=get_merging_mode(handles);
if strcmp('return',eventdata.Key);
    %%处理电极分组,pre processing
    region_idxA=get(handles.listbox3,'Value');
    region_idxB=get(handles.listbox4,'Value');
    channel_A=rat_montage{region_idxA}.channelNo;
    channel_B=rat_montage{region_idxB}.channelNo;
    data_type=get(handles.listbox8,'String');temp_idx=get(handles.listbox8,'Value');data_type=data_type{temp_idx};
    stat_output=[];
    count=current_selected_row;
    A=grouped_data{compare_set{count}.A};
    B=grouped_data{compare_set{count}.B};
    [dataA,dataB,cntA,cntB,stps,delay,a_stp,a_delay,b_stp,b_delay,a_stp_s,a_delay_s,b_stp_s,b_delay_s,c_stp,c_delay,filename,A_name,B_name]=...
        pre_process(A,B,channel_A,channel_B,data_type,rat_montage,region_idxA,region_idxB,get(handles.checkbox1,'Value'),get(handles.edit1,'Value'),mer_mode);
    temp=[sum(abs(b_delay_s-a_delay_s))*100 ;  sum(abs(b_stp_s-a_stp_s))*100];%
    plot_fig(stps,delay,cntA,cntB,a_stp,a_delay,b_stp,b_delay,c_stp,c_delay,dataA,dataB,temp',A_name,B_name,[],[],mer_mode,min_I,min_percent)
end

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double

function [t_p,t_v,k_p,k_v]=stat_column(dataA,dataB)
t_p=[];
t_v=[];
k_p=[];
k_v=[];
for col=1:size(dataA,2)
    [~,t_p(col),~,t_temp]=ttest2(dataA(:,col),dataB(:,col));
    t_v(col)=t_temp.tstat;
    [~,k_p(col),k_v(col)]=kstest2(dataA(:,col),dataB(:,col));
end

function output_mat=cell2mat2(input_cell,mer_mode)
input_cell=reshape(input_cell,1,[]);
output_mat=[];
for idx=1:length(input_cell)
    if ~isempty(input_cell{idx})
        if mer_mode==0
        output_mat=[output_mat;input_cell{idx}];
        else
            if isempty(output_mat)
                output_mat=input_cell{idx}/length(input_cell);
            else
                output_mat=output_mat+input_cell{idx}/length(input_cell);
            end
        end
    end
end

function [dataA_map,dataB_map,dataA_map_weighted,dataB_map_weighted]=map_generater(x,y,dataA,dataB,cntA,cntB)
% x=[min([min(reshape((dataA),[],1)),min(reshape(dataB,[],1))]);x];
dataA_map=zeros(length(x),length(y));
dataB_map=zeros(length(x),length(y));
dataA_map_weighted=zeros(length(x),length(y));
dataB_map_weighted=zeros(length(x),length(y));
if length(x)>1
   x_step=(x(2)-x(1))/2;
else
    x_step=0.5;
end;
if length(y)>1
   y_step=(y(2)-y(1))/2;
else
    y_step=0.5;
end
% y_step=(y(2)-y(1))/2;
data_A_delay=dataA(:,2);
data_A_stp=dataA(:,1);
data_A_wht=dataA(:,3);
data_B_delay=dataB(:,2);
data_B_stp=dataB(:,1);
data_B_wht=dataB(:,3);
for idx=1:length(x)
   for idy=1:length(y)
%         dataA_map(idx,idy)=sum((dataA(:,1)>=x(idx)&dataA(:,1)<x(idx+1))&(dataA(:,2)>=x(idy)&dataA(:,2)<x(idy+1)));
%         dataB_map(idx,idy)=sum((dataB(:,1)>=x(idx)&dataB(:,1)<x(idx+1))&(dataB(:,2)>=x(idy)&dataB(:,2)<x(idy+1)));

        locA=(data_A_stp>=(x(idx)-x_step)&data_A_stp<(x(idx)+x_step))&(data_A_delay>=(y(idy)-y_step)&data_A_delay<(y(idy)+y_step));
        dataA_map(idx,idy)=sum(locA)./cntA;
        dataA_map_weighted(idx,idy)=sum(data_A_wht(locA))./cntA;
        locB=(data_B_stp>=(x(idx)-x_step)&data_B_stp<(x(idx)+x_step))&(data_B_delay>=(y(idy)-y_step)&data_B_delay<(y(idy)+y_step));
        dataB_map(idx,idy)=sum(locB)./cntB;
        dataB_map_weighted(idx,idy)=sum(data_B_wht(locB))./cntB;
    end
end
% dataA_map=arrayfun(@(idx,idy) hist_count_weighted(dataA,x,idx,idy),idx,idy)';
% dataB_map=arrayfun(@(idx,idy) hist_count_weighted(dataB,x,idx,idy),idx,idy)';
% dataA_map_weighted=arrayfun(@(idx,idy) hist_count_weighted(dataA,x,idx,idy),idx,idy)';
% dataB_map_weighted=arrayfun(@(idx,idy) hist_count_weighted(dataB,x,idx,idy),idx,idy)';
% [idx,idy]=meshgrid(1:length(x)-1,1:length(x)-1);
% dataA_map=arrayfun(@(idx,idy) hist_count(dataA,x,idx,idy),idx,idy)';
% dataB_map=arrayfun(@(idx,idy) hist_count(dataB,x,idx,idy),idx,idy)';
% h=figure;
% imagesc(x,x,dataA_map');axis xy
%% plot_fig
function plot_fig(stps,delay,cntA,cntB,a_stp,a_delay,b_stp,b_delay,c_stp,c_delay,dataA,dataB,diff_AB,A_name,B_name,filename,pathname,mer_mode,min_I,min_percent)
h=figure;
if nargin<18
    mer_mode=0;
end
if mer_mode==1
    dataA_map=dataA;
    dataB_map=dataB;
    dataA=loc_find_shell(dataA,min_I,min_percent,diff(stps(1:2)),stps(1),delay(1));
    dataB=loc_find_shell(dataB,min_I,min_percent,diff(stps(1:2)),stps(1),delay(1));
    a_stp=hist(dataA(:,1),stps)./cntA;
    a_delay=hist(dataA(:,2),delay)./cntA;
    b_stp=hist(dataB(:,1),stps)./cntB;
    b_delay=hist(dataB(:,2),delay)./cntB;
end

if isequal(dataA,dataB) && isequal(A_name,B_name)
    subplot(311)
    bar(stps,a_stp)
    if min(stps)~=max(stps)
        xlim([min(stps),max(stps)])
    end
    title(A_name)
    subplot(312)
    bar(delay,a_delay,'r')
    if min(delay)~=max(delay)
        xlim([min(delay),max(delay)])
    end
    title(A_name)
    xlabel('delay / ms');
    subplot(313)
    bar(stps,b_stp)
    if min(stps)~=max(stps)
        xlim([min(stps),max(stps)])
    end
    title(B_name);
    xlabel('start time / ms');
    if ~isempty(filename)
        saveas(h,[pathname '\' filename],'fig')
        print(h,'-djpeg','-r300','-zbuffer',[pathname '\' filename]);
        close(h);
    end
    h=figure();
    [idx,idy]=meshgrid(1:length(stps),1:length(delay));
    if mer_mode==0
    dataA_map=arrayfun(@(idx,idy) hist_count(dataA,stps,delay,idx,idy),idx,idy);  %(dly,stp)
    end
    imagesc(stps,delay,dataA_map./cntA)
    if min(stps)~=max(stps)
        xlim([min(stps),max(stps)])
    end
    title(A_name)
    colorbar
    axis xy;
    if ~isempty(filename)
        saveas(h,[pathname '\' filename '_merged'],'fig')
        print(h,'-djpeg','-r300','-zbuffer',[pathname '\' filename '_merged']);
        close(h)
    end
    
    h=figure();
    if mer_mode==0;
        dataA_map=arrayfun(@(idx,idy) hist_count_weighted(dataA,stps,delay,idx,idy),idx,idy)./cntA;
    end
    imagesc(stps,delay,dataA_map)
    if min(stps)~=max(stps)
        xlim([min(stps),max(stps)])
    end
    title(A_name)
    colorbar
    axis xy;
    if ~isempty(filename)
        saveas(h,[pathname '\' filename '_merged_weighted'],'fig')
        print(h,'-djpeg','-r300','-zbuffer',[pathname '\' filename '_merged_weighted']);
        close(h);
    end
else  %如果是双图
    subplot(321)
    
    bar(stps,a_stp)
    v1=axis;
    if min(stps)~=max(stps)
        xlim([min(stps),max(stps)])
    end
    title(A_name)
    
    subplot(322)
    bar(delay,a_delay,'r')
    if min(delay)~=max(delay)
        xlim([min(delay),max(delay)])
    end
    v1_d=axis;
    title(A_name)
    xlabel('delay / ms');
    
    subplot(323)
    bar(stps,b_stp)
    if min(stps)~=max(stps)
        xlim([min(stps),max(stps)])
    end
    title(B_name);
    v2=axis;
    xlabel('start time / ms');
    
    subplot(324)
    bar(delay,b_delay,'r')
    if min(delay)~=max(delay)
        xlim([min(delay),max(delay)])
    end
    title(B_name);
    v2_d=axis;
    xlabel('delay / ms');
    
    % v=max([v1;v2],[],1);
    % axis(v)
    % subplot(321);
    % bar(stps,a_stp)
    % xlim([min(stps),max(stps)])
    % title(A_name)
    % xlabel('start time / ms');
    % axis(v);
    
    % v_d=max([v1_d;v2_d],[],1);
    % axis(v_d)
    % subplot(321);
    % bar(delay,b_delay)
    % xlim([min(delay),max(delay)])
    % title(A_name)
    % xlabel('start time / ms');
    % axis(v_d);
    
    subplot(325)
    bar(stps,c_stp);
    if min(stps)~=max(stps)
        xlim([min(stps),max(stps)])
    end
    xlabel('start time / ms');
    title([B_name ' - ' A_name 'Diff: ' num2str(diff_AB(1)) ' (%)']);
    
    subplot(326)
    bar(delay,c_delay);
    if min(delay)~=max(delay)
        xlim([min(delay),max(delay)])
    end
    xlabel('delay / ms');
    
    title([B_name ' - ' A_name 'Diff: ' num2str(diff_AB(2)) ' (%)']);
    ylim([-0.5 0.5]);
    if ~isempty(filename)
        saveas(h,[pathname '\' filename],'fig')
        print(h,'-djpeg','-r300','-zbuffer',[pathname '\' filename]);
        close(h);
    end
    
    if mer_mode==0
        h=figure();
        
        [idx,idy]=meshgrid(1:length(stps),1:length(delay));
        dataA_map=arrayfun(@(idx,idy) hist_count(dataA,stps,delay,idx,idy),idx,idy)./cntA;  %(dly,stp)
        dataB_map=arrayfun(@(idx,idy) hist_count(dataB,stps,delay,idx,idy),idx,idy)./cntB;
        subplot(211)
        imagesc(stps,delay,dataA_map)
        if min(stps)~=max(stps)
            xlim([min(stps),max(stps)])
        end
        v1=caxis;
        subplot(212)
        imagesc(stps,delay,dataB_map);
        if min(stps)~=max(stps)
            xlim([min(stps),max(stps)])
        end
        v2=caxis;
        axis xy;
        title(B_name)
        v=max([v1;v2],[],1);
        % v=[0 1500];
        caxis(v)
        colorbar
        subplot(211)
        caxis(v)
        title(A_name)
        colorbar
        axis xy;
        if ~isempty(filename)
            saveas(h,[pathname '\' filename '_merged'],'fig')
            print(h,'-djpeg','-r300','-zbuffer',[pathname '\' filename '_merged']);
            close(h)
        end
    end
    h=figure();
    if mer_mode==0
        dataA_map=arrayfun(@(idx,idy) hist_count_weighted(dataA,stps,delay,idx,idy),idx,idy)./cntA;
        dataB_map=arrayfun(@(idx,idy) hist_count_weighted(dataB,stps,delay,idx,idy),idx,idy)./cntB;
    end
    subplot(211)
    imagesc(stps,delay,dataA_map)
    if min(stps)~=max(stps)
        xlim([min(stps),max(stps)])
    end
    v1=caxis;
    subplot(212)
    imagesc(stps,delay,dataB_map);
    if min(stps)~=max(stps)
        xlim([min(stps),max(stps)])
    end
    v2=caxis;
    axis xy;
    title(B_name)
    v=max([v1;v2],[],1);
    % v=[0 1500];
    caxis(v)
    colorbar
    subplot(211)
    caxis(v)
    title(A_name)
    colorbar
    axis xy;
    if ~isempty(filename)
        saveas(h,[pathname '\' filename '_merged_weighted'],'fig')
        print(h,'-djpeg','-r300','-zbuffer',[pathname '\' filename '_merged_weighted']);
        close(h);
    end
end

% movA=movie_create(x,x,dataA_map',v);
% movB=movie_create(x,x,dataB_map',v);
% 
% movie2avi(movA,[pathname '\' filename '_movA'],'compression','None');
% movie2avi(movB,[pathname '\' filename '_movB'],'compression','None');
function data_map=hist_count(data,x,y,idx,idy)
if length(x)>1
    x_step=(x(2)-x(1))/2;
else
    x_step=0.5;
end
if length(y)>1
    y_step=(y(2)-y(1))/2;
else
    y_step=0.5;
end
data_map=sum((data(:,1)>=(x(idx)-x_step)&data(:,1)<(x(idx)+x_step))&(data(:,2)>=(y(idy)-y_step)&data(:,2)<(y(idy)+y_step)));
% data_map=sum((data(:,1)==x(idx))&(data(:,2)==y(idy)));

function data_map=hist_count_weighted(data,x,y,idx,idy)
if length(x)>1
    x_step=(x(2)-x(1))/2;
else
    x_step=0.5; 
end
if length(y)>1
    y_step=(y(2)-y(1))/2;
else
    y_step=0.5;
end
loc=(data(:,1)>=(x(idx)-x_step)&data(:,1)<(x(idx)+x_step))&(data(:,2)>=(y(idy)-y_step)&data(:,2)<(y(idy)+y_step));
% loc=(data(:,1)==x(idx))&(data(:,2)==y(idy));
data_map=sum(data(loc,3));

function mov=movie_create(x,y,data,v)
% Preallocate the struct array for the struct returned by getframe
mov(2*size(data,2)) = struct('cdata',[],'colormap',[]);
data_fix=zeros(size(data,1),3*size(data,2));  %2倍起始时间，方便后期寻址
data_fix(:,size(data,2)+1:2*size(data,2))=data;
idy=1:length(y);
h=figure();
for frm=1:2*size(data,2)
    frm_idx=frm+size(data,2);
    frm_data=cell2mat(arrayfun(@(dly) data_fix(dly,round(frm_idx-(idy/length(y))*dly )),idy,'UniformOutput',0)');
    imagesc(frm_data)
%     title(x(frm));
    caxis(v);
    axis xy;
    mov(frm)=getframe;
end
 close(h);
 
function [dataA,dataB,cntA,cntB,stps,delay,a_stp,a_delay,b_stp,b_delay,a_stp_s,a_delay_s,b_stp_s,b_delay_s,c_stp,c_delay,filename,A_name,B_name]=...
    pre_process(A,B,channel_A,channel_B,data_type,rat_montage,region_idxA,region_idxB,cb1,ed1,mer_mode)

dataA_temp=getfield(A.data,data_type);
dataA=cell2mat2(dataA_temp(channel_A,channel_B),mer_mode);
if region_idxA==region_idxB
    channel_pair=length(channel_A)*(length(channel_B)-1);
else
    channel_pair=length(channel_A)*(length(channel_B));
end
    
cntA=A.trial_num*channel_pair;
dataB_temp=getfield(B.data,data_type);
dataB=cell2mat2(dataB_temp(channel_A,channel_B),mer_mode);
cntB=B.trial_num*channel_pair;



if cb1
    dataA=dataA';
    dataB=dataB';
end
A_name=cell2mat(cellfun(@(x) [x{:} ' '],A.attrname,'UniformOutput',0));
B_name=cell2mat(cellfun(@(x) [x{:} ' '],B.attrname,'UniformOutput',0));

filename=[A_name ' vs ' B_name '@' rat_montage{region_idxA}.name '_' rat_montage{region_idxB}.name];
A_name=strrep(A_name,'_','\_');
B_name=strrep(B_name,'_','\_');

if isempty(dataB) || isempty(dataA) %防止出错，一旦有空集则将全部输出变量值为零
    stps=[];
    delay=[];
    a_stp=[];
    b_stp=[];
    a_delay=[];
    b_delay=[];
    a_stp_s=[];
    b_stp_s=[];
    a_delay_s=[];
    b_delay_s=[];
    c_stp=[];
    c_delay=[];
    return;
end

if ~sum(strcmp(fieldnames(A),'startpoint'))
    hist_num=str2double(ed1);
    if ~isnan(hist_num)
        [a_stp ]=hist(dataA(:,1),hist_num);
        [a_delay ]=hist(dataA(:,2),hist_num);
        [b_stp stps]=hist(dataB(:,1),hist_num);
        [b_delay delay]=hist(dataB(:,2),hist_num);
    else
        [a_stp ]=hist(dataA(:,1));
        [a_delay ]=hist(dataA(:,2));
        [b_stp stps]=hist(dataB(:,1));
        [b_delay delay]=hist(dataB(:,2));
    end
    
else
    stps=A.startpoint;%+A.w1*1000/A.fs;
    delay=A.delay;
    
    a_stp=hist(dataA(:,1),stps)./cntA;
    a_delay=hist(dataA(:,2),delay)./cntA;
    b_stp=hist(dataB(:,1),stps)./cntB;
    b_delay=hist(dataB(:,2),delay)./cntB;
    
end

a_stp_s=a_stp./sum(a_stp);
a_delay_s=a_delay./sum(a_delay);

b_stp_s=b_stp./sum(b_stp);
b_delay_s=b_delay./sum(b_delay);

c_stp=(b_stp_s-a_stp_s)./a_stp_s;
c_delay=(b_delay_s-a_delay_s)./a_delay_s;

function [dataA_map,dataB_map,dataA_map_weighted,dataB_map_weighted,A_name,B_name,stp,dly]=bundle(A,B,channel_A,channel_B,data_type,rat_montage,region_idxA,region_idxB,cb1,ed1,mer_mode)
%% 直接输出合并后的图
try
    [dataA1,dataB1,cntA1,cntB1,stps,delay,a_stp,a_delay,b_stp,b_delay,a_stp_s,a_delay_s,b_stp_s,b_delay_s,c_stp,c_delay,filename,A_name,B_name]=...
        pre_process(A,B,channel_A,channel_B,data_type,rat_montage,region_idxA,region_idxB,cb1,ed1);
    [dataA2,dataB2,cntA2,cntB2,stps,delay,a_stp,a_delay,b_stp,b_delay,a_stp_s,a_delay_s,b_stp_s,b_delay_s,c_stp,c_delay,filename,~,~]=...
        pre_process(A,B,channel_B,channel_A,data_type,rat_montage,region_idxB,region_idxA,cb1,ed1);
    if mer_mode==0
    [dataA1_map,dataB1_map,dataA1_map_weighted,dataB1_map_weighted]=map_generater(stps,delay,dataA1,dataB1,cntA1,cntB1);
    [dataA2_map,dataB2_map,dataA2_map_weighted,dataB2_map_weighted]=map_generater(stps,delay,dataA2,dataB2,cntA2,cntB2);
    else
        dataA1_map=dataA1;
        dataB1_map=dataB1;
        dataA2_map=dataA2;
        dataB2_map=dataB2;
        dataA1_map_weighted=dataA1;
        dataB1_map_weighted=dataB1;
        dataA2_map_weighted=dataA2;
        dataB2_map_weighted=dataB2;
    end
    dly_len=size(dataA1_map',1);
    stp_len=size(dataA1_map',2)-size(dataA1_map',1);
    dataA_map=zeros(1+stp_len,2*dly_len-1);
    dataB_map=zeros(1+stp_len,2*dly_len-1);
    dataA_map_weighted=dataA_map;
    dataB_map_weighted=dataB_map;
    dataA_map(:,dly_len:end)=dataA1_map(dly_len:end,:)./cntA1;
    dataB_map(:,dly_len:end)=dataB1_map(dly_len:end,:)./cntB1;
    dataA_map_weighted(:,dly_len:end)=dataA1_map_weighted(dly_len:end,:)./cntA1;
    dataB_map_weighted(:,dly_len:end)=dataB1_map_weighted(dly_len:end,:)./cntB1;
    for y=1:dly_len
        %     sel_mat(y,dly_len-y+1:dly_len-y+1+stp_len)=1;
        dataA_map(:,1+dly_len-y)=dataA2_map(dly_len-y+1:dly_len-y+1+stp_len,y)./cntA2;
        dataB_map(:,1+dly_len-y)=dataB2_map(dly_len-y+1:dly_len-y+1+stp_len,y)./cntB2;
        dataA_map_weighted(:,1+dly_len-y)=dataA2_map_weighted(dly_len-y+1:dly_len-y+1+stp_len,y)./cntA2;
        dataB_map_weighted(:,1+dly_len-y)=dataB2_map_weighted(dly_len-y+1:dly_len-y+1+stp_len,y)./cntB2;
    end
    stp=stps(dly_len:end);
    dly=[fliplr(-delay(2:end)+1) delay-1];
catch err
    dataA_map=nan;
    dataB_map=nan;
    dataA_map_weighted=nan;
    dataB_map_weighted=nan;
    A_name=nan;
    B_name=nan;
    stp=nan;
    dly=nan;
end
% --- Executes on button press in pushbutton9.

%% plot_fig_pair
function plot_fig_pair(stps,delay,cntA1,cntB1,cntA2,cntB2,a_stp,a_delay,b_stp,b_delay,c_stp,c_delay,dataA1,dataB1,dataA2,dataB2,diff,A_name,B_name,filename,pathname,mer_mode)


% h=figure();
% 
[idx,idy]=meshgrid(1:length(stps),1:length(delay)); 
% dataA1_map=arrayfun(@(idx,idy) hist_count(dataA1,stps,delay,idx,idy),idx,idy);  %(dly,stp)
% dataB1_map=arrayfun(@(idx,idy) hist_count(dataB1,stps,delay,idx,idy),idx,idy);
% dataA2_map=arrayfun(@(idx,idy) hist_count(dataA2,stps,delay,idx,idy),idx,idy);  %(dly,stp)
% dataB2_map=arrayfun(@(idx,idy) hist_count(dataB2,stps,delay,idx,idy),idx,idy);
% 
% dly_len=size(dataA1_map,1);
% stp_len=size(dataA1_map,2)-size(dataA1_map,1);
% new1=zeros(1+stp_len,2*dly_len-1)';
% new2=zeros(1+stp_len,2*dly_len-1)';
% new1(dly_len:end,:)=dataA1_map(:,dly_len:end)./cntA1;
% new2(dly_len:end,:)=dataB1_map(:,dly_len:end)./cntB1;
% 
% for y=1:dly_len
% %     sel_mat(y,dly_len-y+1:dly_len-y+1+stp_len)=1;
% new1(1+dly_len-y,:)=dataA2_map(y,dly_len-y+1:dly_len-y+1+stp_len)./cntA2;
% new2(1+dly_len-y,:)=dataB2_map(y,dly_len-y+1:dly_len-y+1+stp_len)./cntB2;
% end
% 
% stps_new=stps(dly_len:end);
% delay_new=[fliplr(-delay(2:end)+1) delay-1];
% subplot(211)
% imagesc(stps_new,delay_new,new1);axis xy;
% if min(stps_new)~=max(stps_new)
%     xlim([min(stps_new),max(stps_new)])
% end
% v1=caxis;
% subplot(212)
% imagesc(stps_new,delay_new,new2); axis xy;
% if min(stps_new)~=max(stps_new)
%     xlim([min(stps_new),max(stps_new)])
% end
% v2=caxis;
% axis xy;
% title(B_name)
% v=max([v1;v2],[],1);
% % v=[0 1500];
% caxis(v)
% colorbar
% subplot(211)
% caxis(v)
% title([A_name 'paired'])
% colorbar
% axis xy;
% if ~isempty(filename)
%     saveas(h,[pathname '\' filename '_merged_paired'],'fig')
%     print(h,'-djpeg','-r300','-zbuffer',[pathname '\' filename '_merged_paired']);
%     close(h)
% end

h=figure();
if mer_mode==0
    dataA1_map=arrayfun(@(idx,idy) hist_count_weighted(dataA1,stps,delay,idx,idy),idx,idy);  %(dly,stp)
    dataB1_map=arrayfun(@(idx,idy) hist_count_weighted(dataB1,stps,delay,idx,idy),idx,idy);
    dataA2_map=arrayfun(@(idx,idy) hist_count_weighted(dataA2,stps,delay,idx,idy),idx,idy);  %(dly,stp)
    dataB2_map=arrayfun(@(idx,idy) hist_count_weighted(dataB2,stps,delay,idx,idy),idx,idy);
else
    dataA1_map=dataA1;
    dataB1_map=dataB1;
    dataA2_map=dataA2;
    dataB2_map=dataB2;
end
dly_len=size(dataA1_map,1);
stp_len=size(dataA1_map,2)-size(dataA1_map,1);
new1=zeros(1+stp_len,2*dly_len-1)';
new2=zeros(1+stp_len,2*dly_len-1)';
new1(dly_len:end,:)=dataA1_map(:,dly_len:end)./cntA1;
new2(dly_len:end,:)=dataB1_map(:,dly_len:end)./cntB1;

for y=1:dly_len
%     sel_mat(y,dly_len-y+1:dly_len-y+1+stp_len)=1;
new1(1+dly_len-y,:)=dataA2_map(y,dly_len-y+1:dly_len-y+1+stp_len)./cntA2;
new2(1+dly_len-y,:)=dataB2_map(y,dly_len-y+1:dly_len-y+1+stp_len)./cntB2;
end

stps_new=stps(dly_len:end);
delay_new=[fliplr(-delay(2:end)+1) delay-1];
subplot(211)
imagesc(stps_new,delay_new,new1)
if min(stps_new)~=max(stps_new)
    xlim([min(stps_new),max(stps_new)])
end
v1=caxis;
subplot(212)
imagesc(stps_new,delay_new,new2);
if min(stps_new)~=max(stps_new)
    xlim([min(stps_new),max(stps_new)])
end
v2=caxis;
axis xy;
title(B_name)
v=max([v1;v2],[],1);
% v=[0 1500];
caxis(v)
colorbar
subplot(211)
caxis(v)
title([A_name 'paired'])
colorbar
axis xy;
if ~isempty(filename)
    saveas(h,[pathname '\' filename '_merged_weighted_paired'],'fig')
    print(h,'-djpeg','-r300','-zbuffer',[pathname '\' filename '_merged_weighted_paired']);
    close(h)
end

function plot_fig_pair_single(stps,delay,cntA1,cntA2,dataA1,dataA2,A_name,filename,pathname,mer_mode)
[idx,idy]=meshgrid(1:length(stps),1:length(delay)); 
h=figure();
if mer_mode==0
    dataA1_map=arrayfun(@(idx,idy) hist_count_weighted(datimeseriestaA1,stps,delay,idx,idy),idx,idy);  %(dly,stp)
    dataA2_map=arrayfun(@(idx,idy) hist_count_weighted(dataA2,stps,delay,idx,idy),idx,idy);  %(dly,stp)
else
    dataA1_map=dataA1;
    dataA2_map=dataA2;
end
dly_len=size(dataA1_map,1);
stp_len=size(dataA1_map,2)-size(dataA1_map,1);
new1=zeros(1+stp_len,2*dly_len-1)';

new1(dly_len:end,:)=dataA1_map(:,dly_len:end)./cntA1;

for y=1:dly_len
%     sel_mat(y,dly_len-y+1:dly_len-y+1+stp_len)=1;
new1(1+dly_len-y,:)=dataA2_map(y,dly_len-y+1:dly_len-y+1+stp_len)./cntA2;
end

stps_new=stps(dly_len:end);
delay_new=[fliplr(-delay(2:end)+1) delay-1];

imagesc(stps_new,delay_new,new1)
if min(stps_new)~=max(stps_new)
    xlim([min(stps_new),max(stps_new)])
end

% v=[0 1500];
colorbar

title([A_name 'paired'])
colorbar
axis xy;
if ~isempty(filename)
    saveas(h,[pathname '\' filename '_merged_weighted_paired'],'fig')
    print(h,'-djpeg','-r300','-zbuffer',[pathname '\' filename '_merged_weighted_paired']);
    close(h)
end

function mer_mode=get_merging_mode(handles)
str=get(handles.listbox8,'String');
switch str{1}
    case {'SL_locs','PCMI_locs'}
        mer_mode=0;
    case {'SL','PCMI'}
        mer_mode=1;
    otherwise
        warndlg('Not supported data type!')
        return;
end
function tempA=loc_find_shell(N_data,min_I,min_percent,t_step,st0,dl0)
[tempA]=loc_find(N_data,min_I,min_percent);
if ~isempty(tempA)
    tempA(:,1:2)=(tempA(:,1:2)-1)*t_step;
    tempA(:,1)=tempA(:,1)+st0;
    tempA(:,2)=tempA(:,2)+dl0;
end


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
