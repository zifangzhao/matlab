function varargout = DAT_scope(varargin)
% DAT_SCOPE MATLAB code for DAT_scope.fig
%      DAT_SCOPE, by itself, creates a new DAT_SCOPE or raises the existing
%      singleton*.
%
%      H = DAT_SCOPE returns the handle to a new DAT_SCOPE or the handle to
%      the existing singleton*.
%
%      DAT_SCOPE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DAT_SCOPE.M with the given input arguments.
%
%      DAT_SCOPE('Property','Value',...) creates a new DAT_SCOPE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DAT_scope_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DAT_scope_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DAT_scope

% Last Modified by GUIDE v2.5 13-Mar-2015 23:18:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DAT_scope_OpeningFcn, ...
                   'gui_OutputFcn',  @DAT_scope_OutputFcn, ...
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


% --- Executes just before DAT_scope is made visible.
function DAT_scope_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DAT_scope (see VARARGIN)

% Choose default command line output for DAT_scope
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
global filename  hobj plotting_on  Yscale N_channel selected_channel time_scale fs LP_on HP_on WL_on Ref_on Mean_on HP_v LP_v WL_l WL_h WL_p HD32_on c_eff line_clr;
plotting_on=0;
% plotting_function(handles);
% UIWAIT makes DAT_scope wait for user response (see UIRESUME)
% uiwait(handles.figure1);
HD32_on=get(handles.checkboxRecFormat,'Value') ;
time_scale=str2double(get(handles.edit4,'String')) ;
Yscale=[str2double(get(handles.edit2,'String')) str2double(get(handles.edit3,'String')) ];
LP_on=get(handles.checkbox1,'Value') ;
HP_on=get(handles.checkbox5,'Value') ;
WL_on=get(handles.checkbox7,'Value') ;
Ref_on=get(handles.checkbox3,'Value') ;
Mean_on=get(handles.checkbox2,'Value') ;
LP_v=str2double(get(handles.edit5,'String')) ;
HP_v=str2double(get(handles.edit6,'String')) ;
WL_l=str2double(get(handles.wl_low,'String'));
WL_h=str2double(get(handles.wl_high,'String'));
WL_p=str2double(get(handles.wl_pts,'String'));
fs=str2double(get(handles.edit13,'String'));
selected_channel=str2num(get(handles.edit9,'String'));
N_channel=str2double(get(handles.edit8,'String'));
c_eff=str2double(get(handles.editCeff,'String'));
line_clr=ones(32,1)*[0,0.447058823529412,0.741176470588235];
hobj=hObject;
for idx=1:31
% subaxis(4,8,idx, 'Spacing', 0.05, 'Padding', 0, 'Margin', 0.01);
eval(['axes(handles.axes' num2str(idx) ')']);
% plot(1:100);
set(gca,'color','none')
set(gca,'box','on');
set(gca,'xtick',[],'ytick',[]);

end
eval(['axes(handles.axes32)']);
set(gca,'color','none')
set(gca,'box','on');

for idx=1:32
    eval(['set(handles.axes' num2str(idx) ',''NextPlot'',''replacechildren'')']);
    eval(['set(handles.axes' num2str(idx) ',''HitTest'',''on'')']);
    eval(['set(handles.axes' num2str(idx) ',''ButtonDownFcn'',{@ClickOnFigure,handles})']);
    eval(['set(handles.T' num2str(idx) ',''ButtonDownFcn'',{@ClickOnFigure,handles})']);
    eval(['set(handles.T' num2str(idx) ',''HitTest'',''on'')']);
%    eval(['set(handles.axes' num2str(idx) ',''FontSmoothing'',''off'')']);
%     eval(['set(handles.axes' num2str(idx) ',''ButtonDownFcn'',''DAT_scope(''amplitude_indicator'',hObject,eventdata,guidata(hObject))'')']);
%     eval(['set(handles.axes' num2str(idx) ',''ButtonDownFcn'',@amplitude_indicator)'])
end
set(gcf, 'Renderer', 'painters')

