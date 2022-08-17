function varargout = single_stat(varargin)
% SINGLE_STAT MATLAB code for single_stat.fig
%      SINGLE_STAT, by itself, creates a new SINGLE_STAT or raises the existing
%      singleton*.
%
%      H = SINGLE_STAT returns the handle to a new SINGLE_STAT or the handle to
%      the existing singleton*.
%
%      SINGLE_STAT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SINGLE_STAT.M with the given input arguments.
%
%      SINGLE_STAT('Property','Value',...) creates a new SINGLE_STAT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before single_stat_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to single_stat_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help single_stat

% Last Modified by GUIDE v2.5 22-Feb-2013 16:50:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @single_stat_OpeningFcn, ...
                   'gui_OutputFcn',  @single_stat_OutputFcn, ...
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


% --- Executes just before single_stat is made visible.
function single_stat_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to single_stat (see VARARGIN)

% Choose default command line output for single_stat
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes single_stat wait for user response (see UIRESUME)
% uiwait(handles.figure1);
global freq_def
freq_def=[0.05,4;4,8;8,13;13,30;30,50];

% --- Outputs from this function are returned to the command line.
function varargout = single_stat_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles) %LOAD FILE
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global collected_data  map_attr_grouped map_attr map_attr_selected  rat_montage map_attr_ori
%载入grouped_file文件
[filename pathname]=uigetfile('*.mat','Select collected_data mat-file');
load([pathname filename]);    %collected_data
set(handles.text18,'String',['Current file: ' filename]);
cd(pathname);

%load montage
pushbutton12_Callback(hObject,eventdata,handles);  

%显示可选子集
% fld_temp=fieldnames(collected_data{1});
% fld=fieldnames(collected_data{1}.data);
% set(handles.listbox7,'String',fld);
% set(handles.listbox7,'Enable','on');
channel_all=[];
for m=1:length(rat_montage)
    channel_all=[channel_all rat_montage{m}.channel];
end
%% 找出目标数据文件的分类,做出分类表
data_attr_map=cell(1,length(collected_data));
for idxd=1:length(collected_data)
    data_attr_map{idxd}=attr_extracter(collected_data{idxd}.name,'_');
end%

tag_len=cellfun(@(x) length(x),data_attr_map);
for idx=1:max(tag_len)
    tag_map=tag_len>=idx;
    tags{idx}=unique(cellfun(@(x) x{idx},data_attr_map(tag_map),'UniformOutput',0));
    
end

%% 选择标签类
str = tags;
str=cellfun(@(x) [x{:}],str,'UniformOutput',0);
[s,v] = listdlg('PromptString','Select compare sets',...
    'SelectionMode','multiple',...
    'ListString',str);
