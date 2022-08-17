%% ICA analysis based on EEGLAB
% function raw2ica(searchfile,train_percent)
clear('elim_channel');
[fd p]=uigetfile({'*.lfp','*.lfp|Select lfp files';'*.dat','*.dat|Select dat files';},'MultiSelect','On');
% s=inputdlg('Train set percentage:','train percentage',1,{'100'});
% train_percent=str2num(s{1});
train_percent=10;
% end
multiWaitbar('Processing files:',0);
if ~iscell(fd)
    temp=fd;
    fd=cell(1);
    fd{1}=temp;
end
for f_idx=1:length(fd)
    f=fd{f_idx};
    [Nch,fs,Nsamples,~,good_ch,time_bin]=DAT_xmlread([p f]);

    if ~exist('elim_channel','var')
        elim_channel=listdlg('PromptString','Select channels to skip','ListString',arrayfun(@(x) num2str(x),1:Nch,'UniformOutput',0),'SelectionMode','multiple'); %channels to be exclude from ICA analysis, this is systematic(setup dependent).
    end
    good_ch=setdiff(good_ch,elim_channel);
    
    if train_percent==100
        data_raw=readmulti_frank([p f],Nch,1:Nch,0,inf)';
        if(~isempty(time_bin))
            choice = questdlg('Noise detection found, skipping noisy data?', 'Data selection for ICA','Yes','No','No');
            if strcmp(choice,'Yes')
                disp('Noise detection file found, auto-skipping noisy data..........')
                data=data_raw(:,time_bin);
            else
                data=data_raw;
            end
        else
            data=data_raw;
        end
    else
        win=1000;
        Nwins=floor((Nsamples/win)-1);
        Nwins_selected=round(train_percent/100*Nwins);
        win_selected=randperm(Nwins);
        win_selected=sort(win_selected(1:Nwins_selected));
        data=zeros(Nch,Nwins_selected*win);
        for idx=1:Nwins_selected
            data(:,(idx-1)*1000+1:idx*1000)=readmulti_frank([p f],Nch,1:Nch,win_selected(idx)*1000,(win_selected(idx)+1)*1000-1)';
        end
    end
    EEGICA=pop_importdata('setname',f,'dataformat','array','data','data','srate',fs);
    EEGICA=pop_runica(EEGICA,'icatype','runica','chanind',good_ch,'concatenate','off');
    
    %% ICA 2 DAT
    

    % [f,p]=uiputfile('*.dat','Save ICA components to');
    fid=fopen([p f(1:end-4) '_ICA.' f(end-2:end)],'w+');
    disp(['Dat file saved to:']);
    disp([ f(1:end-4) '_ICA.'  f(end-2:end)]);
    [Nch,fs,Nsamples,ch_sel,good_ch,time_bin]=DAT_xmlread([p f(1:end)]);
    current_ptr=0;
    bulk=1e5;
    while(current_ptr<Nsamples)
        data_raw=readmulti_frank([p f],Nch,1:Nch,current_ptr,current_ptr+bulk)';
        current_ptr=current_ptr+bulk;
        x=zeros(size(data_raw));
        x(end,:)=data_raw(end,:);
        x(1:size(EEGICA.icaweights,1),:) = EEGICA.icaweights*EEGICA.icasphere*data_raw(good_ch,:);%reshape(EEGICA.data(EEGICA.icachansind,:,:), length(EEGICA.icachansind), EEGICA.trials*EEGICA.pnts);
        coef=1e-6*100*65535;
        x=int16(x*coef);
        fwrite(fid,x,'int16');
        disp(['Percent:' num2str(current_ptr/Nsamples*100) '%']); 
    end
    fclose(fid);
    EEGICA.data=[];
    EEGICA.icaact=[];
    save([p f(1:end-4) '_ICA.mat'],'-struct','EEGICA');
    %%
   
%     w_abs=abs(EEGICA.icaweights);
%     grp_idx=[strfind(t_xml,'<channelGroups>')+length('<channelGroups>') strfind(t_xml,'</channelGroups>')-1];
%     r=char(13,10)'; %char for return
%     group_txt=[ r '<group>' r '<channel skip="0">32</channel>' r '</group>' r];
%     clr_idx=strfind(t_xml,'<color>');
%     region=zeros(size(data,1)-1,1);
%     for ch=1:size(EEGICA.icaweights,1)
%         w_this=w_abs(ch,:);
%         [~,loc]=max(w_this);
%         if loc>=1&&loc<=8  %%set the color in xml file if the ICA component maximal value is in one of the regions
%             t_xml(clr_idx(ch)+8:clr_idx(ch)+13)='ff007f';
%             region(ch)=1;
%         end
%         if loc>=9&&loc<=16
%             t_xml(clr_idx(ch)+8:clr_idx(ch)+13)='aa55ff';
%             region(ch)=2;
%         end
%         if loc>=17&&loc<=24
%             t_xml(clr_idx(ch)+8:clr_idx(ch)+13)='ffff00';
%             region(ch)=3;
%         end
%         if loc>=25&&loc<=32
%             t_xml(clr_idx(ch)+8:clr_idx(ch)+13)='0080ff';
%             region(ch)=4;
%         end
%     end
%     for r_idx=1:4
%         chs=find(region==r_idx);
%         if ~isempty(chs)
%             group_txt=[group_txt '<group>' r];
%             for c_idx=1:length(chs)
%                 group_txt=[group_txt '<channel skip="0">' num2str(chs(c_idx)-1) '</channel>' r];
%             end
%             group_txt=[group_txt '</group>' r];
%         end
%     end
%     t_xml=strrep(t_xml,t_xml(grp_idx(1):grp_idx(2)),group_txt);
%     f_xml=fopen([p f(1:end-4) '_ICA.xml'],'w+');
%     fprintf(f_xml,'%c',t_xml);
%     fclose(f_xml);
    multiWaitbar('Processing files:',f_idx/length(fd));
end
clear('elim_channel');
multiWaitbar('closeAll');