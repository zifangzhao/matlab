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

% Last Modified by GUIDE v2.5 26-Aug-2014 16:48:21

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
global filename  plotting_on  Yscale time_scale;
plotting_on=0;
% plotting_function(handles);
% UIWAIT makes DAT_scope wait for user response (see UIRESUME)
% uiwait(handles.figure1);

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
global filename;
[f, p]=uigetfile('.dat','Binary Files','Select the recording file');
filename=[p f];
cd(p);
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
global plotting_on filename
convert_eff=1/65535*3/200*1e6;
% convert_eff=1;
% fs=10.85e3;
fs=round(46e3/32);
% fs=700;
while plotting_on
    display_time=str2double(get(handles.edit4,'String'))/1000;
    a=readmulti_frank(filename,1,1,-display_time*2*fs*32,0,'int16');
    
    a_bin=dec2bin(a+32768,16);
%     counter=0:31;
    counter=bin2dec(a_bin(:,end-4:end));
%     a_bin(:,end-4:end)=repmat('00000',size(a,1),1);
%     a=bin2dec(a_bin(:,1:end-6))-32768;
    a=reshape(a,32,[]);
    a=a-repmat([0:31]',1,size(a,2));
    a=a*convert_eff;
    y_lim=[str2double(get(handles.edit2,'String')) str2double(get(handles.edit3,'String'))];
    if get(handles.checkbox1,'Value') %%LP filter 
        Wn=str2double(get(handles.edit5,'String'));
        [bb,aa]=butter(2,Wn/fs,'low');
        a=-filter(bb,aa,a,[],2);
    end
    
    if get(handles.checkbox5,'Value') %%LP filter
        Wn=str2double(get(handles.edit6,'String'));
        [bb,aa]=butter(2,Wn/fs,'high');
        a=filter(bb,aa,a,[],2);
    end
    med=median(a,2);
    if get(handles.checkbox2,'Value')
        a=a-repmat(mean(a,2),1,size(a,2));
    end
    if get(handles.checkbox3,'Value')
        a=a-repmat(mean(a,1),size(a,1),1);%rereference
    end

    xt=(1:size(a,2))/fs;
    for idx=1:32
        h=getfield(handles,['axes' num2str(idx)]);
        plot(h,xt,a(idx,:));
%         axis(h,'tight');
        xlim(h,[0,display_time]);
        ylim(h,y_lim);
        if idx<32
            set(h,'xtick',[],'ytick',[]);
        end
        eval(['set(handles.T' num2str(idx) ',''String'',''CH:' num2str(counter(idx)) ' Vpp:' num2str(range(a(idx,:))) ' Mean:' num2str(med(idx)) ' Std:' num2str(std(a(idx,:))) 'uV'')' ]);
    end
    drawnow;
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



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


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


% --- Executes on button press in checkbox5.
function checkbox5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox5



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