% selected_tag=str(s);
sin_tag=s(s<=min(tag_len));
mul_tag=s(s>min(tag_len));
group_kwd=[];
for idx=1:length(sin_tag)-1
    for t_idx=1:length(tags{sin_tag(idx)})
        group_kwd=[group_kwd ' ''' tags{sin_tag(idx)}{t_idx} ''''];
    end
    group_kwd=[group_kwd ';'];
end
if ~isempty(mul_tag)
    choice=zeros(length(mul_tag),1);
    for idx=1:length(mul_tag)
        button = questdlg([tags(mul_tag(idx)) '并未在所有数据中具有此分类，是否合并到前级？'],'Merging tags','Yes','No','Yes');
        choice(idx)=strcmp(button,'Yes');
    end
    choice=[0 choice];
    zero_loc=find(choice==0);
    for idx=1:length(zero_loc)
        if idx<length(zero_loc)
            temp=find_name(data_attr_map,sin_tag(end)-1+zero_loc(idx):zero_loc(idx+1));
        else
            temp=find_name(data_attr_map,sin_tag(end)-1+zero_loc(idx):zero_loc(end));
        end
        group_kwd=[group_kwd temp];
    end
else
    for t_idx=1:length(tags{max(sin_tag)})
        group_kwd=[group_kwd ' ''' tags{sin_tag(end)}{t_idx} ''''];
    end
    group_kwd=[group_kwd ';'];
end
clear('str','s','v');
%% 输入分组定义
answer=inputdlg({'Grouping keyword: e.g. ''ctrl'' ''pain'';''pre'' ''post'' 如果需要多级标签则用_来分离多级标签'},'Grouping keywords',1,{group_kwd});
groupingidx=find(answer{1}==';');
if(answer{1}(end)==';')  %解决最后的分组可能无分号的问题
else
    groupingidx=[groupingidx length(answer{1})];
end
group_start=1;
for idx=1:length(groupingidx)
    if(idx>1)
        group_start=groupingidx(idx-1);
    end
    eval(['grouping{' num2str(idx) '}={' answer{1}(group_start:groupingidx(idx)) '};'])
end
clear('answer','groupingidx');

%% 生成分组目录
map_attr=cell(length(grouping),length(collected_data));
% map_attr=nan(length(grouping),length(collected_data));
for idxd=1:length(collected_data)
    for idxg=1:length(grouping)
        map_attr{idxg,idxd}=[]; %若无此标签分类，则属性为[]
        for idxc=1:length(grouping{idxg})   
            %2012-4-15 增加对多级标签的支持
            grouping_list=attr_extracter(grouping{idxg}{idxc},'_');
            found=1;
            for mul_src_idx=1:length(grouping_list)
                if(isempty(find(strcmp(data_attr_map{idxd},grouping_list(mul_src_idx)), 1)))
                    %             if(isempty(strfind(collected_data{idxd}.name,grouping{idxg}{idxc})))
                    found=0;
                end
            end
            if found==1
                map_attr{idxg,idxd}=grouping{idxg}{idxc};
                break;
            end
        end
    end
end
map_attr_selected=grouping;
map_attr_grouped=grouping;
map_attr_ori=map_attr;
%% 控件参数设置
%listbox1->选择需要对比的legend标签级别
% str_group=cellfun(@(x,y) [[x{:}] ' vs ' [y{:}]],map_attr_groupedA(:),map_attr_groupedB(:),'UniformOutput',0);
for idx=1:length(grouping)
    str_temp=[];
    for idx2=1:length(grouping{idx})
        str_temp=[str_temp grouping{idx}{idx2} ' '];
    end
    str_group{idx}=str_temp;
end

set(handles.listbox7,'String',str_group);
set(handles.listbox7,'Enable','on');

compare_idx=get(handles.listbox7,'Value');
set(handles.listbox8,'String',map_attr_selected{compare_idx});
set(handles.listbox9,'String',map_attr_selected{compare_idx});




% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles) %load montage
% hObject    handle to pushbutton12 (see GCBO)
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
set(handles.text17,'String',['Current montage: ' filename]);

str_mtg=cellfun(@(x) x.name,rat_montage,'UniformOutput',0);
set(handles.listbox10,'String',str_mtg); %选择montage中的相应脑区
% set(handles.listbox4,'String',str_mtg);

% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles) %计算当前的选择
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global collected_data rat_montage map_attr map_attr_selected compare_set freq_def
compare_idx=get(handles.listbox7,'Value');
compare_tagA=get(handles.listbox8,'String');temp_idx=get(handles.listbox8,'Value');compare_tagA=compare_tagA{temp_idx};
compare_tagB=get(handles.listbox9,'String');temp_idx=get(handles.listbox9,'Value');compare_tagB=compare_tagB{temp_idx};
idx_enable=ones(1,size(map_attr,2));
for idx=1:length(map_attr_selected)
    idx_enable=idx_enable&cellfun(@(x) sum(strcmp(x,map_attr_selected{idx})),map_attr(idx,:));
end
idx_A=reshape(cell2mat(cellfun(@(x) strcmp(x,compare_tagA),map_attr(compare_idx,:),'UniformOutput',0)),1,[]);%先确定A，再根据A的每一项确定相应的B
idx_A=idx_A&idx_enable;
idx_A=find(idx_A);
count=1;
compare_set_temp=[];
idx_left=idx_A;
while ~isempty(idx_left)
    tags_B=map_attr(:,idx_left(1)); %找到A的标签
    tags_B{compare_idx}={compare_tagB};
    idx_B=ones(1,length(map_attr(compare_idx,:)));
    for idx_tg=1:length(tags_B)
        idx_B=idx_B.*reshape(cell2mat(cellfun(@(x) strcmp(x,tags_B{idx_tg}),map_attr(idx_tg,:),'UniformOutput',0)),1,[]);
    end
    idx_B=find(idx_B);
%     for count_B=1:length(idx_B)
%         count=count+1;
    loc=arrayfun(@(x) isequal(map_attr(:,x),map_attr(:,idx_left(1))),idx_left);
    compare_set_temp{count}.A=idx_left(loc);
    compare_set_temp{count}.B=idx_B;
    compare_set_temp{count}.tagA=map_attr(:,idx_left(1));
    compare_set_temp{count}.tagB=map_attr(:,idx_B(1));
    loc_idx=find(loc);
    idx_left(loc)=[];
    count=count+1;
end
compare_set=compare_set_temp;

%处理电极分组
region_idx=get(handles.listbox10,'Value');
channel=rat_montage{region_idx}.channelNo;

stat_output=[];
print_cnt=1;
data_type='STFT';
% Diff_spec=[];
freq_def=[0.05,4;4,8;8,13;13,30;30,50];
stat_output=cell(length(compare_set),6);
data=zeros(length(compare_set),10);
algo=get(handles.listbox13,'Value');
for count=1:length(compare_set)
    A_loc=compare_set{count}.A;
    B_loc=compare_set{count}.B;
    FFT_tim=str2double(get(handles.edit3,'String'));
    
    if isnan(FFT_tim)
        FFT_tim=[];
    end
    if ~isempty(A_loc) && ~isempty(B_loc)
        [wave_pre_A wave_post_A spec_pre_A spec_post_A f stft_P_A stft_F_A stft_T_A fs_A]...
            =spec_cal(collected_data(A_loc),channel,FFT_tim);
        [wave_pre_B wave_post_B spec_pre_B spec_post_B f stft_P_B stft_F_B stft_T_B fs_B]...
            =spec_cal(collected_data(B_loc),channel,FFT_tim);
        switch num2str(algo)
            case '1'
                specA_post=spec_post_A./repmat(sum(spec_post_A,2),1,size(spec_post_A,2));
                specA_pre=spec_pre_A./repmat(sum(spec_pre_A,2),1,size(spec_post_A,2));
                specA=specA_post-specA_pre;%标化后相减
                specB_post=spec_post_B./repmat(sum(spec_post_B,2),1,size(spec_post_B,2));
                specB_pre=spec_pre_B./repmat(sum(spec_pre_B,2),1,size(spec_post_B,2));
                specB=specB_post-specB_pre;
                c_tag=1;
            case '2'
                specA_post=spec_post_A./repmat(sum(spec_post_A,2),1,size(spec_post_A,2));
                specB_post=spec_post_B./repmat(sum(spec_post_B,2),1,size(spec_post_B,2));
                specA=spec_post_A-spec_pre_A;%直接相减
                specB=spec_post_B-spec_pre_B;
                c_tag=2;
            case '3'
                specA_post=spec_post_A./repmat(sum(spec_post_A,2),1,size(spec_post_A,2));
%                 specA_post=mean(specA_post,1);
                specB_post=spec_post_B./repmat(sum(spec_post_B,2),1,size(spec_post_B,2));
%                 specB_post=mean(specB_post,1);
%                 if ~isequal(size(specA_post),size(specB_post))
%                     specA=mean(nan(freq_def(5,2),1),1);
%                     specB=mean(specA,1);
%                 else
                    specA=mean(specA_post,1);
                    specB=mean(specB_post,1);%nan(size(specA));
%                 end
                    c_tag=3;
            case '4'
%                 spec_post_A=mean(spec_post_A,1);
%                 spec_post_B=mean(spec_post_B,1);
                specA=mean(spec_post_A,1);
                specB=mean(spec_post_B,1);%nan(size(specA));
                c_tag=4;
        end
        name=[compare_set{count}.tagA{:} ' vs ' compare_set{count}.tagB{:}];
        data(count,:)=[mean(sum(specA(:,f>=freq_def(1,1)&f<freq_def(1,2)),2)) ...
            mean(sum(specA(:,f>=freq_def(2,1)&f<freq_def(2,2)),2)) ...
            mean(sum(specA(:,f>=freq_def(3,1)&f<freq_def(3,2)),2)) ...
            mean(sum(specA(:,f>=freq_def(4,1)&f<freq_def(4,2)),2)) ...
            mean(sum(specA(:,f>=freq_def(5,1)&f<freq_def(5,2)),2)) ...
            mean(sum(specB(:,f>=freq_def(1,1)&f<freq_def(1,2)),2)) ...
            mean(sum(specB(:,f>=freq_def(2,1)&f<freq_def(2,2)),2)) ...
            mean(sum(specB(:,f>=freq_def(3,1)&f<freq_def(3,2)),2)) ...
            mean(sum(specB(:,f>=freq_def(4,1)&f<freq_def(4,2)),2)) ...
            mean(sum(specB(:,f>=freq_def(5,1)&f<freq_def(5,2)),2))];
        col=1;
        %A
        stat_output{count,col}=name; col=col+1;
        stat_output{count,col}=data(count,col-1);col=col+1;
        stat_output{count,col}=data(count,col-1);col=col+1;
        stat_output{count,col}=data(count,col-1);col=col+1;
        stat_output{count,col}=data(count,col-1);col=col+1;
        stat_output{count,col}=data(count,col-1);col=col+1;
        %B
        stat_output{count,col}=data(count,col-1);col=col+1;
        stat_output{count,col}=data(count,col-1);col=col+1;
        stat_output{count,col}=data(count,col-1);col=col+1;
        stat_output{count,col}=data(count,col-1);col=col+1;
        stat_output{count,col}=data(count,col-1);col=col+1;
        %stat
        
        switch c_tag
            case {1,2,3}
                specA_temp=zeros(size(specA_post,1),size(freq_def,1));
                specB_temp=zeros(size(specB_post,1),size(freq_def,1));
                for count2=1:length(freq_def)
                    specA_temp(:,count2)=sum(specA_post(:,f>=freq_def(count2,1)&f<freq_def(count2,2)),2);
                    specB_temp(:,count2)=sum(specB_post(:,f>=freq_def(count2,1)&f<freq_def(count2,2)),2);
                end
                [~,stat_temp]=ttest2(specA_temp,specB_temp);
            case 4
                specA_temp=zeros(size(spec_post_A,1),size(freq_def,1));
                specB_temp=zeros(size(spec_post_B,1),size(freq_def,1));
                for count2=1:size(freq_def,1)
                    specA_temp(:,count2)=sum(spec_post_A(:,f>=freq_def(count2,1)&f<freq_def(count2,2)),2);
                    specB_temp(:,count2)=sum(spec_post_B(:,f>=freq_def(count2,1)&f<freq_def(count2,2)),2);
                end
                [~,stat_temp]=ttest2(specA_temp,specB_temp);
        end
        stat_output{count,col}=stat_temp(col-11);col=col+1;
        stat_output{count,col}=stat_temp(col-11);col=col+1;
        stat_output{count,col}=stat_temp(col-11);col=col+1;
        stat_output{count,col}=stat_temp(col-11);col=col+1;
        stat_output{count,col}=stat_temp(col-11);col=col+1;
    end
%     prompt={'Enter the filename:'};
%     name='Input for xls filename';
%     numlines=1;
%     defaultanswer={'single_stat_result'};
%     answer=inputdlg(prompt,name,numlines,defaultanswer);
%     xlsname=answer{1};
    xlsname=[name '.xls'];
    if ~isempty(specA_temp)&&~isempty(specB_temp)
        xlswrite(xlsname,specA_temp,'GroupA');
        xlswrite(xlsname,specB_temp,'GroupB');
        sheet123cleaner([xlsname ],pwd);
    end
    %     not0_row=sum(Diff_spec~=0,2);
%     Diff_spec(not0_row==0,:)=[];
end

% figure(5);
set(handles.uitable2,'Data',stat_output);

function [wave_pre_out wave_post_out spec_pre_out spec_post_out spec_f stft_P stft_F stft_T fs ]=spec_cal(collected_data,channel,FFT_tim)
 data=cellfun(@(x) x.data.STFT,collected_data,'UniformOutput',0);
wave_pre_out=[];
wave_post_out=[];
spec_pre_out=[];
spec_post_out=[];
spec_f=[];
stft_P=[];
stft_F=[];
stft_T=[];
fs=[];

found=0;
for idx=1:length(data)
    for trl=1:length(data{idx})
        for chn=1:length(channel)
            if ~isempty(data{idx}{trl}) && sum(data{idx}{trl}{channel(chn)}.waveform_pre) && sum(data{idx}{trl}{channel(chn)}.waveform_post)~=0
                wave_pre_len=length(data{idx}{trl}{channel(chn)}.waveform_pre);
                wave_post_len=length(data{idx}{trl}{channel(chn)}.waveform_post);
                stft_size=size(data{idx}{trl}{channel(chn)}.P);
                stft_T=data{idx}{trl}{channel(chn)}.T;
                stft_F=data{idx}{trl}{channel(chn)}.F;
                found=1;
            end
            if found==1
                break;
            end
        end
        if found==1
            break;
        end
    end
    if found==1
        break;
    end
end
if found==1
    wave_pre_out=zeros(sum(cellfun(@length,data))*length(channel),wave_pre_len);
    wave_post_out=zeros(sum(cellfun(@length,data))*length(channel),wave_post_len);
    stft_P=zeros(stft_size);
    fs=unique(cellfun(@(x) x.fs,collected_data));
    cnt=0;
    for idx=1:length(data)
        for trl=1:length(data{idx})
            for chn=1:length(channel)
                if ~isempty(data{idx}{trl}{channel(chn)})
                    if sum(data{idx}{trl}{channel(chn)}.waveform_pre) && sum(data{idx}{trl}{channel(chn)}.waveform_post)~=0
                        cnt=cnt+1;
                        wave_pre_out(cnt,:)=[data{idx}{trl}{channel(chn)}.waveform_pre];  %将所有波形整合为一个矩阵(trial x length)
                        wave_post_out(cnt,:)=[data{idx}{trl}{channel(chn)}.waveform_post];  %将所有波形整合为一个矩阵(trial x length)
                        stft_P=stft_P+ data{idx}{trl}{channel(chn)}.P;
                        
                    end
                end
            end
        end
    end
    not0_row=sum(wave_pre_out~=0,2);
    wave_pre_out(not0_row==0,:)=[];
    wave_post_out(not0_row==0,:)=[];
    stft_P=stft_P./cnt;
    %     dataA_temp=getfield(A.data,data_type); %取得STFT结果 .data.STFT{trial}{channel} .S /.F /.T /.P /.waveform
    if isempty(FFT_tim)
        NFFT=2^nextpow2(size(wave_pre_out,2));
    else
        NFFT=round(FFT_tim*fs/1000);
    end
    spec_f=fs/2*linspace(0,1,NFFT/2+1);
    spec_pre_out=fft(wave_pre_out,NFFT,2);
    spec_pre_out=abs(spec_pre_out(:,1:NFFT/2+1));  %Dim2->freq,Dim1->samples
    
    spec_post_out=fft(wave_post_out,NFFT,2);
    spec_post_out=abs(spec_post_out(:,1:NFFT/2+1));  %Dim2->freq,Dim1->samples
end
% abc=1;
% --- Executes on selection change in listbox12.
function listbox12_Callback(hObject, eventdata, handles)
% hObject    handle to listbox12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox12 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox12


% --- Executes during object creation, after setting all properties.
function listbox12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



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


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in listbox10.
function listbox10_Callback(hObject, eventdata, handles)
% hObject    handle to listbox10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox10 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox10


% --- Executes during object creation, after setting all properties.
function listbox10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox7.
function listbox7_Callback(hObject, eventdata, handles)
% hObject    handle to listbox7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox7 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox7
global map_attr_selected
compare_idx=get(hObject,'Value');
set(handles.listbox8,'String',map_attr_selected{compare_idx});set(handles.listbox8,'Value',1);
set(handles.listbox9,'String',map_attr_selected{compare_idx});set(handles.listbox9,'Value',1);

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


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)  %选择比较标签
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
%handles    structure with handles and user data (see GUIDATA)

% % 选择比较的标签大类
global rat_montage map_attr_grouped map_attr_selected map_attr collected_data  map_attr_ori

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

set(handles.listbox8,'String',map_attr_selected{1});  % A group
set(handles.listbox9,'String',map_attr_selected{1});  % B group


%% 控件参数设置
%listbox1->选择需要对比的legend标签级别
% str=cellfun(@(x,y) [[x{:}] ' vs ' [y{:}]],map_attr_groupedA(:),map_attr_groupedB(:),'UniformOutput',0);
for idx=1:length(map_attr_selected)
    str_temp=[];
    for idx2=1:length(map_attr_selected{idx})
        str_temp=[str_temp map_attr_selected{idx}{idx2} ' '];
    end
    str_group{idx}=str_temp;
end
set(handles.listbox7,'Value',1);
set(handles.listbox7,'String',str_group);



% --- Executes on selection change in listbox9.
function listbox9_Callback(hObject, eventdata, handles)
% hObject    handle to listbox9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox9 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox9


% --- Executes during object creation, after setting all properties.
function listbox9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox8.
function listbox8_Callback(hObject, eventdata, handles)
% hObject    handle to listbox8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox8 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox8


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


% --- Executes on key press with focus on uitable2 and none of its controls.
function uitable2_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to uitable2 (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
global collected_data rat_montage map_attr map_attr_selected compare_set freq_def current_selected_row
if strcmp('return',eventdata.Key);
    compare_idx=get(handles.listbox7,'Value');
    compare_tagA=get(handles.listbox8,'String');temp_idx=get(handles.listbox8,'Value');compare_tagA=compare_tagA{temp_idx};
    compare_tagB=get(handles.listbox9,'String');temp_idx=get(handles.listbox9,'Value');compare_tagB=compare_tagB{temp_idx};
    idx_A=reshape(cell2mat(cellfun(@(x) strcmp(x,compare_tagA),map_attr(compare_idx,:),'UniformOutput',0)),1,[]);%先确定A，再根据A的每一项确定相应的B
    idx_A=find(idx_A);
    count=1;
    compare_set_temp=[];
    idx_left=idx_A;
    while ~isempty(idx_left)
        tags_B=map_attr(:,idx_left(1)); %找到A的标签
        tags_B{compare_idx}={compare_tagB};
        idx_B=ones(1,length(map_attr(compare_idx,:)));
        for idx_tg=1:length(tags_B)
            idx_B=idx_B.*reshape(cell2mat(cellfun(@(x) strcmp(x,tags_B{idx_tg}),map_attr(idx_tg,:),'UniformOutput',0)),1,[]);
        end
        idx_B=find(idx_B);
        %     for count_B=1:length(idx_B)
        %         count=count+1;
        loc=arrayfun(@(x) isequal(map_attr(:,x),map_attr(:,idx_left(1))),idx_left);
        compare_set_temp{count}.A=idx_left(loc);
        compare_set_temp{count}.B=idx_B;
        compare_set_temp{count}.tagA=map_attr(:,idx_left(1));
        compare_set_temp{count}.tagB=map_attr(:,idx_B(1));
        loc_idx=find(loc);
        idx_left(loc)=[];
        count=count+1;
    end
    compare_set=compare_set_temp;
    
    %处理电极分组
    region_idx=get(handles.listbox10,'Value');
    channel=rat_montage{region_idx}.channelNo;
    
    stat_output=[];
    print_cnt=1;
    data_type='STFT';
    % Diff_spec=[];
    
    stat_output=cell(length(compare_set),6);
    count=current_selected_row;
    A_loc=compare_set{count}.A;
    B_loc=compare_set{count}.B;
    FFT_tim=str2double(get(handles.edit3,'String'));
    if isnan(FFT_tim)
        FFT_tim=[];
    end
    if ~isempty(A_loc) && ~isempty(B_loc)
        [wave_pre_A wave_post_A spec_pre_A spec_post_A f stft_P_A stft_F_A stft_T_A fs_A]...
            =spec_cal(collected_data(A_loc),channel,FFT_tim);
        [wave_pre_B wave_post_B spec_pre_B spec_post_B f stft_P_B stft_F_B stft_T_B fs_B]...
            =spec_cal(collected_data(B_loc),channel,FFT_tim);
        specA_post=spec_post_A./repmat(sum(spec_post_A,2),1,size(spec_post_A,2));
        specA_pre=spec_pre_A./repmat(sum(spec_pre_A,2),1,size(spec_post_A,2));
        specA=specA_post-specA_pre;%标化后相减
        specB_post=spec_post_B./repmat(sum(spec_post_B,2),1,size(spec_post_B,2));
        specB_pre=spec_pre_B./repmat(sum(spec_pre_B,2),1,size(spec_post_B,2));
        specB=specB_post-specB_pre;
        name=[compare_set{count}.tagA{:} ' vs ' compare_set{count}.tagB{:}];
        plot_fig(wave_pre_A,wave_pre_B,wave_post_A,wave_post_B,spec_pre_A,spec_pre_B,spec_post_A,spec_post_B,f,stft_P_A,stft_P_B,stft_F_A,stft_T_A,fs_A,...
            freq_def,name,[],[]);
    end
    %     not0_row=sum(Diff_spec~=0,2);
    %     Diff_spec(not0_row==0,:)=[];
end


% --- Executes when selected cell(s) is changed in uitable2.
function uitable2_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to uitable2 (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
global current_selected_row
if ~isempty(eventdata.Indices)
    current_selected_row=eventdata.Indices(1);
end

function plot_fig(wave_pre_A,wave_pre_B,wave_post_A,wave_post_B,spec_pre_A,spec_pre_B,spec_post_A,spec_post_B,f,stft_P_A,stft_P_B,stft_F,stft_T,fs,...
    freq_def,name,pathname,filename)
fig_num=0;
fig_num=fig_num+1;figure(fig_num);
subplot(2,1,1);plot([1:size(wave_pre_A,2)]/fs*1000,[mean(wave_pre_A,1);mean(wave_post_A,1)]');xlabel('time / ms');ylabel('Amplitude / nv');lim1=ylim;title('Waveform comparation');
subplot(2,1,2);plot([1:size(wave_pre_A,2)]/fs*1000,[mean(wave_pre_B,1);mean(wave_post_B,1)]');xlabel('time / ms');ylabel('Amplitude / nv');lim2=ylim;
lim=[min([lim1 lim2]) max([lim1 lim2])];ylim(lim);
subplot(2,1,1);ylim(lim);



specA_post=spec_post_A./repmat(sum(spec_post_A,2),1,size(spec_post_A,2));  %convert abs power to relative power
specA_pre=spec_pre_A./repmat(sum(spec_pre_A,2),1,size(spec_post_A,2));
specA=mean(specA_post-specA_pre,1);%标化后相减
specB_post=spec_post_B./repmat(sum(spec_post_B,2),1,size(spec_post_B,2));
specB_pre=spec_pre_B./repmat(sum(spec_pre_B,2),1,size(spec_post_B,2));
specB=mean(specB_post-specB_pre,1);
A=zeros(size(freq_def,1),1);B=zeros(size(freq_def,1),1);
idx=1;
A(idx)=mean(sum(specA(:,f>=freq_def(1,1)&f<freq_def(1,2)),2));idx=idx+1;
A(idx)=mean(sum(specA(:,f>=freq_def(2,1)&f<freq_def(2,2)),2));idx=idx+1;
A(idx)=mean(sum(specA(:,f>=freq_def(3,1)&f<freq_def(3,2)),2));idx=idx+1;
A(idx)=mean(sum(specA(:,f>=freq_def(4,1)&f<freq_def(4,2)),2));idx=idx+1;
A(idx)=mean(sum(specA(:,f>=freq_def(5,1)&f<freq_def(5,2)),2));idx=1;
B(idx)=mean(sum(specB(:,f>=freq_def(1,1)&f<freq_def(1,2)),2));idx=idx+1;
B(idx)=mean(sum(specB(:,f>=freq_def(2,1)&f<freq_def(2,2)),2));idx=idx+1;
B(idx)=mean(sum(specB(:,f>=freq_def(3,1)&f<freq_def(3,2)),2));idx=idx+1;
B(idx)=mean(sum(specB(:,f>=freq_def(4,1)&f<freq_def(4,2)),2));idx=idx+1;
B(idx)=mean(sum(specB(:,f>=freq_def(5,1)&f<freq_def(5,2)),2));idx=idx+1;
fig_num=fig_num+1;figure(fig_num);
subplot(2,2,1);shadedErrorBar(f,specA_post-specA_pre,{@median,@std},{'r','markerfacecolor','r'});xlabel('frequency / Hz');ylabel('Power percentage change');lim1=ylim;
subplot(2,2,2);shadedErrorBar(f,specB_post-specB_pre,{@median,@std},{'r','markerfacecolor','r'});xlabel('frequency / Hz');ylabel('Power percentage change');lim2=ylim;
% subplot(2,2,1);plot(f,specA);xlabel('frequency / Hz');ylabel('Power percentage change');lim1=ylim;
% subplot(2,2,2);plot(f,specB);xlabel('frequency / Hz');ylabel('Power percentage change');lim2=ylim;
lim=[min([lim1 lim2]) max([lim1 lim2])];ylim(lim);
subplot(2,2,1);ylim(lim);
subplot(2,2,[3 4]);bar([A B]);set(gca,'Xticklabel',{'Delta','Theta','Alpha','Beta','Gamma'})
title('Change in relative power')

fig_num=fig_num+1;figure(fig_num);
specAB_post=mean(specA_post,1)-mean(specB_post,1);
idx=1;
AB(idx)=mean(sum(specAB_post(:,f>=freq_def(1,1)&f<freq_def(1,2)),2));idx=idx+1;
AB(idx)=mean(sum(specAB_post(:,f>=freq_def(2,1)&f<freq_def(2,2)),2));idx=idx+1;
AB(idx)=mean(sum(specAB_post(:,f>=freq_def(3,1)&f<freq_def(3,2)),2));idx=idx+1;
AB(idx)=mean(sum(specAB_post(:,f>=freq_def(4,1)&f<freq_def(4,2)),2));idx=idx+1;
AB(idx)=mean(sum(specAB_post(:,f>=freq_def(5,1)&f<freq_def(5,2)),2));idx=1;

bar(AB);set(gca,'Xticklabel',{'Delta','Theta','Alpha','Beta','Gamma'});title('A post vs B post');
fig_num=fig_num+1;figure(fig_num);
specA_diff=mean(spec_post_A-spec_pre_A,1);
specB_diff=mean(spec_post_B-spec_pre_B,1);
spec_pre_diff=mean(spec_pre_B,1)-mean(spec_pre_A,1);
spec_post_diff=mean(spec_post_B,1)-mean(spec_post_A,1);
subplot(4,1,1);plot(f,specA_diff);xlabel('frequency / Hz');ylabel('Abs.Power change');title('GroupA post-pre');lim1=ylim;
subplot(4,1,2);plot(f,specB_diff);xlabel('frequency / Hz');ylabel('Abs.Power change');title('GroupB post-pre');lim2=ylim;
subplot(4,1,3);plot(f,spec_pre_diff);xlabel('frequency / Hz');ylabel('Abs.Power change');title('GroupA-GroupB pre');lim3=ylim;
subplot(4,1,4);plot(f,spec_post_diff);xlabel('frequency / Hz');ylabel('Abs.Power change');title('GroupA-GroupB post');lim4=ylim;
lim=[min([lim1 lim2 lim3 lim4]) max([lim1 lim2 lim3 lim4])];ylim(lim);
subplot(4,1,1);ylim(lim);
subplot(4,1,2);ylim(lim);
subplot(4,1,3);ylim(lim);
fig_num=fig_num+1;figure(fig_num);
plot(f,specA*100);hold on;plot(f,specB*100,'r');
xlabel('frequency / Hz');ylabel('Rel.Power change(precentage)');legend('GroupA','GroupB');
fig_num=fig_num+1;figure(fig_num);
subplot(2,1,1);imagesc(stft_T*1000,stft_F,stft_P_A);axis xy;xlabel('time / ms');ylabel('Power');clim1=caxis;
subplot(2,1,2);imagesc(stft_T*1000,stft_F,stft_P_B);axis xy;xlabel('time / ms');ylabel('Power');clim2=caxis;
clim=[min([clim1 clim2]) max([clim1 clim2])];
caxis(clim);
subplot(2,1,1);caxis(clim);


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


% --- Executes on selection change in listbox13.
function listbox13_Callback(hObject, eventdata, handles)
% hObject    handle to listbox13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox13 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox13


% --- Executes during object creation, after setting all properties.
function listbox13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