function ClickOnFigure(hObject,eventdata,handles)
global line_clr line_handles stacked_handle
switch get(handles.figure1,'SelectionType')
    case 'open' %double click
    case 'alt'      %right click
        
    case 'normal' %left-click
        tag=get(hObject,'tag');
       if strcmp(tag(1:4),'Axes')
           amplitude_indicator(hObject,eventdata);
       end
    case 'extend' %middle-click
        num=str2double(regexpi(get(hObject,'Tag'),'\s*\d+','match')); %legacy support
        if ~isnan(num)
            line_clr(num,:)=uisetcolor();
            set(line_handles(num),'Color',line_clr(num,:));
            set(stacked_handle(num),'Color',line_clr(num,:));
        end
end


% --- Outputs from this function are returned to the command line.
function varargout = DAT_scope_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% select the filename, and do other file operations
global filename;
[f, p]=uigetfile('.dat','Binary Files','Select the recording file');
filename=[p f];
cd(p);
xml_files=dir([f(1:end-4) '.xml']);
if isempty(xml_files)
   try 
       if ispc
           system(['copy template.xml ' f(1:end-4) '.xml']);
           system(['copy template.nrs ' f(1:end-4) '.nrs']);
       else
           system(['scp template.xml ' f(1:end-4) '.xml']);
           system(['scp template.nrs ' f(1:end-4) '.nrs']);
       end
   end
end
% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global plotting_on 
if plotting_on==1
    set(handles.pushbutton2,'Enable','On');
else
    set(handles.pushbutton2,'Enable','Off');
end
plotting_on=~plotting_on;
plotting_function(handles);

function plotting_function(handles)
global h3 h3a HD32_on plotting_on fs filename selected_channel Yscale N_channel time_scale LP_on HP_on WL_on Ref_on Mean_on LP_v HP_v WL_l WL_h WL_p first_plot WL_handles line_handles trig_handles c_eff current_beep stacked_handle tmr1 tmr2
global line_clr current_ptr data_buffer stimu_on
%data_buffer is the raw data
convert_eff=1/65535*2.5/300*1e6;
first_plot=1;
%resample rate calculate
max_pts=1600;%max_pts for each plot
try
   h3.Color; %try to detect if h3 is valid
catch
    h3=figure(3);
    set(h3,'Color',[1.0000    0.9627    0.8863])
    set(h3,'keypressfcn',@Figure_Keypress)
    h3a=gca;
end

% set(h3a,'ButtonDownFcn',@keypress_int)
current_beep=[];
ff=dir(filename);
current_ptr=ff(1).bytes;
display_time=time_scale/1000;%str2double(get(handles.edit4,'String'))/1000;
data_buffer=zeros(N_channel,display_time*fs);
display_buffer=zeros(N_channel,display_time*fs);
display_ptr=1;
stimu_on=zeros(N_channel,display_time*fs);
len2read=100;
while plotting_on
    pts_now=time_scale/1000*fs;
    res_t=round(pts_now/max_pts);
    res_t(res_t<1)=1;
    res_fs=2*WL_h;
    res_fs(res_fs>fs)=fs;
    pts_now_f=time_scale/1000*res_fs;
    res_f=round(pts_now_f/max_pts);
    res_f(res_f<1)=1;

    display_time=time_scale/1000;%str2double(get(handles.edit4,'String'))/1000;
    a_new=[];
