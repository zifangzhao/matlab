%% manual classify unit types
defaultFigPos=get(0, 'defaultfigureposition');
% Can change position of the listbox by changing values of left and bottom
left=0;
bottom=300;
% Create a new position vector using our defined position and the default height and width
figpos=[left bottom defaultFigPos(3:4)];
% Set the default figure position
set(0,'defaultfigureposition',figpos);

[f_all,p]=uigetfile('*.res.*','MultiSelect','on');
if ~iscell(f_all)
    temp=f_all;
    f_all=cell(1);
    f_all{1}=temp;
end
unit_type={'noise','pyr','int','MUA','undeterminable'};

cnt=1;


%% main classfication routine
h=figure('units','normalized','outerposition',[0 0 1 1]);pause();
for f_idx=cnt:length(f_all)
%     try
        f=f_all{f_idx};
        loc=strfind(f,'.res');
        t_xml=fileread([p f(1:loc-1) '.xml']);
        Nch_str=regexpi(t_xml,'(?<=<nChannels>)\d+(?=<)','match');
        Nch=str2num(Nch_str{1});
        fileinfo = dir([p f]);
        fb=fileinfo(1).bytes;
        Nsamples=fb/2/Nch;
        
        fs_str=regexpi(t_xml,'(?<=<samplingRate>)\d+(?=<)','match');
        fs=str2num(fs_str{1});
 
        spk_time=importdata([p f])/fs;
        Rec_time=spk_time(end); %approximation of recording time 
        clu=importdata([p strrep(f,'.res.','.clu.')]); %spike time
        spk_Nclu=clu(1);
        spk_clu=clu(2:end);  %cluster index for each spike
        
        spk_type=zeros(size(spk_clu));
        %%
        clus=unique(spk_clu);
        Nclu=spk_Nclu;
        % M=round(Nclu^0.5);
        % N=ceil(Nclu^0.5);
        % for idx=1:length(Nclu);
        %     subplot(M,N,idx);
        % [~,clu_id]=sort(clus);
        %% plot CCG
        unit_class=cell(Nclu,1);
        for c_idx=1:Nclu
            %             Nclu
            sel_idx=spk_clu==clus(c_idx);
            %             timex(:,3)=1;
            if sum(sel_idx)>1
                [ccg,t]=CCG(spk_time(sel_idx)*1000,ones(size(spk_time(sel_idx))),'binSize',1,'duration',100,'mode','ccg');
                PlotCCG(t,ccg);
                
                pos=[0 0 100 200];
                set(h,'Name',f);
                title(['unit:' num2str(clus(c_idx)) ' FR=' num2str(sum(sel_idx)/Rec_time)]);
                [type_sel,~] = listdlg('PromptString',['Select type for Unit: ' num2str(clus(c_idx))],...
                    'SelectionMode','single',...
                    'ListString',unit_type);
                if isempty(type_sel)
                    break;
                end
                %             unit_class{c_idx}=unit_type(type_sel);
                spk_type(sel_idx)=type_sel;
            else
                spk_type(sel_idx)=1;
            end
        end
        if isempty(type_sel)
            break;
        end
        [a,b,c]=fileparts(f);
        b=strrep(b,'.res','.cls');
%         save([p b c],'unit_class');
        dlmwrite([p b c],spk_type);
        cnt=f_idx;
%     end
end
msgbox('Congrats! All units were classified!');
close(h);
set(0,'defaultfigureposition',defaultFigPos);