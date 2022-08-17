%% general  FFT for laser data
%%2012-4-5  version by  zifang zhao 增加跳过计算过文件的功能  增加对短数据的剔除功能
%%2012-4-4  version by  zifang zhao 修正了读取excel文件名的问题，单页表格问题
%%2012-3-27 version by  zifang zhao added resampling
%searchkeyword,bin,order,tau,delta
%     order : data points within a motif, default is 2;
%     tau   : the number of data points between the adjacent two points of the motif, default is 1;
%     delta : delay time in conditional mutual information, not less than order, larger than the maximum delay, default is order:100;
function general_FFT_laser(searchkeyword,system_fs)
% searchkeyword='raw';
matfile=dir(['*' searchkeyword '*.mat']); %查找所有mat-file
% h1=waitbar(0,'Over all progress of one bhv');
% h2=waitbar(0,'Processing neurons...');
% h3=waitbar(0,'Overall progress:');
% pos_w1=get(h1,'position');
% pos_w2=[pos_w1(1) pos_w1(2)+pos_w1(4) pos_w1(3) pos_w1(4)];set(h2,'position',pos_w2,'doublebuffer','on')
% pos_w3=[pos_w1(1) pos_w1(2)-pos_w1(4) pos_w1(3) pos_w1(4)];set(h3,'position',pos_w3,'doublebuffer','on')
multiWaitbar('Files of current directory:',0,'color',[0.5 0 0.5]);
for file_idx=1:length(matfile)
    
    %% load MAT-files
    % [filename pathname]=uigetfile('*.mat','Load raw data file');
    % rawdata=load([pathname filename]); %读取原始文件
    rawdata=load(matfile(file_idx).name);
    msgbox(['Running file:' matfile(file_idx).name],'Current file','replace');
    %% load 行为xls (including starts,ends)
    %     [filename pathname]=uigetfile('*.xls','Select behavior definition');
    %     filename=[filename(1:end-7) 'bhv.xls'];
    %     filename=[matfile(file_idx).name(1:end-4-length(searchkeyword)) '.xls'];
    filename=[matfile(file_idx).name(1:end-7) 'bhv.xls'];
    [~,field_names,~]=xlsfinfo(filename);
    if length(field_names)>1
        behavior = importdata(filename);
    else
        eval(['behavior.' field_names{1} '=importdata(filename);']);
    end
    %% channel picking筛选出有效通道
    chans=channelpick(fieldnames(rawdata),'elec');
    %% data_reorganize
    for i = 1:length(chans)
        eval(['LFPdata{i}=rawdata.elec' num2str(chans(i)) ';']);
        %         eval(['rawdata_valid{i} = resample(rawdata.elec' num2str(chans(i)) ',res_fs,system_fs);']);
    end
    
    multiWaitbar('Sub classifications:',0,'color',[0.5 1 0.5]);
    %% 分不同行为进行计算
    bhv_name=fieldnames(behavior);
    for bhv=1:length(bhv_name);
        fieldname=bhv_name{bhv};
        fname=[matfile(file_idx).name(1:end-4-length(searchkeyword)) 'pcmi_' fieldname '.mat'];
        if isempty(dir(fname))
            eval(['bhv_time=behavior.' fieldname ';']);
            if(isempty(bhv_time))
                starts=[];
                ends=[];
            else
                starts=bhv_time(:,1);
                ends=bhv_time(:,2);
                %                 idx=find(floor((ends_ori-starts_ori)*res_fs)>max(delta));
                %                 if isempty(idx)
                %                     starts=[];
                %                     ends=[];
                %                 else
                %                     starts=starts_ori(idx);
                %                     ends=ends_ori(idx);
                %                 end
            end
            
            %进行FFT计算
            for i=1:length(LFPdata)
                LFPcalcu{i,:}=LFPdata{i}(ceil(starts*system_fs):floor(ends*system_fs),1);
                NFFT=system_fs;
                pf = system_fs/2*linspace(0,1,NFFT/2+1);
                fft_temp=2*abs(fft(LFPcalcu{i},NFFT));
                LFP_fft{i,:}=fft_temp(1:NFFT/2+1);
                FFTpower(i,1)=chans(i);
                FFTpower(i,2:6)=[sum(LFP_fft{i,:}(1:3)),sum(LFP_fft{i,:}(3:8)),sum(LFP_fft{i,:}(8:13)),sum(LFP_fft{i,:}(13:30)),sum(LFP_fft{i,:}(30:48))];
            end
            %存储数据
            save(fname,'FFTpower');
            clear('FFTpower')
            
        end
        multiWaitbar('Sub classifications:',bhv/length(bhv_name),'color',[0.5 1 0.5]);
    end
    multiWaitbar('Files of current directory:',file_idx/length(matfile),'color',[0.5 0 0.5]);
end
% close(h3);
end