%     [a_new,fb]=readmulti_frank(filename,N_channel,selected_channel,-display_time*fs,0,'int16'
%     );'
    
    tic
    
    while size(a_new,1)<len2read %This one limit the refresh rate to make the display smoother
        [a_new,fb]=readmulti_frank(filename,N_channel,selected_channel,current_ptr/2/N_channel,current_ptr/2/N_channel+len2read,'int16' );
        if toc>2
            pushbutton3_Callback([], [], handles)
            a_new=zeros(len2read,32);
            break;
        end
    end
    
    a_new=a_new(1:len2read,:)';
    %     ff=dir(filename);
    current_ptr=current_ptr+len2read*N_channel*2;
    set(handles.figure1,'Name',['Recording...' datestr(current_ptr./fs/N_channel/2/3600/24,'HH:MM:SS.FFF')]);
    if HD32_on
        a_new=a_new+32768;
        a_bin=dec2bin(a_new(1:length(selected_channel)),16);
        counter=bin2dec(a_bin(:,end-3:end-1));
        a_new=reshape(a_new,length(selected_channel),[]);
        eliminate_bits=4;
        a1=a_new-floor((a_new)/2)*2;
        a_new=floor(a_new/(2^eliminate_bits))*(2^eliminate_bits);
        a_new=a_new-32768;
        a_new=a_new*convert_eff;
        %     stimu_on=a_bin(:,end);
        stimu_on_new=a1;
    else
        counter=selected_channel';
        a_new=(a_new)*0.195;%(1/65535/1000*1e6*3);
%         stimu_on=zeros(length(selected_channel),1);
    end
    %% update the new data into buffer
    new_len=size(a_new,2);
    if new_len>=size(data_buffer,2)
        data_buffer=a_new(:,end-size(data_buffer,2)+1:end);
        stimu_on=stimu_on_new(:,end-size(data_buffer,2)+1:end);
    else
        data_buffer(:,1:end-new_len)=data_buffer(:,new_len+1:end);
        data_buffer(:,end-new_len+1:end)=a_new;
        stimu_on(:,1:end-new_len)=stimu_on(:,new_len+1:end);
        stimu_on(:,end-new_len+1:end)=stimu_on_new;
    end
    a=data_buffer;
    y_lim=Yscale;%[str2double(get(handles.edit2,'String')) str2double(get(handles.edit3,'String'))];
    if LP_on%%LP filter 
        Wn=LP_v;%str2double(get(handles.edit5,'String'));
        [bb,aa]=butter(3,Wn/fs,'low');
        a=filter(bb,aa,a,[],2);
    end
    
    if HP_on%%HP filter
        Wn=HP_v;%str2double(get(handles.edit6,'String'));
        [bb,aa]=butter(3,Wn/fs,'high');
        a=filter(bb,aa,a,[],2);
    end
    med=median(a,2);
    if Mean_on
        a=bsxfun(@minus,a,mean(a,2)); %subtract the mean of all channel from itself(DC removal)
    end
    if Ref_on
        a=bsxfun(@minus,a,mean(a,1)); %rereference the display by subtracting the mean of all channels
    end

    xt=(1:res_t:size(a,2))/fs;
    f_list=linspace(WL_l,WL_h,WL_p);%linspace(str2double(get(handles.wl_low,'String')),str2double(get(handles.wl_high,'String')),str2double(get(handles.wl_pts,'String'))); 
    if WL_on
        P=ones(round(display_time*res_fs),length(f_list),length(selected_channel));
        for c_idx=1:length(selected_channel)
            tmp=awt_freqlist(resample(a(c_idx,:),res_fs,fs),res_fs,f_list,'Gabor');
            P(:,:,c_idx)=(abs(tmp));
        end
    end
   if first_plot
       WL_handles=zeros(32,1);
       line_handles=zeros(32,1);
   end
   counter_str=num2str(counter);
   range_str=num2str(range(a,2));
   med_str=num2str(med);
   std_str=num2str(std(a,[],2));
   if display_ptr+new_len-1<size(display_buffer,2)
       display_buffer(:,display_ptr+1:display_ptr+new_len)=a(:,end-new_len+1:end);
       display_ptr=display_ptr+new_len-1;
   else
       len2end=(size(display_buffer,2)-display_ptr);
       leninfront=new_len-len2end;
       display_buffer(:,display_ptr+1:end)=a(:,end-new_len+1:end-leninfront);
       display_buffer(:,1:leninfront)=a(:,end-leninfront+1:end);
       display_ptr=leninfront;
   end
%    if first_plot
%        pause(0.2) ; %make some room for the keypress_interrupt
%    end
   for idx=1:length(selected_channel)
       h=getfield(handles,['axes' num2str(idx)]);
       if first_plot
%            pause(0.05); %make some room for the keypress_interrupt
           if ~WL_on
               hold(h,'off')
               line_handles(idx)=plot(h,xt,a(idx,1:res_t:end),'linewidth',1,'ButtonDownFcn',{@ClickOnFigure,handles},'Tag',['Plot' num2str(idx)],'Color',line_clr(idx,:));
               xlim(h,[0,display_time]);
               ylim(h,y_lim);
               hold(h,'on')
               trig_handles(idx)=scatter(h,[],[],'r*','ButtonDownFcn',{@ClickOnFigure,handles},'Tag',['Trig' num2str(idx)]);
               hold(h,'off')

           else
               WL_handles(idx)=imagesc(linspace(0,display_time,display_time*res_fs/res_f),f_list,(P(1:res_f:end,:,idx))' ,'ButtonDownFcn',{@ClickOnFigure,handles},'Parent',h,[0,diff(y_lim)/5*c_eff]);
               axis(h,'xy','tight')
               hold(h,'on')
               trig_handles(idx)=scatter(h,[],[],'r*');
               hold(h,'off')
               if WL_on==2
                   hold(h,'on')
                   line_handles(idx)=plot(h,xt,(a(idx,1:res_t:end)-Yscale(1))/(Yscale(2)-Yscale(1))*(WL_h-WL_l)+WL_l,'linewidth',1,'color',[1,1,1]);
                   ylim(h,[WL_l,WL_h]);
                   hold(h,'off')
               end
               
           end
           if idx<33
               set(h,'xtick',[],'ytick',[]);
           end
           %             cla
           set(h,'ButtonDownFcn',{@ClickOnFigure,handles},'Tag',['Axes' num2str(idx)]);
           hold(h3a,'off');
           stacked_handle=plot(h3a,xt,bsxfun(@plus,a(:,1:res_t:end),(length(selected_channel)-1:-1:0)'*diff(y_lim)/2)','b','hittest','off');
           arrayfun(@(x) set(stacked_handle(x),'Color',line_clr(x,:)),1:length(stacked_handle));
           hold(h3a,'on');
           stacked_marker=bar(h3a,xt,zeros(length(xt),1),1,'Edgecolor','none','facecolor','r','ShowBaseLine','off','hittest','off');
           alpha(0.5);
           hold(h3a,'off');
           axis(h3a,'tight');
           set(h3a,'box','off')
           set(h3a,'visible','off')
           set(h3a,'xtick',[])
           set(h3a,'ytick',[])
           ylim(h3a,[-diff(y_lim/2),diff(y_lim)*length(selected_channel)/2]);
           %drawnow
       else
           if ~WL_on
               set(line_handles(idx),'ydata',display_buffer(idx,1:res_t:end))
           else
               set(WL_handles(idx),'Cdata',(P(1:res_f:end,:,idx))');
               if WL_on==2
                   set(line_handles(idx),'ydata',(a(idx,1:res_t:end)-Yscale(1))/(Yscale(2)-Yscale(1))*(WL_h-WL_l)+WL_l);
               end
           end
           set(stacked_handle(idx),'ydata',a(idx,1:res_t:end)+(length(selected_channel)-idx)*diff(y_lim)/2);
       end
       eval(['set(handles.T' num2str(idx) ',''String'',''CH:' counter_str(idx,:) ' Vpp:' range_str(idx,:) ' Mean:' med_str(idx,:) ' Std:' std_str(idx,:)  'uV'')' ]);
       %         if stimu_on(idx)~=0;
       %             eval(['set(handles.T' num2str(idx) ',''ForeGroundColor'',''r'')' ]);
       %             beep
       %         else
       %             eval(['set(handles.T' num2str(idx) ',''ForeGroundColor'',''k'')' ]);
       trigs=find(stimu_on(idx,:))/fs;
       set(trig_handles(idx),'xdata',(1:1000)/fs,'ydata',zeros(1000,1));
       set(trig_handles(idx),'xdata',trigs,'ydata',y_lim(2)/2*ones(length(trigs),1))
   end
   set(h3,'name',['Recording...' datestr(current_ptr./fs/N_channel/2/3600/24,'HH:MM:SS.FFF')],'numbertitle','off')
   stimu_ptr=sum(stimu_on,1);
   stimu_time=find(stimu_ptr)+ff.bytes/N_channel/2-length(stimu_ptr);
   set(stacked_marker,'xdata',xt,'ydata',resample(stimu_ptr,1,res_t)*1000000);
   if ~isempty(stimu_time)
       if ~isempty(current_beep)
           if current_beep<stimu_time(end)
               current_beep=stimu_time(end);
               beep;
           end
       else
           current_beep=stimu_time(end);
           beep;
       end
   end
   first_plot=0;
   if fb-current_ptr>1*fs*N_channel*2
        len2read=len2read+50;
    end
   drawnow ;
end

function Figure_Keypress(hObject,eventdata,handles)
global hobj
handles=guidata(hobj);
keypress_int(hObject, eventdata, handles)

function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double
global Yscale first_plot
Yscale(1)=str2double(get(handles.edit2,'String'));
first_plot=1;
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
global Yscale first_plot
Yscale(2)=str2double(get(handles.edit3,'String'));
first_plot=1;
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



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double
global time_scale first_plot
time_scale=str2double(get(handles.edit4,'String'));
first_plot=1;
% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_3_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global plotting_on
plotting_on=0;


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1
global LP_on
LP_on=get(handles.checkbox1,'Value');


function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double
global LP_v
LP_v=str2double(get(handles.edit5,'string'));

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


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2
global Mean_on
Mean_on=get(handles.checkbox2,'Value');
% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3
global Ref_on
Ref_on=get(handles.checkbox3,'Value');
% --- Executes on button press in checkbox5.
function checkbox5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox5
global HP_on
HP_on=get(handles.checkbox5,'Value');


function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double
global HP_v
HP_v=str2double(get(handles.edit6,'string'));

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



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double
global selected_channel first_plot
selected_channel=str2num(get(handles.edit9,'String'));
first_plot=1;
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



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double
global N_channel
N_channel=str2double(get(handles.edit8,'String'));

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


% --- Executes on button press in checkbox7.
function checkbox7_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox7
global WL_on first_plot
WL_on=WL_on+1;
if WL_on==3
    WL_on=0;
    set(handles.checkbox7,'Value',0);
    set(handles.checkbox7,'Foregroundcolor','k');
else
    set(handles.checkbox7,'Value',1);
    if WL_on==2
        set(handles.checkbox7,'Foregroundcolor','r');
    end
end
for idx=1:32
    if  get(handles.checkbox7,'Value')
        eval(['set(handles.axes' num2str(idx) ',''HitTest'',''off'')']);
    else
        eval(['set(handles.axes' num2str(idx) ',''HitTest'',''on'')']);
    end
end
first_plot=1;

function wl_low_Callback(hObject, eventdata, handles)
% hObject    handle to wl_low (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of wl_low as text
%        str2double(get(hObject,'String')) returns contents of wl_low as a double
global WL_l first_plot
WL_l=str2double(get(hObject,'String'));
first_plot=1;
% --- Executes during object creation, after setting all properties.
function wl_low_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wl_low (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on mouse press over axes background.
function axes1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on mouse press over axes background.
function axes2_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on mouse press over axes background.
function axes3_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on mouse press over axes background.
function axes4_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on mouse press over axes background.
function axes5_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on mouse press over axes background.
function axes6_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on mouse press over axes background.
function axes7_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on mouse press over axes background.
function axes8_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on mouse press over axes background.
function axes9_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on mouse press over axes background.
function axes10_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on mouse press over axes background.
function axes11_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on mouse press over axes background.
function axes12_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on mouse press over axes background.
function axes13_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on mouse press over axes background.
function axes14_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on mouse press over axes background.
function axes15_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on mouse press over axes background.
function axes16_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function amplitude_indicator(hObject,eventdata)
% if get(handles.checkbox7,'Value')
handles=guidata(hObject); 
axesHandle  = hObject;
if get(handles.checkbox7,'Value')
    coordinates = get(gca,'CurrentPoint'); 
    coordinates = coordinates(1,1:2);
    set(handles.Text_indicator,'String',[num2str(round(coordinates(1)*1000)) 'ms  ' num2str(round(coordinates(2))) 'Hz'])

else
   coordinates = get(axesHandle,'CurrentPoint'); 
   coordinates = coordinates(1,1:2);
   set(handles.Text_indicator,'String',[num2str(round(coordinates(1)*1000)) 'ms  ' num2str(round(coordinates(2))) 'uV'])

end

   
% end



function wl_pts_Callback(hObject, eventdata, handles)
% hObject    handle to wl_pts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of wl_pts as text
%        str2double(get(hObject,'String')) returns contents of wl_pts as a double
global WL_p first_plot
WL_p=str2double(get(hObject,'String'));
first_plot=1;
% --- Executes during object creation, after setting all properties.
function wl_pts_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wl_pts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function wl_high_Callback(hObject, eventdata, handles)
% hObject    handle to wl_high (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of wl_high as text
%        str2double(get(hObject,'String')) returns contents of wl_high as a double
global WL_h first_plot
WL_h=str2double(get(hObject,'String'));
first_plot=1;
% --- Executes during object creation, after setting all properties.
function wl_high_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wl_high (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on figure1 and none of its controls.
function figure1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
keypress_int(hObject, eventdata, handles);


function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double
global fs
fs=str2double(get(handles.edit13,'String'));

% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function keypress_int(hObject,eventdata,handles)
    global c_eff hobj plotting_on tmr1
    plotting_on=0;
    if isempty(eventdata)
        k=get(get(get(hObject,'Parent'),'Parent'), 'CurrentKey');
        m=get(get(get(hObject,'Parent'),'Parent'), 'CurrentModifier');
        handles=guidata(hobj);
    else
        k=eventdata.Key;
        m=eventdata.Modifier;
    end
    if strcmp(k,'o')
        pushbutton2_Callback(hObject, eventdata, handles)
    end
    if strcmp(k,'space')
        pushbutton3_Callback(hObject, eventdata, handles)
    end
    if strcmp(k,'p')||strcmp(k,'w')
        checkbox7_Callback(hObject, eventdata, handles)
    end
    if strcmp(k, 'r')
        set(handles.checkbox3,'Value',~get(handles.checkbox3,'Value'));
        checkbox3_Callback(hObject, eventdata, handles)
    end
    if strcmp(k, 'm')
        set(handles.checkbox2,'Value',~get(handles.checkbox2,'Value'));
        checkbox2_Callback(hObject, eventdata, handles)
    end
    if strcmp(k,'l')
        set(handles.checkbox1,'Value',~get(handles.checkbox1,'Value'));
        checkbox1_Callback(hObject, eventdata, handles)
    end
    if strcmp(k,'h')
        set(handles.checkbox5,'Value',~get(handles.checkbox5,'Value'));
        checkbox5_Callback(hObject, eventdata, handles)
    end
    if strcmp(k,'uparrow')||(strcmp(k,'i')&&isequal(m,{'control'}))  %up
        al=str2double(get(handles.edit2,'String'));
        ah=str2double(get(handles.edit3,'String'));
        if al+50<0 && ah-50>0
            al=al+50;
            ah=ah-50;
        end
        set(handles.edit2,'String',num2str(al))
        set(handles.edit3,'String',num2str(ah))
        edit2_Callback(hObject, eventdata, handles)
        edit3_Callback(hObject, eventdata, handles)
    end
    if strcmp(k,'downarrow')||(strcmp(k,'d')&&isequal(m,{'control'}))  %up
        al=str2double(get(handles.edit2,'String'));
        ah=str2double(get(handles.edit3,'String'));
        al=al-50;
        ah=ah+50;
        set(handles.edit2,'String',num2str(al))
        set(handles.edit3,'String',num2str(ah))
        edit2_Callback(hObject, eventdata, handles)
        edit3_Callback(hObject, eventdata, handles)
    end
    if strcmp(k,'leftarrow') %left
        al=str2double(get(handles.edit4,'String'));
        if al-100>0
            al=al-100;
        end
        set(handles.edit4,'String',num2str(al))
        edit4_Callback(hObject, eventdata, handles)
    end
    if strcmp(k,'rightarrow') %right
        al=str2double(get(handles.edit4,'String'));
        al=al+100;
        set(handles.edit4,'String',num2str(al))
        edit4_Callback(hObject, eventdata, handles)
    end
    if strcmp(k,'return')
        pushbutton3_Callback(hObject, eventdata, handles)
    end
    if strcmp(k,'subtract')
        c_eff=c_eff+0.01;
        set(handles.editCeff,'String',num2str(c_eff));
        editCeff_Callback(hObject, eventdata, handles)
    end
    if strcmp(k,'add')|| strcmp(k,'equal')
        if c_eff-0.01<=0
            c_eff=0.01;
        else
            c_eff=c_eff-0.01;
        end
        set(handles.editCeff,'String',num2str(c_eff));
        editCeff_Callback(hObject, eventdata, handles)
    end
    plotting_on=1;


function delay_display()
global plotting_on tmr1
plotting_on=1;

% --- Executes on key press with focus on pushbutton3 and none of its controls.
function pushbutton3_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
keypress_int(hObject, eventdata, handles)


% --- Executes on key press with focus on pushbutton2 and none of its controls.
function pushbutton2_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
keypress_int(hObject, eventdata, handles)


% --- Executes on key press with focus on checkbox1 and none of its controls.
function checkbox1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
keypress_int(hObject, eventdata, handles)


% --- Executes on key press with focus on checkbox5 and none of its controls.
function checkbox5_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to checkbox5 (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
keypress_int(hObject, eventdata, handles)


% --- Executes on key press with focus on checkbox7 and none of its controls.
function checkbox7_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to checkbox7 (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
keypress_int(hObject, eventdata, handles)


% --- Executes on key press with focus on checkbox2 and none of its controls.
function checkbox2_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
keypress_int(hObject, eventdata, handles)


% --- Executes on key press with focus on checkbox3 and none of its controls.
function checkbox3_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
keypress_int(hObject, eventdata, handles)


% --- Executes on button press in checkboxRecFormat.
function checkboxRecFormat_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxRecFormat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxRecFormat
global HD32_on
HD32_on=get(handles.checkboxRecFormat,'Value');
if HD32_on
    set(handles.edit13,'String','1250');
else
    set(handles.edit13,'String','20000');
end
edit13_Callback(hObject, eventdata, handles)
% --- Executes on key press with focus on checkboxRecFormat and none of its controls.
function checkboxRecFormat_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to checkboxRecFormat (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
keypress_int(hObject, eventdata, handles)



function editCeff_Callback(hObject, eventdata, handles)
% hObject    handle to editCeff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editCeff as text
%        str2double(get(hObject,'String')) returns contents of editCeff as a double
global c_eff first_plot
c_eff=str2double(get(handles.editCeff,'String'));
first_plot=1;
% --- Executes during object creation, after setting all properties.
function editCeff_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editCeff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
